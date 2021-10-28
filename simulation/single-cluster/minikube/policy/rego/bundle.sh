#!/bin/bash

echo "build"
opa build -b -o bundle$1.tar.gz .
echo "upload"
gsutil cp -p bundle$1.tar.gz gs://test-opa-policy-bundles