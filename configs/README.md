## Manual Installation
### 1. Install kafka each broker nodes

```
# if you want specifig version to download visit this site: 
  https://kafka.apache.org/downloads

wget https://dlcdn.apache.org/kafka/4.0.0/kafka_2.13-4.0.0.tgz
tar -xzvf kafka_2.13-4.0.0
mv kafka_2.13-4.0.0/* /opt/kafka
```
First of all we need to run kafka without any security protocol for creating admin user
### 2. Change only this config in "server.properties" file each broker

```
vim /opt/kafka/config/server.properties
```


Find the following lines:
```
...
# The role of this server. Setting this puts us in KRaft mode
process.roles=broker,controller

# The node id associated with this instance's roles
node.id=1

# The connect string for the controller quorum
controller.quorum.bootstrap.servers=broker1.local:9093, broker2.local:9093, broker3.local:9093
...
```

```node.id``` specified the node’s ID in the cluster. This is the first node, so it should be left at 1. All nodes must have unique node IDs, so the second and third nodes will have an ID of 2 and 3, respectively.

```controller.quorum.voters``` maps node IDs to their respective addresses and ports for communication. This is where you’ll specify the addresses of all cluster nodes so that each node is aware of all others. Modify the line to look like this:

```
...
controller.quorum.voters=1@broker1.local:9093,2@broker2.local:9093,3@broker3.local:9093
...
```

Next, find the following lines in the file:
```
...
listeners=PLAINTEXT://:9092,CONTROLLER://:9093

# Name of listener used for communication between brokers.
inter.broker.listener.name=PLAINTEXT

# Listener name, hostname and port the broker will advertise to clients.
advertised.listeners=PLAINTEXT://broker1.local:9092

num.partitions=6
...
```
As the comment states, this configures each new topic’s default number of partitions. Since you have three nodes, set it to a multiple of two:
A value of 6 here ensures that each node will hold two topic partitions by default.


Next, you’ll configure the replication factor for internal topics, which keeps the consumer offsets and transaction states. Find the following lines:
```
...
offsets.topic.replication.factor=2
transaction.state.log.replication.factor=2
...
```

### 3. Then, generate a new cluster ID and store it an environment variable:
```
# do this only controller node or broker1
 
KAFKA_CLUSTER_ID="$(bin/kafka-storage.sh random-uuid)"

echo $KAFKA_CLUSTER_ID

# Finally, run the following command to generate the log storage:

./bin/kafka-storage.sh format -t $KAFKA_CLUSTER_ID -c config/server.properties

# And write Cluster ID on each broker

KAFKA_CLUSTER_ID="your_cluster_id"

```
### 4. Create system service in all brokers

```
[Unit]
Requires=network.target remote-fs.target
After=network.target remote-fs.target

[Service]
Type=simple
User=root
ExecStart=/bin/sh -c '/opt/kafka/bin/kafka-server-start.sh /opt/kafka/config/server.properties > /opt/kafka/kafka.log 2>&1'
ExecStop=/opt/kafka/bin/kafka-server-stop.sh
Restart=on-abnormal

[Install]
WantedBy=multi-user.target
```
```
sudo systemctl daemon-reload
sudo systemctl enable --now kafka.service
sudo systemctl restart kafka.service
```
Kafka provides the kafka-metadata-quorum.sh script, which shows information about the cluster and its members. Run the following command to execute it:
```
./bin/kafka-metadata-quorum.sh --bootstrap-controller broker1.local:9093 describe --status
```

### 5. Create SCRAM admin user
```
bin/kafka-configs.sh --bootstrap-server localhost:9092 \
 --alter --add-config 'SCRAM-SHA-256=[iterations=4096,password=adminpass]' \
 --entity-type users --entity-name admin
```

### 6. Create CA-ROOT, Truststore and Keystore

```
# copy create-ssl.sh to on your server under /opt/kafka/
cd /opt/kafka
chmod u+x create-ssl.sh

./create-ssl.sh

# if script successed then copy keystore and truststore to each broker

cd certs
scp broker2.keystore.jks kafka.truststore.jks user@broker2.local:/opt/kafka/certs/

# do this for another brokers...

```

### 7. Let's get start config with SASL_SSL_SCRAM_SHA256 with ACL

```
process.roles=broker,controller

node.id=1 # change this each broker 1,2,3
KAFKA_CLUSTER_ID="your-cluster-id"

controller.quorum.bootstrap.servers=broker1.local:9093, broker2.local:9093, broker3.local:9093
controller.quorum.voters=1@broker1.local:9093,2@broker2.local:9093,3@broker3.local:9093
controller.listener.names=CONTROLLER

num.network.threads=3
num.io.threads=8

socket.send.buffer.bytes=102400
socket.receive.buffer.bytes=102400
socket.request.max.bytes=104857600

log.dirs=/var/log/kraft-combined-logs

num.partitions=6
num.recovery.threads.per.data.dir=1

offsets.topic.replication.factor=2
share.coordinator.state.topic.replication.factor=1
share.coordinator.state.topic.min.isr=1
transaction.state.log.replication.factor=2
transaction.state.log.min.isr=1

log.retention.hours=168
log.segment.bytes=1073741824
log.retention.check.interval.ms=300000

# ACL
authorizer.class.name=org.apache.kafka.metadata.authorizer.StandardAuthorizer
allow.everyone.if.no.acl.found=false
super.users=User:admin

# Listeners
inter.broker.listener.name=SASL_SSL
listener.name.controller.scram-sha-256.sasl.jaas.config=org.apache.kafka.common.security.scram.ScramLoginModule required username="admin" password="adminpass";
listeners=SASL_SSL://broker1.local:9092,CONTROLLER://broker1.local:9093 # change this for each broker hostname
listener.security.protocol.map=SASL_SSL:SASL_SSL,CONTROLLER:SASL_SSL
advertised.listeners=SASL_SSL://broker1.local:9092 # change this for each broker 

# SASL & SSL configuration
sasl.enabled.mechanisms=SCRAM-SHA-256
sasl.mechanism.inter.broker.protocol=SCRAM-SHA-256
sasl.mechanism.controller.protocol=SCRAM-SHA-256

ssl.keystore.location=/opt/kafka/certs/broker1.keystore.jks # change this for each broker
ssl.keystore.password=123456
ssl.key.password=123456
ssl.truststore.location=/opt/kafka/certs/kafka.truststore.jks
ssl.truststore.password=123456
ssl.endpoint.identification.algorithm=
```

### 8.