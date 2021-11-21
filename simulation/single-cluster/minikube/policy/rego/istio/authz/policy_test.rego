package istio.authz

mock_policies =
{
  "api-istio": {
    "api1": {
      "apiVersion": "example.com/v1alpha1",
      "kind": "GraphqlPolicy",
      "metadata": {
        "annotations": {
          "kubectl.kubernetes.io/last-applied-configuration": "{\"apiVersion\":\"example.com/v1alpha1\",\"kind\":\"GraphqlPolicy\",\"metadata\":{\"annotations\":{},\"labels\":{\"api-id\":\"api1\"},\"name\":\"api1\",\"namespace\":\"api-istio\"},\"spec\":{\"acls\":[{\"kind\":\"API\",\"whitelist\":[\"spiffe://cluster.local/ns/clientns/sa/client1\",\"spiffe://cluster.local/ns/clientns/sa/client3\"]}],\"api_id\":\"api1\"}}\n"
        },
        "creationTimestamp": "2021-10-06T14:47:56Z",
        "generation": 2,
        "labels": {
          "api-id": "api1"
        },
        "managedFields": [
          {
            "apiVersion": "example.com/v1alpha1",
            "fieldsType": "FieldsV1",
            "fieldsV1": {
              "f:metadata": {
                "f:annotations": {
                  ".": {},
                  "f:kubectl.kubernetes.io/last-applied-configuration": {}
                },
                "f:labels": {
                  ".": {},
                  "f:api-id": {}
                }
              },
              "f:spec": {
                ".": {},
                "f:acls": {},
                "f:api_id": {}
              }
            },
            "manager": "kubectl-client-side-apply",
            "operation": "Update",
            "time": "2021-10-06T14:47:56Z"
          }
        ],
        "name": "api1",
        "namespace": "api-istio",
        "resourceVersion": "183915",
        "uid": "e27eaaf5-f250-450b-9797-75c771b241c5"
      },
      "spec": {
        "acls": [
          {
            "kind": "API",
            "whitelist": [
              "spiffe://cluster.local/ns/clientns/sa/client1",
              "spiffe://cluster.local/ns/clientns/sa/client3"
            ]
          }
        ],
        "api_id": "api1"
      }
    },
    "api2": {
      "apiVersion": "example.com/v1alpha1",
      "kind": "GraphqlPolicy",
      "metadata": {
        "annotations": {
          "kubectl.kubernetes.io/last-applied-configuration": "{\"apiVersion\":\"example.com/v1alpha1\",\"kind\":\"GraphqlPolicy\",\"metadata\":{\"annotations\":{},\"labels\":{\"api-id\":\"api2\"},\"name\":\"api2\",\"namespace\":\"api-istio\"},\"spec\":{\"acls\":[{\"blacklist\":[\"client4\"],\"kind\":\"API\",\"whitelist\":[\"spiffe://cluster.local/ns/clientns/sa/client2\",\"spiffe://cluster.local/ns/clientns/sa/client3\"]},{\"kind\":\"QUERY\",\"whitelist\":[\"client2\"]},{\"kind\":\"MUTATE\",\"whitelist\":[\"client2\"]},{\"fields\":[\"field1\",\"field2\"],\"kind\":\"FIELD_GROUP\",\"name\":\"fieldgroup1\",\"whitelist\":[\"client1\",\"client2\"]}],\"api_id\":\"api2\"}}\n"
        },
        "creationTimestamp": "2021-10-06T14:47:57Z",
        "generation": 2,
        "labels": {
          "api-id": "api2"
        },
        "managedFields": [
          {
            "apiVersion": "example.com/v1alpha1",
            "fieldsType": "FieldsV1",
            "fieldsV1": {
              "f:metadata": {
                "f:annotations": {
                  ".": {},
                  "f:kubectl.kubernetes.io/last-applied-configuration": {}
                },
                "f:labels": {
                  ".": {},
                  "f:api-id": {}
                }
              },
              "f:spec": {
                ".": {},
                "f:acls": {},
                "f:api_id": {}
              }
            },
            "manager": "kubectl-client-side-apply",
            "operation": "Update",
            "time": "2021-10-06T14:47:57Z"
          }
        ],
        "name": "api2",
        "namespace": "api-istio",
        "resourceVersion": "183924",
        "uid": "6164931e-cc35-4dee-9001-c17fa972ed67"
      },
      "spec": {
        "acls": [
          {
            "kind": "API",
            "whitelist": [
              "spiffe://cluster.local/ns/clientns/sa/client2",
              "spiffe://cluster.local/ns/clientns/sa/client3"
            ]
          },
          {
            "fields": [
              "field1",
              "field2"
            ],
            "kind": "MUTATE_FIELDS",
            "whitelist": [
              "spiffe://cluster.local/ns/clientns/sa/client3",
            ]
          },
          {
            "fields": [
              "field2",
              "field3"
            ],
            "kind": "MUTATE_FIELDS",
            "whitelist": [
              "spiffe://cluster.local/ns/clientns/sa/client4",
            ]
          },
          {
            "fields": [
              "field3",
              "field4"
            ],
            "kind": "MUTATE_FIELDS",
            "whitelist": [
              "spiffe://cluster.local/ns/clientns/sa/client2",
            ]
          }
        ],
        "api_id": "api2"
      }
    }
  }
}

