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

### Global Chart Settings
variable "atomic" {
  default     = null
  description = "Purge the chart on a failed installation."
  type        = bool
}

variable "cleanup_on_fail" {
  default     = null
  description = "Allow deletion of new resources created in this upgrade when upgrade fails"
  type        = bool
}

variable "timeout" {
  default     = null
  description = "Time in seconds to wait for any individual kubernetes operation"
  type        = number
}

### vmagent Chart Settings
variable "basicauth_enabled" {
  default     = null
  description = "Enable basic auth for remote write endpoint. Requires providing a username and base64 encoded password."
  type        = bool
}

variable "basicauth_username" {
  default     = null
  description = "If basic auth is enabled, provate the username for the VMAgent client"
  sensitive   = true
  type        = string
}

variable "basicauth_password" {
  default     = null
  description = "If basic auth is enabled, provide the base64 encoded password to use for the VMAgent client connection"
  sensitive   = true
  type        = string
}

variable "gsa_audience" {
  default     = null
  description = "If using GSA for auth to send metrics, the audience to use for token generation"
  sensitive   = true
  type        = string
}

variable "create_namespace" {
  default     = null
  description = "Create a namespace for the deployment."
  type        = bool
}

variable "chart_name" {
  default     = null
  description = "The name of the Helm chart to install. Refer to https://github.com/VictoriaMetrics/helm-charts/tree/master/charts/victoria-metrics-agent"
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

variable "gtoken_image" {
  default     = null
  description = "The image URL to use for the gtoken container."
  type        = string
}

variable "gtoken_image_version" {
  default     = null
  description = "The image version to use for the gtoken container."
  type        = string
}

variable "namespace" {
  default     = null
  description = "The namespace used for the deployment."
  type        = string
}

variable "oauth2_enabled" {
  default     = null
  description = "Enable OAuth2 authentication for remote write endpoint. Requires providing a client id and secret."
  type        = bool
}

variable "oauth2_client_id" {
  default     = null
  description = "If OAuth2 is enabled, provide the client id for the VMAgent client"
  sensitive   = true
  type        = string
}

variable "oauth2_client_secret" {
  default     = null
  description = "If OAuth2 is enabled, provide a base64 encoded secret to use for the VMAgent client connection."
  sensitive   = true
  type        = string
}

variable "oauth2_token_url" {
  default     = null
  description = "If OAuth2 is enabled, provide the token url to use for the VMAgent client connection"
  type        = string
}

variable "release_name" {
  default     = null
  description = "The name of the helm release"
  type        = string
}

variable "remote_write_urls" {
  default     = null
  description = "A list of URL(s) for the remote write endpoint(s)."
  type        = list(string)
}

variable "settings" {
  default     = null
  description = "Additional settings which will be passed to the Helm chart values"
  type        = map(any)
}

variable "pods_scrape_namespaces" {
  default     = null
  description = "A list of additional namespaces to scrape pod metrics. Defaults to \"sn-system\"."
  type        = list(string)
}

variable "values" {
  default     = null
  description = "A list of values in raw YAML to be applied to the helm release. Merges with the settings input, can also be used with the `file()` function, i.e. `file(\"my/values.yaml\")`."
}
