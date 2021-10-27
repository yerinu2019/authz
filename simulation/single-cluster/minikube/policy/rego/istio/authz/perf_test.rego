package istio.authz

test_perf_client1_to_api1_allowed {
    allow with input as perf_client1_to_api1 with data.kubernetes.graphqlpolicies as mock_data
}

test_perf_client100_to_api1_denied {
    not allow with input as perf_client100_to_api1 with data.kubernetes.graphqlpolicies as mock_data
}

test_perf_cant_mutate_fields {
    fields := cant_mutate_fields
    with input as perf_client2_to_api1 with data.kubernetes.graphqlpolicies as mock_data
    fields == {"field1",
                "field2",
                "field3",
                "field4",
                "field5",
                "field6",
                "field7",
                "field8",
                "field9",
                "field10"}
}

test_perf_health_check_allowed {
    allow with input as perf_healthcheck with data.kubernetes.graphqlpolicies as mock_data
}