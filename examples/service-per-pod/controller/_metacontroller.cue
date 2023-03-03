package controller

import (
	metacontroller_v1alpha1 "github.com/metacontroller/metacontroller/pkg/apis/metacontroller/v1alpha1"
	decorator_v1 "github.com/metacontroller/metacontroller/pkg/controller/decorator/api/v1"
	composite_v1 "github.com/metacontroller/metacontroller/pkg/controller/composite/api/v1"
	customize_v1 "github.com/metacontroller/metacontroller/pkg/controller/common/customize/api/v1"
)

_opt: {
	$: _
	out: {
		for key, value in $ {
			"\(key)"?: value
		}
	}
}

m: DecoratorController: [string]: {
	resources: [...metacontroller_v1alpha1.#DecoratorControllerResourceRule]
	attachments?: [...metacontroller_v1alpha1.#DecoratorControllerAttachmentRule]

	#hooks: {
		sync?: {
			request?:  (_opt & {$: decorator_v1.#DecoratorHookRequest}).out
			response?: (_opt & {$: decorator_v1.#DecoratorHookResponse}).out
		}
		finalize?: {
			request?:  (_opt & {$: decorator_v1.#DecoratorHookRequest}).out
			response?: (_opt & {$: decorator_v1.#DecoratorHookResponse}).out
		}
		customize?: {
			request?:  (_opt & {$: customize_v1.#CustomizeHookRequest}).out
			response?: (_opt & {$: customize_v1.#CustomizeHookResponse}).out
		}
	}
}

m: CompositeController: [string]: {
	parentResource: metacontroller_v1alpha1.#CompositeControllerParentResourceRule
	childResources?: [...metacontroller_v1alpha1.#CompositeControllerChildResourceRule]

	#hooks: {
		sync?: {
			request?:  (_opt & {$: composite_v1.#CompositeHookRequest}).out
			response?: (_opt & {$: composite_v1.#CompositeHookResponse}).out
		}
		finalize?: {
			request?:  (_opt & {$: composite_v1.#CompositeHookRequest}).out
			response?: (_opt & {$: composite_v1.#CompositeHookResponse}).out
		}
		customize?: {
			request?:  (_opt & {$: customize_v1.#CustomizeHookRequest}).out
			response?: (_opt & {$: customize_v1.#CustomizeHookResponse}).out
		}
	}
}
