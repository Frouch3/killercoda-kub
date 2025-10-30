# Étape 1 : Différence Deployment vs StatefulSet

## 📝 Objectif

Comprendre concrètement la différence entre **Deployment** et **StatefulSet** en les créant et en observant leur comportement.

## 📊 Tableau Comparatif

| Critère | Deployment | StatefulSet |
|---------|-----------|-------------|
| **Nom des pods** | `app-7f8c9-xyz` (hash aléatoire) | `app-0`, `app-1`, `app-2` (index stable) |
| **Identité** | Éphémère (change à chaque redémarrage) | Stable (ne change jamais) |
| **Stockage** | PVC partagé OU sans stockage | **PVC dédié** par pod |
| **Ordre création** | **Parallèle** (tous en même temps) | **Séquentiel** (un par un) |
| **Ordre suppression** | Parallèle | **Inverse** (dernier → premier) |
| **DNS** | Via Service (load balancing) | **Headless Service** + DNS par pod |
| **Cas d'usage** | API stateless, frontend web | Bases de données, caches, Kafka |

## 🎯 Cas d'Usage

### Utilisez un Deployment pour :
- ✅ Applications **stateless** (sans état)
- ✅ APIs REST, microservices
- ✅ Frontend React, Angular, Vue
- ✅ Workers de traitement
- ✅ Scaling rapide (horizontal)

### Utilisez un StatefulSet pour :
- ✅ **Bases de données** : PostgreSQL, MySQL, MongoDB
- ✅ **Caches distribués** : Redis Cluster, Memcached
- ✅ **Message queues** : Kafka, RabbitMQ, Zookeeper
- ✅ **Systèmes distribués** : Elasticsearch, Cassandra
- ✅ Applications nécessitant une **identité stable**

## 📄 Créer un StatefulSet Simple

Créons un StatefulSet nginx avec stockage persistant pour comparer avec un Deployment :

```bash
cat > nginx-statefulset.yaml <<EOF
apiVersion: v1
kind: Service
metadata:
  name: nginx-headless
spec:
  clusterIP: None  # Headless Service (pas de load balancing)
  selector:
    app: nginx-stateful
  ports:
  - port: 80
    name: web
---
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: nginx-stateful
spec:
  serviceName: nginx-headless  # Obligatoire pour StatefulSet
  replicas: 3
  selector:
    matchLabels:
      app: nginx-stateful
  template:
    metadata:
      labels:
        app: nginx-stateful
    spec:
      containers:
      - name: nginx
        image: nginx:1.25
        ports:
        - containerPort: 80
          name: web
        volumeMounts:
        - name: data
          mountPath: /usr/share/nginx/html

  # volumeClaimTemplates : Crée un PVC par pod automatiquement
  volumeClaimTemplates:
  - metadata:
      name: data
    spec:
      accessModes: [ "ReadWriteOnce" ]
      resources:
        requests:
          storage: 100Mi
EOF
```{{exec}}

## 🚀 Déployer le StatefulSet

```bash
microk8s kubectl apply -f nginx-statefulset.yaml
```{{exec}}

## 👀 Observer la Création Séquentielle

Regardez les pods se créer **un par un** :

```bash
microk8s kubectl get pods -l app=nginx-stateful --watch
```{{exec}}

Vous verrez :
1. `nginx-stateful-0` créé → Running
2. Puis `nginx-stateful-1` créé → Running
3. Puis `nginx-stateful-2` créé → Running

**Ordre séquentiel** : Chaque pod attend que le précédent soit Ready.

Appuyez sur **Ctrl+C** pour arrêter le watch.

## 🔍 Vérifier les Noms Stables

```bash
microk8s kubectl get pods -l app=nginx-stateful
```{{exec}}

Les noms sont **prévisibles** : `nginx-stateful-0`, `nginx-stateful-1`, `nginx-stateful-2`

## 💾 Vérifier les PVC Créés Automatiquement

Chaque pod a son propre PVC :

```bash
microk8s kubectl get pvc
```{{exec}}

Vous verrez 3 PVC :
- `data-nginx-stateful-0`
- `data-nginx-stateful-1`
- `data-nginx-stateful-2`

Format : `<volumeClaimTemplate-name>-<statefulset-name>-<index>`

## 🔗 Tester le DNS Headless

Avec un **Headless Service** (`clusterIP: None`), chaque pod a son propre DNS :

```bash
microk8s kubectl run dns-test --rm -it --image=busybox -- sh -c "
  nslookup nginx-stateful-0.nginx-headless
  nslookup nginx-stateful-1.nginx-headless
  nslookup nginx-stateful-2.nginx-headless
"
```{{exec}}

Format DNS : `<pod-name>.<headless-service-name>.<namespace>.svc.cluster.local`

## 🗑️ Tester la Suppression Ordonnée

Supprimons le StatefulSet **sans supprimer les PVC** :

```bash
microk8s kubectl delete statefulset nginx-stateful --cascade=orphan
```{{exec}}

Observer les pods disparaître dans l'**ordre inverse** :

```bash
microk8s kubectl get pods -l app=nginx-stateful
```{{exec}}

Les pods sont supprimés : `nginx-stateful-2` → `nginx-stateful-1` → `nginx-stateful-0`

## 💾 Vérifier que les PVC sont Conservés

```bash
microk8s kubectl get pvc
```{{exec}}

Les PVC sont toujours là ! Ils ne sont **pas supprimés** automatiquement.

## 📊 Comparaison : Deployment

Pour comparer, créons un Deployment :

```bash
cat > nginx-deployment.yaml <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deploy
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx-deploy
  template:
    metadata:
      labels:
        app: nginx-deploy
    spec:
      containers:
      - name: nginx
        image: nginx:1.25
        ports:
        - containerPort: 80
EOF
```{{exec}}

Déployer :

```bash
microk8s kubectl apply -f nginx-deployment.yaml
```{{exec}}

Observer :

```bash
microk8s kubectl get pods -l app=nginx-deploy
```{{exec}}

Les noms sont **aléatoires** : `nginx-deploy-7f8c9-xyz`, `nginx-deploy-abc12-def`

## 🧹 Nettoyer

```bash
microk8s kubectl delete deployment nginx-deploy
microk8s kubectl delete service nginx-headless
microk8s kubectl delete pvc --all
```{{exec}}

## 🎯 Points Clés

- ✅ **StatefulSet** : Noms prévisibles, PVC par pod, ordre garanti
- ✅ **Deployment** : Noms aléatoires, pas de garantie d'ordre
- ✅ **Headless Service** : DNS par pod au lieu de load balancing
- ✅ **volumeClaimTemplates** : Crée automatiquement un PVC par pod
- ✅ Les PVC ne sont **pas supprimés** automatiquement (protection des données)

---

Cliquez sur **Continue** pour déployer PostgreSQL avec un StatefulSet.
