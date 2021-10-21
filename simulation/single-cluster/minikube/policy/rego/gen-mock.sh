#!/bin/bash

cat > istio/authz/mock_data.rego << EOF
package istio.authz

mock_data = 
{
  "api-istio": {
EOF
for num in {1..200}
do
    api="api${num}"
    client="client${num}"

cat >> istio/authz/mock_data.rego << EOF
    "${api}": {
      "apiVersion": "example.com/v1alpha1",
      "kind": "GraphqlPolicy",
      "metadata": {
        "annotations": {
          "kubectl.kubernetes.io/last-applied-configuration": "{\"apiVersion\":\"example.com/v1alpha1\",\"kind\":\"GraphqlPolicy\",\"metadata\":{\"annotations\":{},\"labels\":{\"api-id\":\"${api}\"},\"name\":\"${api}\",\"namespace\":\"api-istio\"},\"spec\":{\"acls\":[{\"kind\":\"API\",\"whitelist\":[\"spiffe://cluster.local/ns/clientns/sa/${client}\"]}]}}\n"
        },
        "creationTimestamp": "2021-10-06T14:47:56Z",
        "generation": 2,
        "labels": {
          "api-id": "${api}"
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
              }
            },
            "manager": "kubectl-client-side-apply",
            "operation": "Update",
            "time": "2021-10-06T14:47:56Z"
          }
        ],
        "name": "${api}",
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
              "spiffe://cluster.local/ns/clientns/sa/client2",
              "spiffe://cluster.local/ns/clientns/sa/client3",
              "spiffe://cluster.local/ns/clientns/sa/client4",
              "spiffe://cluster.local/ns/clientns/sa/client5",
              "spiffe://cluster.local/ns/clientns/sa/client6",
              "spiffe://cluster.local/ns/clientns/sa/client7",
              "spiffe://cluster.local/ns/clientns/sa/client8",
              "spiffe://cluster.local/ns/clientns/sa/client9",
              "spiffe://cluster.local/ns/clientns/sa/client10",
              "spiffe://cluster.local/ns/clientns/sa/client11",
              "spiffe://cluster.local/ns/clientns/sa/client12",
              "spiffe://cluster.local/ns/clientns/sa/client13",
              "spiffe://cluster.local/ns/clientns/sa/client14",
              "spiffe://cluster.local/ns/clientns/sa/client15",
              "spiffe://cluster.local/ns/clientns/sa/client16",
              "spiffe://cluster.local/ns/clientns/sa/client17",
              "spiffe://cluster.local/ns/clientns/sa/client18",
              "spiffe://cluster.local/ns/clientns/sa/client19",
              "spiffe://cluster.local/ns/clientns/sa/client20",
              "spiffe://cluster.local/ns/clientns/sa/client21",
              "spiffe://cluster.local/ns/clientns/sa/client22",
              "spiffe://cluster.local/ns/clientns/sa/client23",
              "spiffe://cluster.local/ns/clientns/sa/client24",
              "spiffe://cluster.local/ns/clientns/sa/client25",
              "spiffe://cluster.local/ns/clientns/sa/client26",
              "spiffe://cluster.local/ns/clientns/sa/client27",
              "spiffe://cluster.local/ns/clientns/sa/client28",
              "spiffe://cluster.local/ns/clientns/sa/client29",
              "spiffe://cluster.local/ns/clientns/sa/client30",
              "spiffe://cluster.local/ns/clientns/sa/client31",
              "spiffe://cluster.local/ns/clientns/sa/client32",
              "spiffe://cluster.local/ns/clientns/sa/client33",
              "spiffe://cluster.local/ns/clientns/sa/client34",
              "spiffe://cluster.local/ns/clientns/sa/client35",
              "spiffe://cluster.local/ns/clientns/sa/client36",
              "spiffe://cluster.local/ns/clientns/sa/client37",
              "spiffe://cluster.local/ns/clientns/sa/client38",
              "spiffe://cluster.local/ns/clientns/sa/client39",
              "spiffe://cluster.local/ns/clientns/sa/client40",
              "spiffe://cluster.local/ns/clientns/sa/client41",
              "spiffe://cluster.local/ns/clientns/sa/client42",
              "spiffe://cluster.local/ns/clientns/sa/client43",
              "spiffe://cluster.local/ns/clientns/sa/client44",
              "spiffe://cluster.local/ns/clientns/sa/client45",
              "spiffe://cluster.local/ns/clientns/sa/client46",
              "spiffe://cluster.local/ns/clientns/sa/client47",
              "spiffe://cluster.local/ns/clientns/sa/client48",
              "spiffe://cluster.local/ns/clientns/sa/client49",
              "spiffe://cluster.local/ns/clientns/sa/client50"
            ]
          },
          {
              "kind": "MUTATE_FIELDS",
              "fields": [
                "field1",
                "field2",
                "field3",
                "field4",
                "field5",
                "field6",
                "field7",
                "field8",
                "field9",
                "field10",
              ],
              "whitelist": [
                "spiffe://cluster.local/ns/clientns/sa/${client}",
              ]
          }
        ],
      }
    },
EOF
done

cat >> istio/authz/mock_data.rego << EOF
  }
}
EOF