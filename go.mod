module github.com/addreas/cue-metacontroller

go 1.20

require (
	cuelang.org/go v0.4.3
	k8s.io/api v0.26.1
	k8s.io/apimachinery v0.26.1
	k8s.io/kube-aggregator v0.26.1
	metacontroller v0.0.0-00010101000000-000000000000
)

require (
	github.com/cockroachdb/apd/v2 v2.0.1 // indirect
	github.com/emicklei/proto v1.6.15 // indirect
	github.com/go-logr/logr v1.2.3 // indirect
	github.com/gogo/protobuf v1.3.2 // indirect
	github.com/golang/glog v0.0.0-20160126235308-23def4e6c14b // indirect
	github.com/google/gofuzz v1.1.0 // indirect
	github.com/google/uuid v1.2.0 // indirect
	github.com/json-iterator/go v1.1.12 // indirect
	github.com/modern-go/concurrent v0.0.0-20180306012644-bacd9c7ef1dd // indirect
	github.com/modern-go/reflect2 v1.0.2 // indirect
	github.com/mpvl/unique v0.0.0-20150818121801-cbe035fff7de // indirect
	github.com/pkg/errors v0.9.1 // indirect
	github.com/protocolbuffers/txtpbfmt v0.0.0-20201118171849-f6a6b3f636fc // indirect
	golang.org/x/net v0.3.1-0.20221206200815-1e63c2f08a10 // indirect
	golang.org/x/text v0.5.0 // indirect
	gopkg.in/inf.v0 v0.9.1 // indirect
	gopkg.in/yaml.v2 v2.4.0 // indirect
	gopkg.in/yaml.v3 v3.0.1 // indirect
	k8s.io/klog/v2 v2.90.0 // indirect
	k8s.io/utils v0.0.0-20230209194617-a36077c30491 // indirect
	sigs.k8s.io/json v0.0.0-20221116044647-bc3834ca7abd // indirect
	sigs.k8s.io/structured-merge-diff/v4 v4.2.3 // indirect
)

replace metacontroller => github.com/metacontroller/metacontroller v1.5.21-0.20230217120541-13b175b74cc1