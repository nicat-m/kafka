#Data sources

data "vsphere_datacenter" "dc" {
  name = var.vsphere_datacenter
}

#data "vsphere_host" "hosts" {
#  name                  = var.vsphere_host
#  datacenter_id         = data.vsphere_datacenter.dc.id
#}

data "vsphere_compute_cluster" "compute_cluster" {
  name          = var.vsphere_compute_cluster
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_datastore" "datastore" {
  name          = var.vsphere_datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = var.vsphere_network
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  name          = var.vm_template_name
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_resource_pool" "pool" {
  name          = var.vsphere_resource_pool
  datacenter_id = data.vsphere_datacenter.dc.id
}

# Ansible Kafka

# locals {
#   broker_ips = [
#     values(var.vm_kafka_ips)
#   ]
# }

resource "local_file" "ansible_inventory" {
  filename = "../ansible/inventory.ini"

  content = templatefile("${path.module}/files/inventory.tpl", {
    broker_ips = local.kafka_ip_range
  })
}


resource "local_file" "ansible_env_yaml" {
  filename = "../ansible/variables/env.yaml"

  content = templatefile("${path.module}/files/env.tpl", {
    kafka_version    = var.kafka_config.kafka_version
    scala_version    = var.kafka_config.scala_version
    kafka_dir        = var.kafka_config.kafka_dir
    kafka_cluster_id = var.kafka_config.kafka_cluster_id
    broker_port      = var.kafka_config.broker_port
    controller_port  = var.kafka_config.controller_port
    client_port      = var.kafka_config.client_port
    sasl_username    = var.kafka_config.sasl_username
    sasl_password    = var.kafka_config.sasl_password
    keystore_pass    = var.kafka_config.keystore_pass
    key_pass         = var.kafka_config.key_pass
    truststore_pass  = var.kafka_config.truststore_pass
    client_password  = var.kafka_config.client_password
    client_username  = var.kafka_config.client_username
    kafka_operations = var.kafka_config.kafka_operations
    kafka_topics     = var.kafka_config.kafka_topics
    kafka_acl_groups = var.kafka_config.kafka_acl_groups
    kafka_broker_ip  = local.kafka_ip_range[0]

    # Cert Config
    org                 = var.certificate_config.org
    org_unit            = var.certificate_config.org_unit
    common_name         = var.certificate_config.common_name
    state_province      = var.certificate_config.state_province
    locality            = var.certificate_config.locality
    country             = var.certificate_config.country
    cert_validity       = var.certificate_config.cert_validity
    ssl_keystore_type   = var.kafka_config.ssl_keystore_type
    ssl_truststore_type = var.kafka_config.ssl_truststore_type
    ssl_user_dn         = var.kafka_config.ssl_user_dn
  })
}

resource "local_file" "ansible_secrets_yaml" {
  filename = "../ansible/variables/secrets.yaml"

  content = templatefile("${path.module}/files/secret.tpl", {
    ssh_password = var.ssh_password
  })
}

resource "local_file" "ansible_config" {
  filename = "../ansible/ansible.cfg"

  content = templatefile("${path.module}/files/ansible.tpl", {
    become            = var.ansible_config.become
    become_ask_pass   = var.ansible_config.become_ask_pass
    become_method     = var.ansible_config.become_method
    become_user       = var.ansible_config.become_user
    host_key_checking = var.ansible_config.host_key_checking
    remote_user       = var.ansible_config.remote_user
    inventory_path    = "inventory.ini"
  })
}

resource "time_sleep" "wait_60_seconds" {
  depends_on      = [vsphere_virtual_machine.kafka_hosts]
  create_duration = "60s"
}

resource "null_resource" "run_kafka_install" {
  depends_on = [time_sleep.wait_60_seconds]

  provisioner "local-exec" {
    command     = "ansible-playbook kafka-install.yaml"
    working_dir = "../ansible"
  }
}

resource "null_resource" "create_jks_folder" {
  provisioner "local-exec" {
    command = "mkdir ../ansible/jks-files"
  }
  depends_on = [null_resource.run_kafka_install]

}

resource "null_resource" "run_kafka_configure" {
  depends_on = [null_resource.run_kafka_install, null_resource.create_jks_folder]

  provisioner "local-exec" {
    command     = var.action == "plaintext" ? local.plaintext : var.action == "saslssl" ? local.saslssl : local.ssl
    working_dir = "../ansible"
  }
}

locals {
  plaintext = "ansible-playbook kafka-configure-plaintext.yaml"
  saslssl   = "ansible-playbook kafka-configure-sasl-ssl.yaml"
  ssl       = "ansible-playbook kafka-configure-ssl.yaml"
}

# Create Virtual machine

resource "vsphere_virtual_machine" "kafka_hosts" {
  count = var.kafka_vm_count

  datastore_id     = data.vsphere_datastore.datastore.id
  resource_pool_id = data.vsphere_resource_pool.pool.id
  guest_id         = data.vsphere_virtual_machine.template.guest_id

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }

  name = "${var.kafka_vm_hostname}-${count.index + 1}"

  num_cpus = var.vm_vcpu
  memory   = var.vm_memory
  firmware = data.vsphere_virtual_machine.template.guest_id == "rhel8_64Guest" ? "efi" : "bios"
  disk {
    label            = var.vm_disk_label
    size             = var.vm_disk_size
    thin_provisioned = var.vm_disk_thin
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
    customize {
      linux_options {
        host_name = "${var.kafka_vm_hostname}-${count.index + 1}"
        domain    = var.vm_domain
      }
      network_interface {
        ipv4_address = local.kafka_ip_range[count.index]
        ipv4_netmask = var.vm_ipv4_netmask

      }
      ipv4_gateway    = var.vm_ipv4_gateway
      dns_suffix_list = var.dns_suffix_list
      dns_server_list = var.vm_dns_servers
    }
  }
}

