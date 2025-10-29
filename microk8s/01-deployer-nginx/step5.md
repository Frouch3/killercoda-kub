# Étape 5 : Scaler l'Application

## 📝 Objectif

Apprendre à **scaler horizontalement** votre application pour gérer plus de charge.

## 🎓 Qu'est-ce que le Scaling Horizontal ?

Le **scaling horizontal** consiste à augmenter le nombre de pods (réplicas) :
- ✅ Plus de pods = plus de capacité à traiter des requêtes
- ✅ Haute disponibilité : si un pod crash, les autres continuent
- ✅ Kubernetes distribue automatiquement la charge

## 📈 Scaler de 2 à 5 Réplicas

Une seule commande pour passer de 2 à 5 pods :

```bash
microk8s kubectl scale deployment nginx-deployment --replicas=5
```{{exec}}

## 👀 Observer les Pods se Créer

```bash
microk8s kubectl get pods -l app=nginx
```{{exec}}

Vous devriez maintenant voir **5 pods** !

## ⏱️ Voir la Création en Temps Réel

Lançons le scaling encore plus haut et observons en temps réel :

```bash
# Scaler à 8 réplicas
microk8s kubectl scale deployment nginx-deployment --replicas=8

# Observer en temps réel (rafraîchissement toutes les 2 secondes)
watch -n 2 'microk8s kubectl get pods -l app=nginx'
```{{exec}}

Vous verrez les nouveaux pods passer de **Pending** → **ContainerCreating** → **Running**.

Appuyez sur **Ctrl+C** pour arrêter le watch.

## 🔗 Vérifier les Endpoints du Service

Le Service a automatiquement détecté les nouveaux pods :

```bash
microk8s kubectl get endpoints nginx-service
```{{exec}}

Vous devriez maintenant voir **8 IPs** dans les endpoints !

## 📊 Voir l'Historique du Scaling

```bash
microk8s kubectl describe deployment nginx-deployment | grep -A 5 "Events:"
```{{exec}}

Vous verrez l'historique des opérations de scaling dans les Events.

## 📉 Scaler vers le Bas

On peut aussi réduire le nombre de replicas pour économiser des ressources :

```bash
microk8s kubectl scale deployment nginx-deployment --replicas=3
```{{exec}}

Vérifiez que Kubernetes supprime automatiquement les pods en trop :

```bash
microk8s kubectl get pods -l app=nginx
```{{exec}}

Vous devriez voir certains pods en état **Terminating**, puis seulement **3 pods Running**.

## 🔍 Vérification Finale

```bash
# Combien de pods Running ?
microk8s kubectl get pods -l app=nginx --no-headers | grep Running | wc -l

# Combien de replicas configurés ?
microk8s kubectl get deployment nginx-deployment -o jsonpath='{.spec.replicas}'
echo ""

# Combien de replicas disponibles ?
microk8s kubectl get deployment nginx-deployment -o jsonpath='{.status.availableReplicas}'
echo ""
```{{exec}}

Tous les chiffres devraient être **3** !

## 📝 Modifier le YAML Directement

Vous pouvez aussi modifier le nombre de replicas en éditant le fichier YAML :

```bash
# Ouvrir l'éditeur
nano nginx-deployment.yaml
```

Changez `replicas: 2` en `replicas: 4`, puis sauvegardez (**Ctrl+O**, **Enter**, **Ctrl+X**).

Appliquez la modification :

```bash
microk8s kubectl apply -f nginx-deployment.yaml
```{{exec}}

## 🎯 Points Clés

- ✅ Le scaling est **instantané** avec une simple commande
- ✅ Kubernetes crée/supprime automatiquement les pods
- ✅ Le Service détecte automatiquement les nouveaux pods
- ✅ Pas de downtime : les pods existants continuent de tourner
- ✅ En production, on peut utiliser l'**Horizontal Pod Autoscaler (HPA)** pour du scaling automatique basé sur le CPU/RAM

## 💡 Autoscaling Automatique (Bonus)

En production, on configure un HPA pour que Kubernetes scale automatiquement :

```bash
# Exemple (ne pas exécuter maintenant)
kubectl autoscale deployment nginx-deployment \
  --min=2 --max=10 --cpu-percent=70
```

Cela signifie : "Maintiens entre 2 et 10 pods, et ajoute des pods si le CPU dépasse 70%"

---

Cliquez sur **Continue** pour explorer les logs.
