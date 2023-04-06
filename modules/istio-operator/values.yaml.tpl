{*
 Copyright 2023 StreamNative, Inc.

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
*}

istioNamespace: ${istio_system_namespace}
controlPlane:
  install: true
  spec:
    profile: ${profile}
    revision: ${revision_tag}
    values:
      global:
        istioNamespace: ${istio_system_namespace}
        meshID: ${mesh_id}
        multiCluster:
          clusterName: ${cluster_name}
        network: ${network}
      sidecarInjectorWebhook:
        injectedAnnotations:
          cluster-autoscaler.kubernetes.io/safe-to-evict: "true"
        neverInjectSelector:
          # kube-prometheus-stack
          ## Admission Webhook jobs do not terminate as expected with istio-proxy
          - matchExpressions:
            - {key: app, operator: In, values: [kube-prometheus-stack-admission-create,kube-prometheus-stack-admission-patch,kube-prometheus-stack-operator,sn-operator,flink-operator]}

    meshConfig:
      trustDomain: ${trust_domain}
      defaultConfig:
        proxyMetadata:
          ISTIO_META_DNS_CAPTURE: "true"
          ISTIO_META_DNS_AUTO_ALLOCATE: "true"
      enablePrometheusMerge: false
    components:
      cni:
        enabled: true
      pilot:
        k8s:
          podDisruptionBudget:
            maxUnavailable: 1
          hpaSpec:
            minReplicas: 2
      ingressGateways:
        - name: istio-ingressgateway
          namespace: ${istio_system_namespace} 
          enabled: true 
          label:
            cloud.streamnative.io/role: "istio-ingressgateway"
          k8s:
            podDisruptionBudget:
              maxUnavailable: 1
            hpaSpec:
              minReplicas: 2
            serviceAnnotations:
%{ for k, v in ingress_gateway_service_annotations ~}
              ${k}: "${v}"
%{ endfor ~}
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