input_c1_to_a1 :=
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

input_c2_to_a2 :=
{
  "attributes": {
    "destination": {
      "address": {
        "socketAddress": {
          "address": "172.17.0.12",
          "portValue": 80
        }
      },
      "principal": "spiffe://cluster.local/ns/api-istio/sa/api2"
    },
    "metadataContext": {},
    "request": {
      "http": {
        "body": "{\"query\":\"query{showCollection {items {title firstEpisodeDate lastEpisodeDate henshinMp4 { url }}}}\"}",
        "headers": {
          ":authority": "api2.api-istio",
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
          "x-forwarded-client-cert": "By=spiffe://cluster.local/ns/api-istio/sa/api2;Hash=612a138cd4323a27208c3ed5ce7c4ab63775ac33dd6d13b772e5e8389717f21d;Subject=\"\";URI=spiffe://cluster.local/ns/clientns/sa/client2",
          "x-forwarded-proto": "http",
          "x-request-id": "7b4c44f1-2c12-912f-a019-b3a167956ed8"
        },
        "host": "api2.api-istio",
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
    "query": "mutation{showCollection {items {title firstEpisodeDate lastEpisodeDate henshinMp4 { url }}}}"
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

test_client1_to_api1_allowed {
    allow with input as input_c1_to_a1 with data.kubernetes.graphqlpolicies as mock_policies
}

test_client2_to_api1_denied {
    not allow with input as {
        "attributes": {
                  "request": {
                    "http": {
                      "host": "api1.api-istio",
                      "path": "/",
                      "source": {
                          "principal": "spiffe://cluster.local/ns/clientns/sa/client2"
                        },
                      "headers": {
                        "X-Forwarded-Client-Cert":
                        "By=spiffe://cluster.local/ns/api-istio/sa/api1;Hash=fc67247d5fcb211ba49b72d73b65cdbdcc514052bb14f0d104875ed986da9329;Subject=\"\";URI=spiffe://cluster.local/ns/clientns/sa/client2"
                      },
                    },
                  },
                },
              }
        with data.kubernetes.graphqlpolicies as mock_policies
}

test_client1_to_api2_denied {
    deny with input as {
        "attributes": {
                  "request": {
                    "http": {
                      "host": "api2.api-istio",
                      "path": "/",
                      "source": {
                          "principal": "spiffe://cluster.local/ns/clientns/sa/client1"
                        },
                      "headers": {
                        "X-Forwarded-Client-Cert":
                        "By=spiffe://cluster.local/ns/api-istio/sa/api2;Hash=fc67247d5fcb211ba49b72d73b65cdbdcc514052bb14f0d104875ed986da9329;Subject=\"\";URI=spiffe://cluster.local/ns/clientns/sa/client1"
                      },
                    },
                  },
                },
              }
        with data.kubernetes.graphqlpolicies as mock_policies
}

test_client2_to_api2_allowed {
    result := allow with input as input_c2_to_a2 with data.kubernetes.graphqlpolicies as mock_policies
    trace(sprintf("result: %v", [result]))
    result == {
        "allowed": true,
        "http_status": 200,
        "headers": {
            "X-CANT-MUTATE": "field1,field2"
        },
    }
}

test_gql_mutate {
    mutateFieldBlacklist == {"f1", "f2.f3"}
}

test_api_policy {
    api_policy == {"acls": [{"kind": "API", "whitelist": ["c1", "c3"]}]}
    with input as {
        "attributes": {
            "request": {
                "http": {
                    "host": "api1.api-istio"
                }
            }
        }
    }
    with data.kubernetes.graphqlpolicies as {
        "api-istio": {
            "api1": {
                "acls": [
                    {"kind": "API", "whitelist": ["c1", "c3"]}
                ]
            },
            "api2": {
                "acls": [
                    {"kind": "API", "whitelist": ["c2", "c3"]}
                ]
            }
        }
    }
}

test_api_acl {
    api_acl == {"kind": "API", "whitelist": ["c1", "c2"]}
    with input as
    {
        "attributes": {
            "request": {
                "http": {
                    "host": "api1.api-istio"
                }
            }
        }
    }
    with data.kubernetes.graphqlpolicies as {
        "api-istio": {
            "api1": {
                "spec": {
                    "acls": [
                        {"kind": "API", "whitelist": ["c1", "c2"]},
                        {"kind": "MUTATE_FIELDS", "fields": ["f1", "f2"], "whitelist": ["c3","c4"]}
                    ]
                }
            }
        }
    }
}

test_mutate_fields_acl {
    mutate_fields_acl == {{"kind": "MUTATE_FIELDS", "fields": ["f1", "f2"], "whitelist": ["c3","c4"]}}
    with input as
    {
        "attributes": {
            "request": {
                "http": {
                    "host": "api1.api-istio"
                }
            }
        }
    }
    with data.kubernetes.graphqlpolicies as {
        "api-istio": {
            "api1": {
                "spec": {
                    "acls": [
                        {"kind": "API", "whitelist": ["c1", "c2"]},
                        {"kind": "MUTATE_FIELDS", "fields": ["f1", "f2"], "whitelist": ["c3","c4"]}
                    ]
                }
            }
        }
    }
}

test_whitelisted {
    acl := {"kind": "MUTATE_FIELDS", "whitelist": ["c1", "c2"]}
    whitelisted(acl)
    with input as {
        "attributes": {
            "source": {
                "principal": "c1"
            }
        }
    }
}

test_cant_mutate_fields {
    fields := cant_mutate_fields
    with input as
    {
        "attributes": {
            "request": {
                "http": {
                    "host": "api1.api-istio"
                }
            },
            "source": {
                "principal": "c1"
            }
        }
    }
    with data.kubernetes.graphqlpolicies as {
        "api-istio": {
            "api1": {
                "spec": {
                    "acls": [
                        {"kind": "MUTATE_FIELDS", "fields": ["f1", "f2"], "whitelist": ["c3","c4"]}
                    ]
                }
            }
        }
    }
    trace(sprintf("fields: %v", [fields]))
    fields == {"f1", "f2"}
}

test_multiple_cant_mutate_fields_acl {
    fields := cant_mutate_fields
    with input as
    {
        "attributes": {
            "request": {
                "http": {
                    "host": "api1.api-istio"
                }
            },
            "source": {
                "principal": "c1"
            }
        }
    }
    with data.kubernetes.graphqlpolicies as {
        "api-istio": {
            "api1": {
                "spec": {
                    "acls": [
                        {"kind": "MUTATE_FIELDS", "fields": ["f1", "f2"], "whitelist": ["c3","c4"]},
                        {"kind": "MUTATE_FIELDS", "fields": ["f2", "f3"], "whitelist": ["c3","c4"]},
                    ]
                }
            }
        }
    }
    trace(sprintf("fields: %v", [fields]))
    fields == {"f1", "f2", "f3"}
}

test_multiple_can_mutate_fields_acl {
    fields := can_mutate_fields
    with input as
    {
        "attributes": {
            "request": {
                "http": {
                    "host": "api1.api-istio"
                }
            },
            "source": {
                "principal": "c1"
            }
        }
    }
    with data.kubernetes.graphqlpolicies as {
        "api-istio": {
            "api1": {
                "spec": {
                    "acls": [
                        {"kind": "MUTATE_FIELDS", "fields": ["f1", "f2"], "whitelist": ["c1","c4"]},
                        {"kind": "MUTATE_FIELDS", "fields": ["f2", "f3"], "whitelist": ["c1","c4"]},
                    ]
                }
            }
        }
    }
    trace(sprintf("fields: %v", [fields]))
    fields == {"f1", "f2", "f3"}
}

test_cant_mutate_minus_can_mutate {
    fields := cant_mutate_fields - can_mutate_fields
    with input as
    {
        "attributes": {
            "request": {
                "http": {
                    "host": "api1.api-istio"
                }
            },
            "source": {
                "principal": "c1"
            }
        }
    }
    with data.kubernetes.graphqlpolicies as {
        "api-istio": {
            "api1": {
                "spec": {
                    "acls": [
                        {"kind": "MUTATE_FIELDS", "fields": ["f1", "f2"], "whitelist": ["c4","c4"]},
                        {"kind": "MUTATE_FIELDS", "fields": ["f2", "f3"], "whitelist": ["c3","c4"]},
                        {"kind": "MUTATE_FIELDS", "fields": ["f3", "f4"], "whitelist": ["c1", "c4"]}
                    ]
                }
            }
        }
    }
    trace(sprintf("fields: %v", [fields]))
    fields == {"f1", "f2"}
}

test_emptyPolicy_denied {
    deny with data.kubernetes.graphqlpolicies as {}
}

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
