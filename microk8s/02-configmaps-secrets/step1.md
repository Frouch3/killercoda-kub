# Étape 1 : Créer un ConfigMap

## 📝 Objectif

Créer un **ConfigMap** pour stocker des données de configuration non sensibles.

## 🎓 Qu'est-ce qu'un ConfigMap ?

Un **ConfigMap** est une ressource Kubernetes qui stocke des paires clé-valeur de configuration :
- Variables d'environnement
- Fichiers de configuration
- Paramètres applicatifs

## 📄 Méthode 1 : Créer depuis la ligne de commande

La méthode la plus rapide pour créer un ConfigMap :

```bash
microk8s kubectl create configmap app-config \
  --from-literal=APP_NAME="Mon Application" \
  --from-literal=APP_ENV="production" \
  --from-literal=LOG_LEVEL="info" \
  --from-literal=API_URL="https://api.example.com"
```{{exec}}

## 🔍 Vérifier le ConfigMap

Voir les ConfigMaps :
```bash
microk8s kubectl get configmaps
```{{exec}}

Voir les détails :
```bash
microk8s kubectl describe configmap app-config
```{{exec}}

Voir le contenu en YAML :
```bash
microk8s kubectl get configmap app-config -o yaml
```{{exec}}

## 📄 Méthode 2 : Créer avec un fichier YAML

Créons un deuxième ConfigMap avec un fichier de configuration :

```bash
cat > database-config.yaml <<EOF
apiVersion: v1
kind: ConfigMap
metadata:
  name: database-config
data:
  DB_HOST: "postgres-service"
  DB_PORT: "5432"
  DB_NAME: "myapp"
  DB_POOL_SIZE: "20"
  # On peut aussi inclure des fichiers complets
  database.conf: |
    max_connections = 100
    shared_buffers = 256MB
    effective_cache_size = 1GB
EOF
```{{exec}}

Appliquer le ConfigMap :
```bash
microk8s kubectl apply -f database-config.yaml
```{{exec}}

## 🔍 Inspecter le deuxième ConfigMap

```bash
microk8s kubectl get configmap database-config -o yaml
```{{exec}}

Notez la clé `database.conf` qui contient un fichier complet sur plusieurs lignes.

## 🎯 Points Clés

- ✅ `--from-literal` : Créer depuis des valeurs en ligne de commande
- ✅ YAML : Plus lisible et versionnable (Git)
- ✅ Multi-lignes : Utiliser `|` pour inclure des fichiers complets
- ✅ **Jamais de données sensibles** dans un ConfigMap !

## ⚠️ Attention

Les ConfigMaps sont **visibles par tous** les utilisateurs ayant accès au namespace. Pour les données sensibles, utilisez des **Secrets** (étape suivante).

---

Cliquez sur **Continue** quand vous avez créé les deux ConfigMaps.
