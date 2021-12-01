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

#####
# Why the weird use of null defaults? This module is a "child" used by the terraform-provider-helm parent module.
# Since we don't want to duplicate default managemant, some hacky use of locals and ternary operators are necessary.
# As such, the defaults are configured in the locals{} block in this module's corresponding main.tf file.
# See this issue for more details https://github.com/hashicorp/terraform/issues/24142
#####

variable "atomic" {
  default     = null
  description = "Purge the chart on a failed installation."
  type        = bool
}

variable "chart_name" {
  default     = null
  description = "The name of the Helm chart to install."
  type        = string
}

variable "chart_repository" {
  default     = null
  description = "The repository containing the Helm chart to install."
  type        = string
}

variable "chart_version" {
  default     = null
  description = "The version of the Helm chart to install."
  type        = string
}

variable "cleanup_on_fail" {
  default     = null
  description = "Allow deletion of new resources created in this upgrade when upgrade fails."
  type        = bool
}

variable "create_namespace" {
  default     = null
  description = "Create a namespace for the deployment. Defaults to \"true\"."
  type        = bool
}

variable "namespace" {
  default     = null
  description = "The namespace used for the operator deployment."
  type        = string
}

variable "release_name" {
  default     = null
  description = "The name of the helm release."
  type        = string
}

variable "settings" {
  default     = null
  description = "Additional settings which will be passed to the Helm chart values."
  type        = map(any)
}

variable "timeout" {
  default     = null
  description = "Time in seconds to wait for any individual kubernetes operation."
  type        = number
}

variable "values" {
  default     = null
  description = "A list of values in raw YAML to be applied to the helm release. Merges with the settings input, can also be used with the `file()` function, i.e. `file(\"my/values.yaml\")`."
}