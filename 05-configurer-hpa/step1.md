# Étape 1 : Activer Metrics Server

```bash
microk8s enable metrics-server
microk8s kubectl wait --for=condition=Available deployment/metrics-server -n kube-system --timeout=120s
microk8s kubectl top nodes
```{{exec}}

✅ Metrics Server activé !
