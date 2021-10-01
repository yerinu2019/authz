package authz

api_whitelist = ["spiffe://cluster.local/ns/clientns/sa/client1",
			"spiffe://cluster.local/ns/clientns/sa/client3",]

test_xfcc_allowed {
    allow with input as 
    {
        "attributes": {
            "request": {
                "http": {
                    "headers": {
        "X-Forwarded-Client-Cert": 
        "By=spiffe://cluster.local/ns/api-istio/sa/api1;Hash=86df29e74ec819ebd2eba49bb5fc37e54a084f6b8de44d4c123f4a95056d7c2d;Subject=\"\";URI=spiffe://cluster.local/ns/clientns/sa/client1",
                               }
                        }
                       }
                     }
    } with data.api_whitelist as api_whitelist
}

test_xfcc_not_allowed {
    not allow with input as 
    {
        "attributes": {
            "request": {
                "http": {
                    "headers": {
        "X-Forwarded-Client-Cert": 
        "By=spiffe://cluster.local/ns/api-istio/sa/api1;Hash=86df29e74ec819ebd2eba49bb5fc37e54a084f6b8de44d4c123f4a95056d7c2d;Subject=\"\";URI=spiffe://cluster.local/ns/clientns/sa/client2",
                               }
                        }
                       }
                     }
    } with data.api_whitelist as api_whitelist
}

test_post_allowed {
    allow with input as {"path": ["users"], "method": "POST"}
}

test_get_anonymous_denied {
    not allow with input as {"path": ["users"], "method": "GET"}
}

test_get_user_allowed {
    allow with input as {"path": ["users", "bob"], "method": "GET", "user_id": "bob"}
}

test_get_another_user_denied {
    not allow with input as {"path": ["users", "bob"], "method": "GET", "user_id": "alice"}
}

