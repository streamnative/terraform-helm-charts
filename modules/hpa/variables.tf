# Copyright 2023 StreamNative, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#

variable "metric_server_namespace" {
  default     = "sn-system"
  description = "Namespace to deploy custom metric server(prometheus adapter)."
  type        = string
}

variable "cert_manager_namespace" {
  default     = "cert-manager"
  description = "Namespace where cert manager is deployed."
  type        = string
}

variable "scaling_prometheus_namespace" {
  default     = "sn-system"
  description = "Namespace to deploy prometheus for prometheus used for scarping metrics for HPA."
  type        = string
}

variable "scaling_prometheus_version" {
  default     = "v2.19.2"
  description = "Version of prometheus used for scarping metrics for HPA."
  type        = string
}

variable "scaling_prometheus_scrape_interval" {
  default     = "15s"
  description = "Scrape interval for prometheus used for scarping metrics for HPA."
  type        = string
}

variable "scaling_prometheus_evaluation_interval" {
  default     = "30s"
  description = "Evaluation interval for prometheus used for scarping metrics for HPA."
  type        = string
}

variable "scaling_prometheus_retention_period" {
  default     = "1h"
  description = "Retention period for prometheus used for scarping metrics for HPA."
  type        = string
}

variable "scaling_prometheus_cpu_limit" {
  default     = "200m"
  description = "CPU limit for prometheus used for scarping metrics for HPA."
  type        = string
}

variable "scaling_prometheus_memory_limit" {
  default     = "1G"
  description = "Memory limit for prometheus used for scarping metrics for HPA."
  type        = string
}

variable "scaling_prometheus_replicas" {
  default     = 1
  description = "Replicas of prometheus used for scarping metrics for HPA."
  type        = number
}
