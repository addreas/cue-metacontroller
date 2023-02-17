package controller

import (
    decorator_v1 "github.com/metacontroller/metacontroller/pkg/controller/decorator/api/v1"
    composite_v1 "github.com/metacontroller/metacontroller/pkg/controller/composite/api/v1"
    customize_v1 "github.com/metacontroller/metacontroller/pkg/controller/common/customize/api/v1"
)

m: DecoratorController: [string]: hooks: {
	sync?: {
		request:  decorator_v1.#DecoratorHookRequest
		response: decorator_v1.#DecoratorHookResponse
	}
	finalize?: {
		request:  decorator_v1.#DecoratorHookRequest
		response: decorator_v1.#DecoratorHookResponse
	}
	customize?: {
        request: customize_v1.#CustomizeHookRequest
        response: customize_v1.#CustomizeHookResponse
    }
}

m: CompositeController: [string]: hooks: {
	sync?: {
		request:  composite_v1.#CompositeHookRequest
		response: composite_v1.#CompositeHookResponse
	}
	finalize?: {
		request:  composite_v1.#CompositeHookRequest
		response: composite_v1.#CompositeHookResponse
	}
	customize?: {
        request: customize_v1.#CustomizeHookRequest
        response: customize_v1.#CustomizeHookResponse
    }
}
