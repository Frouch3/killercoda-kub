# Étape 2 : Résoudre un ImagePullBackOff

## 📝 Objectif

Diagnostiquer et corriger un pod qui ne peut pas télécharger son image Docker.

## 🎓 Qu'est-ce qu'un ImagePullBackOff ?

**ImagePullBackOff** signifie que Kubernetes ne peut pas télécharger l'image Docker :

**Causes courantes** :
- Image n'existe pas (typo dans le nom)
- Tag incorrect (ex: `nginx:99.99`)
- Registry privé sans credentials
- Registry inaccessible
- Rate limit atteint (Docker Hub)

## 📄 Créer un Pod avec une Image Inexistante

```bash
cat > imagepull-pod.yaml <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: imagepull-app
spec:
  containers:
  - name: app
    image: nginx:this-tag-does-not-exist-999
EOF
```{{exec}}

Déployer :
```bash
microk8s kubectl apply -f imagepull-pod.yaml
```{{exec}}

## 🔍 Observer le Problème

```bash
microk8s kubectl get pods
```{{exec}}

Le status sera : `ImagePullBackOff` ou `ErrImagePull`

## 🕵️ Diagnostiquer

### 1. Describe pour voir l'erreur
```bash
microk8s kubectl describe pod imagepull-app
```{{exec}}

Dans la section **Events**, vous verrez :
```
Failed to pull image "nginx:this-tag-does-not-exist-999":
rpc error: code = NotFound desc = failed to pull and unpack image
```

### 2. Voir les events
```bash
microk8s kubectl get events --field-selector involvedObject.name=imagepull-app
```{{exec}}

Le message d'erreur indique clairement que le tag n'existe pas.

## 🔧 Corriger le Problème

Utiliser un tag valide :

```bash
cat > imagepull-pod.yaml <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: imagepull-app
spec:
  containers:
  - name: app
    image: nginx:1.25
EOF
```{{exec}}

Supprimer et recréer :
```bash
microk8s kubectl delete pod imagepull-app
microk8s kubectl apply -f imagepull-pod.yaml
```{{exec}}

Vérifier :
```bash
microk8s kubectl get pod imagepull-app
```{{exec}}

Le pod devrait maintenant être `Running`.

## 🧪 Scénario 2 : Registry Privé Sans Credentials

Créons un pod qui essaie d'accéder à un registry privé :

```bash
cat > private-registry.yaml <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: private-app
spec:
  containers:
  - name: app
    image: private-registry.example.com/myapp:latest
EOF
```{{exec}}

```bash
microk8s kubectl apply -f private-registry.yaml
```{{exec}}

Diagnostiquer :
```bash
microk8s kubectl describe pod private-app
```{{exec}}

Vous verrez une erreur d'authentification dans les Events.

## 🔐 Solution : Utiliser un ImagePullSecret

Pour un vrai registry privé, vous créeriez un Secret :

```bash
# Exemple (ne fonctionne pas ici, juste pour info)
kubectl create secret docker-registry regcred \
  --docker-server=private-registry.example.com \
  --docker-username=user \
  --docker-password=password \
  --docker-email=user@example.com
```

Puis dans le pod :
```yaml
spec:
  imagePullSecrets:
  - name: regcred
  containers:
  - name: app
    image: private-registry.example.com/myapp:latest
```

Nettoyez le pod de test :
```bash
microk8s kubectl delete pod private-app
```{{exec}}

## 🎯 Points Clés

- ✅ `kubectl describe pod` : Voir l'erreur exacte de pull
- ✅ Vérifier le nom et tag de l'image
- ✅ Pour les registries privés : utiliser `imagePullSecrets`
- ✅ Docker Hub a des rate limits (500 pulls/6h sans compte)
- ✅ Toujours valider que l'image existe avant de déployer

## 💡 Commandes Utiles

Lister les images disponibles localement :
```bash
microk8s ctr images ls | grep nginx
```{{exec}}

Voir les secrets d'image pull :
```bash
microk8s kubectl get secrets
```{{exec}}

---

Cliquez sur **Continue** quand vous avez résolu l'ImagePullBackOff.
