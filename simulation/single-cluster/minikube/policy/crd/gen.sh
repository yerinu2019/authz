#!/bin/bash

for num in {3..4}
do
  api="api${num}"
  if [ ! -d $api ]
  then
    echo "create directory ${api}"
    mkdir $api
  fi
  #echo "create file ${api}/acl.yaml"
  left=25
  right=50
  low=$((num - left))
  low=$((low>0 ? low : 1))
  high=$((low+right))
  clients=""
  enter=$'\n'
  for clientnum in $(seq $low $high);
  do
    tmp="    - spiffe://cluster.local/ns/clientns/sa/client1${clientnum}${enter}"
    client=$client$tmp
  done
cat > ${api}/acl.yaml << EOF
apiVersion: "example.com/v1alpha1"
kind: GraphqlPolicy
metadata:
  name: ${api}
  namespace: api-istio
  labels:
    api-id: ${api}
spec:
  acls:
  - kind: API
    whitelist:
${client}
EOF
  #kubectl -n api-istio apply -f ${api}/acl.yaml
done