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

# Helm Release Module Template
This is a template used for creating Helm releases managed by Terraform.

To use it, create a copy in the [modules](https://github.com/streamnative/terraform-helm-charts/tree/master/modules) directory of this repo, rename it, and update the [default values](https://github.com/streamnative/terraform-helm-charts/blob/master/modules/_templates/_helm_release/main.tf) in the `locals()` block accordingly (don't forget to update this README file!).

If necessary, you can compose your new module in the [root module](https://github.com/streamnative/terraform-helm-charts/blob/master/main.tf). Just follow the existing patterns and be sure to add/update the necessary [variables](https://github.com/streamnative/terraform-helm-charts/blob/master/variables.tf).


## Why are all the variable defaults null?
The submodules contained in this repo are typically composed in the root module, and as such many of a submodules variables get duplicated in the root module. 

This introduces a problem where we don't want to also duplicate default values in both places, i.e. managing a default value in the root module _and_ in the submodule, as they are difficult to synchronize and have historically drifted away from eachother.

In a perfect world, the approach we would like to take is:

- Have the root module's variables that map to a submodule's variables default to `null`
- Have the submodule's variables default to their expected value

However when we do this, the root module _overrides_ the submodule's default value with `null`, rather than respect it and treat `null` as an omission. This unfortuately is [expected behavior](https://github.com/hashicorp/terraform/issues/24142#issuecomment-646393631) in Terraform, where `null` is actually a valid value in some module configurations (instead of being "the absence of a value", like we want it to be and also like the Terraform documentation states).

To work around this, we set the default values in _both_ the root module and submodules to `null`, then use a `locals()` configuration in the submodule to manage the expected default values. To illustrate, here is a simple example:

Submodule: `streamnative/terraform-helm-charts/modules/submodule_a/main.tf`
```hcl
variable "input_1" {
  default = null
  type    = string
}

locals (
  input_1 = var.input_1 != null ? : var.input_1 : "my_default_value" // This is where we set the default value
)

output "submodule_a" {
  value = local.input_1
}
```

Root module: `streamnative/terraform-helm-charts/main.tf`
```hcl
variable "submodule_a_input_1" {
  default = null
}

module "submodule_a" {
  source = "./modules/submodule_a"

  input_1 = var.submodule_a_input_1
}
```

And in a module composition, we could override the default value:
```hcl
module "terraform-helm-charts" {
  source = "streamnative/terraform-helm-charts"

  submodule_a_input = "my_custom_value" 
}
```

While this pattern has [some limitations](https://github.com/hashicorp/terraform/issues/24142#issuecomment-938106778), it is a sufficient workaround for our (opinionated) needs in these modules.
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.0.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >=2.2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | >=2.2.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.helm_chart](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_atomic"></a> [atomic](#input\_atomic) | Purge the chart on a failed installation. Defaults are configured in the locals block of this module's main.tf file. | `bool` | `null` | no |
| <a name="input_chart_name"></a> [chart\_name](#input\_chart\_name) | The name of the Helm chart to install. Defaults are configured in the locals block of this module's main.tf file. | `string` | `null` | no |
| <a name="input_chart_repository"></a> [chart\_repository](#input\_chart\_repository) | The repository containing the Helm chart to install. Defaults are configured in the locals block of this module's main.tf file. | `string` | `null` | no |
| <a name="input_chart_version"></a> [chart\_version](#input\_chart\_version) | The version of the Helm chart to install. Defaults are configured in the locals block of this module's main.tf file. | `string` | `null` | no |
| <a name="input_cleanup_on_fail"></a> [cleanup\_on\_fail](#input\_cleanup\_on\_fail) | Allow deletion of new resources created in this upgrade when upgrade fails. Defaults are configured in the locals block of this module's main.tf file. | `bool` | `null` | no |
| <a name="input_create_namespace"></a> [create\_namespace](#input\_create\_namespace) | Create a namespace for the deployment. Defaults are configured in the locals block of this module's main.tf file. | `bool` | `null` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | The namespace used for the operator deployment. Defaults are configured in the locals block of this module's main.tf file. | `string` | `null` | no |
| <a name="input_release_name"></a> [release\_name](#input\_release\_name) | The name of the helm release. Defaults are configured in the locals block of this module's main.tf file. | `string` | `null` | no |
| <a name="input_settings"></a> [settings](#input\_settings) | Additional settings which will be passed to the Helm chart values. Defaults are configured in the locals block of this module's main.tf file. | `map(any)` | `null` | no |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | Time in seconds to wait for any individual kubernetes operation. Defaults are configured in the locals block of this module's main.tf file. | `number` | `null` | no |
| <a name="input_values"></a> [values](#input\_values) | A list of values in raw YAML to be applied to the helm release. Merges with the settings input, can also be used with the `file()` function, i.e. `file("my/values.yaml")`. Defaults are configured in the locals block of this module's main.tf file. | `any` | `null` | no |

## Outputs

No outputs.
