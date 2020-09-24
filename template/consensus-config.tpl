node_id = {{env "NODE_ID"}}
network_port = {{range service (printf "%s_network" (env "NODE_NAME"))}}{{ .Port }}{{ end }}
controller_port = {{range service (printf "%s_controller" (env "NODE_NAME"))}}{{ .Port }}{{ end }}
