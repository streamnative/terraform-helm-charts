# OLM Subscription Module	
This module creates the OLM subscriptions necessary to manage the StreamNative Operators.

## Using a private registry
Here are the full instructions for enabling OLM and using it with Cloudsmith.

1. Set the `olm_registry` input in the [terraform-helm-charts](https://github.com/streamnative/terraform-helm-charts) module to the `streamnative/operators` registry, then run `tf apply`:

```hcl
module "sn_bootstrap" {
  source = "./terraform-helm-charts"   

  enable_olm   = true
  olm_registry = "docker.cloudsmith.io/streamnative/operators/registry/pulsar-operators:master"
}
```


2. Get the entitlement token for the `streamnative/operators` registry in Cloudsmith, then create the k8s secret in the OLM namespace (`olm`) *and* the install namespace (`sn-system`). You have to do it in both namespaces since OLM doesn’t propagate secrets into the install namespace. You may need to bounce the catalog pods:

``` bash
$ kubectl create secret docker-registry cloudsmith --docker-server=docker.cloudsmith.io --docker-username=streamnative/operators --docker-password=<cloudsmith_entitlement_token> -n olm

$ kubectl create secret docker-registry cloudsmith --docker-server=docker.cloudsmith.io --docker-username=streamnative/operators --docker-password=<cloudsmith_entitlement_token> -n sn-system
```

3. Edit the `*-operator-controller-manager` deployments that are crash looping in the `sn-system` namespace and set the `ImagePullSecret` under `spec.template.spec.` to: `-name: "cloudsmith"`:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: flink-operator-controller-manager
  namespace: sn-system
...
...
spec:
  template:
    spec:
      imagePullSecrets:
      - name: cloudsmith
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.0.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | 2.2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.2.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.olm_subscriptions](https://registry.terraform.io/providers/hashicorp/helm/2.2.0/docs/resources/release) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_atomic"></a> [atomic](#input\_atomic) | Purge the chart on a failed installation. | `any` | `null` | no |
| <a name="input_chart_name"></a> [chart\_name](#input\_chart\_name) | The name of the chart to install. | `string` | `null` | no |
| <a name="input_chart_repository"></a> [chart\_repository](#input\_chart\_repository) | The repository to install the chart from. | `string` | `null` | no |
| <a name="input_chart_version"></a> [chart\_version](#input\_chart\_version) | The version of the chart to install. | `string` | `null` | no |
| <a name="input_cleanup_on_fail"></a> [cleanup\_on\_fail](#input\_cleanup\_on\_fail) | Allow deletion of new resources created in this upgrade when upgrade fails. | `bool` | `null` | no |
| <a name="input_install_namespace"></a> [install\_namespace](#input\_install\_namespace) | The namespace used for installing the operators managed by OLM. | `string` | `null` | no |
| <a name="input_olm_namespace"></a> [olm\_namespace](#input\_olm\_namespace) | The namespace used by OLM and its resources. | `string` | `"olm"` | no |
| <a name="input_registry"></a> [registry](#input\_registry) | The registry containing StreamNative's operator catalog images. This is required. | `string` | n/a | yes |
| <a name="input_release_name"></a> [release\_name](#input\_release\_name) | The name of the helm release. | `string` | `null` | no |
| <a name="input_settings"></a> [settings](#input\_settings) | Additional settings which will be passed to the Helm chart values. | `map(any)` | `null` | no |
| <a name="input_subscription_cpu_limits"></a> [subscription\_cpu\_limits](#input\_subscription\_cpu\_limits) | The cpu limits of subscription. | `string` | `null` | no |
| <a name="input_subscription_cpu_requests"></a> [subscription\_cpu\_requests](#input\_subscription\_cpu\_requests) | The cpu requests of subscription. | `string` | `null` | no |
| <a name="input_subscription_mem_limits"></a> [subscription\_mem\_limits](#input\_subscription\_mem\_limits) | The mem limits of subscription. | `string` | `null` | no |
| <a name="input_subscription_mem_requests"></a> [subscription\_mem\_requests](#input\_subscription\_mem\_requests) | The mem requests of subscription. | `string` | `null` | no |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | Time in seconds to wait for any individual kubernetes operation. | `number` | `null` | no |
| <a name="input_values"></a> [values](#input\_values) | A list of values in raw YAML to be applied to the helm release. Merges with the settings input, can also be used with the `file()` function, i.e. `file("my/values.yaml")`. | `any` | `null` | no |
| <a name="input_enable_sn_operator"></a> [enable\_sn\_operator](#input\_enable\_sn\_operator) | Whether to enable SN Operator | `bool` | `"false"` | no |
| <a name="input_sn_operator_registry"></a> [sn\_operator\_registry](#input\_sn\_operator\_registry) | SN Operator's registry | `string` | `""` | no |

## Outputs

No outputs.
