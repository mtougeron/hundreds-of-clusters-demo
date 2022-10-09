# hundreds-of-clusters-demo

Demo repository for the code for the "_Hundreds of Clusters Sitting in a Tree with Argo CD_" talk at [GitOpsCon NA 2022](https://sched.co/1AR8S).

## WARNING!!!

**Warning**: Thar **_BE SERIOUS_** dragons here...

If you leave the PR generator running on a public repo, someone could apply apply things onto your cluster that you don't want installed. *DO NOT DO THIS!*

## Create the needed namespaces

```sh
kubectl create ns argocd
kubectl create ns argo
kubectl create ns argo-events
kubectl create ns vcluster
```

## Install Argo CD

```sh
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
export ARGOCD_OPTS='--port-forward --port-forward-namespace argocd'
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
argocd login
argocd account update-password
```

## Install Argo Workflows

```sh
kubectl apply -n argo -f https://raw.githubusercontent.com/argoproj/argo-workflows/stable/manifests/install.yaml
kubectl patch deployment \
  argo-server \
  --namespace argo \
  --type='json' \
  -p='[{"op": "replace", "path": "/spec/template/spec/containers/0/args", "value": [
  "server",
  "--auth-mode=server"
]}]'
```

## Install Argo Events

```sh
kubectl apply -f https://raw.githubusercontent.com/argoproj/argo-events/stable/manifests/install.yaml
kubectl apply -f https://raw.githubusercontent.com/argoproj/argo-events/stable/manifests/install-validating-webhook.yaml
kubectl apply -n argo-events -f https://raw.githubusercontent.com/argoproj/argo-events/stable/examples/eventbus/native.yaml
```

## Add the Argo CD Password to the argo namespace

*NOTE*: This really should use an account other than `admin` for security purposes!!

```sh
kubectl create secret generic argocd-login --from-literal=password=THE_ARGOCD_PASSWORD_FROM_ABOVE --from-literal=username=admin -n argo
```

## Apply the Application and ApplicationSet to Argo CD

Be sure to modify the repo names inside the `argocd/*.yaml` to point to your repository then apply it to Argo CD.

```sh
kubectl apply -n argocd -R -f argocd/
```
