# Setup a basic cluster-api AWS or EKS based cluster to do your testing with

## Install Kind & setup cluster

```sh
brew install kind
kind create cluster
```

## Install cluster-api dependencies

```sh
brew install clusterctl
brew install clusterawsadm
```

## Setup cluster-api

 Modify `~/.cluster-api/clusterctl.yaml` and add the vcluster provider

```yaml
providers:
- name: vcluster
    url: https://github.com/loft-sh/cluster-api-provider-vcluster/releases/latest/infrastructure-components.yaml
    type: InfrastructureProvider      
```

```sh
export CAPA_EKS_IAM=true
export EXP_MACHINE_POOL=true
export CAPA_EKS_IAM=true
export CAPA_EKS_ADD_ROLES=true

# Setup your AWS environment variables

clusterawsadm bootstrap iam create-cloudformation-stack
export AWS_B64ENCODED_CREDENTIALS=$(clusterawsadm bootstrap credentials encode-as-profile)

clusterctl init --infrastructure aws
```

## Build a quick cluster

Please see the `values.yaml` for the various options available (you'll probably want to change some of them).

```sh
helm install hundreds-of-clusters-demo .
```

and wait for the cluster to be created.

Once the cluster is created, you'll need to find the private subnet IDs so that you can populate your values file
with them and create the `AWSManagedMachinePool` in the private subnets. 

## Get the kubeconfig

```sh
clusterctl get kubeconfig hundreds-of-clusters-demo > kubeconfig.yaml
```

## Setup cluster-api-provider-vcluster in the new cluster

```sh
export KUBECONFIG="$(pwd)/kubeconfig.yaml"
kubectl create ns vcluster
clusterctl init --infrastructure vcluster
```

## Tear it down

**NOTE**: Be sure to delete the `cluster` not the helm chart first. Otherwise it may leave the VPC resources abandoned.

```sh
kubectl delete cluster hundreds-of-clusters-demo
## 
## Wait for the cluster to be fully deleted
## 
helm uninstall hundreds-of-clusters-demo
```
