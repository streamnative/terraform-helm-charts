image:
  repository: docker.cloudsmith.io/streamnative/cloud-tools/vector 
  pullPolicy: IfNotPresent
  # Overrides the image tag, the default is `{image.version}-{image.base}`.
  tag: "0.18.0-debian"
customConfig:
  data_dir: /vector-data-dir
  api:
    enabled: false
    address: '0.0.0.0:8686'
    playground: true
  log_schema:
    host_key: host
    message_key: message
    source_type_key: source_type
    timestamp_key: timestamp
  sources:
    kubernetes_logs:
      type: kubernetes_logs
  sinks:
    ${sink_name}:
      encoding: json
      endpoint: ${sink_endpoint} 
      inputs: 
        - kubernetes_logs
      topic: ${sink_topic} 
      type: pulsar
      auth:
        oauth2:
          audience: ${sink_oauth_audience} 
          credentials_url: >-
            ${sink_oauth_credentials_url} 
          issuer_url: ${sink_oauth_issuer_url}
      healthcheck:
        enabled: true