[controller]
%{ for i in range(length(controller_ips)) ~}
${controller_ips[i]} node_id=${i + 1}
%{ endfor ~}

[brokers]
%{ for i in range(length(broker_ips)) ~}
${broker_ips[i]} node_id=${i + 1 + length(controller_ips)}
%{ endfor ~}

[all_nodes:children]
controller
brokers
