export API_GW_ADDR=$(kubectl get --context=api svc --selector=app=istio-eastwestgateway \
    -n istio-system -o jsonpath='{.items[0].status.loadBalancer.ingress[0].ip}')

kubectl apply --context=client -n clientns -f - <<EOF
apiVersion: networking.istio.io/v1alpha3
kind: ServiceEntry
metadata:
  name: api1
spec:
  hosts:
  - api1.api-istio.global
  location: MESH_INTERNAL
  ports:
  - name: http1
    number: 80
    protocol: http
  resolution: DNS
  addresses:
  - 240.0.0.2
  endpoints:
  - address: ${API_GW_ADDR}
    ports:
      http1: 15443 # Do not change this port value
EOF