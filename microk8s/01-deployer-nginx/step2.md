# Étape 2 : Vérifier les Pods

## 📝 Objectif

Observer les pods créés par le Deployment et comprendre leur cycle de vie.

## 🎓 Qu'est-ce qu'un Pod ?

Un **Pod** est la plus petite unité déployable dans Kubernetes :
- Contient un ou plusieurs conteneurs
- Partage le même réseau et stockage
- Est éphémère (peut être détruit et recréé)

## 🔍 Lister les Pods

Listez tous les pods créés par notre Deployment :

```bash
microk8s kubectl get pods
```{{exec}}

Vous devriez voir **2 pods** avec un nom similaire à `nginx-deployment-xxxxxxxx-xxxxx`.

## 📊 Format de Sortie

La commande affiche :
- **NAME** : Nom unique du pod
- **READY** : Nombre de conteneurs prêts (devrait être 1/1)
- **STATUS** : État du pod (Running, Pending, CrashLoopBackOff, etc.)
- **RESTARTS** : Nombre de fois que le pod a redémarré
- **AGE** : Âge du pod

## 🏷️ Filtrer par Label

Pour voir seulement les pods de notre application :

```bash
microk8s kubectl get pods -l app=nginx
```{{exec}}

L'option `-l app=nginx` filtre par le label `app=nginx` que nous avons défini dans le Deployment.

## 🔎 Voir les Détails d'un Pod

Pour voir tous les détails d'un pod (remplacez `<pod-name>` par le nom d'un de vos pods) :

```bash
# D'abord, récupérons le nom du premier pod
POD_NAME=$(microk8s kubectl get pods -l app=nginx -o jsonpath='{.items[0].metadata.name}')
echo "Pod sélectionné : $POD_NAME"

# Ensuite, affichons ses détails
microk8s kubectl describe pod $POD_NAME
```{{exec}}

## 📋 Informations Importantes dans `describe`

La commande `describe` affiche :
- **Image** : L'image Docker utilisée
- **Port** : Le port exposé par le conteneur
- **Node** : Sur quel nœud le pod tourne
- **IP** : L'IP interne du pod
- **Events** : Historique des événements (création, pull de l'image, démarrage, etc.)

## ⏱️ Surveiller en Temps Réel

Pour surveiller les pods en temps réel (avec rafraîchissement toutes les 2 secondes) :

```bash
watch -n 2 'microk8s kubectl get pods -l app=nginx'
```{{exec}}

Appuyez sur **Ctrl+C** pour arrêter le watch.

## 🎯 Points Clés

- ✅ Le Deployment a créé **2 pods** comme demandé dans `replicas: 2`
- ✅ Les pods sont en état **Running**
- ✅ Chaque pod a un nom unique généré automatiquement
- ✅ Kubernetes surveille ces pods et les redémarrera automatiquement s'ils crashent

---

Cliquez sur **Continue** quand vous avez exploré les pods.
