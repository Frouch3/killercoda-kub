# Étape 2 : Créer un PVC

## 📄 Créer le PVC

```bash
cat > my-pvc.yaml <<EOF
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: data-pvc
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
  storageClassName: microk8s-hostpath
EOF
```{{exec}}

## 🔍 Explication

- **`accessModes: ReadWriteOnce`** : Le volume peut être monté en lecture-écriture par **un seul nœud**
- **`storage: 1Gi`** : Demande 1 GB de stockage
- **`storageClassName`** : Utilise la StorageClass par défaut

## Autres Access Modes

- **ReadWriteOnce (RWO)** : 1 nœud en lecture-écriture (le plus courant)
- **ReadOnlyMany (ROX)** : Plusieurs nœuds en lecture seule
- **ReadWriteMany (RWX)** : Plusieurs nœuds en lecture-écriture (nécessite NFS/Ceph)

## 🚀 Appliquer

```bash
microk8s kubectl apply -f my-pvc.yaml
```{{exec}}

## ✅ Vérifier

```bash
microk8s kubectl get pvc data-pvc
```{{exec}}

État **Bound** = le PVC est lié à un PV et prêt à l'emploi !

## 🔎 Voir le PV Créé Automatiquement

```bash
microk8s kubectl get pv
```{{exec}}

Un PV a été créé automatiquement pour satisfaire votre demande.

```bash
microk8s kubectl describe pvc data-pvc
```{{exec}}

La section **Volume** montre le nom du PV lié.

---

Cliquez sur **Continue** pour utiliser ce PVC dans un Pod.
