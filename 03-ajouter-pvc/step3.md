# Étape 3 : Utiliser le PVC dans un Pod

## 📄 Créer un Pod avec le PVC

```bash
cat > pod-with-pvc.yaml <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: writer-pod
spec:
  containers:
  - name: writer
    image: busybox
    command: ["/bin/sh"]
    args:
      - -c
      - |
        echo "Writing data..."
        echo "Hello from Kubernetes PVC!" > /data/message.txt
        echo "Timestamp: \$(date)" >> /data/message.txt
        cat /data/message.txt
        echo "Data written! Sleeping forever..."
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

## 🔍 Explication

- **`volumeMounts.mountPath: /data`** : Le PVC est monté dans `/data`
- **`volumes.persistentVolumeClaim`** : Référence le PVC `data-pvc`
- Le conteneur écrit un fichier dans `/data/message.txt`

## 🚀 Appliquer

```bash
microk8s kubectl apply -f pod-with-pvc.yaml
```{{exec}}

## ✅ Attendre que le Pod soit Running

```bash
microk8s kubectl wait --for=condition=Ready pod/writer-pod --timeout=60s
```{{exec}}

## 📋 Voir les Logs

```bash
microk8s kubectl logs writer-pod
```{{exec}}

Vous voyez le contenu du fichier écrit !

## 🔎 Vérifier que le Fichier Existe dans le Volume

```bash
microk8s kubectl exec writer-pod -- cat /data/message.txt
```{{exec}}

Le fichier est bien présent dans le volume persistant.

---

Cliquez sur **Continue** pour tester la persistance !
