package istio.authz

import input.attributes.request.http as http_request
import input.attributes.source
import input.parsed_path
import data.kubernetes.graphqlpolicies

# Allow health check
allow = {
    "allowed": true,
    "suppress_decision_log": true,
    "http_status": 200
} {
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
allow = {
    "allowed": true,
    "http_status": 200,
    "headers": {"X-CANT-MUTATE": concat(",", cant_mutate_minus_can_mutate_fields)}
} {
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
    acl := api_acl
    trace(sprintf("api acl: %v", [acl]))
    client := acl.whitelist[_]
    trace(sprintf("client: %v, source: %v", [client, source.principal]))
    client == source.principal
}

api_policy = policy {
    policies := data.kubernetes.graphqlpolicies["api-istio"]
    input_api := substring(http_request.host, 0, indexof(http_request.host, "."))
    policy := policies[input_api]
    trace(sprintf("input api: %v, policy: %v", [input_api, policy]))
}

api_acl = acl {
    policy := api_policy
    acl := policy.spec.acls[_]
    acl.kind == "API"
    trace(sprintf("api acl: %v", [acl]))
}

mutate_fields_acl[acl] {
    policy := api_policy
    acl := policy.spec.acls[_]
    acl.kind == "MUTATE_FIELDS"
}

can_mutate_fields[fields] {
    acl := mutate_fields_acl[_]
    whitelisted(acl)
    fields := acl.fields[_]
}

cant_mutate_fields[fields] {
    acl := mutate_fields_acl[_]
    not whitelisted(acl)
    trace("not whitelisted")
    fields := acl.fields[_]
    trace(sprintf("fields: %v", [fields]))
}

cant_mutate_minus_can_mutate_fields := cant_mutate_fields - can_mutate_fields

whitelisted(acl) {
    trace(sprintf("source: %v, acl: %v", [source.principal, acl]))
    some i
    acl.whitelist[i] == source.principal
}

mutateFieldBlacklist[cantMutate]  {
    fields := ["f1", "f2.f3"]
    cantMutate := fields[_]
}
