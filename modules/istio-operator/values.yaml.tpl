istioNamespace: ${watched_namespace}
controlPlane:
  install: true
  spec:
    profile: ${profile}
    revision: ${revision_tag}
    values:
      global:
        istioNamespace: ${watched_namespace}
        meshID: ${mesh_id}
        multiCluster:
          clusterName: ${cluster_name}
        network: ${network}
    meshConfig:
      trustDomain: ${trust_domain}
      defaultConfig:
        proxyMetadata:
          ISTIO_META_DNS_CAPTURE: "true"
          ISTIO_META_DNS_AUTO_ALLOCATE: "true"
    components:
      cni:
        enabled: true
      ingressGateways:
        - name: istio-ingressgateway
          namespace: ${watched_namespace} 
          enabled: true
          label:
            cloud.streamnative.io/role: istio-gateway
            istio: ingressgateway
          k8s:
            service:
              ports:
                - port: 15021
                  targetPort: 15021
                  name: status-port
                - port: 80
                  targetPort: 8080
                  name: http2
                - port: 443
                  targetPort: 8443
                  name: https
                - port: 6651
                  targetPort: 6651
                  name: tls-pulsar
                - port: 9093
                  targetPort: 9093
                  name: tls-kafka