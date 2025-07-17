#Infrastructure
vsphere_datacenter      = "Non_VxRail_Datacenter"
#vsphere_host           = "10.122.22.7"
vsphere_compute_cluster = "Non_VxRail_Cluster"
vsphere_datastore       = "DC2_E590H_02_dev_Test"
vsphere_network         = "VLAN65"
vsphere_resource_pool   = "DC2_DVX_DevOPS_Test"


#VM
vm_template_name = "ubuntu_test_vm"
vm_vcpu          = "2"
vm_memory        = "8192"
vm_ipv4_netmask  = "24"
vm_ipv4_gateway  = "10.122.65.254"
vm_dns_servers   = ["10.122.53.53", "10.122.53.54"]
dns_suffix_list  = ["vn.local"]
vm_disk_label    = "disk0"
vm_disk_size     = "120"
vm_disk_thin     = "true"
vm_domain        = "example.com"

vms = {
  kafka-node1 = {
    name  = "kafka-01"
    vm_ip = "10.122.65.180"
  },
  kafka-node2 = {
    name  = "kafka-02"
    vm_ip = "10.122.65.181"
  },
  kafka-node3 = {
    name  = "kafka-03"
    vm_ip = "10.122.65.182"
  },
  kafka-node4 = {
    name  = "kafka-04"
    vm_ip = "10.122.65.183"
  },
  kafka-node5 = {
    name  = "kafka-05"
    vm_ip = "10.122.65.184"
  },
}

## Kafka ENV

kafka_config = {
  kafka_version    = "4.0.0"
  scala_version    = "2.13"
  kafka_dir        = "/opt/kafka"
  kafka_cluster_id = "kafkademo"
  broker_port      = 9094
  controller_port  = 9093
  client_port      = 9092
  sasl_username    = "admin"
  sasl_password    = "adminpass"
  keystore_pass    = "123456"
  key_pass         = "123456"
  truststore_pass  = "123456"
  client_password  = "nici"
  client_username  = "nici"
  kafka_operations = ["Read", "Create", "Write"]
  kafka_topics     = ["nici", "test"]
  kafka_acl_groups = ["rest-api-group"]
}

ssh_password = ""

## Ansible config env

ansible_config = {
  become            = true
  host_key_checking = false
  remote_user       = "nicat"
  become_method     = "sudo"
  become_ask_pass   = false
  become_user       = "root"
}

certificate_config = {
  common_name     = "kafka.demo.local"
  country         = "AZ"
  org             = "Company"
  org_unit        = "IT"
  state_province  = "Baku"
  locality        = "Baku"
  cert_validity   = 3650
}