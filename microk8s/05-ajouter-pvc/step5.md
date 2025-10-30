# Étape 5 : PVC avec Deployment

## 📝 Objectif

Utiliser un PVC avec un Deployment (cas réel en production).

## ⚠️ Limite Importante

Un PVC avec **ReadWriteOnce** ne peut être monté que par **un seul pod à la fois**.

Avec un Deployment qui a plusieurs replicas, tous les pods essaieraient de monter le même volume → **Erreur** !

## 💡 Solutions

1. **Option 1** : Deployment avec **1 replica** (OK pour RWO)
2. **Option 2** : **StatefulSet** avec 1 PVC par pod (recommandé pour bases de données)
3. **Option 3** : PVC avec **ReadWriteMany** (nécessite NFS/Ceph)

## 📄 Deployment avec 1 Replica

```bash
cat > app-with-storage.yaml <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app-with-storage
spec:
  replicas: 1
  selector:
    matchLabels:
      app: myapp
  template:
    metadata:
      labels:
        app: myapp
    spec:
      containers:
      - name: app
        image: nginx:alpine
        volumeMounts:
        - name: data
          mountPath: /usr/share/nginx/html
      volumes:
      - name: data
        persistentVolumeClaim:
          claimName: data-pvc
EOF
```{{exec}}

## 🚀 Appliquer

```bash
# D'abord supprimer le reader-pod pour libérer le PVC
microk8s kubectl delete pod reader-pod

# Puis déployer
microk8s kubectl apply -f app-with-storage.yaml
```{{exec}}

## ✅ Vérifier

```bash
microk8s kubectl get pods -l app=myapp
```{{exec}}

## 📝 Écrire un Fichier HTML

```bash
POD=$(microk8s kubectl get pods -l app=myapp -o jsonpath='{.items[0].metadata.name}')

microk8s kubectl exec $POD -- sh -c 'echo "<h1>Hello from PVC!</h1><p>This content is stored in a PersistentVolume.</p>" > /usr/share/nginx/html/index.html'
```{{exec}}

## 🧪 Tester

```bash
microk8s kubectl exec $POD -- cat /usr/share/nginx/html/index.html
```{{exec}}

## 🔄 Simuler un Crash (Redémarrage du Pod)

```bash
microk8s kubectl delete pod $POD
```{{exec}}

Attendez quelques secondes que le Deployment recrée le pod :

```bash
microk8s kubectl wait --for=condition=Ready pod -l app=myapp --timeout=60s
```{{exec}}

## ✅ Vérifier que les Données Sont Toujours Là

```bash
NEW_POD=$(microk8s kubectl get pods -l app=myapp -o jsonpath='{.items[0].metadata.name}')
echo "Nouveau pod: $NEW_POD"

microk8s kubectl exec $NEW_POD -- cat /usr/share/nginx/html/index.html
```{{exec}}

🎉 **Les données ont survécu au redémarrage !**

## 🎯 Points Clés

- ✅ Le PVC peut être utilisé dans un Deployment
- ✅ Avec RWO, **1 replica maximum**
- ✅ Les données survivent aux redémarrages
- ✅ Pour plusieurs replicas, utiliser **StatefulSet** ou **RWX**

## 💡 StatefulSet (Bonus)

Pour des applications comme bases de données :

```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: database
spec:
  replicas: 3
  volumeClaimTemplates:  # 1 PVC par replica !
  - metadata:
      name: data
    spec:
      accessModes: ["ReadWriteOnce"]
      resources:
        requests:
          storage: 1Gi
```

Chaque replica obtient son propre PVC unique.

---

Félicitations ! Cliquez sur **Continue** pour le résumé.
