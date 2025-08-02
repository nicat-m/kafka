output "kafka_nodes" {
  description = "List of Kafka node names and IPs"
  value = [
    for i in range(var.kafka_vm_count) : {
      name = "${var.kafka_vm_hostname}-${i + 1}"
      ip   = local.kafka_ip_range[i]
    }
  ]
}
