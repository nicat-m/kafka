# Kafka Multi Node Cluster Setup with SASL_SSL Authentication and ACL with SCRAM mechanism (KRaft Mode)
![Logo](images/kafka.png)

#### There are 2 types of installation and configure method if you want to deploy with terraform click "Automatic Installation" or click "Manual Installation"

[Automatic Installation](./configs/scripts/README.md)

[Manual Installation](./configs/README.md)


## Repository Structure
    .
    ├── README.md
    └── configs
        ├── scripts
        │    ├── ansible
        │          ├── ansible.cfg
        │          ├── inventory
        │          ├── kafka-install.yaml
        │          ├── kafka-configure-plaintext.yaml
        │          ├── kafka-configure-sasl-ssl.yaml
        │          ├── acl-create-user.yaml
        │          ├── templates
        │          │      ├── kafka-server-jaas.conf.j2
        │          │      ├── server.properties.plaintext.j2
        │          │      ├── server.properties.saslssl.j2
        │          │      ├── kafka.service.j2
        │          │      ├── client.properties.j2
        │          │      ├── create-ssl.sh.j2
        │          │      ├── create-acl.sh.j2        
        │          ├── variables
        │    ├── terraform
        │          ├── main.tf
        │          ├── terraform.tfvars
        │          ├── variables.tf
        │          ├── backend.tf
        │          ├── files
        │          │      ├── ansible.tpl
        │          │      ├── env.tpl
        │          │      ├── secret.tpl
        │          │      ├── inventory.tpl


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
