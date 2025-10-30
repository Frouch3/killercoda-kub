# Étape 2 : Jobs Parallèles

## 📝 Objectif

Exécuter des Jobs en **parallèle** pour traiter plusieurs tâches simultanément.

## 🎓 Parallélisme des Jobs

Deux paramètres contrôlent l'exécution parallèle :

### completions
Nombre **total** de fois que le Job doit réussir :
- `completions: 5` → Le Job doit réussir 5 fois (5 Pods terminés avec succès)

### parallelism
Nombre de Pods qui s'exécutent **en même temps** :
- `parallelism: 2` → Max 2 Pods en cours d'exécution simultanément

**Exemple** : `completions: 5` + `parallelism: 2`
- Kubernetes lance 2 Pods
- Dès qu'un Pod se termine, un nouveau est lancé
- Continue jusqu'à avoir 5 complétions réussies

## 📄 Créer un Job Parallèle

Créons un Job qui traite 5 tâches avec 2 Pods en parallèle :

```bash
cat > parallel-job.yaml <<EOF
apiVersion: batch/v1
kind: Job
metadata:
  name: parallel-worker
spec:
  # Le Job doit se terminer avec succès 5 fois
  completions: 5

  # Maximum 2 Pods en parallèle
  parallelism: 2

  template:
    spec:
      restartPolicy: OnFailure
      containers:
      - name: worker
        image: busybox:1.36
        command:
        - sh
        - -c
        - |
          echo "Worker démarré à \$(date)"
          echo "Traitement de la tâche..."
          sleep 10
          echo "Tâche terminée à \$(date)"
EOF
```{{exec}}

Appliquer :
```bash
microk8s kubectl apply -f parallel-job.yaml
```{{exec}}

## 🔍 Observer la Progression

Dans un **premier terminal**, observer les Pods en temps réel :
```bash
watch -n 1 'microk8s kubectl get pods --selector=job-name=parallel-worker'
```{{exec}}

Vous verrez :
1. 2 Pods lancés en parallèle
2. Quand un Pod termine, un nouveau est créé
3. Progression : 0/5, 1/5, 2/5, ... jusqu'à 5/5

Arrêter avec `Ctrl+C`.

## 📊 Voir le Status du Job

```bash
microk8s kubectl get job parallel-worker
```{{exec}}

La colonne **COMPLETIONS** montre la progression : `3/5`, `4/5`, `5/5`.

Voir les détails :
```bash
microk8s kubectl describe job parallel-worker
```{{exec}}

Cherchez la section **Events** pour voir l'historique :
- `Created pod: parallel-worker-xxxxx`
- `SuccessfulCreate`

## 🧪 Job avec Index de Complétion

Pour des tâches **indexées** (chaque Pod traite un index différent), utilisez `completionMode: Indexed` :

```bash
cat > indexed-job.yaml <<EOF
apiVersion: batch/v1
kind: Job
metadata:
  name: indexed-worker
spec:
  completions: 3
  parallelism: 2
  completionMode: Indexed  # Chaque Pod reçoit un index unique

  template:
    spec:
      restartPolicy: OnFailure
      containers:
      - name: worker
        image: busybox:1.36
        command:
        - sh
        - -c
        - |
          echo "Traitement de l'index: \$JOB_COMPLETION_INDEX"
          sleep 5
          echo "Index \$JOB_COMPLETION_INDEX terminé"
EOF
```{{exec}}

Appliquer :
```bash
microk8s kubectl apply -f indexed-job.yaml
```{{exec}}

Attendre la complétion :
```bash
microk8s kubectl wait --for=condition=complete --timeout=60s job/indexed-worker
```{{exec}}

Voir les logs de chaque index :
```bash
for pod in $(microk8s kubectl get pods --selector=job-name=indexed-worker -o name); do
  echo "=== Logs de $pod ==="
  microk8s kubectl logs $pod
done
```{{exec}}

Vous verrez que chaque Pod traite un index différent (0, 1, 2).

## 🎯 Cas d'Usage Réels

### Batch Processing
```yaml
completions: 100      # Traiter 100 fichiers
parallelism: 10       # 10 workers en parallèle
```

### MapReduce
```yaml
completionMode: Indexed
completions: 10       # 10 partitions de données
parallelism: 5        # 5 workers simultanés
```

## 🧹 Nettoyer

```bash
microk8s kubectl delete job parallel-worker indexed-worker
```{{exec}}

## 🎯 Points Clés

- ✅ `completions: N` → Le Job doit réussir N fois
- ✅ `parallelism: M` → Max M Pods en parallèle
- ✅ `completionMode: Indexed` → Chaque Pod reçoit un index ($JOB_COMPLETION_INDEX)
- ✅ `kubectl wait --for=condition=complete` → Attendre la fin du Job
- ✅ Utile pour batch processing, MapReduce, traitement parallèle

## 💡 Astuce

Pour ajuster le parallélisme **en cours d'exécution** :
```bash
microk8s kubectl patch job parallel-worker -p '{"spec":{"parallelism":5}}'
```

---

Cliquez sur **Continue** pour apprendre les CronJobs.
