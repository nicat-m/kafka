output "kafka_nodes" {
  description = "List of Kafka node names and IPs"
  value       = local.kafka_ip_range
}