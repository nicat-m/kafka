#!/bin/bash

# Variables
KAFKA_DIR=
HOSTNAME=
PASSWORD=
USERNAME=
CLIENT_CONFIG=$KAFKA_DIR/config/client.properties
TOPICS=()
OPERATIONS=()
GROUP=()


##################################################################################################

# Operation Lists

# Delete
# Write
# CreateTokens
# IdempotentWrite
# DescribeConfigs
# DescribeTokens
# Read
# ClusterAction
# All
# AlterConfigs
# Alter
# Create
# Describe


cd $KAFKA_DIR


# Create user

bin/kafka-configs.sh --bootstrap-server $HOSTNAME:9092 \
--alter --add-config 'SCRAM-SHA-256=[iterations=4096,password='${PASSWORD}']' \
--entity-type users --entity-name $USERNAME \
--command-config $CLIENT_CONFIG

echo "$USERNAME user created successfully !"
echo ""

# some operation access

for operation in ${OPERATIONS[@]}
do

    for topics in ${TOPICS[@]}
    do
        bin/kafka-acls.sh --bootstrap-server $HOSTNAME:9092 \
        --add --allow-principal User:$USERNAME --operation $operation \
        --topic $topics --command-config $CLIENT_CONFIG

        echo "INFO: $operation access given for $USERNAME user in this $topics topics"
        echo ""
    done
done


# Consumer group access for users

for groups in ${GROUP[@]}
do
    bin/kafka-acls.sh --bootstrap-server $HOSTNAME:9092 \
    --add --allow-principal User:$USERNAME --operation Read \
    --group $groups --command-config $CLIENT_CONFIG

    echo "INFO: Read access given for $USERNAME user in $groups"
    echo ""
done
