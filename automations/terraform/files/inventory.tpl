[brokers]
%{ for i in range(length(broker_ips)) ~}
${broker_ips[i]} node_id=${i + 1}
%{ endfor ~}