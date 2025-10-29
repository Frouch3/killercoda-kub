# Étape 4 : Générer de la Charge

```bash
microk8s kubectl run load-generator --image=busybox --restart=Never -- /bin/sh -c "while true; do wget -q -O- http://php-service; done"

# Observer le scaling
watch -n 2 'microk8s kubectl get hpa php-app; echo ""; microk8s kubectl get pods -l app=php'
```{{exec}}

Après 1-2 minutes, vous verrez le nombre de pods augmenter ! (Ctrl+C pour arrêter)

```bash
microk8s kubectl delete pod load-generator
```{{exec}}

🎉 Autoscaling en action !
