package authz

default allow = false

allow {
    contains(input.attributes.request.http.headers["X-Forwarded-Client-Cert"], data.api_whitelist[_])
}

allow {
    input.path == ["users"]
    input.method == "POST"
}

allow {
    some profile_id
    input.path = ["users", profile_id]
    input.method == "GET"
    profile_id == input.user_id
}

