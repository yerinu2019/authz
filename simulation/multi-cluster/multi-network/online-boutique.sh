kubectl --context client create namespace online-boutique
kubectl --context api create namespace online-boutique

kubectl --context client label namespace online-boutique istio-injection=enabled
kubectl --context api label namespace online-boutique istio-injection=enabled

kubectl --context api -n online-boutique apply -f $WORKDIR/istio-multi-primary/central
kubectl --context client -n online-boutique apply -f $WORKDIR/istio-multi-primary/west

# In central cluster
kubectl --context=api -n online-boutique wait --for=condition=available deployment emailservice --timeout=5m
kubectl --context=api -n online-boutique wait --for=condition=available deployment checkoutservice --timeout=5m
kubectl --context=api -n online-boutique wait --for=condition=available deployment shippingservice --timeout=5m
kubectl --context=api -n online-boutique wait --for=condition=available deployment paymentservice --timeout=5m
kubectl --context=api -n online-boutique wait --for=condition=available deployment adservice --timeout=5m
kubectl --context=api -n online-boutique wait --for=condition=available deployment currencyservice --timeout=5m

# In west cluster
kubectl --context=client -n online-boutique wait --for=condition=available deployment frontend --timeout=5m
kubectl --context=client -n online-boutique wait --for=condition=available deployment recommendationservice --timeout=5m
kubectl --context=client -n online-boutique wait --for=condition=available deployment productcatalogservice --timeout=5m
kubectl --context=client -n online-boutique wait --for=condition=available deployment cartservice --timeout=5m
kubectl --context=client -n online-boutique wait --for=condition=available deployment redis-cart --timeout=5m
kubectl --context=client -n online-boutique wait --for=condition=available deployment loadgenerator --timeout=5m

kubectl --context client get -n istio-system service istio-ingressgateway -o json | jq -r '.status.loadBalancer.ingress[0].ip'
kubectl --context api get -n istio-system service istio-ingressgateway -o json | jq -r '.status.loadBalancer.ingress[0].ip'