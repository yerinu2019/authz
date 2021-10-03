#!/bin/bash

echo "build"
opa build -b .
echo "upload"
gsutil cp -p bundle.tar.gz gs://test-opa-policy-bundles
