KAFKA_VERSION: "${kafka_version}"
SCALA_VERSION: "${scala_version}"
KAFKA_DIR: "${kafka_dir}"
KAFKA_TARBALL: "kafka_${scala_version}-${kafka_version}.tgz"
KAFKA_URL: "https://downloads.apache.org/kafka/${kafka_version}/kafka_${scala_version}-${kafka_version}.tgz"
KAFKA_EXTRACT: "kafka_${scala_version}-${kafka_version}"
KAFKA_SERVER_CONFIG: "${kafka_dir}/config/server.properties"
KAFKA_SERVICE_PATH: "/etc/systemd/system/kafka.service"

KAFKA_CLUSTER_ID: "${kafka_cluster_id}"
BROKER_PORT: ${broker_port}
CONTROLLER_PORT: ${controller_port}
CLIENT_PORT: ${client_port}

SASL_USERNAME: "${sasl_username}"
SASL_PASSWORD: "${sasl_password}"

KEYSTORE_PATH: "${kafka_dir}/certs/{{ansible_hostname}}.keystore.jks"
KEYSTORE_PASS: "${keystore_pass}"
KEY_PASS: "${key_pass}"
TRUSTSTORE_PATH: "${kafka_dir}/certs/kafka.truststore.jks"
TRUSTSTORE_PASS: "${truststore_pass}"

CERT_PATH: "${kafka_dir}/certs"
SCRIPT_PATH: "${kafka_dir}/create-ssl.sh"
JAAS_PATH: "${kafka_dir}/config/kafka-server-jaas.conf"

## Creating new user and give ACL ENV
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