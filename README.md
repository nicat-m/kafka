# Kafka Multi Node Cluster Setup with SASL_SSL and ACL with SCRAM Authentication (KRaft Mode)
![Logo](images/kafka.png)

#### There are 2 types of installation and configure method if you want to deploy with terraform click "Automatic Installation" or click "Manual Installation"

[Automatic Installation](./configs/scripts/README.md)

[Manual Installation](./configs/README.md)


## Repository Structure
    .
    ├── README.md
    └── configs
        ├── scripts
        │    ├── create-ssl.sh
        │    ├── ansible
        │          ├── ansible.cfg
        │          ├── inventory
        │          ├── kafka-install.yaml
        │          ├── kafka-configure-plaintext.yaml
        │          ├── kafka-configure-sasl-ssl.yaml
        │          ├── templates
        │          │      ├── kafka-server-jaas.conf.j2
        │          │      ├── server.properties.plaintext.j2
        │          │      ├── server.properties.saslssl.j2
        │          │      ├── kafka.service.j2
        │          │      ├── client.properties.j2
        │          │      ├── create-ssl.sh.j2
        │          ├── variables
        │                 ├── env.yaml
        │                 ├── secrets.yaml
        ├── client.properties
        ├── server-1.properties
        ├── server-2.properties
        └── server-3.properties