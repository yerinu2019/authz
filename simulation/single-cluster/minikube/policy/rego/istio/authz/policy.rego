package istio.authz

import input.attributes.request.http as http_request
import input.attributes.source
import input.parsed_path
import data.kubernetes.graphqlpolicies

success := {
    "allowed": true,
    "headers": {"X-Hello": "World"},
    "body": "XXXXXXXXX Hello World !!!!!!!",
    "http_status": 200
}

# Allow health check
allow = success {
   healthCheck
}
healthCheck {
    parsed_path[0] == "health"
    http_request.method == "GET"
}
healthCheck {
    parsed_path[0] == "healthz"
    http_request.method == "GET"
}

# API whitelist check
allow = success {
    apiWhitelistMatch
}
failed := {
    "allowed" : false,
    "http_status": 403,
    "body": "apiWhitelistMatch failed"
}
deny = failed {
    not healthCheck
    not apiWhitelistMatch
}
apiWhitelistMatch {
    trace("Here!!!")
    trace(sprintf("path: %s", [http_request.path]))
    trace(sprintf("source: %s", [source.principal]))
    http_request.path == "/"
    policies := data.kubernetes.graphqlpolicies["api-istio"]
    input_api := substring(http_request.host, 0, indexof(http_request.host, "."))
    trace(sprintf("input api:%s", [input_api]))
    policy := policies[input_api]
    trace(sprintf("api:%s, policy: %s", [input_api, policy]))

    acl := policy.spec.acls[_]
    acl.kind == "API"

    client := acl.whitelist[_]
    trace(sprintf("client: %v, source: %v", [client, source.principal]))
    client == source.principal
}
