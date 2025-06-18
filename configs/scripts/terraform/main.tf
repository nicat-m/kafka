terraform {
  required_providers {
    vsphere = {
      source = "hashicorp/vsphere"
      version = "2.2.0"
    }
  }
}

#Provider settings
provider "vsphere" {
  user                  = var.vsphere_user
  password              = var.vsphere_password
  vsphere_server        = var.vsphere_vcenter
  allow_unverified_ssl  = true
}

#Data sources

data "vsphere_datacenter" "dc" {
  name = var.vsphere_datacenter
}

#data "vsphere_host" "hosts" {
#  name                  = var.vsphere_host
#  datacenter_id         = data.vsphere_datacenter.dc.id
#}

data "vsphere_compute_cluster" "compute_cluster" {
  name                  = var.vsphere_compute_cluster
  datacenter_id         = data.vsphere_datacenter.dc.id
}

data "vsphere_datastore" "datastore" {
  name                  = var.vsphere_datastore
  datacenter_id         = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name                  = var.vsphere_network
  datacenter_id         = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  name                  = var.vm_template_name
  datacenter_id         = data.vsphere_datacenter.dc.id
}

data "vsphere_resource_pool" "pool" {
  name          = var.vsphere_resource_pool
  datacenter_id = data.vsphere_datacenter.dc.id
}

# Ansible Kafka

locals {
  controller_ips = [
    for vm in values(var.vms) : vm.vm_ip
    if vm.role == "controller"
  ]

  broker_ips = [
    for vm in values(var.vms) : vm.vm_ip
    if vm.role == "broker"
  ]
}

resource "local_file" "ansible_inventory" {
  filename = "../ansible/inventory.ini"

  content = templatefile("${path.module}/files/inventory.tpl", {
    controller_ips = local.controller_ips
    broker_ips     = local.broker_ips
  })
}

resource "null_resource" "run_ansible" {
  depends_on = [
    vsphere_virtual_machine.vm,
    local_file.ansible_inventory
    ]

  provisioner "local-exec" {
    command = "ansible-playbook -i inventory.ini kafka-install.yaml"
    working_dir = "../ansible"
  }
}

#Resource
resource "vsphere_virtual_machine" "vm" {
  for_each              = var.vms

  datastore_id          = data.vsphere_datastore.datastore.id
  resource_pool_id      = data.vsphere_resource_pool.pool.id 
  guest_id              = data.vsphere_virtual_machine.template.guest_id

  network_interface {
    network_id          = data.vsphere_network.network.id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }

  name                  = each.value.name

  num_cpus              = var.vm_vcpu
  memory                = var.vm_memory
  firmware              = data.vsphere_virtual_machine.template.guest_id == "rhel8_64Guest" ? "efi" : "bios"
  disk {
    label               = var.vm_disk_label
    size                = var.vm_disk_size
    thin_provisioned    = var.vm_disk_thin
  }

  clone {
    template_uuid       = data.vsphere_virtual_machine.template.id
    customize {
      linux_options {
        host_name       = each.value.name
        domain          = var.vm_domain
    }
    network_interface {
      ipv4_address      = each.value.vm_ip
      ipv4_netmask      = var.vm_ipv4_netmask
      
    }
    ipv4_gateway = var.vm_ipv4_gateway
    dns_suffix_list   = var.dns_suffix_list
    dns_server_list   = var.vm_dns_servers
   }
  }

 }

