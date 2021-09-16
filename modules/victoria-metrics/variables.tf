#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
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

variable "atomic" {
  default     = true
  description = "Purge the chart on a failed installation. Default's to \"true\"."
  type        = bool
}


variable "chart_name" {
  default     = "victoria-metrics-k8s-stack"
  description = "The name of the Helm chart to install"
  type        = string
}

variable "chart_repository" {
  default     = "https://victoriametrics.github.io/helm-charts/"
  description = "The repository containing the Helm chart to install. See https://github.com/VictoriaMetrics/helm-charts/tree/master/charts/victoria-metrics-k8s-stack for available configuration options"
  type        = string
}

variable "create_namespace" {
  default     = true
  description = "Create a namespace for the operator. Defaults to \"true\""
  type        = bool
}

variable "chart_version" {
  default     = "0.4.5"
  description = "The version of the Helm chart to install. See"
  type        = string
}

variable "cleanup_on_fail" {
  default     = true
  description = "Allow deletion of new resources created in this upgrade when upgrade fails"
  type        = bool
}

variable "namespace" {
  default     = "monitoring-system"
  description = "The namespace used for the deployment. Defaults to \"monitoring-system\" (recommended)"
  type        = string
}

variable "release_name" {
  default     = "vm-stack"
  description = "The name of the helm release"
  type        = string
}

variable "settings" {
  default     = {}
  description = "Additional settings which will be passed to the Helm chart values"
  type        = map(any)
}

variable "timeout" {
  default     = 300
  description = "Time in seconds to wait for any individual kubernetes operation"
  type        = number
}

variable "values" {
  default     = []
  description = "A list of values in raw YAML to be applied to the helm release. Merges with the settings input, can also be used with the `file()` function, i.e. `file(\"my/values.yaml\")`"
}
