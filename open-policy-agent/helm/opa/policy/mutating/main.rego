package policy.mutating

import data.k8s.matches

main = {
	"apiVersion": "admission.k8s.io/v1",
	"kind": "AdmissionReview",
	"response": response,
}

default uid = "missing-uid"

uid = input.request.uid

# default allow without patch
response = r {
	count(patch) == 0
	r := {
		"uid": uid,
		"allowed": true,
	}
}

# response with patch
response = {
	"uid": input.request.uid,
	"allowed": true,
	"patchType": "JSONPatch",
	"patch": patch_bytes,
} {
	count(patch) > 0
	patch_json = json.marshal(patch)
	patch_bytes = base64url.encode(patch_json)
}

# patch
default patch = []

patch = result {
	operations := {"CREATE", "UPDATE"}
	kind := {"Pod", "Deployment"}
	
	
	operations[input.request.operation]
	kind[input.request.kind.kind]

	# construct patch for each image in the container array that requires it.
	result := [p |
		image = get_images[_]
		not contains(image.name, "@sha256:")

		parts := split_image(image.name)

		# format: registry/project@sha256:xxx
		patchedImage := concat("", [parts.gun, "@sha256:", get_digest(image.name)])

		# cconstruct JSON Patch for the deployment.
		# kube-apiserver expects changes to be represented as
		# JSON Patch operation against the resource.
		# the JSON Patch must be JSON serialized and base64 encoded.
		p := {
			"op": "replace",
			"path": get_path(image.index),
			"value": patchedImage,
		}
	]
}

# helper rules

# rule to compute images set
# the first line ensures that its matched to the right k8s resource
# the second line iterates over each container and extracts the image
get_images[x] {
	input.request.kind.kind == "Pod"
	name := input.request.object.spec.containers[i].image
	x := {
		"index": i,
		"name": name,
	}
}

get_images[x] {
	input.request.kind.kind == "Deployment"
	name := input.request.object.spec.template.spec.containers[i].image
	x := {
		"index": i,
		"name": name,
	}
}

# construct and returns json path for "Pods"
get_path(index) = path {
	input.request.kind.kind == "Pod"
	path := concat("/", ["", "spec", "containers", format_int(index, 10), "image"])
}

# construct and returns json path for "Deployment"
get_path(index) = path {
	input.request.kind.kind == "Deployment"
	path := concat("/", ["", "spec", "template", "spec", "containers", format_int(index, 10), "image"])
}

split_image(image) = x {
	parts := split(image, ":")
	x := {
		"gun": parts[0],
		"tag": parts[1],
	}
}

# helper rule to retrieve the digest from notary using notary-wrapper
get_digest(image) = digest {
	wrapperRootCa := "/etc/certs/notary/root-ca.crt"
	notaryWrapperURL = "https://notary-wrapper-svc.opa.svc:4445/list"
	parts := split_image(image)
	body := {
		"GUN": parts.gun,
		"Tag": parts.tag,
		"notaryServer": "notary-server-svc.notary.svc:4443"
	}

	headers_json := {"Content-Type": "application/json"}
	output := http.send({"method": "post", "url": notaryWrapperURL, "headers": headers_json, "body": body, "tls_ca_cert_file": wrapperRootCa})
	digest := output.body.Digest
}
