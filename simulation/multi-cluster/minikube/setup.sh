#kube.sh
#cert.sh

echo "Add Kiali environment"
KIALI_USERNAME=$(read -p 'Kiali Username: ' uval && echo -n $uval | base64)
KIALI_PASSPHRASE=$(read -sp 'Kiali Passphrase: ' pval && echo -n $pval | base64)
NAMESPACE=istio-system

echo "Install Istio in Cluster1"
echo "Add cacerts certificate"
kubectl --context cluster1 create namespace istio-system
kubectl --context cluster1 create secret generic cacerts -n istio-system \
    --from-file=ca-cert.pem \
    --from-file=ca-key.pem \
    --from-file=root-cert.pem \
    --from-file=cert-chain.pem

echo "Add kiali secret"
kubectl --context cluster1 apply -f - <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: kiali
  namespace: $NAMESPACE
  labels:
    app: kiali
type: Opaque
data:
  username: $KIALI_USERNAME
  passphrase: $KIALI_PASSPHRASE
EOF

echo "Install Istio"
istioctl --context cluster1 manifest apply -f istio.yaml

echo "Patch the coredns"
kubectl --context cluster1 apply -f - <<EOF
apiVersion: v1
kind: ConfigMap
metadata:
  name: coredns
  namespace: kube-system
data:
  Corefile: |
    .:53 {
        errors
        health
        kubernetes cluster.local in-addr.arpa ip6.arpa {
           pods insecure
           upstream
           fallthrough in-addr.arpa ip6.arpa
        }
        prometheus :9153
        proxy . /etc/resolv.conf
        cache 30
        loop
        reload
        loadbalance
    }
    global:53 {
        errors
        cache 30
        proxy . $(kubectl --context cluster1 get svc -n istio-system istiocoredns -o jsonpath={.spec.clusterIP})
    }
EOF

echo "Install Istio in cluster2"
echo "Add cacerts certificate"
kubectl --context cluster2 create namespace istio-system
kubectl --context cluster2 create secret generic cacerts -n istio-system \
    --from-file=ca-cert.pem \
    --from-file=ca-key.pem \
    --from-file=root-cert.pem \
    --from-file=cert-chain.pem

echo "Add kiali secret"
kubectl --context cluster2 apply -f - <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: kiali
  namespace: $NAMESPACE
  labels:
    app: kiali
type: Opaque
data:
  username: $KIALI_USERNAME
  passphrase: $KIALI_PASSPHRASE
EOF

echo "Install Istio"
istioctl --context cluster2 manifest apply -f istio.yaml

echo "Patch the coredns"
kubectl --context cluster2 apply -f - <<EOF
apiVersion: v1
kind: ConfigMap
metadata:
  name: coredns
  namespace: kube-system
data:
  Corefile: |
    .:53 {
        errors
        health
        kubernetes cluster.local in-addr.arpa ip6.arpa {
           pods insecure
           upstream
           fallthrough in-addr.arpa ip6.arpa
        }
        prometheus :9153
        proxy . /etc/resolv.conf
        cache 30
        loop
        reload
        loadbalance
    }
    global:53 {
        errors
        cache 30
        proxy . $(kubectl --context cluster2 get svc -n istio-system istiocoredns -o jsonpath={.spec.clusterIP})
    }
EOF

