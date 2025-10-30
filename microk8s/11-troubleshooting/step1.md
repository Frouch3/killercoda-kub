# Étape 1 : Diagnostiquer un CrashLoopBackOff

## 📝 Objectif

Diagnostiquer et corriger un pod qui redémarre en boucle à cause d'une mauvaise commande.

## 🎓 Qu'est-ce qu'un CrashLoopBackOff ?

**CrashLoopBackOff** signifie que :
- Le conteneur démarre
- Il crashe immédiatement
- Kubernetes le redémarre automatiquement
- Le cycle se répète avec un backoff exponentiel (délai croissant)

**Causes courantes** :
- Commande ou arguments incorrects
- Application qui crashe au démarrage
- Configuration manquante
- Erreur de code

## 📄 Créer un Pod qui Crashe

Créons un pod avec une commande invalide :

```bash
cat > crashloop-pod.yaml <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: crashloop-app
spec:
  containers:
  - name: app
    image: busybox
    command: ["sh", "-c", "echo 'Starting...' && invalid-command"]
  restartPolicy: Always
EOF
```{{exec}}

Déployer le pod :
```bash
microk8s kubectl apply -f crashloop-pod.yaml
```{{exec}}

## 🔍 Observer le CrashLoopBackOff

Attendre quelques secondes puis observer l'état :
```bash
microk8s kubectl get pods -w
```{{exec}}

Vous verrez le status passer par : `ContainerCreating` → `Error` → `CrashLoopBackOff`

Appuyez sur `Ctrl+C` pour arrêter le watch.

## 🕵️ Diagnostiquer le Problème

### 1. Voir l'état du pod
```bash
microk8s kubectl get pod crashloop-app
```{{exec}}

### 2. Consulter les logs
```bash
microk8s kubectl logs crashloop-app
```{{exec}}

Si le conteneur a déjà crashé plusieurs fois, voir les logs précédents :
```bash
microk8s kubectl logs crashloop-app --previous
```{{exec}}

### 3. Describe pour voir les events
```bash
microk8s kubectl describe pod crashloop-app
```{{exec}}

Cherchez la section **Events** en bas. Vous verrez :
- `Back-off restarting failed container`
- Le nombre de restarts augmente

### 4. Voir les events filtrés
```bash
microk8s kubectl get events --field-selector involvedObject.name=crashloop-app
```{{exec}}

## 🔧 Corriger le Problème

La commande `invalid-command` n'existe pas. Corrigeons :

```bash
cat > crashloop-pod.yaml <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: crashloop-app
spec:
  containers:
  - name: app
    image: busybox
    command: ["sh", "-c", "echo 'Starting...' && sleep 3600"]
  restartPolicy: Always
EOF
```{{exec}}

Supprimer l'ancien pod et recréer :
```bash
microk8s kubectl delete pod crashloop-app
microk8s kubectl apply -f crashloop-pod.yaml
```{{exec}}

Vérifier que le pod est maintenant Running :
```bash
microk8s kubectl get pod crashloop-app
```{{exec}}

## 🎯 Points Clés

- ✅ `kubectl logs` : Première commande pour voir POURQUOI ça crashe
- ✅ `kubectl logs --previous` : Logs du conteneur qui vient de crasher
- ✅ `kubectl describe` : Voir les events et le nombre de restarts
- ✅ `kubectl get events` : Historique complet des problèmes
- ✅ Toujours vérifier la section **Events** dans describe

## 🧪 Bonus : Tester un Crash Applicatif

Créer un pod qui crashe après 5 secondes :
```bash
cat > delayed-crash.yaml <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: delayed-crash
spec:
  containers:
  - name: app
    image: busybox
    command: ["sh", "-c", "echo 'Running for 5s...' && sleep 5 && exit 1"]
  restartPolicy: Always
EOF
```{{exec}}

```bash
microk8s kubectl apply -f delayed-crash.yaml
microk8s kubectl get pods -w
```{{exec}}

Observer le cycle : `Running` → `Error` → `CrashLoopBackOff`

Appuyez sur `Ctrl+C` puis nettoyez :
```bash
microk8s kubectl delete pod delayed-crash
```{{exec}}

---

Cliquez sur **Continue** quand vous avez corrigé le CrashLoopBackOff.
