// Code generated by cue get go. DO NOT EDIT.

//cue:generate cue get go metacontroller/pkg/controller/decorator/api/v1

package v1

import (
	"github.com/metacontroller/metacontroller/pkg/apis/metacontroller/v1alpha1"
	"k8s.io/apimachinery/pkg/apis/meta/v1/unstructured"
	"github.com/metacontroller/metacontroller/pkg/controller/common/api/v1"
)

// DecoratorHookRequest is the object sent as JSON to the sync hook.
#DecoratorHookRequest: {
	controller?: null | v1alpha1.#DecoratorController @go(Controller,*v1alpha1.DecoratorController)
	object?:     null | unstructured.#Unstructured    @go(Object,*unstructured.Unstructured)
	attachments: v1.#RelativeObjectMap                @go(Attachments)
	related:     v1.#RelativeObjectMap                @go(Related)
	finalizing:  bool                                 @go(Finalizing)
}

// DecoratorHookResponse is the expected format of the JSON response from the sync hook.
#DecoratorHookResponse: {
	labels: {[string]: null | string} @go(Labels,map[string]*string)
	annotations: {[string]: null | string} @go(Annotations,map[string]*string)
	status: {...} @go(Status,map[string]interface{})
	attachments: [...null | unstructured.#Unstructured] @go(Attachments,[]*unstructured.Unstructured)
	resyncAfterSeconds?: float64 @go(ResyncAfterSeconds)

	// Finalized is only used by the finalize hook.
	finalized?: bool @go(Finalized)
}
