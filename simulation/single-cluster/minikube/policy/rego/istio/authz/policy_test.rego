package istio.authz

test_health_check_allowed {
    allow with input as
      {
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
}