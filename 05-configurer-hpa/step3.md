# Étape 3 : Configurer HPA

```bash
microk8s kubectl autoscale deployment php-app --min=1 --max=10 --cpu-percent=50
microk8s kubectl get hpa php-app
```{{exec}}

Le HPA va maintenir entre 1 et 10 pods, en ajoutant des pods si le CPU dépasse 50%.

✅ HPA configuré !
