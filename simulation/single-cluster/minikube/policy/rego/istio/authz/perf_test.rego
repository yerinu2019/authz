package istio.authz

test_client1_to_api1_allowed {
    allow with input as client1_to_api1 with data.kubernetes.graphqlpolicies as mock_data
}

test_cant_mutate_fields {
    fields := cant_mutate_fields
    with input as client2_to_api1 with data.kubernetes.graphqlpolicies as mock_data
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