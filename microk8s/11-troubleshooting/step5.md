# Étape 5 : Init Container qui Échoue

## 📝 Objectif

Diagnostiquer et corriger un pod dont l'Init Container échoue, empêchant le conteneur principal de démarrer.

## 🎓 Qu'est-ce qu'un Init Container ?

Les **Init Containers** s'exécutent **avant** les conteneurs principaux :

**Utilisations courantes** :
- Attendre qu'un service soit disponible
- Télécharger des données de configuration
- Initialiser une base de données
- Préparer un volume partagé

**Comportement** :
- S'exécutent séquentiellement (un par un)
- Doivent TOUS réussir avant que le conteneur principal démarre
- Si l'un échoue, le pod reste en `Init:Error` ou `Init:CrashLoopBackOff`

## 📄 Créer un Pod avec Init Container qui Échoue

```bash
cat > init-pod.yaml <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: init-app
spec:
  initContainers:
  - name: wait-for-database
    image: busybox
    command: ['sh', '-c', 'echo "Waiting for DB..." && invalid-command']
  - name: setup-config
    image: busybox
    command: ['sh', '-c', 'echo "Setting up config..." && sleep 2']
  containers:
  - name: app
    image: nginx
EOF
```{{exec}}

```bash
microk8s kubectl apply -f init-pod.yaml
```{{exec}}

## 🔍 Observer le Problème

```bash
microk8s kubectl get pods
```{{exec}}

Le status sera : `Init:Error` ou `Init:CrashLoopBackOff`

## 🕵️ Diagnostiquer

### 1. Describe pour voir quel init container échoue

```bash
microk8s kubectl describe pod init-app
```{{exec}}

Dans la section **Init Containers**, vous verrez :
- `wait-for-database` : State = `Waiting` ou `Terminated`
- `setup-config` : State = `Waiting` (pas encore exécuté)

Dans **Events** :
```
Back-off restarting failed container wait-for-database
```

### 2. Voir les logs de l'Init Container

Pour voir les logs d'un init container spécifique :
```bash
microk8s kubectl logs init-app -c wait-for-database
```{{exec}}

Si déjà crashé :
```bash
microk8s kubectl logs init-app -c wait-for-database --previous
```{{exec}}

Vous verrez l'erreur : `invalid-command: not found`

### 3. Lister tous les conteneurs du pod

```bash
microk8s kubectl get pod init-app -o jsonpath='{.spec.initContainers[*].name}'
echo ""
```{{exec}}

## 🔧 Corriger le Problème

Corriger la commande invalide :

```bash
cat > init-pod.yaml <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: init-app
spec:
  initContainers:
  - name: wait-for-database
    image: busybox
    command: ['sh', '-c', 'echo "Waiting for DB..." && sleep 2 && echo "DB ready!"']
  - name: setup-config
    image: busybox
    command: ['sh', '-c', 'echo "Setting up config..." && sleep 2 && echo "Config ready!"']
  containers:
  - name: app
    image: nginx
EOF
```{{exec}}

Supprimer et recréer :
```bash
microk8s kubectl delete pod init-app
microk8s kubectl apply -f init-pod.yaml
```{{exec}}

Observer la progression :
```bash
microk8s kubectl get pods -w
```{{exec}}

Vous verrez :
- `Init:0/2` : Premier init container en cours
- `Init:1/2` : Deuxième init container en cours
- `Running` : Tous les init containers terminés, conteneur principal démarré

Appuyez sur `Ctrl+C`.

## 🔍 Voir les Logs de Tous les Conteneurs

Init container 1 :
```bash
microk8s kubectl logs init-app -c wait-for-database
```{{exec}}

Init container 2 :
```bash
microk8s kubectl logs init-app -c setup-config
```{{exec}}

Conteneur principal :
```bash
microk8s kubectl logs init-app -c app
```{{exec}}

## 🧪 Scénario Réaliste : Attendre un Service

Créons un init container qui attend qu'un service soit disponible :

```bash
cat > init-wait-service.yaml <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: app-with-init
spec:
  initContainers:
  - name: wait-for-backend
    image: busybox
    command:
    - sh
    - -c
    - |
      echo "Waiting for backend-service to be ready..."
      until nslookup backend-service; do
        echo "Service not found, retrying in 2s..."
        sleep 2
      done
      echo "Backend service is ready!"
  containers:
  - name: app
    image: nginx
EOF
```{{exec}}

```bash
microk8s kubectl apply -f init-wait-service.yaml
```{{exec}}

Si le service `backend-service` existe (créé dans l'étape 4), le pod démarrera :
```bash
microk8s kubectl get pods
```{{exec}}

Voir les logs de l'init container :
```bash
microk8s kubectl logs app-with-init -c wait-for-backend
```{{exec}}

## 🎯 Points Clés

- ✅ `kubectl logs <pod> -c <init-container>` : Voir logs d'un init container
- ✅ `kubectl describe pod` : Voir quel init container a échoué
- ✅ Init containers s'exécutent **séquentiellement**, dans l'ordre
- ✅ Le conteneur principal ne démarre que si **TOUS** les init containers réussissent
- ✅ Status `Init:0/2` signifie "0 init containers terminés sur 2"
- ✅ Les init containers sont parfaits pour les **dépendances** et la **préparation**

## 💡 Cas d'Usage des Init Containers

1. **Attendre des dépendances** :
   ```yaml
   - name: wait-db
     command: ['sh', '-c', 'until nc -z db-service 5432; do sleep 1; done']
   ```

2. **Télécharger des assets** :
   ```yaml
   - name: download-assets
     command: ['wget', 'https://example.com/assets.tar.gz']
     volumeMounts:
     - name: assets
       mountPath: /data
   ```

3. **Initialiser un volume** :
   ```yaml
   - name: setup-volume
     command: ['sh', '-c', 'cp /config/* /app/config/']
   ```

## 🧹 Nettoyage

```bash
microk8s kubectl delete pod init-app app-with-init
```{{exec}}

---

Cliquez sur **Continue** pour voir le récapitulatif final.
