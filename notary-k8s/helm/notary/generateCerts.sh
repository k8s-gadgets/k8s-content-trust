#!/usr/bin/env bash

# file from tuf/notary: https://github.com/theupdateframework/notary/blob/master/fixtures/regenerateTestingCerts.sh

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CERT_DIR=$SCRIPT_DIR/certs

rm -rf $CERT_DIR
mkdir -p $CERT_DIR


# First generates root-ca
openssl genrsa -out "$CERT_DIR/root-ca.key" 4096
openssl req -new -key "$CERT_DIR/root-ca.key" -out "$CERT_DIR/root-ca.csr" -sha256 \
        -subj '/CN=notary-ca'

cat > "$CERT_DIR/root-ca.cnf" <<EOL
[root_ca]
basicConstraints = critical,CA:TRUE,pathlen:1
keyUsage = critical, nonRepudiation, cRLSign, keyCertSign
subjectKeyIdentifier=hash
EOL

openssl x509 -req -days 3650 -in "$CERT_DIR/root-ca.csr" -signkey "$CERT_DIR/root-ca.key" -sha256 \
        -out "$CERT_DIR/root-ca.crt" -extfile "$CERT_DIR/root-ca.cnf" -extensions root_ca

rm "$CERT_DIR/root-ca.cnf" "$CERT_DIR/root-ca.csr"

# Then generate intermediate-ca
openssl genrsa -out "$CERT_DIR/intermediate-ca.key" 4096
openssl req -new -key "$CERT_DIR/intermediate-ca.key" -out "$CERT_DIR/intermediate-ca.csr" -sha256 \
        -subj '/CN=notary-intermediate-ca'

cat > "$CERT_DIR/intermediate-ca.cnf" <<EOL
[intermediate_ca]
authorityKeyIdentifier=keyid,issuer
basicConstraints = critical,CA:TRUE,pathlen:0
extendedKeyUsage=serverAuth,clientAuth
keyUsage = critical, nonRepudiation, cRLSign, keyCertSign
subjectKeyIdentifier=hash
EOL

openssl x509 -req -days 3650 -in "$CERT_DIR/intermediate-ca.csr" -sha256 \
        -CA "$CERT_DIR/root-ca.crt" -CAkey "$CERT_DIR/root-ca.key"  -CAcreateserial \
        -out "$CERT_DIR/intermediate-ca.crt" -extfile "$CERT_DIR/intermediate-ca.cnf" -extensions intermediate_ca

rm "$CERT_DIR/intermediate-ca.cnf" "$CERT_DIR/intermediate-ca.csr"
rm "$CERT_DIR/root-ca.srl"
# rm "$CERT_DIR/root-ca.key"


# Then generate notary-server
openssl genrsa -out "$CERT_DIR/notary-server.key" 4096
openssl req -new -key "$CERT_DIR/notary-server.key" -out "$CERT_DIR/notary-server.csr" -sha256 \
        -subj '/CN=notary-server'

cat > "$CERT_DIR/notary-server.cnf" <<EOL
[notary_server]
authorityKeyIdentifier=keyid,issuer
basicConstraints = critical,CA:FALSE
extendedKeyUsage=serverAuth,clientAuth
keyUsage = critical, digitalSignature, keyEncipherment
# subjectAltName = DNS:notary-server, DNS:notaryserver, DNS:localhost, IP:127.0.0.1   # local testing
subjectAltName = DNS:notary-server-svc, DNS:notary-server-svc.notary, DNS:notary-server-svc.notary.svc, DNS:notary-server-svc.notary.svc.cluster, DNS:notary-server-svc.notary.svc.cluster.local
subjectKeyIdentifier=hash
EOL


openssl x509 -req -days 750 -in "$CERT_DIR/notary-server.csr" -sha256 \
        -CA "$CERT_DIR/intermediate-ca.crt" -CAkey "$CERT_DIR/intermediate-ca.key"  -CAcreateserial \
        -out "$CERT_DIR/notary-server.crt" -extfile "$CERT_DIR/notary-server.cnf" -extensions notary_server
