package controller

m: DecoratorController: "pod-name-label": {
	resources: [{
		apiVersion: "v1"
		resource:   "pods"
		labelSelector: matchExpressions: [{key: "pod-name", operator: "DoesNotExist"}]
		annotationSelector: matchExpressions: [{key: "pod-name-label", operator: "Exists"}]
	}]
}

m: DecoratorController: "pod-name-label": #hooks: sync: {
	request?: _
	response: {
		let pod = request.object
		let labelKey = pod.metadata.annotations["pod-name-label"]

		labels: {
			// Inject the Pod name as a label with the key requested in the annotation.
			(labelKey): pod.metadata.name
		}
	}
}
