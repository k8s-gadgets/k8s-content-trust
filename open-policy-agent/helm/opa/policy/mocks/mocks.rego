package policy.mocks

mock_containers := [
	{"image": "foo:stable"},
	{"image": "bar:latest"},
]

mock_pod_input := {"request": {
	"uid": "pod-req-id",
	"kind": {"kind": "Pod"},
	"operation": "CREATE",
	"object": {"spec": {"containers": mock_containers}},
}}

mock_deploy_input := {"request": {
	"uid": "deploy-req-id",
	"kind": {"kind": "Deployment"},
	"object": {"spec": {"template": {"spec": {"containers": mock_containers}}}},
	"operation": "CREATE",
}}

mock_unknown_input := {"request": {
	"uid": "unknown-req-id",
	"kind": {"kind": "Unknown"},
	"operation": "UPDATE",
}}

mock_missing_uid_input := {"request": {
	"kind": {"kind": "Unknown"},
	"operation": "UPDATE",
}}