# append the intermediate cert to this one to make it a proper bundle
cat "$CERT_DIR/intermediate-ca.crt" >> "$CERT_DIR/notary-server.crt"

rm "$CERT_DIR/notary-server.cnf" "$CERT_DIR/notary-server.csr"

# Then generate notary-signer
openssl genrsa -out "$CERT_DIR/notary-signer.key" 4096
openssl req -new -key "$CERT_DIR/notary-signer.key" -out "$CERT_DIR/notary-signer.csr" -sha256 \
        -subj '/CN=notary-signer'

cat > "$CERT_DIR/notary-signer.cnf" <<EOL
[notary_signer]
authorityKeyIdentifier=keyid,issuer
basicConstraints = critical,CA:FALSE
extendedKeyUsage=serverAuth,clientAuth
keyUsage = critical, digitalSignature, keyEncipherment
# subjectAltName = DNS:notary-signer, DNS:notarysigner, DNS:localhost, IP:127.0.0.1   # local testing
subjectAltName = DNS:notary-signer-svc, DNS:notary-signer-svc.notary, DNS:notary-signer-svc.notary.svc, DNS:notary-signer-svc.notary.svc.cluster, DNS:notary-signer-svc.notary.svc.cluster.local
subjectKeyIdentifier=hash
EOL

openssl x509 -req -days 750 -in "$CERT_DIR/notary-signer.csr" -sha256 \
        -CA "$CERT_DIR/intermediate-ca.crt" -CAkey "$CERT_DIR/intermediate-ca.key"  -CAcreateserial \
        -out "$CERT_DIR/notary-signer.crt" -extfile "$CERT_DIR/notary-signer.cnf" -extensions notary_signer
# append the intermediate cert to this one to make it a proper bundle
cat "$CERT_DIR/intermediate-ca.crt" >> "$CERT_DIR/notary-signer.crt"

rm "$CERT_DIR/notary-signer.cnf" "$CERT_DIR/notary-signer.csr"
rm "$CERT_DIR/intermediate-ca.srl"

# Then generate notary-wrapper
openssl genrsa -out "$CERT_DIR/notary-wrapper.key" 4096
openssl req -new -key "$CERT_DIR/notary-wrapper.key" -out "$CERT_DIR/notary-wrapper.csr" -sha256 \
        -subj '/CN=notary-wrapper'

cat > "$CERT_DIR/notary-wrapper.cnf" <<EOL
[notary_wrapper]
authorityKeyIdentifier=keyid,issuer
basicConstraints = critical,CA:FALSE
extendedKeyUsage=serverAuth,clientAuth
keyUsage = critical, digitalSignature, keyEncipherment
subjectAltName = DNS:notary-wrapper-svc, DNS:notary-wrapper-svc.opa, DNS:notary-wrapper-svc.opa.svc, DNS:notary-wrapper-svc.opa.svc.cluster, DNS:notary-wrapper-svc.opa.svc.cluster.local
subjectKeyIdentifier=hash
EOL

openssl x509 -req -days 750 -in "$CERT_DIR/notary-wrapper.csr" -sha256 \
        -CA "$CERT_DIR/intermediate-ca.crt" -CAkey "$CERT_DIR/intermediate-ca.key"  -CAcreateserial \
        -out "$CERT_DIR/notary-wrapper.crt" -extfile "$CERT_DIR/notary-wrapper.cnf" -extensions notary_wrapper
# append the intermediate cert to this one to make it a proper bundle
cat "$CERT_DIR/intermediate-ca.crt" >> "$CERT_DIR/notary-wrapper.crt"

rm "$CERT_DIR/notary-wrapper.cnf" "$CERT_DIR/notary-wrapper.csr"
rm "$CERT_DIR/intermediate-ca.srl"
