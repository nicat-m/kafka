locals {
  kafka_ip_range = [
    for i in range(1, var.kafka_vm_count + 1) : cidrhost(var.kafka_vm_cidr, i)
  ]
}