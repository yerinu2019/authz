#!/bin/bash
opa test -v --bench --count 10 --format gobench ./istio/authz/mock_data.rego ./istio/authz/mock_input.rego ./istio/authz/perf_test.rego ./istio/authz/policy.rego ./istio/authz/mask.rego | tee ./perf.txt
benchstat ./perf.txt