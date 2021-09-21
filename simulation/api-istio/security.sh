export INGRESS_HOST=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
export INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].port}')
export SECURE_INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="https")].port}')
export TCP_INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="tcp")].port}')
# create a root certificate and private key to sign the certificates for services
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -subj '/O=example Inc./CN=example.com' -keyout example.com.key -out example.com.crt
# create a certificate and a private key for api.example.com
openssl req -out api.example.com.csr -newkey rsa:2048 -nodes -keyout api.example.com.key -subj "/CN=api.example.com/O=api organization"
openssl x509 -req -days 365 -CA example.com.crt -CAkey example.com.key -set_serial 0 -in api.example.com.csr -out api.example.com.crt
# create a secret for the ingress gateway
kubectl create -n istio-system secret tls api-credential --key=api.example.com.key --cert=api.example.com.crt