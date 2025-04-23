# ca-root for sign all certificates
# truststore contain only ca-root certificate
# keystore contain ca-root and broker certificates

#!/bin/bash

set -e

PASSWORD="123456"
VALIDITY=365
CERT_DIR="/opt/kafka/certs"
CA_CERT="$CERT_DIR/ca.cert"
CA_KEY="$CERT_DIR/ca.key"
mkdir -p "$CERT_DIR"

BROKERS=("broker.local" "broker2.local" "broker3.local")

echo "[+] Creating CA-ROOT Certificate..."
openssl req -new -x509 -keyout "$CA_KEY" -out "$CA_CERT" -days "$VALIDITY" -passout pass:$PASSWORD -subj "/CN=Kafka-CA"

for broker in "${BROKERS[@]}"; do
  echo "[*] $broker preparing for this broker..."

  # Step 1: Creating Keystore
  keytool -genkeypair \
    -alias "$broker" \
    -keyalg RSA \
    -keystore "$CERT_DIR/$broker.keystore.jks" \
    -storepass "$PASSWORD" \
    -keypass "$PASSWORD" \
    -dname "CN=$broker, OU=Kafka, O=Kafka, L=Baku, ST=Baku, C=AZ"

  # Step 2: Creating CSR
  keytool -certreq \
    -alias "$broker" \
    -keystore "$CERT_DIR/$broker.keystore.jks" \
    -file "$CERT_DIR/$broker.csr" \
    -storepass "$PASSWORD"

  # Step 3: Signing with CA
  openssl x509 -req \
    -CA "$CA_CERT" \
    -CAkey "$CA_KEY" \
    -in "$CERT_DIR/$broker.csr" \
    -out "$CERT_DIR/$broker-signed.crt" \
    -days "$VALIDITY" \
    -CAcreateserial \
    -passin pass:$PASSWORD

  # Step 4: CA and signed cert importing to keystore
  keytool -importcert \
    -keystore "$CERT_DIR/$broker.keystore.jks" \
    -alias CARoot \
    -file "$CA_CERT" \
    -storepass "$PASSWORD" -noprompt

  keytool -importcert \
    -keystore "$CERT_DIR/$broker.keystore.jks" \
    -alias "$broker" \
    -file "$CERT_DIR/$broker-signed.crt" \
    -storepass "$PASSWORD"

  # Step 5: Creating Truststore and import CA
  keytool -importcert \
    -keystore "$CERT_DIR/$broker.truststore.jks" \
    -alias CARoot \
    -file "$CA_CERT" \
    -storepass "$PASSWORD" -noprompt
done

echo ""
echo "✅ All Certificate and JKS successfully created !!!"