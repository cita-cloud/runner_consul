appenders:
  # An appender named "stdout" that writes to stdout
  stdout:
    kind: console

  journey-service:
    kind: rolling_file
    path: "logs/{{ env "SERVICE_NAME" }}-service.log"
    policy:
      # Identifies which policy is to be used. If no kind is specified, it will
      # default to "compound".
      kind: compound
      # The remainder of the configuration is passed along to the policy's
      # deserializer, and will vary based on the kind of policy.
      trigger:
        kind: size
        limit: 1mb
      roller:
        kind: fixed_window
        base: 1
        count: 5
        pattern: "logs/{{ env "SERVICE_NAME" }}-service.{}.gz"

# Set the default logging level and attach the default appender to the root
root:
  level: {{key (printf "%s/global.log4rs.level" (env "NODE_NAME"))}}
  appenders:
    - {{key (printf "%s/global.log4rs.appenders" (env "NODE_NAME"))}}
