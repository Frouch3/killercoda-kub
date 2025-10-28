# Étape 4 : Tester la Persistance

## 📝 Objectif

Vérifier que les données **survivent** à la suppression du pod.

## 🗑️ Supprimer le Pod

```bash
microk8s kubectl delete pod writer-pod
```{{exec}}

Le pod est supprimé, mais le PVC reste !

## ✅ Vérifier que le PVC Existe Toujours

```bash
microk8s kubectl get pvc data-pvc
```{{exec}}

État toujours **Bound** → le volume existe toujours.

## 📄 Créer un Nouveau Pod pour Lire les Données

```bash
cat > reader-pod.yaml <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: reader-pod
spec:
  containers:
  - name: reader
    image: busybox
    command: ["/bin/sh"]
    args:
      - -c
      - |
        echo "Reading data from PVC..."
        if [ -f /data/message.txt ]; then
          cat /data/message.txt
          echo ""
          echo "✅ Data persisted successfully!"
        else
          echo "❌ File not found!"
          exit 1
        fi
        sleep infinity
    volumeMounts:
    - name: storage
      mountPath: /data
  volumes:
  - name: storage
    persistentVolumeClaim:
      claimName: data-pvc
EOF
```{{exec}}

## 🚀 Appliquer

```bash
microk8s kubectl apply -f reader-pod.yaml
```{{exec}}

## 📋 Voir les Logs

```bash
microk8s kubectl wait --for=condition=Ready pod/reader-pod --timeout=60s
microk8s kubectl logs reader-pod
```{{exec}}

🎉 **Le fichier est toujours là !** Les données ont survécu à la suppression du premier pod !

## 🔍 Comprendre ce qui s'est Passé

```
1. writer-pod écrit dans /data (qui pointe vers le PVC)
2. writer-pod est supprimé
3. Le PVC reste attaché au PV
4. reader-pod monte le même PVC
5. reader-pod lit les données écrites par writer-pod
```

## 🎯 Point Clé

Le PVC et les données sont **indépendants du cycle de vie des pods** !

---

Cliquez sur **Continue** pour utiliser un PVC avec un Deployment.
