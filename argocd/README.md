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

Apply the Let's Encrypt Issuer:

```
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod
spec:
  acme:
    server: https://acme-v02.api.letsencrypt.org/directory
    email: test@example.com
    privateKeySecretRef:
      name: letsencrypt-prod
    solvers:
      - http01:
          ingress:
            class: nginx
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
