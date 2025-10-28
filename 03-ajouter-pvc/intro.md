# Bienvenue dans l'Exercice 3 : Stockage Persistant

## 🎯 Objectifs

- ✅ Comprendre les **PersistentVolumes (PV)** et **PersistentVolumeClaims (PVC)**
- ✅ Créer et utiliser un PVC pour stocker des données
- ✅ Tester la **persistance** des données
- ✅ Utiliser des PVC avec des Deployments
- ✅ Comprendre les **StorageClasses**

## 🎓 Pourquoi le Stockage Persistant ?

Par défaut, les données dans un pod sont **éphémères** :
- Le pod est supprimé → les données sont perdues
- Le conteneur crashe → les données sont perdues

Avec les **PVC**, les données survivent :
- Aux redémarrages de pods
- Aux crashes
- Aux mises à jour (rolling updates)

## 🛠️ Environnement

- Ubuntu 22.04 avec Microk8s
- Addon **storage** pré-activé
- kubectl configuré

## ⏱️ Durée Estimée

30 minutes

Cliquez sur **Start** pour commencer !
