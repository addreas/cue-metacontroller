package main

import (
	_ "k8s.io/api/apps/v1"
	_ "k8s.io/api/batch/v1"
	_ "k8s.io/api/batch/v1beta1"
	_ "k8s.io/api/core/v1"
	_ "k8s.io/api/discovery/v1beta1"
	_ "k8s.io/api/networking/v1"
	_ "k8s.io/api/policy/v1"
	_ "k8s.io/api/rbac/v1"
	_ "k8s.io/api/storage/v1"
	_ "k8s.io/apimachinery/pkg/apis/meta/v1"
	_ "k8s.io/apimachinery/pkg/apis/meta/v1/unstructured"
	_ "k8s.io/kube-aggregator/pkg/apis/apiregistration/v1"

	_ "metacontroller/pkg/apis/metacontroller/v1alpha1"
	_ "metacontroller/pkg/controller/common/customize/api/v1"
	_ "metacontroller/pkg/controller/composite/api/v1"
	_ "metacontroller/pkg/controller/decorator/api/v1"
)
