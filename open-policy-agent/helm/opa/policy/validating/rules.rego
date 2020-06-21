package policy.validating

operations := {"CREATE", "UPDATE"}

kind := {"Pod", "Deployment"}

# rule to deny digests for pods and deployments
deny[msg] {
	operations[input.request.operation]
	kind[input.request.kind.kind]
	image = get_images[_]
	not contains(image.name, "@sha256:")
	msg := sprintf("%v contains tag; only images with checksum are allowed", [image.name])
}

# # http.send error (part 1)
# # see issue: https://github.com/open-policy-agent/opa/issues/2187
# # rule to deny request when connection to notary is down
# deny[msg] {
# 	operations[input.request.operation]
# 	kind[input.request.kind.kind]
	
# 	wrapper_status := get_wrapper_connection_status()
# 	wrapper_status != 200

# 	msg := sprintf("Failed to contact notary-wrapper! return_code %v", [wrapper_status])
# }

# rule deny if digest is not in notary
deny[msg] {
	operations[input.request.operation]
	kind[input.request.kind.kind]
	image = get_images[_]
	contains(image.name, "@sha256:")

	# Example to mock digest comparison
	# parts := split_image(image.name)
	# not parts.digest == "@sha256:50"

	get_checksum_status(image.name) != 200
	msg := sprintf("No trust data found for the following image: %v ", [image.name])
}

# helper rules
# get images if pod
get_images[x] {
	input.request.kind.kind == "Pod"
	name := input.request.object.spec.containers[i].image
	x := {
		"index": i,
		"name": name,
	}
}

## get images if deployment
get_images[x] {
	input.request.kind.kind == "Deployment"
	name := input.request.object.spec.template.spec.containers[i].image
	x := {
		"index": i,
		"name": name,
	}
}

# rule to split gun and tag
split_image(image) = x {
	parts := split(image, "@sha256:")
	x := {
		"gun": parts[0],
		"digest": parts[1],
	}
}

# rule to get digest from notary-wrapper
get_checksum_status(image) = status {
	wrapperRootCa := "/etc/certs/notary/root-ca.crt"
	notaryWrapperURL = "https://notary-wrapper-svc.opa.svc:4445/verify"
	parts := split_image(image)
	body := {
		"GUN": parts.gun,
		"SHA": parts.digest,
		"notaryServer": "notary-server-svc.notary.svc:4443",
	}

	headers_json := {"Content-Type": "application/json"}
	output := http.send({"method": "post", "url": notaryWrapperURL, "headers": headers_json, "body": body, "tls_ca_cert_file": wrapperRootCa})
	status := output.status_code
}

# # http.send error (part 2)
# # see issue: https://github.com/open-policy-agent/opa/issues/2187
# rule to get check if notary-wrapper is up 
# get_wrapper_connection_status() = status_wrapper {
# 	wrapperRootCa := "/etc/certs/notary/root-ca.crt"
# 	notaryWrapperURL = "https://notary-wrapper-svc.opa.svc:4445"

# 	headers_json := {"Content-Type": "application/json"}
# 	output := http.send({"method": "get", "url": notaryWrapperURL, "headers": headers_json, "tls_ca_cert_file": wrapperRootCa})
# 	status_wrapper := output.status
# }
