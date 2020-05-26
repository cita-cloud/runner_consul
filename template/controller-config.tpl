network_port = {{range service (printf "%s_network" (env "NODE_NAME"))}}{{ .Port }}{{ end }}
consensus_port = {{range service (printf "%s_consensus" (env "NODE_NAME"))}}{{ .Port }}{{ end }}
storage_port = {{range service (printf "%s_storage" (env "NODE_NAME"))}}{{ .Port }}{{ end }}
kms_port = {{range service (printf "%s_kms" (env "NODE_NAME"))}}{{ .Port }}{{ end }}
executor_port = {{range service (printf "%s_executor" (env "NODE_NAME"))}}{{ .Port }}{{ end }}
block_delay_number = {{key (printf "%s/global.consensus.block_delay_number" (env "NODE_NAME"))}}
