#!/bin/bash

echo "build"
opa build -b .
echo "upload"
gsutil cp bundle.tar.gz gs://test-opa-policy-bundles
