## Init ArgoCD

Init cert-manager dns secret:

```
kubectl create ns cert-manager
echo -n access-key-id > access-key-id
echo -n secret-access-key > secret-access-key
kubectl -n cert-manager create secret generic route53-credentials-secret --from-file=access-key-id --from-file=secret-access-key
```

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

## Init Atlantis

Create `atlantis` ns and secrets. Follow [this doc](https://www.runatlantis.io/docs/configuring-webhooks.html) for the `github_secret`:

```
kubectl create ns atlantis
echo -n gh_token_here > github_token
echo -n webhook_secret_here > github_secret
echo -n username > username
echo -n password > password
kubectl -n atlantis create secret generic atlantis-vcs --from-literal=github_user=bentastic27 --from-file=github_token --from-file=github_secret
kubectl -n atlantis create secret generic atlantis-creds --from-file=username --from-file=password
```

Create an AWS key for remote state:

```
cat <<EOT > credentials
[default]
aws_access_key_id=YOUR_ACCESS_KEY_ID
aws_secret_access_key=YOUR_SECRET_ACCESS_KEY
region=us-east-1
EOT

kubectl -n atlantis create secret generic aws-creds --from-file=credentials
```
