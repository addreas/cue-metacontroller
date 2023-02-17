// Code generated by cue get go. DO NOT EDIT.

//cue:generate cue get go metacontroller/pkg/controller/common/customize/api/v1

package v1

import (
	"github.com/metacontroller/metacontroller/pkg/apis/metacontroller/v1alpha1"
	"k8s.io/apimachinery/pkg/apis/meta/v1/unstructured"
)

// CustomizeHookRequest is a request send to customize hook
#CustomizeHookRequest: {
	controller: v1alpha1.#CustomizableController  @go(Controller)
	parent?:    null | unstructured.#Unstructured @go(Parent,*unstructured.Unstructured)
}

// CustomizeHookResponse is a response from customize hook
#CustomizeHookResponse: {
	relatedResources?: [...null | v1alpha1.#RelatedResourceRule] @go(RelatedResourceRules,[]*v1alpha1.RelatedResourceRule)
}