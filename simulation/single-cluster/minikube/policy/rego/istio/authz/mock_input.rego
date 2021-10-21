package istio.authz

client1_to_api1 :=
{
  "attributes": {
    "destination": {
      "address": {
        "socketAddress": {
          "address": "172.17.0.12",
          "portValue": 80
        }
      },
      "principal": "spiffe://cluster.local/ns/api-istio/sa/api1"
    },
    "metadataContext": {},
    "request": {
      "http": {
        "body": "{\"query\":\"query{showCollection {items {title firstEpisodeDate lastEpisodeDate henshinMp4 { url }}}}\"}",
        "headers": {
          ":authority": "api1.api-istio",
          ":method": "POST",
          ":path": "/",
          ":scheme": "http",
          "accept": "*/*",
          "content-length": "101",
          "content-type": "application/json",
          "user-agent": "curl/7.64.0",
          "x-b3-sampled": "1",
          "x-b3-spanid": "10a485e1e27799a1",
          "x-b3-traceid": "b76cf826fc86c7a510a485e1e27799a1",
          "x-envoy-attempt-count": "3",
          "x-envoy-auth-partial-body": "false",
          "x-forwarded-client-cert": "By=spiffe://cluster.local/ns/api-istio/sa/api1;Hash=612a138cd4323a27208c3ed5ce7c4ab63775ac33dd6d13b772e5e8389717f21d;Subject=\"\";URI=spiffe://cluster.local/ns/clientns/sa/client1",
          "x-forwarded-proto": "http",
          "x-request-id": "7b4c44f1-2c12-912f-a019-b3a167956ed8"
        },
        "host": "api1.api-istio",
        "id": "3915651613227659083",
        "method": "POST",
        "path": "/",
        "protocol": "HTTP/1.1",
        "scheme": "http",
        "size": "101"
      },
      "time": "2021-10-07T00:37:12.890920Z"
    },
    "source": {
      "address": {
        "socketAddress": {
          "address": "172.17.0.10",
          "portValue": 35568
        }
      },
      "principal": "spiffe://cluster.local/ns/clientns/sa/client1"
    }
  },
  "parsed_body": {
    "query": "query{showCollection {items {title firstEpisodeDate lastEpisodeDate henshinMp4 { url }}}}"
  },
  "parsed_path": [
    ""
  ],
  "parsed_query": {},
  "truncated_body": false,
  "version": {
    "encoding": "protojson",
    "ext_authz": "v3"
  }
}

client2_to_api1 :=
{
  "attributes": {
    "destination": {
      "address": {
        "socketAddress": {
          "address": "172.17.0.12",
          "portValue": 80
        }
      },
      "principal": "spiffe://cluster.local/ns/api-istio/sa/api1"
    },
    "metadataContext": {},
    "request": {
      "http": {
        "body": "{\"query\":\"query{showCollection {items {title firstEpisodeDate lastEpisodeDate henshinMp4 { url }}}}\"}",
        "headers": {
          ":authority": "api1.api-istio",
          ":method": "POST",
          ":path": "/",
          ":scheme": "http",
          "accept": "*/*",
          "content-length": "101",
          "content-type": "application/json",
          "user-agent": "curl/7.64.0",
          "x-b3-sampled": "1",
          "x-b3-spanid": "10a485e1e27799a1",
          "x-b3-traceid": "b76cf826fc86c7a510a485e1e27799a1",
          "x-envoy-attempt-count": "3",
          "x-envoy-auth-partial-body": "false",
          "x-forwarded-client-cert": "By=spiffe://cluster.local/ns/api-istio/sa/api1;Hash=612a138cd4323a27208c3ed5ce7c4ab63775ac33dd6d13b772e5e8389717f21d;Subject=\"\";URI=spiffe://cluster.local/ns/clientns/sa/client2",
          "x-forwarded-proto": "http",
          "x-request-id": "7b4c44f1-2c12-912f-a019-b3a167956ed8"
        },
        "host": "api1.api-istio",
        "id": "3915651613227659083",
        "method": "POST",
        "path": "/",
        "protocol": "HTTP/1.1",
        "scheme": "http",
        "size": "101"
      },
      "time": "2021-10-07T00:37:12.890920Z"
    },
    "source": {
      "address": {
        "socketAddress": {
          "address": "172.17.0.10",
          "portValue": 35568
        }
      },
      "principal": "spiffe://cluster.local/ns/clientns/sa/client2"
    }
  },
  "parsed_body": {
    "query": "query{showCollection {items {title firstEpisodeDate lastEpisodeDate henshinMp4 { url }}}}"
  },
  "parsed_path": [
    ""
  ],
  "parsed_query": {},
  "truncated_body": false,
  "version": {
    "encoding": "protojson",
    "ext_authz": "v3"
  }
}

