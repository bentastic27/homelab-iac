Install cert-manager:

```
helm repo add jetstack https://charts.jetstack.io --force-update
helm install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --version v1.15.3 \
  --set crds.enabled=true
```

Install ArgoCD:

```
helm repo add argo https://argoproj.github.io/argo-helm --force-update
helm install \
  argocd argo/argo-cd \
  --namespace argocd \
  --create-namespace \
  --set crds.install=true \
  --version 7.5.0
```

Create the LE issuer and ArgoCD ingress:

```
kubectl apply -f system-manifests
```

Create the initial `argocd` project and `homelab-iac-sync` app to get everything fired off:

```
kubectl apply -f projects/argocd.yaml
kubectl apply -f applications/homelab-iac-sync.yaml
```
