package istio.authz

import input.attributes.request.http as http_request
import input.parsed_path

default allow = false

# Allow health-checks
# NOTE:
# Without health check rules, opa admission controller
# container fails to start.
allow {
    split(http_request.host, ":")[1] == "8282"
}
allow {
    split(http_request.host, ":")[1] == "15021"
}
allow {
    parsed_path[0] == "health"
    http_request.method == "GET"
}
allow {
    parsed_path[0] == "healthz"
    http_request.method == "GET"
}

# XFCC header based access control
# NOTE:
# Logically, it looks like the following rule is enough, but it does NOT.
# allow {
#   contains(input.attributes.request.http.headers["x-forwarded-client-cert"], api_whitelist[_])
# }
# api_whitelist = ["spiffe://cluster.local/ns/clientns/sa/client1",
#  "spiffe://cluster.local/ns/clientns/sa/client3",
# ]
#
# The above rule works in standalone rego file based evaluation, but does NOT works
# in ConfigMap in opa envoy plugin.
# The above simple clean and short rule had to be rewritten as follows.
# Rules that work in OPA envoy plugin unit test do not work in the runtime environment.
# So be careful when refactoring the following rules. Do manual test with small changes.
allow = response {
    response := {
      "allowed": checkXfcc,
    }
}

deny = response {
    response := {
    "allowed": checkXfcc,
    }
}

checkXfcc {
  contains(input.attributes.request.http.headers["x-forwarded-client-cert"], api_whitelist[_])
}

api_whitelist = ["spiffe://cluster.local/ns/clientns/sa/client1",
  "spiffe://cluster.local/ns/clientns/sa/client3",
]