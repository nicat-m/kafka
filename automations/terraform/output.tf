output "kafka_nodes" {
  description = "List of Kafka node names and IPs"
  value = {
    for k, v in var.vms :
    k => {
      name  = v.name
      vm_ip = v.vm_ip
    }
  }
}