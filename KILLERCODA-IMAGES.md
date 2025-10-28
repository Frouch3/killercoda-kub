# 🐳 Images Killercoda Disponibles

## ❌ Problème Résolu : `imageId unknown`

**Symptôme** : Sur Killercoda, vos scénarios affichent "imageId unknown"

**Cause** : Utilisation d'un imageId invalide (ex: `ubuntu:2204` au lieu de `ubuntu`)

**Solution** : ✅ Corrigé ! Tous les fichiers `index.json` utilisent maintenant `"imageid": "ubuntu"`

---

## 📋 Images Valides sur Killercoda

Killercoda supporte un nombre limité d'images préconfigurées. Voici les principales :

### 🐧 Linux de Base

| ImageId | Description | Use Case |
|---------|-------------|----------|
| `ubuntu` | Ubuntu 22.04 LTS | **Recommandé** - Usage général |
| `ubuntu2004` | Ubuntu 20.04 LTS | Legacy |
| `alpine` | Alpine Linux | Environnement léger |

### ☸️ Kubernetes Pré-configuré

| ImageId | Description | Nodes | Use Case |
|---------|-------------|-------|----------|
| `kubernetes-kubeadm-1node` | Kubernetes avec kubeadm | 1 | Cluster simple |
| `kubernetes-kubeadm-2nodes` | Kubernetes avec kubeadm | 2 | Multi-nodes |
| `kubernetes-kubeadm-3nodes` | Kubernetes avec kubeadm | 3 | Production-like |

> ⚠️ **Note** : Pour Microk8s, utilisez `ubuntu` et installez Microk8s dans le script `setup.sh`

### 🐳 Docker Pré-installé

| ImageId | Description | Use Case |
|---------|-------------|----------|
| `ubuntu` | Docker déjà installé | Containers, builds |

---

## 🔧 Configuration dans index.json

### ✅ Configuration Correcte (Nos scénarios)

```json
{
  "title": "Exercice 1 : Déployer Nginx",
  "backend": {
    "imageid": "ubuntu"
  }
}
```

### ❌ Configuration Incorrecte (Erreur)

```json
{
  "backend": {
    "imageid": "ubuntu:2204"  ← Invalide !
  }
}
```

```json
{
  "backend": {
    "imageid": "ubuntu-22.04"  ← Invalide !
  }
}
```

---

## 🎯 Quelle Image Choisir ?

### Pour Microk8s (Notre Cas) ✅

```json
"backend": {
  "imageid": "ubuntu"
}
```

**Pourquoi ?**
- Ubuntu 22.04 LTS avec snap pré-installé
- Compatible avec Microk8s via snap
- Docker déjà installé
- Lightweight et rapide

### Pour Kubernetes Natif

```json
"backend": {
  "imageid": "kubernetes-kubeadm-1node"
}
```

**Avantages** :
- Kubernetes déjà installé et configuré
- Pas besoin d'installation dans `setup.sh`
- Prêt en quelques secondes

**Inconvénients** :
- Ce n'est pas Microk8s (kubeadm à la place)
- Moins représentatif de notre formation

### Pour Docker Pur

```json
"backend": {
  "imageid": "ubuntu"
}
```

Docker est déjà installé sur l'image Ubuntu de base.

---

## 🛠️ Personnalisation de l'Environnement

### Installer des Outils dans setup.sh

```bash
#!/bin/bash

# L'image de base est Ubuntu
# Ajoutez vos installations ici

# Installer Microk8s
snap install microk8s --classic

# Installer d'autres outils
apt-get update
apt-get install -y curl wget vim

# Activer des addons
microk8s enable dns storage

# Configuration kubectl
echo "alias kubectl='microk8s kubectl'" >> /root/.bashrc
```

---

## 🔍 Vérifier l'Image Utilisée

### Dans l'Interface Killercoda

1. Aller dans votre scénario
2. Section "Settings" → "Environment"
3. Vérifier le champ "Image"

### Via le Code

```bash
# Vérifier tous les index.json
grep -r "imageid" */index.json

# Devrait afficher : "imageid": "ubuntu"
```

---

## 📚 Ressources et Versions

### Ubuntu Image Details

```
OS: Ubuntu 22.04 LTS (Jammy Jellyfish)
Kernel: Linux 5.15+
Pre-installed:
  - Docker 24.0+
  - snap
  - git
  - curl, wget
  - Python 3.10
  - Node.js 18 (via nvm)
```

### Kubernetes Images Details

```
Kubernetes: v1.28+ (kubeadm)
Container Runtime: containerd
CNI: Calico ou Flannel
Pre-configured kubectl
```

---

## 🚨 Erreurs Courantes

### Erreur 1 : "imageId unknown"

**Symptôme** :
```
Error: imageId "ubuntu:2204" is not supported
```

**Solution** :
```json
// Avant (incorrect)
"imageid": "ubuntu:2204"

// Après (correct)
"imageid": "ubuntu"
```

### Erreur 2 : "Image not found"

**Cause** : Typo dans le nom de l'image

**Vérifier** :
```bash
# Doit être exactement l'un de ces noms :
- ubuntu
- ubuntu2004
- alpine
- kubernetes-kubeadm-1node
- kubernetes-kubeadm-2nodes
```

### Erreur 3 : Setup trop long

**Cause** : Installation de Microk8s dans `setup.sh` prend du temps

**Solution** : Optimiser le script
```bash
# Utiliser --channel pour version stable
snap install microk8s --classic --channel=1.28/stable

# Éviter les apt update inutiles
# Activer seulement les addons nécessaires
```

---

## 🔄 Migration entre Images

### De Kubeadm vers Microk8s

Si vous aviez commencé avec `kubernetes-kubeadm-1node` :

```json
// Avant
{
  "backend": {
    "imageid": "kubernetes-kubeadm-1node"
  }
}

// Après (pour Microk8s)
{
  "backend": {
    "imageid": "ubuntu"
  }
}
```

Puis ajouter dans `setup.sh` :
```bash
snap install microk8s --classic
```

---

## 💡 Conseils

1. **Toujours utiliser `ubuntu`** pour Microk8s
2. **Tester localement** avant de publier
3. **Optimiser `setup.sh`** pour un démarrage rapide
4. **Documenter les dépendances** dans le README
5. **Vérifier les logs** si problèmes au démarrage

---

## 🔗 Liens Utiles

- **Killercoda Docs** : https://killercoda.com/creators/documentation
- **Images disponibles** : https://killercoda.com/creators/environments
- **Community Forum** : https://community.killercoda.com/

---

## ✅ Checklist de Vérification

Avant de publier sur Killercoda :

- [ ] L'`imageid` est valide (`ubuntu`, pas `ubuntu:2204`)
- [ ] Le fichier `setup.sh` installe Microk8s correctement
- [ ] Le `foreground.sh` attend la fin du setup
- [ ] Tous les scripts ont les permissions d'exécution (`chmod +x`)
- [ ] Test du scénario en preview sur Killercoda
- [ ] Vérification que l'environnement démarre en < 2 minutes

---

**📅 Dernière mise à jour** : Octobre 2024
**✅ Statut** : Tous les scénarios corrigés avec `"imageid": "ubuntu"`
