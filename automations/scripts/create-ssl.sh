# ca-root for sign all certificates
# truststore contain only ca-root certificate
# keystore contain ca-root and broker certificates

#!/bin/bash

set -e

dt=`date +%F`
PASSWORD="123456"
CERT_DIR="/opt/kafka/certs"
CA_CERT="$CERT_DIR/ca.cert"
CA_KEY="$CERT_DIR/ca.key"
jks_files=$(find $CERT_DIR -maxdepth 1 -type f -name "*.jks")

ORG_UNIT=IT
ORG=Company
COMMON_NAME=kafka.demo.local
LOCALITY=Baku
STATE_PROVINCE=Baku
COUNTRY=AZ
VALIDITY=3650

mkdir -p "$CERT_DIR"


create_certs(){

  BROKERS=("broker.local" "broker2.local" "broker3.local")

  echo "[+] Creating CA-ROOT Certificate..."
  openssl req -new -x509 -keyout "$CA_KEY" -out "$CA_CERT" -days "$VALIDITY" -passout pass:$PASSWORD -subj "/CN=$COMMON_NAME"

  for broker in "${BROKERS[@]}"; do
    echo "[*] $broker preparing for this broker..."

    # Step 1: Creating Keystore
    keytool -genkeypair \
      -alias "$broker" \
      -keyalg RSA \
      -keystore "$CERT_DIR/$broker.keystore.jks" \
      -storepass "$PASSWORD" \
      -keypass "$PASSWORD" \
      -validity $VALIDITY \
      -dname "CN=$broker, OU=$ORG_UNIT, O=$ORG, L=$LOCALITY, ST=$STATE_PROVINCE, C=$COUNTRY"

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


  done

    # Step 5: Creating Truststore and import CA
    keytool -importcert \
      -keystore "$CERT_DIR/kafka.truststore.jks" \
      -alias CARoot \
      -file "$CA_CERT" \
      -storepass "$PASSWORD" -noprompt

  echo ""
  echo "✅ INFO: $dt All Certificate and JKS successfully created !!!"
}

check_jks_files(){
  if [[ -n $jks_files ]]
  then
    echo ".jks files is exists under $CERT_DIR"
    echo "$jks_files"
    echo "WARN: $dt Deleting old jks files..."
    rm -rf $CERT_DIR/*
    sleep 1
    create_certs
  else
    create_certs
  fi
}

check_jks_files