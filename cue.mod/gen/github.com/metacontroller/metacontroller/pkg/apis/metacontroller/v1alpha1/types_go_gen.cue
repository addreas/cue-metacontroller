// Code generated by cue get go. DO NOT EDIT.

//cue:generate cue get go metacontroller/pkg/apis/metacontroller/v1alpha1

// +groupName=metacontroller.k8s.io
package v1alpha1

import (
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/apimachinery/pkg/runtime"
)

// CompositeController
// +k8s:deepcopy-gen:interfaces=k8s.io/apimachinery/pkg/runtime.Object
// +kubebuilder:subresource:status
// +kubebuilder:resource:path=compositecontrollers,scope=Cluster,shortName=cc;cctl
// +kubebuilder:metadata:annotations="api-approved.kubernetes.io=unapproved, request not yet submitted"
#CompositeController: {
	metav1.#TypeMeta
	metadata: metav1.#ObjectMeta         @go(ObjectMeta)
	spec:     #CompositeControllerSpec   @go(Spec)
	status?:  #CompositeControllerStatus @go(Status)
}

#CompositeControllerSpec: {
	parentResource: #CompositeControllerParentResourceRule @go(ParentResource)
	childResources?: [...#CompositeControllerChildResourceRule] @go(ChildResources,[]CompositeControllerChildResourceRule)
	hooks?:               null | #CompositeControllerHooks @go(Hooks,*CompositeControllerHooks)
	resyncPeriodSeconds?: null | int32                     @go(ResyncPeriodSeconds,*int32)
	generateSelector?:    null | bool                      @go(GenerateSelector,*bool)
}

#ResourceRule: {
	apiVersion: string @go(APIVersion)
	resource:   string @go(Resource)
}

#CompositeControllerParentResourceRule: {
	#ResourceRule
	revisionHistory?: null | #CompositeControllerRevisionHistory @go(RevisionHistory,*CompositeControllerRevisionHistory)
	labelSelector?:   null | metav1.#LabelSelector               @go(LabelSelector,*metav1.LabelSelector)
}

#CompositeControllerRevisionHistory: {
	fieldPaths?: [...string] @go(FieldPaths,[]string)
}

// +kubebuilder:validation:Enum={"OnDelete","Recreate","InPlace","RollingRecreate","RollingInPlace"}
#ChildUpdateMethod: string // #enumChildUpdateMethod

#enumChildUpdateMethod:
	#ChildUpdateOnDelete |
	#ChildUpdateRecreate |
	#ChildUpdateInPlace |
	#ChildUpdateRollingRecreate |
	#ChildUpdateRollingInPlace

#ChildUpdateOnDelete:        #ChildUpdateMethod & "OnDelete"
#ChildUpdateRecreate:        #ChildUpdateMethod & "Recreate"
#ChildUpdateInPlace:         #ChildUpdateMethod & "InPlace"
#ChildUpdateRollingRecreate: #ChildUpdateMethod & "RollingRecreate"
#ChildUpdateRollingInPlace:  #ChildUpdateMethod & "RollingInPlace"

#CompositeControllerChildResourceRule: {
	#ResourceRule
	updateStrategy?: null | #CompositeControllerChildUpdateStrategy @go(UpdateStrategy,*CompositeControllerChildUpdateStrategy)
}

#CompositeControllerChildUpdateStrategy: {
	method?:       #ChildUpdateMethod       @go(Method)
	statusChecks?: #ChildUpdateStatusChecks @go(StatusChecks)
}

#ChildUpdateStatusChecks: {
	conditions?: [...#StatusConditionCheck] @go(Conditions,[]StatusConditionCheck)
}

#StatusConditionCheck: {
	type:    string        @go(Type)
	status?: null | string @go(Status,*string)
	reason?: null | string @go(Reason,*string)
}

#ServiceReference: {
	name:      string        @go(Name)
	namespace: string        @go(Namespace)
	port?:     null | int32  @go(Port,*int32)
	protocol?: null | string @go(Protocol,*string)
}

#CompositeControllerHooks: {
	customize?:       null | #Hook @go(Customize,*Hook)
	sync?:            null | #Hook @go(Sync,*Hook)
	finalize?:        null | #Hook @go(Finalize,*Hook)
	preUpdateChild?:  null | #Hook @go(PreUpdateChild,*Hook)
	postUpdateChild?: null | #Hook @go(PostUpdateChild,*Hook)
}

#Hook: {
	// +kubebuilder:default:="v1"
	version?: null | #HookVersion @go(Version,*HookVersion)
	webhook?: null | #Webhook     @go(Webhook,*Webhook)
}

// +kubebuilder:validation:Enum={"v1","v2"}
#HookVersion: string // #enumHookVersion

#enumHookVersion:
	#HookVersionV1 |
	#HookVersionV2

#HookVersionV1: #HookVersion & "v1"
#HookVersionV2: #HookVersion & "v2"

#WebhookEtagConfig: {
	enabled?:             null | bool  @go(Enabled,*bool)
	cacheTimeoutSeconds?: null | int32 @go(CacheTimeoutSeconds,*int32)
	cacheCleanupSeconds?: null | int32 @go(CacheCleanupSeconds,*int32)
}

