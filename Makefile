cue-get-go:
	@cue get go k8s.io/api/apps/v1
	@cue get go k8s.io/api/batch/v1
	@cue get go k8s.io/api/batch/v1beta1
	@cue get go k8s.io/api/core/v1
	@cue get go k8s.io/api/discovery/v1beta1
	@cue get go k8s.io/api/networking/v1
	@cue get go k8s.io/api/policy/v1
	@cue get go k8s.io/api/rbac/v1
	@cue get go k8s.io/api/storage/v1
	@cue get go k8s.io/apimachinery/pkg/apis/meta/v1
	@cue get go k8s.io/apimachinery/pkg/apis/meta/v1/unstructured
	@cue get go k8s.io/kube-aggregator/pkg/apis/apiregistration/v1

	@cue get go metacontroller/pkg/apis/metacontroller/v1alpha1
	@cue get go metacontroller/pkg/controller/common/customize/api/v1
	@cue get go metacontroller/pkg/controller/composite/api/v1
	@cue get go metacontroller/pkg/controller/decorator/api/v1

	@mkdir -p cue.mod/gen/github.com/metacontroller
	@mv cue.mod/gen/{metacontroller,github.com/metacontroller}
	@sed -i 's%metacontroller/pkg%github.com/metacontroller/metacontroller/pkg%g' cue.mod/gen/github.com/metacontroller/**/*.go
