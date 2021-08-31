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

resource "helm_release" "olm_subscriptions" {
  atomic          = var.atomic
  chart           = "${path.module}/chart"
  cleanup_on_fail = var.cleanup_on_fail
  namespace       = var.namespace
  name            = var.release_name
  timeout         = var.timeout

  set {
    name  = "catalog_namespace"
    value = var.catalog_namespace
    type  = "string"
  }

  set {
    name  = "install_namespace"
    value = var.namespace
    type  = "string"
  }

  set {
    name  = "sn_registry"
    value = var.registry 
    type  = "string"
  }

  dynamic "set" {
    for_each = var.settings
    content {
      name  = set.key
      value = set.value
    }
  }
}
