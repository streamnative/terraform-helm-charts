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

# prometheus-cluster-role
This basic helm chart installs `ClusterRole` resource for Prometheus, useful when installing the operator but not the server component.

## Usage
Update the Helm provider configuration accordingly:

```hcl
provider "helm" {
  kubernetes {
    host                   = <host> 
    cluster_ca_certificate = <ca_cert>
    token                  = <token>
  }
}

module "prometheus_cluster_role" {
  source = "streamnative/charts/helm//modules/prometheus-operator/prometheus-cluster-role"
}
```

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.prometheus_cluster_role](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |

## Inputs

No inputs.

## Outputs

No outputs.