client100_to_api1 :=
{
  "attributes": {
    "destination": {
      "address": {
        "socketAddress": {
          "address": "172.17.0.12",
          "portValue": 80
        }
      },
      "principal": "spiffe://cluster.local/ns/api-istio/sa/api1"
    },
    "metadataContext": {},
    "request": {
      "http": {
        "body": "{\"query\":\"query{showCollection {items {title firstEpisodeDate lastEpisodeDate henshinMp4 { url }}}}\"}",
        "headers": {
          ":authority": "api1.api-istio",
          ":method": "POST",
          ":path": "/",
          ":scheme": "http",
          "accept": "*/*",
          "content-length": "101",
          "content-type": "application/json",
          "user-agent": "curl/7.64.0",
          "x-b3-sampled": "1",
          "x-b3-spanid": "10a485e1e27799a1",
          "x-b3-traceid": "b76cf826fc86c7a510a485e1e27799a1",
          "x-envoy-attempt-count": "3",
          "x-envoy-auth-partial-body": "false",
          "x-forwarded-client-cert": "By=spiffe://cluster.local/ns/api-istio/sa/api1;Hash=612a138cd4323a27208c3ed5ce7c4ab63775ac33dd6d13b772e5e8389717f21d;Subject=\"\";URI=spiffe://cluster.local/ns/clientns/sa/client100",
          "x-forwarded-proto": "http",
          "x-request-id": "7b4c44f1-2c12-912f-a019-b3a167956ed8"
        },
        "host": "api1.api-istio",
        "id": "3915651613227659083",
        "method": "POST",
        "path": "/",
        "protocol": "HTTP/1.1",
        "scheme": "http",
        "size": "101"
      },
      "time": "2021-10-07T00:37:12.890920Z"
    },
    "source": {
      "address": {
        "socketAddress": {
          "address": "172.17.0.10",
          "portValue": 35568
        }
      },
      "principal": "spiffe://cluster.local/ns/clientns/sa/client100"
    }
  },
  "parsed_body": {
    "query": "query{showCollection {items {title firstEpisodeDate lastEpisodeDate henshinMp4 { url }}}}"
  },
  "parsed_path": [
    ""
  ],
  "parsed_query": {},
  "truncated_body": false,
  "version": {
    "encoding": "protojson",
    "ext_authz": "v3"
  }
}

healthcheck := {
        "attributes": {
          "destination": {
            "address": {
              "socketAddress": {
                "address": "172.17.0.11",
                "portValue": 8282
              }
            }
          },
          "metadataContext": {},
          "request": {
            "http": {
              "headers": {
                ":authority": "172.17.0.11:8282",
                ":method": "GET",
                ":path": "/health?plugins",
                ":scheme": "http",
                "accept": "*/*",
                "user-agent": "kube-probe/1.22",
                "x-forwarded-proto": "http",
                "x-request-id": "86931885-cdaf-476c-a35c-84bce7a8a877"
              },
              "host": "172.17.0.11:8282",
              "id": "9468817280282368621",
              "method": "GET",
              "path": "/health?plugins",
              "protocol": "HTTP/1.1",
              "scheme": "http"
            },
            "time": "2021-10-03T20:46:38.596037Z"
          },
          "source": {
            "address": {
              "socketAddress": {
                "address": "172.17.0.1",
                "portValue": 47080
              }
            }
          }
        },
        "parsed_body": null,
        "parsed_path": [
          "health"
        ],
        "parsed_query": {
          "plugins": [
            ""
          ]
        },
        "truncated_body": false,
        "version": {
          "encoding": "protojson",
          "ext_authz": "v3"
        }
      }