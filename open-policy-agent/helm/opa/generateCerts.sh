#!/usr/bin/env bash

# from opa: https://www.openpolicyagent.org/docs/latest/kubernetes-tutorial/

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CERT_DIR=$SCRIPT_DIR/certs

rm -rf $CERT_DIR
mkdir -p $CERT_DIR


openssl genrsa -out "$CERT_DIR/opa-ca.key" 2048
openssl req -x509 -new -nodes -key "$CERT_DIR/opa-ca.key" -out "$CERT_DIR/opa-ca.crt" -subj "/CN=admission_ca" -days 100000


cat > "$CERT_DIR/opa-server.cnf" <<EOL
[req]
req_extensions = v3_req
distinguished_name = req_distinguished_name
[req_distinguished_name]
[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
extendedKeyUsage = clientAuth, serverAuth
EOL


openssl genrsa -out "$CERT_DIR/opa-server.key" 2048
openssl req -new -key "$CERT_DIR/opa-server.key" -out "$CERT_DIR/opa-server.csr" -subj "/CN=opa-svc.opa.svc" -config "$CERT_DIR/opa-server.cnf"

openssl x509 -req -days 100000 -in "$CERT_DIR/opa-server.csr" \
        -CA "$CERT_DIR/opa-ca.crt" -CAkey "$CERT_DIR/opa-ca.key" -CAcreateserial \
        -out "$CERT_DIR/opa-server.crt" -extfile "$CERT_DIR/opa-server.cnf" -extensions v3_req 
