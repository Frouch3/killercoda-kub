# Étape 1 : Créer un Job Simple

## 📝 Objectif

Créer un **Job** qui exécute une tâche unique jusqu'à complétion.

## 🎓 Qu'est-ce qu'un Job ?

Un **Job** est une ressource Kubernetes qui :
- Crée un ou plusieurs Pods
- S'assure qu'ils se terminent **avec succès**
- Relance automatiquement en cas d'échec
- Se marque comme **Complete** une fois terminé

Contrairement aux Deployments (processus long), les Jobs sont **run-to-completion** : ils s'arrêtent quand la tâche est finie.

## 📄 Créer un Job qui Calcule Pi

Créons un Job qui calcule les décimales de Pi :

```bash
cat > pi-job.yaml <<EOF
apiVersion: batch/v1
kind: Job
metadata:
  name: pi-calculator
spec:
  # Nombre de complétions réussies nécessaires (par défaut: 1)
  completions: 1

  # Nombre de tentatives max en cas d'échec (par défaut: 6)
  backoffLimit: 4

  template:
    spec:
      # IMPORTANT : Pour un Job, restartPolicy doit être Never ou OnFailure
      restartPolicy: Never
      containers:
      - name: pi
        image: perl:5.34
        command: ["perl", "-Mbignum=bpi", "-wle", "print bpi(2000)"]
EOF
```{{exec}}

Appliquer le Job :
```bash
microk8s kubectl apply -f pi-job.yaml
```{{exec}}

## 🔍 Voir le Status du Job

Voir la liste des Jobs :
```bash
microk8s kubectl get jobs
```{{exec}}

Voir les détails :
```bash
microk8s kubectl describe job pi-calculator
```{{exec}}

Voir les Pods créés par le Job :
```bash
microk8s kubectl get pods --selector=job-name=pi-calculator
```{{exec}}

## 📋 Consulter les Logs du Job

Une fois le Job terminé (status = Complete), consulter les logs :

```bash
# Récupérer le nom du Pod
POD_NAME=$(microk8s kubectl get pods --selector=job-name=pi-calculator -o jsonpath='{.items[0].metadata.name}')

# Voir les logs
microk8s kubectl logs $POD_NAME
```{{exec}}

Vous verrez les 2000 décimales de Pi !

## 🎯 Retry Policy

### backoffLimit
Contrôle le **nombre de tentatives** en cas d'échec :
- `backoffLimit: 4` → Max 4 tentatives
- Défaut : 6
- Entre chaque tentative : délai exponentiel (10s, 20s, 40s, ...)

### restartPolicy
Pour les Jobs, deux valeurs possibles :
- `Never` : Ne jamais redémarrer le conteneur (crée un nouveau Pod)
- `OnFailure` : Redémarre le conteneur dans le même Pod

**Attention** : `Always` n'est **pas autorisé** pour les Jobs !

## 🧪 Tester un Job qui Échoue

Créons un Job qui échoue pour voir le retry :

```bash
cat > failing-job.yaml <<EOF
apiVersion: batch/v1
kind: Job
metadata:
  name: failing-job
spec:
  backoffLimit: 3  # 3 tentatives max
  template:
    spec:
      restartPolicy: Never
      containers:
      - name: fail
        image: busybox:1.36
        command: ["sh", "-c", "echo 'Échec du job'; exit 1"]
EOF
```{{exec}}

Appliquer :
```bash
microk8s kubectl apply -f failing-job.yaml
```{{exec}}

Observer les tentatives :
```bash
microk8s kubectl get jobs
microk8s kubectl get pods --selector=job-name=failing-job
```{{exec}}

Vous verrez **4 Pods** (1 + 3 retries), tous en état **Error**.

## 🧹 Nettoyer les Jobs Terminés

Supprimer les Jobs :
```bash
microk8s kubectl delete job pi-calculator failing-job
```{{exec}}

Note : Supprimer un Job supprime aussi ses Pods.

## 🎯 Points Clés

- ✅ `completions: 1` → Nombre de fois que le Job doit réussir
- ✅ `backoffLimit: 4` → Nombre max de tentatives en cas d'échec
- ✅ `restartPolicy: Never` ou `OnFailure` (jamais `Always`)
- ✅ Logs consultables même après la fin du Job
- ✅ `kubectl delete job <name>` supprime le Job et ses Pods

## ⚠️ Attention

Par défaut, les Pods terminés restent (pour consulter les logs). Pour un cleanup automatique, utilisez `ttlSecondsAfterFinished: 100` (supprime le Job 100s après la fin).

---

Cliquez sur **Continue** quand vous avez créé et testé vos Jobs.
