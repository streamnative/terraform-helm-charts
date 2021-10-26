controlPlane:
  install: true
  spec:
    values:
      global:
        istioNamespace: ${istio_namespace}
        meshID: ${mesh_id}
        multiCluster:
          clusterName: ${cluster_name}
        network: network1 # should this be a parameter?
    revision: ${revision_tag}
    profile: default # should this be a parameter?
    meshConfig:
      trustDomain: ${trust_domain}
      defaultConfig:
        proxyMetadata:
          ISTIO_META_DNS_CAPTURE: "true"
          ISTIO_META_DNS_AUTO_ALLOCATE: "true"
    components:
  #    cni:
  #      enabled: true
      ingressGateways:
        - namespace: ${istio_namespace} 
          name: istio-ingressgateway
          enabled: true
          label:
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
istioNamespace: ${istio_namespace}
podLabels: 
  istio.io/rev: ${revision_tag}