package examples

import (
	appsv1 "k8s.io/api/apps/v1"
	batchv1 "k8s.io/api/batch/v1"
	batchv1beta1 "k8s.io/api/batch/v1beta1"
	corev1 "k8s.io/api/core/v1"
	discoveryv1 "k8s.io/api/discovery/v1beta1"
	networkingv1 "k8s.io/api/networking/v1"
	policyv1 "k8s.io/api/policy/v1"
	rbacv1 "k8s.io/api/rbac/v1"
	storagev1 "k8s.io/api/storage/v1"
	metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
	"k8s.io/apimachinery/pkg/apis/meta/v1/unstructured"
	apiregistrationv1 "k8s.io/kube-aggregator/pkg/apis/apiregistration/v1"

	decoratorv1 "github.com/metacontroller/metacontroller/pkg/controller/decorator/api/v1"
	compositev1 "github.com/metacontroller/metacontroller/pkg/controller/composite/api/v1"
	customizev1 "github.com/metacontroller/metacontroller/pkg/controller/common/customize/api/v1"

)

things: [
	appsv1,
	batchv1,
	batchv1beta1,
	corev1,
	discoveryv1,
	networkingv1,
	policyv1,
	rbacv1,
	storagev1,
	metav1,
	unstructured,
	apiregistrationv1,
	decoratorv1,
	compositev1,
	customizev1,
]
