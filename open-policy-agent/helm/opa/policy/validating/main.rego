package policy.validating

main = {
	"apiVersion": "admission.k8s.io/v1",
	"kind": "AdmissionReview",
	"response": response,
}

reason = concat(", ", deny)

# for requests without uid
default response = {
	"uid": "missing-uid",
	"allowed": true,
}

# allowed
response = r {
	reason == ""
	r := {
		"uid": input.request.uid,
		"allowed": true,
	}
}

# denied
response = r {
	reason != ""
	r := {
		"uid": input.request.uid,
		"allowed": false,
		"status": {"reason": reason},
	}
}
