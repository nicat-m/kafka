![Logo](../../images/terra-ansible-kafka.png)

## Automatic Installation with ansible

### Terraform Structure
            ├── terraform
            │      ├── main.tf
            │      ├── terraform.tfvars
            │      ├── variables.tf
            │      ├── files
            │      │      ├── ansible.tpl
            │      │      ├── env.tpl
            │      │      ├── inventory.tpl
            │      │      ├── secret.tpl

### 1. Install ansible on your management server
```
# Debian
sudo apt update
sudo apt install software-properties-common
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install ansible -y

# RHEL
sudo dnf install ansible -y
```

### 2. Set some kafka variables ans ssh password under variables folder
```
# for variables
vim variables/env.yaml

# for ssh_password

vim variables/secret.yaml

# set your hosts

vim inventory
```

### 3. Let's get start:

```
# Install kafka 

ansible-playbook kafka-install.yaml

# if you want to configure with plaintext mode you need to run this yaml:

ansible-playbook kafka-configure-plaintext.yaml

# if you want to configure with sasl_ssl mode you need to run this yaml:

# first of all you need to create "jks-files" folder under ansible for fetch jks files on your local machine or management servers

mkdir jks-files

ansible-playbook kafka-configure-sasl-ssl.yaml
```

## Resources
#### Kafka download:
* https://kafka.apache.org/downloads
#### Kafka Book
* [Kafka book](../../images/Kafka-Definitive-Guide.pdf)
#### Kafka-ui github repo url:
* https://github.com/provectus/kafka-ui/tree/master/documentation/compose
* https://github.com/provectus/kafka-ui/tree/master