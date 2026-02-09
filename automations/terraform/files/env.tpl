# KAFKA ENV

KAFKA_VERSION: "${kafka_version}"
SCALA_VERSION: "${scala_version}"
KAFKA_DIR: "${kafka_dir}"
KAFKA_TARBALL: "kafka_${scala_version}-${kafka_version}.tgz"
KAFKA_URL: "https://downloads.apache.org/kafka/${kafka_version}/kafka_${scala_version}-${kafka_version}.tgz"
KAFKA_EXTRACT: "kafka_${scala_version}-${kafka_version}"
KAFKA_SERVER_CONFIG: "${kafka_dir}/config/server.properties"
KAFKA_SERVICE_PATH: "/etc/systemd/system/kafka.service"
KAFKA_LOG_DIR: "/var/lib/kafka"

KAFKA_CLUSTER_ID: "${kafka_cluster_id}"
BROKER_PORT: ${broker_port}
CONTROLLER_PORT: ${controller_port}
CLIENT_PORT: ${client_port}

SASL_USERNAME: "${sasl_username}"
SASL_PASSWORD: "${sasl_password}"

# Certificate ENV

ORG_UNIT: ${org_unit}
ORG: ${org}
COMMON_NAME: ${common_name}
LOCALITY: ${locality}
STATE_PROVINCE: ${state_province}
COUNTRY: ${country}
VALIDITY: ${cert_validity}

KEYSTORE_PATH: "${kafka_dir}/certs"
KEYSTORE_PASS: "${keystore_pass}"
KEY_PASS: "${key_pass}"
TRUSTSTORE_PATH: "${kafka_dir}/certs"
TRUSTSTORE_PASS: "${truststore_pass}"

# SSL Type Configuration (JKS or PEM)
SSL_KEYSTORE_TYPE: "${ssl_keystore_type}"
SSL_TRUSTSTORE_TYPE: "${ssl_truststore_type}"
SSL_USER_DN: "${ssl_user_dn}"

CERT_PATH: "${kafka_dir}/certs"
SCRIPT_PATH: "${kafka_dir}/create-ssl.sh"
JAAS_PATH: "${kafka_dir}/config/kafka-server-jaas.conf"

# Creating new user and give ACL ENV

HOSTNAME: "${kafka_broker_ip}"
CLIENT_PASSWORD: "${client_password}"
CLIENT_USERNAME: "${client_username}"
CLIENT_CONFIG: "{{kafka_dir}}/config/client.properties"
TOPICS:
%{ for topic in kafka_topics ~}
  - "${topic}"
%{ endfor ~}

OPERATIONS:
%{ for op in kafka_operations ~}
  - "${op}"
%{ endfor ~}

GROUP:
%{ for gr in kafka_acl_groups ~}
  - "${gr}"
%{ endfor ~}