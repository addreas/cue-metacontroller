package controller

controllerName: "cue-metacontroller"

m: _

k: DecoratorController: {
	for n, value in m.DecoratorController {
		(n): {
			apiVersion: "metacontroller.k8s.io/v1alpha1"
			kind:       "DecoratorController"
			metadata: name: n
			spec: value & {
				hooks: {
					for t, handler in value.#hooks {
						(t): webhook: url: "http://\(controllerName).metacontroller/DecoratorController/\(n)/hooks/\(t)"
					}
				}
			}
		}
	}
}

k: CompositeController: {
	for n, value in m.CompositeController {
		(n): {
			apiVersion: "metacontroller.k8s.io/v1alpha1"
			kind:       "CompositeController"
			metadata: name: n
			spec: value & {
				hooks: {
					for t, handler in value.#hooks {
						(t): webhook: url: "http://\(controllerName).metacontroller/DecoratorController/\(n)/hooks/\(t)"
					}
				}
			}
		}
	}
}

k: Deployment: (controllerName): {
	apiVersion: "apps/v1"
	kind:       "Deployment"
	metadata: name:      controllerName
	metadata: namespace: "metacontroller"

	spec: {
		replicas: 1
		selector: matchLabels: app: controllerName
		template: metadata: labels: app: controllerName
		spec: {

			containers: [{
				name:            "hooks"
				image:           "ghcr.io/addreas/cue-metacontroller:latest"
				imagePullPolicy: "Always"
				workingDir:      "/hooks"
				volumeMounts: [{
					name:      "hooks"
					mountPath: "/hooks"
				}]
			}]
			volumes: [{
				name: "hooks"
				configMap: name: "service-per-pod-hooks"
			}]
		}
	}
}

k: Service: (controllerName): {
	apiVersion: "v1"
	kind:       "Service"
	metadata: name:      controllerName
	metadata: namespace: "metacontroller"

	spec: {
		selector: app: controllerName
		ports: [{
			port:       80
			targetPort: 8080
		}]

	}
}
