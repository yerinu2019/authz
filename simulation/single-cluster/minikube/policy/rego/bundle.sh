#!/bin/bash

echo "build"
opa build -b -o authz-bundle.tar.gz .
echo "upload"
gsutil cp -p authz-bundle.tar.gz gs://test-opa-policy-bundles