# Étape 2 : Déployer PostgreSQL avec StatefulSet

## 📝 Objectif

Déployer une base de données **PostgreSQL** avec un StatefulSet pour garantir la persistance des données et l'identité stable.

## 🎓 Pourquoi PostgreSQL avec StatefulSet ?

PostgreSQL nécessite :
- ✅ **Stockage persistant** : Les données doivent survivre aux redémarrages
- ✅ **Identité stable** : Pour la réplication master/replica
- ✅ **DNS prévisible** : `postgres-0.postgres` pour se connecter
- ✅ **Ordre de démarrage** : Important pour les clusters (master avant replicas)

## 📄 Créer le ConfigMap pour l'Init Script

Créons un script d'initialisation pour PostgreSQL :

```bash
cat > postgres-configmap.yaml <<EOF
apiVersion: v1
kind: ConfigMap
metadata:
  name: postgres-init
data:
  init.sql: |
    -- Script d'initialisation PostgreSQL
    CREATE TABLE IF NOT EXISTS users (
      id SERIAL PRIMARY KEY,
      username VARCHAR(50) NOT NULL,
      email VARCHAR(100) NOT NULL,
      created_at TIMESTAMP DEFAULT NOW()
    );

    -- Données d'exemple
    INSERT INTO users (username, email) VALUES
      ('alice', 'alice@example.com'),
      ('bob', 'bob@example.com');
EOF
```{{exec}}

Appliquer :

```bash
microk8s kubectl apply -f postgres-configmap.yaml
```{{exec}}

## 📄 Créer le StatefulSet PostgreSQL

Créons maintenant le StatefulSet complet avec Headless Service :

```bash
cat > postgres-statefulset.yaml <<EOF
---
# Headless Service pour le StatefulSet
apiVersion: v1
kind: Service
metadata:
  name: postgres
  labels:
    app: postgres
spec:
  clusterIP: None  # Headless (pas de load balancing)
  selector:
    app: postgres
  ports:
  - port: 5432
    name: postgres
---
# Service pour accès externe (optionnel)
apiVersion: v1
kind: Service
metadata:
  name: postgres-lb
  labels:
    app: postgres
spec:
  selector:
    app: postgres
  ports:
  - port: 5432
    targetPort: 5432
  type: ClusterIP
---
# StatefulSet PostgreSQL
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: postgres
spec:
  serviceName: postgres  # Lien avec Headless Service
  replicas: 2
  selector:
    matchLabels:
      app: postgres
  template:
    metadata:
      labels:
        app: postgres
    spec:
      containers:
      - name: postgres
        image: postgres:15-alpine
        ports:
        - containerPort: 5432
          name: postgres

        env:
        - name: POSTGRES_DB
          value: "myapp"
        - name: POSTGRES_USER
          value: "admin"
        - name: POSTGRES_PASSWORD
          value: "secretpassword"
        - name: PGDATA
          value: /var/lib/postgresql/data/pgdata

        volumeMounts:
        - name: data
          mountPath: /var/lib/postgresql/data
        - name: init-script
          mountPath: /docker-entrypoint-initdb.d

        # Probes pour auto-healing
        livenessProbe:
          exec:
            command:
            - pg_isready
            - -U
            - admin
          initialDelaySeconds: 30
          periodSeconds: 10

        readinessProbe:
          exec:
            command:
            - pg_isready
            - -U
            - admin
          initialDelaySeconds: 5
          periodSeconds: 5

      volumes:
      - name: init-script
        configMap:
          name: postgres-init

  # Créer un PVC par pod (100Mi chacun)
  volumeClaimTemplates:
  - metadata:
      name: data
    spec:
      accessModes: [ "ReadWriteOnce" ]
      resources:
        requests:
          storage: 500Mi
EOF
```{{exec}}

## 🚀 Déployer PostgreSQL

```bash
microk8s kubectl apply -f postgres-statefulset.yaml
```{{exec}}

## 👀 Observer la Création Séquentielle

```bash
microk8s kubectl get pods -l app=postgres --watch
```{{exec}}

Vous verrez :
1. `postgres-0` créé et Running
2. Puis `postgres-1` créé et Running

