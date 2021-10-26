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

variable "cleanup_on_fail" {
  default     = true
  description = "Allow deletion of new resources created in this upgrade when upgrade fails"
  type        = bool
}

variable "cluster_name" {
  description = "The name of the kubernetes cluster where Istio is being configured."
  type        = string
}

variable "enable_istio_operator" {
  default     = true
  description = "Enables the Istio Operator for installation. Can be disabled if you only need to install Kiali."
  type        = bool
}

variable "enable_kiali_operator" {
  default     = true
  description = "Enables the Kiali Operator for installation. Can be disabled if you only need to install Istio."
  type        = bool
}

variable "istio_chart_name" {
  default     = "istio-operator"
  description = "The name of the Helm chart to install"
  type        = string
}

variable "istio_chart_repository" {
  default     = "https://stevehipwell.github.io/helm-charts/"
  description = "The repository containing the Helm chart to install"
  type        = string
}

variable "istio_chart_version" {
  default     = "2.3.4"
  description = "The version of the Helm chart to install. See https://github.com/stevehipwell/helm-charts/tree/master/charts/istio-operator for available versions."
  type        = string
}

variable "istio_namespace" {
  description = "The namespace used for the Istio operator."
  type        = string
}

variable "istio_release_name" {
  default     = "istio-operator"
  description = "The name of the Istio release"
  type        = string
}

variable "istio_settings" {
  default     = {}
  description = "Additional settings which will be passed to the Helm chart values"
  type        = map(any)
}

variable "kiali_chart_name" {
  default     = "kiali-operator"
  description = "The name of the Helm chart to install"
  type        = string
}

variable "kiali_chart_repository" {
  default     = "https://kiali.org/helm-charts"
  description = "The repository containing the Helm chart to install"
  type        = string
}

variable "kiali_chart_version" {
  default     = "1.42.0"
  description = "The version of the Helm chart to install. See https://github.com/kiali/helm-charts/tree/v1.42/kiali-operator for configuration options, and note that newer versions will be in their corresponding branch in the git repo."
  type        = string
}

variable "kiali_namespace" {
  description = "The namespace used for the Kiali operator."
  type        = string
}

variable "kiali_release_name" {
  default     = "kiali-operator"
  description = "The name of the Kiali release"
  type        = string
}

variable "kiali_settings" {
  default     = {}
  description = "Additional settings which will be passed to the Helm chart values. See https://github.com/kiali/helm-charts/blob/v1.42/kiali-operator/values.yaml for available options"
  type        = map(any)
}

variable "mesh_id" {
  description = "The ID used by the Istio mesh. This is also the ID of the StreamNative Cloud Pool used for the workload environments"
  type        = string
}

variable "release_name" {
  default     = "istio-operator"
  description = "The name of the helm release"
  type        = string
}

variable "revision_tag" {
  default     = "sn-stable"
  description = "The revision tag value use for the Istio label \"istio.io/rev\"."
  type        = string
}

variable "timeout" {
  default     = 600
  description = "Time in seconds to wait for any individual kubernetes operation"
  type        = number
}

variable "trust_domain" {
  description = "The trust domain used by Istio, which corresponds to the the trust root of a system"
  type        = string
}
