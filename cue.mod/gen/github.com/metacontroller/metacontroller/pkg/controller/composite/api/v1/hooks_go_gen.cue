// Code generated by cue get go. DO NOT EDIT.

//cue:generate cue get go metacontroller/pkg/controller/composite/api/v1

package v1

import (
	"github.com/metacontroller/metacontroller/pkg/apis/metacontroller/v1alpha1"
	"k8s.io/apimachinery/pkg/apis/meta/v1/unstructured"
	"github.com/metacontroller/metacontroller/pkg/controller/common/api/v1"
)

// CompositeHookRequest is the object sent as JSON to the sync and finalize hooks.
#CompositeHookRequest: {
	controller?: null | v1alpha1.#CompositeController @go(Controller,*v1alpha1.CompositeController)
	parent?:     null | unstructured.#Unstructured    @go(Parent,*unstructured.Unstructured)
	children:    v1.#RelativeObjectMap                @go(Children)
	related:     v1.#RelativeObjectMap                @go(Related)
	finalizing:  bool                                 @go(Finalizing)
}

// CompositeHookResponse is the expected format of the JSON response from the sync and finalize hooks.
#CompositeHookResponse: {
	status: {...} @go(Status,map[string]interface{})
	children: [...null | unstructured.#Unstructured] @go(Children,[]*unstructured.Unstructured)
	resyncAfterSeconds?: float64 @go(ResyncAfterSeconds)

	// Finalized is only used by the finalize hook.
	finalized?: bool @go(Finalized)
}