#Webhook: {
	url?: null | string @go(URL,*string)

	// +kubebuilder:validation:Format:="duration"
	timeout?: null | metav1.#Duration   @go(Timeout,*metav1.Duration)
	etag?:    null | #WebhookEtagConfig @go(Etag,*WebhookEtagConfig)
	path?:    null | string             @go(Path,*string)
	service?: null | #ServiceReference  @go(Service,*ServiceReference)

	// Sets the json unmarshall mode. One of the 'loose' or 'strict'. In 'strict'
	// mode additional checks are performed to detect unknown and duplicated fields.
	responseUnMarshallMode?: null | #ResponseUnmarshallMode @go(ResponseUnmarshallMode,*ResponseUnmarshallMode)
}

// +kubebuilder:validation:Enum:={"loose","strict"}
#ResponseUnmarshallMode: string // #enumResponseUnmarshallMode

#enumResponseUnmarshallMode:
	#ResponseUnmarshallModeLoose |
	#ResponseUnmarshallModeStrict

#ResponseUnmarshallModeLoose:  #ResponseUnmarshallMode & "loose"
#ResponseUnmarshallModeStrict: #ResponseUnmarshallMode & "strict"

#CompositeControllerStatus: {
}

// CompositeControllerList
// +k8s:deepcopy-gen:interfaces=k8s.io/apimachinery/pkg/runtime.Object
#CompositeControllerList: {
	metav1.#TypeMeta
	metadata: metav1.#ListMeta @go(ListMeta)
	items: [...#CompositeController] @go(Items,[]CompositeController)
}

// ControllerRevision
// +genclient
// +genclient:noStatus
// +k8s:deepcopy-gen:interfaces=k8s.io/apimachinery/pkg/runtime.Object
// +kubebuilder:subresource:status
// +kubebuilder:resource:path=controllerrevisions,scope=Namespaced
// +kubebuilder:metadata:annotations="api-approved.kubernetes.io=unapproved, request not yet submitted"
#ControllerRevision: {
	metav1.#TypeMeta
	metadata:    metav1.#ObjectMeta    @go(ObjectMeta)
	parentPatch: runtime.#RawExtension @go(ParentPatch)
	children?: [...#ControllerRevisionChildren] @go(Children,[]ControllerRevisionChildren)
}

#ControllerRevisionChildren: {
	apiGroup: string @go(APIGroup)
	kind:     string @go(Kind)
	names: [...string] @go(Names,[]string)
}

// ControllerRevisionList
// +k8s:deepcopy-gen:interfaces=k8s.io/apimachinery/pkg/runtime.Object
#ControllerRevisionList: {
	metav1.#TypeMeta
	metadata: metav1.#ListMeta @go(ListMeta)
	items: [...#ControllerRevision] @go(Items,[]ControllerRevision)
}

// DecoratorController
// +k8s:deepcopy-gen:interfaces=k8s.io/apimachinery/pkg/runtime.Object
// +kubebuilder:subresource:status
// +kubebuilder:resource:path=decoratorcontrollers,scope=Cluster,shortName=dec;decorators
// +kubebuilder:metadata:annotations="api-approved.kubernetes.io=unapproved, request not yet submitted"
#DecoratorController: {
	metav1.#TypeMeta
	metadata: metav1.#ObjectMeta         @go(ObjectMeta)
	spec:     #DecoratorControllerSpec   @go(Spec)
	status?:  #DecoratorControllerStatus @go(Status)
}

#DecoratorControllerSpec: {
	resources: [...#DecoratorControllerResourceRule] @go(Resources,[]DecoratorControllerResourceRule)
	attachments?: [...#DecoratorControllerAttachmentRule] @go(Attachments,[]DecoratorControllerAttachmentRule)
	hooks?:               null | #DecoratorControllerHooks @go(Hooks,*DecoratorControllerHooks)
	resyncPeriodSeconds?: null | int32                     @go(ResyncPeriodSeconds,*int32)
}

#DecoratorControllerResourceRule: {
	#ResourceRule
	labelSelector?:      null | metav1.#LabelSelector @go(LabelSelector,*metav1.LabelSelector)
	annotationSelector?: null | #AnnotationSelector   @go(AnnotationSelector,*AnnotationSelector)
}

#AnnotationSelector: {
	matchAnnotations?: {[string]: string} @go(MatchAnnotations,map[string]string)
	matchExpressions?: [...metav1.#LabelSelectorRequirement] @go(MatchExpressions,[]metav1.LabelSelectorRequirement)
}

#DecoratorControllerAttachmentRule: {
	#ResourceRule
	updateStrategy?: null | #DecoratorControllerAttachmentUpdateStrategy @go(UpdateStrategy,*DecoratorControllerAttachmentUpdateStrategy)
}

#DecoratorControllerAttachmentUpdateStrategy: {
	method?: #ChildUpdateMethod @go(Method)
}

#DecoratorControllerHooks: {
	customize?: null | #Hook @go(Customize,*Hook)
	sync?:      null | #Hook @go(Sync,*Hook)
	finalize?:  null | #Hook @go(Finalize,*Hook)
}

#DecoratorControllerStatus: {
}

// DecoratorControllerList
// +k8s:deepcopy-gen:interfaces=k8s.io/apimachinery/pkg/runtime.Object
#DecoratorControllerList: {
	metav1.#TypeMeta
	metadata: metav1.#ListMeta @go(ListMeta)
	items: [...#DecoratorController] @go(Items,[]DecoratorController)
}

#RelatedResourceRule: {
	#ResourceRule
	labelSelector?: null | metav1.#LabelSelector @go(LabelSelector,*metav1.LabelSelector)
	namespace?:     string                       @go(Namespace)
	names: [...string] @go(Names,[]string)
}

// CustomizableController is an interface representing Controller exposing customize hook
#CustomizableController: _
