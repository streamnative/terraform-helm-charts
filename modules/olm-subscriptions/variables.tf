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

variable "release_name" {
  default     = "olm-subscriptions"
  description = "The name of the helm release"
  type        = string
}

variable "install_namespace" {
  default     = "sn-system"
  description = "The namespace used for installing the operators managed by OLM"
  type        = string
}

variable "olm_namespace" {
  default     = "olm"
  description = "The namespace used by OLM and its resources"
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
  default     = 300
  description = "Time in seconds to wait for any individual kubernetes operation"
  type        = number
}