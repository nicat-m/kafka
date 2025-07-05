#Provider -  VMware vSphere Provider

variable "vsphere_user" {
  description = "vSphere username to use to connect to the environment"
}

variable "vsphere_password" {
  description = "vSphere password to use to connect to the environment"
}

variable "vsphere_vcenter" {
  description = "vCenter server FQDN or IP"
}

# Infrastructure - vCenter / vSPhere environment

variable "vsphere_datacenter" {
  description = "vSphere datacenter in which the virtual machine will be deployed"
}

#variable "vsphere_host" {
#  description = "vSphere ESXi host FQDN or IP"
#}

variable "vsphere_compute_cluster" {
  description = "vSPhere cluster in which the virtual machine will be deployed"
}


variable "vsphere_resource_pool" {
  description = "vsphere_resource_pool pool id "
}

variable "vsphere_datastore" {
  description = "Datastore in which the virtual machine will be deployed"
}

variable "vsphere_network" {
  description = "Portgroup to which the virtual machine will be connected"
}

#VM

variable "vm_template_name" {
  description = "VM template with vmware-tools and perl installed"
}


variable "vm_vcpu" {
  description = "The number of virtual processors to assign to this virtual machine."
  default     = "1"
}

variable "vm_memory" {
  description = "The size of the virtual machine's memory in MB"
  default     = "1024"
}

variable "vm_ipv4_netmask" {
  description = "The IPv4 subnet mask"
}

variable "vm_ipv4_gateway" {
  description = "The IPv4 default gateway"
}

variable "vm_dns_servers" {
  description = "The list of DNS servers to configure on the virtual machine"
}

variable "dns_suffix_list" {
  description = "The list of DNS suffix to configure on the virtual machine"
}

variable "vm_domain" {
  description = "Domain name of virtual machine"
}

variable "vms" {
  type        = map(any)
  description = "List of virtual machines to be deployed"
}

variable "vm_disk_label" {
  description = "Disk label of the created virtual machine"
}

variable "vm_disk_size" {
  description = "Disk size of the created virtual machine in GB"
}

variable "vm_disk_thin" {
  description = "Disk type of the created virtual machine , thin or thick"
}

variable "kafka_config" {
  type = object({
    kafka_version    = string
    scala_version    = string
    kafka_dir        = string
    kafka_cluster_id = string
    broker_port      = number
    controller_port  = number
    sasl_username    = string
    sasl_password    = string
    keystore_pass    = string
    key_pass         = string
    truststore_pass  = string
    client_password  = string
    client_username  = string
    kafka_topics     = list(string)
    kafka_operations = list(string)
    kafka_acl_groups = list(string)
  })
}

variable "ssh_password" {
  type      = string
  sensitive = true
}

variable "ansible_config" {
  type = object({
    become            = bool
    become_ask_pass   = bool
    become_method     = string
    become_user       = string
    host_key_checking = bool
    remote_user       = string
  })
}

variable "action" {
  type = string
  default = "plaintext"
  description = "Kafka provisioning action: saslssl or plaintext"
}