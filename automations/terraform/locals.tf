locals {
  kafka_ip_range = [
    for i in range(var.kafka_vm_start_ip, var.kafka_vm_end_ip) : cidrhost(var.kafka_vm_cidr, i)
  ]
}