# Étape 3 : Tester Persistance et Ordre

## 📝 Objectif

Vérifier que les données **persistent** après suppression d'un pod et observer l'**ordre de création/suppression** lors du scaling.

## 💾 Tester la Persistance des Données

### 1. Insérer des Données dans postgres-0

```bash
microk8s kubectl exec -it postgres-0 -- psql -U admin -d myapp -c "
  INSERT INTO users (username, email) VALUES ('david', 'david@test.com');
  INSERT INTO users (username, email) VALUES ('eve', 'eve@test.com');
  SELECT * FROM users;
"
```{{exec}}

Vous devriez voir 4 utilisateurs maintenant (alice, bob, charlie, david, eve).

### 2. Supprimer le Pod postgres-0

```bash
microk8s kubectl delete pod postgres-0
```{{exec}}

Kubernetes va **recréer automatiquement** le pod (auto-healing du StatefulSet).

### 3. Observer la Recréation

```bash
microk8s kubectl get pods -l app=postgres --watch
```{{exec}}

Vous verrez :
- `postgres-0` : **Terminating**
- `postgres-0` : **Pending** → **Running**

Le pod est **recréé avec le même nom** ! Appuyez sur **Ctrl+C**.

### 4. Vérifier que les Données sont Toujours Là

```bash
microk8s kubectl wait --for=condition=Ready pod/postgres-0 --timeout=120s
microk8s kubectl exec -it postgres-0 -- psql -U admin -d myapp -c "SELECT * FROM users;"
```{{exec}}

Les données sont **toujours là** ! Le PVC `data-postgres-0` a été **réattaché** au nouveau pod.

## 📊 Comprendre la Persistance

Que s'est-il passé ?

1. Pod `postgres-0` supprimé → **PVC conservé** (`data-postgres-0`)
2. StatefulSet recréé le pod → **Même nom** : `postgres-0`
3. Kubernetes **réattache automatiquement** le PVC `data-postgres-0`
4. Les données PostgreSQL sont intactes !

## 🔼 Tester le Scale Up (Augmenter les Replicas)

### 1. Scale de 2 à 4 Replicas

```bash
microk8s kubectl scale statefulset postgres --replicas=4
```{{exec}}

### 2. Observer l'Ordre de Création

```bash
microk8s kubectl get pods -l app=postgres --watch
```{{exec}}

Vous verrez la création **séquentielle** :
1. `postgres-2` créé → Running
2. Puis `postgres-3` créé → Running

Ordre : **2 → 3** (pas en parallèle !). Appuyez sur **Ctrl+C**.

### 3. Vérifier les Nouveaux PVC

```bash
microk8s kubectl get pvc
```{{exec}}

Vous voyez maintenant 4 PVC :
- `data-postgres-0`
- `data-postgres-1`
- `data-postgres-2`
- `data-postgres-3`

Créés automatiquement !

### 4. Vérifier les Pods

```bash
microk8s kubectl get pods -l app=postgres
```{{exec}}

4 pods : `postgres-0`, `postgres-1`, `postgres-2`, `postgres-3`

## 🔽 Tester le Scale Down (Réduire les Replicas)

### 1. Scale de 4 à 2 Replicas

```bash
microk8s kubectl scale statefulset postgres --replicas=2
```{{exec}}

### 2. Observer l'Ordre de Suppression

```bash
microk8s kubectl get pods -l app=postgres --watch
```{{exec}}

Vous verrez la suppression **dans l'ordre inverse** :
1. `postgres-3` supprimé
2. Puis `postgres-2` supprimé

Ordre : **3 → 2** (dernier créé → premier supprimé). Appuyez sur **Ctrl+C**.

### 3. Vérifier les PVC

```bash
microk8s kubectl get pvc
```{{exec}}

Les PVC `data-postgres-2` et `data-postgres-3` sont **toujours là** ! Ils ne sont **pas supprimés** automatiquement (protection des données).

## 🗑️ Supprimer les PVC Orphelins

