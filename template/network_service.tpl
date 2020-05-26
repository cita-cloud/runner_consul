{
  "Name": "{{env "NODE_NAME"}}/{{env "SERVICE_NAME"}}",
  "Tags": ["{{env "NODE_NAME"}}", "{{env "SERVICE_NAME"}}"],
  "Address": "127.0.0.1",
  "Port": {{env "SERVICE_PORT"}}
}
