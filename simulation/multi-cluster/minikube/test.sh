echo "mTLS testing"
echo "Install httpbin service in Cluster2"
echo "Create namespace istio-testing and enable injection."
kubectl --context cluster2 create namespace istio-testing
kubectl --context cluster2 label namespace istio-testing istio-injection=enabled

echo "Apply httpbin deployment and service"
kubectl --context cluster2 apply -f - <<EOF
apiVersion: v1
kind: Service
metadata:
  name: httpbin
  namespace: istio-testing
  labels:
    app: httpbin
spec:
  ports:
  - name: http
    port: 80
  selector:
    app: httpbin
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: httpbin
  namespace: istio-testing
spec:
  replicas: 1
  selector:
    matchLabels:
      app: httpbin
      version: v1
  template:
    metadata:
      labels:
        app: httpbin
        version: v1
    spec:
      containers:
      - image: docker.io/kennethreitz/httpbin
        imagePullPolicy: IfNotPresent
        name: httpbin
        ports:
        - containerPort: 80
EOF

# ServiceEntry is a special object in Istio, this basically configure in istiocoredns to resolve
# httpbin.istio-testing.global into an unused ip 240.0.0.2 and force sidecar to forward the traffic into
# specific endpoint (ingressgateway cluster2 with a special port 15443) and force mutual TLS.
echo "Install sleep deployment and Istio ServiceEntry in Cluster1"
kubectl --context cluster1 create namespace istio-testing
kubectl --context cluster1 label namespace istio-testing istio-injection=enabled

kubectl --context cluster1 apply -f - <<EOF
---
apiVersion: networking.istio.io/v1beta1
kind: ServiceEntry
metadata:
  name: httpbin-cluster2-se
spec:
  hosts:
    - httpbin.istio-testing.global
  location: MESH_INTERNAL
  ports:
    - name: http
      number: 80
      protocol: http
  resolution: DNS
  addresses:
    - 240.0.0.2
  endpoints:
    - address: $(minikube --profile cluster2 ip)
      ports:
        http: $(kubectl --context cluster2 get svc -n istio-system istio-ingressgateway -o=jsonpath='{.spec.ports[?(@.port==443)].nodePort}')
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: sleep
  namespace: istio-testing
spec:
  replicas: 1
  selector:
    matchLabels:
      app: sleep
  template:
    metadata:
      labels:
        app: sleep
    spec:
      containers:
        - name: sleep
          image: governmentpaas/curl-ssl
          command: ["/bin/sleep", "3650d"]
          imagePullPolicy: IfNotPresent
EOF

echo "Exec from sleep pod in Cluster1"
kubectl --context cluster1 -n istio-testing -it $(kubectl --context cluster1 -n istio-testing get pod | grep -m 1 sleep | awk '{print $1}') -c sleep -- sh

# Test nslookup
# nslookup httpbin.istio-testing.global
#
# Test curl
# curl http://httpbin.istio-testing.global/headers