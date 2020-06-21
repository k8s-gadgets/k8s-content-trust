package policy.mutating_test

import data.policy.mocks
import data.policy.mutating

# test_response_deployment {
# 	res := response with input as mocks.mock_deploy_input
# 	res == {
# 		"allowed": true,
# 		"patch": "?",
# 		"patchType": "JSONPatch",
# 	}
# }

test_response_pod {
	res := mutating.response with input as mocks.mock_pod_input

	#with data.policy.mutating.get_digest as "1234"

	expected_patch := [{
		"op": "add",
		"path": "/metadata/labels/opa",
		"value": "added-by-mutating-webhook",
	}]

	expected_patch_bytes := base64url.encode(json.marshal(expected_patch))
	res == {
		"uid": "pod-req-id",
		"allowed": true,
		"patch": expected_patch_bytes,
		"patchType": "JSONPatch",
	}
}

test_response_unknown {
	res := mutating.response with input as mocks.mock_unknown_input
	res == {
		"uid": "unknown-req-id",
		"allowed": true,
	}
}

test_response_missing_uid {
	res := mutating.response with input as mocks.mock_missing_uid_input
	res == {
		"uid": "missing-uid",
		"allowed": true,
	}
}

expected_images := {
	{"index": 0, "name": "foo:stable"},
	{"index": 1, "name": "bar:latest"},
}

test_pod_images {
	result := mutating.get_images with input as mocks.mock_pod_input
	result == expected_images
}

test_deploy_images {
	result := mutating.get_images with input as mocks.mock_deploy_input
	result == expected_images
}

test_pod_patch {
	result := mutating.patch with input as mocks.mock_pod_input

	#with mutating.get_digest as "1234"

	count(result) == 2
	result == [
		{
			"op": "replace",
			"path": "/spec/containers/0/image",
			"value": "foo@sha256:1234",
		},
		{
			"op": "replace",
			"path": "/spec/containers/1/image",
			"value": "bar@sha256:1234",
		},
	]
}

test_deploy_patch {
	result := mutating.patch with input as mocks.mock_deploy_input

	#with mutating.get_digest as "1234"

	count(result) == 2
	result == [
		{
			"op": "replace",
			"path": "/spec/template/spec/containers/0/image",
			"value": "foo@sha256:1234",
		},
		{
			"op": "replace",
			"path": "/spec/template/spec/containers/1/image",
			"value": "bar@sha256:1234",
		},
	]
}
