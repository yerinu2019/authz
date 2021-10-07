#!/bin/bash
POD=`kubectl -n $1 get pod -l app=$2 -o jsonpath='{.items..metadata.name}'`
echo POD: $POD
kubectl -n $1 exec $POD -- curl -v -g -sS \
-X POST \
-H "Content-Type: application/json" \
-d '{"query":"mutation { createUser(name: \"John Doe\") }"}' \
$3