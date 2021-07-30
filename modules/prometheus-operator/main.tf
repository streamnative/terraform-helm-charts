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

terraform {
  required_version = ">=1.0.0"

  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "2.2.0"
    }
  }
}

resource "helm_release" "prometheus_operator" {
  atomic           = var.atomic
  chart            = var.chart_name
  cleanup_on_fail  = var.cleanup_on_fail
  name             = var.release_name
  namespace        = var.namespace
  repository       = var.chart_repository
  timeout          = var.timeout
  version          = var.chart_version

  dynamic "set" {
    for_each = var.settings
    content {
      name  = set.key
      value = set.value
    }
  }
}
