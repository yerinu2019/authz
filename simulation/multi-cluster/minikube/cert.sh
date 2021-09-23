echo "Generate Certificate with step and step-ca"
step certificate create dummy-ca root-cert.pem root-key.pem --profile root-ca  --kty RSA --no-password --insecure --not-after 87600h --san example.com
step certificate create dummy-intermediate-ca ca-cert.pem ca-key.pem --profile intermediate-ca --kty RSA --ca ./root-cert.pem --ca-key ./root-key.pem --no-password --insecure --not-after 43800h --san example.com
step certificate bundle ca-cert.pem root-cert.pem cert-chain.pem