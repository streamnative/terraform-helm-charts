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

variable "catalog_namespace" {
  default     = "olm"
  description = "The namespace used by OLM catalog services"
  type        = string
}

variable "cleanup_on_fail" {
  default     = true
  description = "Allow deletion of new resources created in this upgrade when upgrade fails"
  type        = bool
}

variable "release_name" {
  default     = "olm-subscriptions"
  description = "The name of the helm release"
  type        = string
}

variable "namespace" {
  default     = "sn-system"
  description = "The namespace used for the Pulsar Operator deployment"
  type        = string
}

variable "settings" {
  default     = {}
  description = "Additional settings which will be passed to the Helm chart values"
  type        = map(any)
}

variable "registry" {
  description = "The registry containing StreamNative's operator catalog images"
  type        = string
}

variable "timeout" {
  default     = 600
  description = "Time in seconds to wait for any individual kubernetes operation"
  type        = number
}

variable "enable_sn_operator" {
  default     = false
  description = "Whether to enable en operator."
  type        = bool
}

variable "sn_operator_registry" {
  default     = ""
  description = "SN Operator's registry."
  type        = string
}

variable "sn_operator_registry_username" {
  default     = ""
  description = "SN Operator's registry username."
  type        = string
}

variable "sn_operator_registry_credential" {
  default     = ""
  description = "SN Operator's registry password."
  type        = string
}

variable "sn_operator_catalog_sa" {
  default     = ""
  description = "OLM catalog's service account"
  type        = string
}

variable "sn_operator_controller_sa" {
  default     = ""
  description = "SN Operator's service account"
  type        = string
}

