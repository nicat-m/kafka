# Kafka Multi Node Cluster Setup with SASL_SSL Authentication and ACL with SCRAM mechanism (KRaft Mode)
![Logo](images/kafka.png)

#### There are 2 types of installation and configure method if you want to deploy with terraform click "Automatic Installation" or click "Manual Installation"

[Automatic Installation with Ansible](./automations/ansible/README.md)

[Automatic Installation with Terraform](https://github.com/nicat-m/kafka/blob/kafka-with-terraform/automations/README.md)

[Manual Installation](./automations/README.md)


## Repository Structure
    .
    ├── README.md
    └── automations
        ├── README.md
        ├── scripts
        │    ├── create-ssl.sh
        │    ├── create-acl.sh
        ├── ansible
        │     ├── ansible.cfg
        │     ├── inventory
        │     ├── kafka-install.yaml
        │     ├── kafka-configure-plaintext.yaml
        │     ├── kafka-configure-sasl-ssl.yaml
        │     ├── acl-create-user.yaml
        │     ├── README.md
        │     ├── templates
        │     │      ├── kafka-server-jaas.conf.j2
        │     │      ├── server.properties.plaintext.j2
        │     │      ├── server.properties.saslssl.j2
        │     │      ├── kafka.service.j2
        │     │      ├── client.properties.j2
        │     │      ├── create-ssl.sh.j2
        │     │      ├── create-acl.sh.j2
        │     ├── variables
        │            ├── env.yaml
        │            ├── secrets.yaml
        ├── configs
        │     ├──client.properties
        │     ├── server.properties
        │     ├── kafka-server-jaas.conf


## Resources
#### Kafka download:
* https://kafka.apache.org/downloads
#### Kafka Book
* [Kafka book](./images/Kafka-Definitive-Guide.pdf)
#### Kafka-ui github repo url:
* https://github.com/provectus/kafka-ui/tree/master/documentation/compose
* https://github.com/provectus/kafka-ui/tree/master


## 🚀 About Me
I'm a DevOps Engineer...
