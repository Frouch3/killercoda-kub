# Étape 1 : Comprendre le Stockage Kubernetes

## 🎓 Concepts

### PersistentVolume (PV)
- Ressource de **stockage physique** du cluster
- Provisionné par l'admin ou automatiquement
- Indépendant des pods

### PersistentVolumeClaim (PVC)
- **Demande** de stockage par un utilisateur
- Spécifie la taille et le mode d'accès
- Se lie automatiquement à un PV disponible

### StorageClass
- **Template** pour créer dynamiquement des PVs
- Définit le type de stockage (SSD, HDD, NFS, etc.)
- Permet le provisionnement automatique

## 🏗️ Architecture

```
Pod
 └── Volume Mount
      └── PVC (demande 1GB)
           └── PV (volume physique 1GB)
                └── Stockage réel (disque)
```

## 📊 Voir les StorageClasses Disponibles

```bash
microk8s kubectl get storageclass
```{{exec}}

Vous verrez `microk8s-hostpath` qui est la StorageClass par défaut de Microk8s.

## 🔍 Détails de la StorageClass

```bash
microk8s kubectl describe storageclass microk8s-hostpath
```{{exec}}

Cette StorageClass :
- Utilise le **hostPath** (stockage local du nœud)
- Provisionne **automatiquement** des PV à la demande
- Est marquée comme **default**

## 🎯 Point Clé

Avec une StorageClass par défaut, vous n'avez qu'à créer un **PVC** !
Le PV sera créé automatiquement.

---

Cliquez sur **Continue** pour créer votre premier PVC.