Si vous voulez supprimer les PVC non utilisés :

```bash
microk8s kubectl delete pvc data-postgres-2 data-postgres-3
```{{exec}}

Vérifier :

```bash
microk8s kubectl get pvc
```{{exec}}

Maintenant seulement 2 PVC restent : `data-postgres-0` et `data-postgres-1`.

## 🔄 Tester le Rolling Update

Mettons à jour l'image PostgreSQL :

```bash
microk8s kubectl patch statefulset postgres -p '{"spec":{"template":{"spec":{"containers":[{"name":"postgres","image":"postgres:16-alpine"}]}}}}'
```{{exec}}

Observer le rolling update **séquentiel** :

```bash
microk8s kubectl rollout status statefulset postgres
```{{exec}}

Les pods sont mis à jour **un par un** dans l'ordre inverse :
1. `postgres-1` mis à jour
2. Puis `postgres-0` mis à jour

## 🔍 Vérifier la Version PostgreSQL

```bash
microk8s kubectl exec -it postgres-0 -- psql -U admin -d myapp -c "SELECT version();"
```{{exec}}

La version doit être PostgreSQL **16** maintenant !

## 📊 Statistiques du StatefulSet

Voir l'historique des révisions :

```bash
microk8s kubectl rollout history statefulset postgres
```{{exec}}

Voir les détails :

```bash
microk8s kubectl describe statefulset postgres | grep -A 5 "Update Strategy"
```{{exec}}

La stratégie par défaut est `RollingUpdate` avec `Partition: 0` (tous les pods sont mis à jour).

## 🎯 Comprendre l'Ordre Garanti

Pourquoi l'ordre est-il important ?

### Pour PostgreSQL avec Réplication :
1. **Master** (`postgres-0`) doit démarrer **en premier**
2. **Replicas** (`postgres-1+`) se connectent au master
3. Lors d'un scale down, on supprime les replicas **avant** le master

### Pour Zookeeper / Kafka :
1. Former un **quorum** nécessite un ordre précis
2. Le leader doit être élu avant les followers
3. Suppression inverse pour éviter la perte de quorum

### Pour Cassandra / MongoDB :
1. Les seeds nodes démarrent en premier
2. Les autres nodes rejoignent le cluster ensuite

## 📈 Visualiser l'Ordre avec un Test

Créons un simple test pour visualiser :

```bash
# Scale à 5 replicas
microk8s kubectl scale statefulset postgres --replicas=5

# Observer en temps réel
watch -n 1 'microk8s kubectl get pods -l app=postgres'
```{{exec}}

Vous verrez les pods apparaître **séquentiellement** : 0 → 1 → 2 → 3 → 4

Appuyez sur **Ctrl+C** pour arrêter.

## 🧹 Nettoyer

Remettons à 2 replicas :

```bash
microk8s kubectl scale statefulset postgres --replicas=2
```{{exec}}

## 🎯 Points Clés

- ✅ **Persistance garantie** : Les PVC survivent à la suppression des pods
- ✅ **Réattachement automatique** : Le même PVC est réattaché au pod recréé
- ✅ **Scale Up** : Création **séquentielle** (0 → 1 → 2 → ...)
- ✅ **Scale Down** : Suppression **inverse** (... → 2 → 1 → 0)
- ✅ **PVC non supprimés** : Protection contre la perte de données accidentelle
- ✅ **Rolling Update** : Mise à jour **un par un** dans l'ordre inverse
- ✅ **Auto-healing** : Le pod recréé garde le même nom et PVC

## 💡 Bonnes Pratiques

1. **Ne jamais supprimer manuellement les PVC** d'un StatefulSet en cours d'exécution
2. **Toujours faire des backups** avant un scale down
3. **Tester les rolling updates** en staging avant production
4. **Monitorer les probes** (liveness + readiness) pour l'auto-healing
5. **Utiliser un StorageClass** avec rétention pour éviter la perte de données

---

Cliquez sur **Continue** pour voir le récapitulatif.
