<!--
  ~ Copyright 2023 StreamNative, Inc.
  ~
  ~ Licensed under the Apache License, Version 2.0 (the "License");
  ~ you may not use this file except in compliance with the License.
  ~ You may obtain a copy of the License at
  ~
  ~     http://www.apache.org/licenses/LICENSE-2.0
  ~
  ~ Unless required by applicable law or agreed to in writing, software
  ~ distributed under the License is distributed on an "AS IS" BASIS,
  ~ WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  ~ See the License for the specific language governing permissions and
  ~ limitations under the License.
-->

# HPA
Deploy resources to support HPA.
Including a Prometheus to scrape metrics used to determine if scaling is needed.
An internal issuer to issue self-signed cert.
A Prometheus Adapter to bridge HPA controller and Prometheus.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_metric_server_namespace"></a> [metric\_server\_namespace](#input\_metric\_server\_namespace) | Namespace to deploy custom metric server(prometheus adapter). | `string` | `sn-system` | no |
| <a name="input_cert_manager_namespace"></a> [cert\_manager\_namespace](#input\_cert\_manager\_namespace) | Namespace where cert manager is deployed. | `string` | `cert-manager` | no |
| <a name="input_scaling_prometheus_namespace"></a> [scaling\_prometheus\_namespace](#input\_scaling\_prometheus\_namespace) | Namespace to deploy prometheus for prometheus used for scarping metrics for HPA. | `string` | `sn-system` | no |
| <a name="input_scaling_prometheus_version"></a> [scaling\_prometheus\_version](#input\_scaling\_prometheus\_version) | Version of prometheus used for scarping metrics for HPA. | `string` | `v2.19.2` | no |
| <a name="input_scaling_prometheus_scrape_interval"></a> [scaling\_prometheus\_scrape\_interval](#input\_scaling\_prometheus\_scrape\_interval) | Scrape interval for prometheus used for scarping metrics for HPA. | `string` | `15s` | no |
| <a name="input_scaling_prometheus_evaluation_interval"></a> [scaling\_prometheus\_evaluation\_interval](#input\_scaling\_prometheus\_evaluation\_interval) | Evaluation interval for prometheus used for scarping metrics for HPA. | `string` | `30s` | no |
| <a name="input_scaling_prometheus_retention_period"></a> [scaling\_prometheus\_retention\_period](#input\_scaling\_prometheus\_retention\_period) | Retention period for prometheus used for scarping metrics for HPA. | `string` | `1h` | no |
| <a name="input_scaling_prometheus_cpu_limit"></a> [scaling\_prometheus\_cpu\_limit](#input\_scaling\_prometheus\_cpu\_limit) | CPU limit for prometheus used for scarping metrics for HPA. | `string` | `200m` | no |
| <a name="input_scaling_prometheus_memory_limit"></a> [scaling\_prometheus\_memory\_limit](#input\_scaling\_prometheus\_memory\_limit) | Memory limit for prometheus used for scarping metrics for HPA. | `string` | `1G` | no |
| <a name="input_scaling_prometheus_replicas"></a> [scaling\_prometheus\_replicas](#input\_scaling\_prometheus\_replicas) | Replicas of prometheus used for scarping metrics for HPA. | `number` | `1` | no |
