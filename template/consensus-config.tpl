network_port = {{range service (printf "%s_network" (env "NODE_NAME"))}}{{ .Port }}{{ end }}
controller_port = {{range service (printf "%s_kms" (env "NODE_NAME"))}}{{ .Port }}{{ end }}
