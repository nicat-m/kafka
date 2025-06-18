#Infrastructure
vsphere_datacenter      = "Non_VxRail_Datacenter"
#vsphere_host           = "10.122.22.7"
vsphere_compute_cluster = "Non_VxRail_Cluster"
vsphere_datastore       = "DC2_E590H_02_dev_Test"
vsphere_network         = "VLAN65"
vsphere_resource_pool   = "DC2_DVX_DevOPS_Test"


#VM
vm_template_name        = "ubuntu_test_vm"
vm_vcpu                 = "2"
vm_memory               = "8192"
vm_ipv4_netmask         = "24"
vm_ipv4_gateway         = "10.122.65.254"
vm_dns_servers          = ["10.122.53.53", "10.122.53.54"]
dns_suffix_list         = ["vn.local"]
vm_disk_label           = "disk0"
vm_disk_size            = "120"
vm_disk_thin            = "true"
vm_domain               = "example.com"

vms = {
  kafka-node1 = {
    name  = "kafka-01"
    vm_ip = "10.122.65.180"
    role  = "controller"
  },
  kafka-node2 = {
    name  = "kafka-02"
    vm_ip = "10.122.65.181"
    role  = "broker"
  },
  kafka-node3 = {
    name  = "kafka-03"
    vm_ip = "10.122.65.182"
    role  = "broker"
  },
  kafka-node4 = {
    name  = "kafka-04"
    vm_ip = "10.122.65.183"
    role  = "controller"
  },
  kafka-node5 = {
    name  = "kafka-05"
    vm_ip = "10.122.65.184"
    role  = "controller"
  },
}

