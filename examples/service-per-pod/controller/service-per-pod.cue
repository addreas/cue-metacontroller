package controller

import (
	"list"
	"strconv"
	"strings"

	appsv1 "k8s.io/api/apps/v1"
)

m: DecoratorController: "service-per-pod": {
	resources: [{
		apiVersion: "apps/v1"
		resource:   "statefulsets"
		annotationSelector: matchExpressions: [
			{key: "service-per-pod-label", operator: "Exists"},
			{key: "service-per-pod-ports", operator: "Exists"},
		]
	}]
	attachments: [{
		apiVersion: "v1"
		resource:   "services"
	}]
}

m: DecoratorController: "service-per-pod": #hooks: sync: {
	request: object: appsv1.#StatefulSet

	response: {
		let statefulset = request.object
		let labelKey = statefulset.metadata.annotations["service-per-pod-label"]
		let portList = [
			for item in strings.Split(statefulset.metadata.annotations["service-per-pod-ports"], ",") {
				let parts = strings.Split(item, ":")
				let left = strconv.Atoi(parts[0])
				let right = strconv.Atoi(parts[1])

				name:       "port-\(left)"
				port:       left
				targetPort: right
			},
		]

		// Create a service for each Pod, with a selector on the given label key.
		attachments: [
			for index in list.Range(0, statefulset.spec.replicas, 1) {
				let indexedName = "\(statefulset.metadata.name)-\(index)"
				apiVersion: "v1"
				kind:       "Service"
				metadata: {
					name: indexedName
					labels: app: "service-per-pod"
				}
				spec: {
					selector: (labelKey): indexedName
					ports: portList
				}
			},

		]
	}
}

m: DecoratorController: "service-per-pod": #hooks: finalize: {
	request: {
		attachments: "Service.v1": *[] | _
	}
	response: {
		// If the StatefulSet is updated to no longer match our decorator selector,
		// or if the StatefulSet is deleted, clean up any attachments we made.
		attachments: []
		// Mark as finalized once we observe all Services are gone.
		finalized: len(request.attachments["Service.v1"]) == 0
	}
}
