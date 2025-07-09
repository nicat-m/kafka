[defaults]
host_key_checking = ${host_key_checking}
remote_user       = ${remote_user}
inventory         = ${inventory_path}

[privilege_escalation]
become=${become}
become_method=${become_method}
become_user=${become_user}
become_ask_pass=${become_ask_pass}