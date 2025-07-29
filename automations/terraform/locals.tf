locals {
  kafka_ip_range = [
    for i in range(1, 4) : cidrhost(var.kafka_vm_cidr, i)
  ]
}