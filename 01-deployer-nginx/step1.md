# Étape 1 : Créer le Deployment

## 📝 Objectif

Créer un fichier YAML qui définit un **Deployment** Kubernetes pour déployer Nginx.

## 🎓 Qu'est-ce qu'un Deployment ?

Un **Deployment** est une ressource Kubernetes qui :
- Gère le cycle de vie des pods
- Maintient le nombre de réplicas souhaité
- Permet les mises à jour progressives (rolling updates)
- Auto-répare les pods en cas de crash

## 📄 Création du Fichier YAML

Créez le fichier `nginx-deployment.yaml` avec le contenu suivant :

```bash
cat > nginx-deployment.yaml <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  replicas: 2
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.25-alpine
        ports:
        - containerPort: 80
EOF
```{{exec}}

## 🔍 Explication du YAML

- **`apiVersion: apps/v1`** : Version de l'API Kubernetes à utiliser
- **`kind: Deployment`** : Type de ressource
- **`replicas: 2`** : Nombre de pods à créer (haute disponibilité)
- **`selector.matchLabels`** : Comment le Deployment trouve ses pods
- **`template`** : Modèle de pod à créer
- **`image: nginx:1.25-alpine`** : Image Docker à utiliser (version Alpine légère)
- **`containerPort: 80`** : Port sur lequel le conteneur écoute

## ✅ Vérification

Vérifiez que le fichier a bien été créé :

```bash
cat nginx-deployment.yaml
```{{exec}}

## 🚀 Application du Deployment

Maintenant, appliquez ce fichier pour créer le Deployment :

```bash
microk8s kubectl apply -f nginx-deployment.yaml
```{{exec}}

Vous devriez voir : `deployment.apps/nginx-deployment created`

## 🎯 Commandes Utiles

Voir tous les deployments :
```bash
microk8s kubectl get deployments
```{{exec}}

Voir les détails du deployment :
```bash
microk8s kubectl describe deployment nginx-deployment
```{{exec}}

> 💡 **Point Clé** : La commande `kubectl apply` est **idempotente** : vous pouvez l'exécuter plusieurs fois, elle créera ou mettra à jour la ressource.

---

Cliquez sur **Continue** quand vous avez appliqué le Deployment.
