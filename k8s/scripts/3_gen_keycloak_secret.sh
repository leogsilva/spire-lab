#!/bin/bash

pushd ${PROJECT_HOME}/tmpdir

# create CA key
openssl genrsa -out ca.key 2048

# create CA certificate
openssl req -x509 -new -nodes -sha256 -days 3650 -subj "/CN=example.com" \
  -key ca.key -out ca.crt

# create keycloak server private key
openssl genrsa -out keycloak.key 2048

# prepare certificate configuration 
# On your system the location of the file may be elsewhere.
# You may try:
#     /etc/pki/tls/openssl.cnf
#     /usr/local/ssl/openssl.cnf
#     
cp /etc/ssl/openssl.cnf ssl.cnf
cat >> ssl.cnf << EOF
 [ SAN ]
 basicConstraints = CA:FALSE
 keyUsage = digitalSignature, keyEncipherment
 subjectAltName = DNS:keycloak.keycloak, DNS:keycloak.example.com
EOF

# create certificate-signing request
openssl req -new -sha256 \
  -key keycloak.key \
  -subj "/CN=keycloak" \
  -reqexts SAN \
  -config ssl.cnf \
  -out keycloak.csr

# Generate the final keycloak certificate, signed by CA
openssl x509 -req -extfile ssl.cnf -extensions SAN -in keycloak.csr -CA ca.crt \
  -CAkey ca.key -CAcreateserial -out keycloak.crt -days 365 -sha256

kubectl create secret tls tls-keys -n keycloak \
  --cert=./keycloak.crt --key=./keycloak.key -o yaml --dry-run=client > keycloak_secret.yaml

kubectl apply -f keycloak_secret.yaml

popd