Ordre **séquentiel** ! Appuyez sur **Ctrl+C** pour arrêter.

## 🔍 Vérifier le Statut

```bash
microk8s kubectl get statefulset postgres
microk8s kubectl get pods -l app=postgres
microk8s kubectl get pvc
```{{exec}}

Vous devriez voir :
- StatefulSet avec **2/2 Ready**
- Pods : `postgres-0` et `postgres-1`
- PVC : `data-postgres-0` et `data-postgres-1`

## 🔗 Tester la Connexion DNS

Chaque pod a son propre DNS :

```bash
microk8s kubectl run dns-test --rm -it --image=busybox -- sh -c "
  echo 'Testing DNS for postgres-0...'
  nslookup postgres-0.postgres
  echo ''
  echo 'Testing DNS for postgres-1...'
  nslookup postgres-1.postgres
"
```{{exec}}

DNS : `postgres-0.postgres.default.svc.cluster.local`

## 🗄️ Se Connecter à PostgreSQL

Connectons-nous au premier pod (`postgres-0`) :

```bash
microk8s kubectl exec -it postgres-0 -- psql -U admin -d myapp
```{{exec}}

Une fois connecté, testez :

```sql
-- Voir les tables
\dt

-- Voir les utilisateurs
SELECT * FROM users;

-- Quitter
\q
```{{exec}}

## 📊 Vérifier les Données Initiales

```bash
microk8s kubectl exec -it postgres-0 -- psql -U admin -d myapp -c "SELECT * FROM users;"
```{{exec}}

Vous devriez voir Alice et Bob !

## 🔍 Vérifier Chaque Pod a ses Propres Données

Vérifions que chaque pod a sa **propre base** indépendante :

```bash
# Ajouter une donnée dans postgres-0
microk8s kubectl exec -it postgres-0 -- psql -U admin -d myapp -c "
  INSERT INTO users (username, email) VALUES ('charlie', 'charlie@pod0.com');
  SELECT * FROM users;
"
```{{exec}}

```bash
# Vérifier postgres-1 (ne doit PAS avoir charlie)
microk8s kubectl exec -it postgres-1 -- psql -U admin -d myapp -c "SELECT * FROM users;"
```{{exec}}

Les données sont **indépendantes** ! Chaque pod a son propre stockage.

## 🌐 Tester via le Service

Le Service `postgres-lb` fait du load balancing sur les 2 pods :

```bash
microk8s kubectl run pg-client --rm -it --image=postgres:15-alpine -- sh -c "
  PGPASSWORD=secretpassword psql -h postgres-lb -U admin -d myapp -c 'SELECT version();'
"
```{{exec}}

## 📊 Voir les Détails du StatefulSet

```bash
microk8s kubectl describe statefulset postgres
```{{exec}}

Notez :
- **volumeClaimTemplates** : Template pour créer les PVC
- **serviceName** : Lien avec le Headless Service
- **Replicas** : 2 pods

## 🔍 Voir les PVC et leur Taille

```bash
microk8s kubectl get pvc -o custom-columns=NAME:.metadata.name,STATUS:.status.phase,CAPACITY:.status.capacity.storage,POD:.metadata.labels
```{{exec}}

Chaque PVC fait **500Mi** et est lié à un pod spécifique.

## 🎯 Points Clés

- ✅ **Headless Service** (`clusterIP: None`) pour DNS par pod
- ✅ **volumeClaimTemplates** crée automatiquement un PVC par pod
- ✅ Chaque pod PostgreSQL a son **propre stockage**
- ✅ DNS stable : `postgres-0.postgres`, `postgres-1.postgres`
- ✅ **Probes** (liveness + readiness) pour auto-healing
- ✅ ConfigMap pour script d'initialisation SQL

## ⚠️ Note Importante

Dans cet exercice, chaque pod PostgreSQL est **indépendant**. En production, vous configureriez une **réplication master/replica** avec :
- `postgres-0` = master (lecture + écriture)
- `postgres-1+` = replicas (lecture seule)

---

Cliquez sur **Continue** pour tester la persistance et l'ordre des pods.
