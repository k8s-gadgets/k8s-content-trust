package policy.validating_test

import data.policy.mocks
import data.policy.validating.response

test_response_deployment {
	res := response with input as mocks.mock_deploy_input
	res == {
		"uid": "deploy-req-id",
		"allowed": false,
		"status": {"reason": "foo:stable contains tag; only images with checksum are allowed, bar:latest contains tag; only images with checksum are allowed"},
	}
}

test_response_pod {
	res := response with input as mocks.mock_pod_input
	res == {
		"uid": "pod-req-id",
		"allowed": false,
		"status": {"reason": "foo:stable contains tag; only images with checksum are allowed, bar:latest contains tag; only images with checksum are allowed"},
	}
}
