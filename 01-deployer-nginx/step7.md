# Étape 7 : Rolling Update

## 📝 Objectif

Effectuer une **mise à jour sans downtime** de votre application (Rolling Update).

## 🎓 Qu'est-ce qu'un Rolling Update ?

Un **Rolling Update** est une stratégie de déploiement qui :
- ✅ Met à jour les pods **progressivement** (un par un ou par petits groupes)
- ✅ **Aucun downtime** : l'application reste accessible pendant la mise à jour
- ✅ Permet un **rollback rapide** si problème détecté
- ✅ Vérifie que les nouveaux pods sont sains avant de supprimer les anciens

## 📊 Stratégie par Défaut

Kubernetes utilise par défaut une stratégie **RollingUpdate** :
```yaml
strategy:
  type: RollingUpdate
  rollingUpdate:
    maxUnavailable: 25%  # Max 25% de pods indisponibles pendant l'update
    maxSurge: 25%        # Max 25% de pods supplémentaires créés temporairement
```

## 🚀 Mettre à Jour la Version de l'Application

Nous allons passer de **nginxdemos/hello** (version HTML) à **nginxdemos/hello:plain-text** (version texte simple).

### Méthode 1 : Via `kubectl set image`

```bash
microk8s kubectl set image deployment/nginx-deployment nginx=nginxdemos/hello:plain-text
```{{exec}}

Cette commande :
- Modifie l'image du conteneur `nginx` dans le deployment
- Déclenche automatiquement un rolling update

## 👀 Observer le Rolling Update

Surveillez les pods en temps réel pendant l'update :

```bash
watch -n 1 'microk8s kubectl get pods -l app=nginx'
```{{exec}}

Vous verrez :
1. Nouveaux pods créés avec la nouvelle image (nginxdemos/hello:plain-text)
2. Anciens pods terminés progressivement
3. À aucun moment tous les pods ne sont down

Appuyez sur **Ctrl+C** après 20-30 secondes.

## 📊 Voir le Statut du Rollout

```bash
microk8s kubectl rollout status deployment/nginx-deployment
```{{exec}}

Cette commande attend que le rollout soit complètement terminé.

## ✅ Vérifier la Nouvelle Version

Vérifions que la mise à jour a bien été appliquée :

```bash
microk8s kubectl get deployment nginx-deployment -o jsonpath='{.spec.template.spec.containers[0].image}'
echo ""
```{{exec}}

Vous devriez voir : `nginxdemos/hello:plain-text`

## 📜 Voir l'Historique des Déploiements

Kubernetes garde un historique des révisions :

```bash
microk8s kubectl rollout history deployment/nginx-deployment
```{{exec}}

Vous verrez :
- **REVISION 1** : Déploiement initial (nginxdemos/hello)
- **REVISION 2** : Mise à jour (nginxdemos/hello:plain-text)

## 🔍 Détails d'une Révision

Pour voir les détails d'une révision spécifique :

```bash
microk8s kubectl rollout history deployment/nginx-deployment --revision=2
```{{exec}}

## ⏪ Rollback vers la Version Précédente

Si la nouvelle version a un bug, on peut rollback instantanément :

```bash
microk8s kubectl rollout undo deployment/nginx-deployment
```{{exec}}

Cette commande :
- Revient à la révision précédente (REVISION 1)
- Effectue aussi un rolling update (pas de downtime)

## 👀 Observer le Rollback

```bash
watch -n 1 'microk8s kubectl get pods -l app=nginx'
```{{exec}}

Vous verrez les pods revenir à nginxdemos/hello (version HTML) !

Appuyez sur **Ctrl+C** après quelques secondes.

## ✅ Vérifier la Version Après Rollback

```bash
microk8s kubectl get deployment nginx-deployment -o jsonpath='{.spec.template.spec.containers[0].image}'
echo ""
```{{exec}}

Devrait afficher : `nginxdemos/hello`

## 🎯 Rollback vers une Révision Spécifique

Vous pouvez aussi rollback vers n'importe quelle révision :

```bash
# Rollback vers la révision 2
microk8s kubectl rollout undo deployment/nginx-deployment --to-revision=2
```{{exec}}

## 📝 Méthode 2 : Modifier le YAML et Apply

Vous pouvez aussi modifier le fichier YAML directement :

```bash
# Éditer le fichier (remplacer l'image)
sed -i 's|nginxdemos/hello$|nginxdemos/hello:plain-text|g' nginx-deployment.yaml

# Vérifier la modification
grep "image:" nginx-deployment.yaml

# Appliquer
microk8s kubectl apply -f nginx-deployment.yaml
```{{exec}}

## 🎯 Points Clés

- ✅ Rolling Update = **Zero Downtime**
- ✅ Kubernetes met à jour **progressivement** les pods
- ✅ Rollback **instantané** si problème détecté
- ✅ Historique complet des révisions conservé
- ✅ Stratégie personnalisable (maxUnavailable, maxSurge)

## 🚀 Stratégies Avancées (Production)

En production, on peut utiliser des stratégies plus avancées :

### **Blue-Green Deployment**
- Déployer la nouvelle version à côté de l'ancienne
- Basculer le trafic instantanément
- Rollback instantané en rebasculant

### **Canary Deployment**
- Déployer la nouvelle version sur 5-10% du trafic
- Monitorer les métriques et erreurs
- Augmenter progressivement si tout va bien

### **A/B Testing**
- Déployer 2 versions en parallèle
- Router le trafic selon des critères (géo, user-agent, etc.)
- Mesurer les KPIs de chaque version

## 📊 Voir les Events du Deployment

```bash
microk8s kubectl describe deployment nginx-deployment | tail -20
```{{exec}}

Les Events montrent tout l'historique : scale, update, rollback, etc.

---

Félicitations ! Vous avez complété l'exercice 1 ! 🎉

Cliquez sur **Continue** pour voir le résumé final.
