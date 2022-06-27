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
