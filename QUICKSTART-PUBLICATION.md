# 🚀 Guide Rapide : Publier sur Killercoda

Ce guide vous montre comment publier votre scénario sur Killercoda en **5 minutes**.

## 📋 Prérequis

- Un compte GitHub (gratuit)
- Accès à Killercoda.com

## 🎯 Méthode 1 : Via l'Interface Killercoda (La Plus Simple)

### Étape 1 : Créer un Compte

1. Aller sur [killercoda.com](https://killercoda.com)
2. Cliquer sur **"Sign in with GitHub"**
3. Autoriser l'accès à votre compte GitHub

### Étape 2 : Créer un Nouveau Scénario

1. Cliquer sur votre avatar → **"Creator Area"**
2. Cliquer sur **"+ New Scenario"**
3. Remplir le formulaire :
   - **Title** : "Exercice 1 : Déployer Nginx sur Kubernetes"
   - **Description** : "Apprenez à créer un Deployment, un Service, et gérer votre première application"
   - **Time** : "45 minutes"
   - **Difficulty** : "Beginner"

### Étape 3 : Uploader les Fichiers

1. Dans la page du scénario, aller à l'onglet **"Files"**
2. Uploader tous les fichiers du dossier `KILLERCODA/01-deployer-nginx/` :
   - `index.json`
   - `intro.md`
   - `finish.md`
   - `setup.sh`
   - `foreground.sh`
   - `step1.md` à `step7.md`
   - `verify-step1.sh` à `verify-step7.sh`

### Étape 4 : Tester

1. Cliquer sur **"Preview"**
2. Attendre que l'environnement démarre (30-60 secondes)
3. Tester les étapes une par une
4. Vérifier que les scripts de vérification fonctionnent

### Étape 5 : Publier

1. Si tout fonctionne, cliquer sur **"Publish"**
2. Votre scénario est maintenant accessible via :
   ```
   https://killercoda.com/votre-username/scenario/deployer-nginx
   ```

---

## 🎯 Méthode 2 : Via GitHub (Pour CI/CD)

Cette méthode permet de gérer vos scénarios via Git et de les publier automatiquement.

### Étape 1 : Créer un Repo GitHub

```bash
# Créer un nouveau repo (ou utiliser celui-ci)
cd /home/fcrespin/Code/formation-microk8s/KILLERCODA
git init
git add .
git commit -m "Initial commit: Exercice 1 Killercoda"
```

### Étape 2 : Connecter Killercoda à GitHub

1. Sur Killercoda, aller dans **"Creator Area"**
2. Cliquer sur **"Settings"** → **"GitHub Integration"**
3. Autoriser Killercoda à accéder à votre repo
4. Sélectionner le repo : `formation-microk8s`
5. Définir le dossier : `KILLERCODA/`

### Étape 3 : Push et Auto-Deploy

```bash
# Pousser vers GitHub
git push origin main
```

Killercoda va automatiquement :
- Détecter les changements
- Mettre à jour les scénarios
- Re-publier

### Structure du Repo pour GitHub Integration

```
votre-repo/
├── 01-deployer-nginx/
│   ├── index.json
│   ├── intro.md
│   ├── step1.md
│   └── ...
├── 02-exposer-via-ingress/
│   ├── index.json
│   └── ...
└── README.md
```

Killercoda va créer automatiquement un scénario pour chaque dossier contenant un `index.json`.

---

## 🎨 Personnalisation Avancée

### Ajouter un Logo

1. Créer une image `logo.png` (recommandé : 400x400px)
2. L'uploader dans le dossier du scénario
3. Dans `index.json`, ajouter :
```json
{
  "icon": "fa-cube",
  "details": {
    "assets": {
      "host01": [
        {"file": "logo.png", "target": "/root/"}
      ]
    }
  }
}
```

### Pré-charger des Fichiers

Pour que l'utilisateur trouve des fichiers déjà présents :

1. Créer un dossier `assets/` dans votre scénario
2. Y placer vos fichiers (ex: `nginx-deployment.yaml`)
3. Dans `index.json` :
```json
{
  "details": {
    "assets": {
      "host01": [
        {"file": "nginx-deployment.yaml", "target": "/root/"}
      ]
    }
  }
}
```

### Multi-Node Cluster

Pour simuler un cluster multi-nœuds :

Dans `index.json` :
```json
{
  "backend": {
    "imageid": "kubernetes:1.28"
  },
  "environment": {
    "nodes": {
      "master": {
        "name": "master",
        "type": "master"
      },
      "node01": {
        "name": "node01",
        "type": "worker"
      },
      "node02": {
        "name": "node02",
        "type": "worker"
      }
    }
  }
}
```

---

## 🐛 Troubleshooting

### Le setup.sh prend trop de temps

**Problème** : L'installation de Microk8s prend 2-3 minutes.

**Solution** : Utiliser une image pré-configurée ou optimiser le script :

```bash
# setup.sh optimisé
#!/bin/bash
snap install microk8s --classic --channel=1.28/stable
microk8s status --wait-ready --timeout=300
microk8s enable dns storage --wait-ready
```

### Les vérifications échouent

**Problème** : Les scripts `verify-stepX.sh` retournent toujours une erreur.

**Solution** : Ajouter des délais et des retries :

```bash
#!/bin/bash
# verify-step1.sh avec retry

MAX_ATTEMPTS=5
ATTEMPT=0

while [ $ATTEMPT -lt $MAX_ATTEMPTS ]; do
  if kubectl get deployment nginx-deployment > /dev/null 2>&1; then
    echo "✅ Deployment trouvé!"
    exit 0
  fi

  ATTEMPT=$((ATTEMPT + 1))
  echo "⏳ Tentative $ATTEMPT/$MAX_ATTEMPTS..."
  sleep 2
done

echo "❌ Deployment non trouvé après $MAX_ATTEMPTS tentatives"
exit 1
```

### L'environnement est trop lent

**Problème** : Les commandes mettent du temps à s'exécuter.

**Causes possibles** :
- Trop d'utilisateurs simultanés (rare sur Killercoda)
- Image de base trop lourde
- Setup.sh fait trop d'opérations

**Solutions** :
1. Utiliser une image plus légère (Alpine au lieu d'Ubuntu)
2. Pré-builder une image custom avec Microk8s pré-installé
3. Désactiver certains addons non nécessaires

---

## 📊 Bonnes Pratiques

### ✅ À Faire

- **Tester** le scénario plusieurs fois avant de publier
- **Écrire des messages d'erreur clairs** dans les scripts de vérification
- **Donner des hints** si l'utilisateur est bloqué
- **Utiliser des commandes cliquables** (`{{exec}}`)
- **Ajouter des emojis** pour rendre le contenu plus engageant
- **Expliquer le "pourquoi"**, pas seulement le "comment"
- **Prévoir 20-30% de temps en plus** que votre estimation

### ❌ À Éviter

- Scripts de setup trop longs (> 2 minutes)
- Trop d'étapes (max 10 recommandé)
- Commandes sans explication
- Copies d'écran (privilégier du texte avec code)
- Supposer que l'utilisateur connaît déjà Kubernetes

---

## 📈 Promouvoir Votre Scénario

Une fois publié, partagez-le :

1. **Twitter** :
   ```
   🎓 Nouveau tutoriel interactif Kubernetes!
   Apprenez à déployer Nginx en 45 minutes
   👉 https://killercoda.com/votre-username/scenario/deployer-nginx
   #Kubernetes #DevOps #Microk8s
   ```

2. **LinkedIn** :
   ```
   Je viens de publier un tutoriel interactif pour apprendre Kubernetes.
   Aucune installation requise, directement dans le navigateur!
   [lien]
   ```

3. **Reddit** :
   - r/kubernetes
   - r/devops
   - r/learnprogramming

4. **Dev.to** / **Medium** :
   Écrire un article de blog expliquant le scénario

---

## 🎯 Checklist Avant Publication

- [ ] Toutes les commandes ont été testées
- [ ] Les scripts de vérification fonctionnent
- [ ] Le setup.sh prend moins de 2 minutes
- [ ] Les messages d'erreur sont clairs et utiles
- [ ] Chaque étape a un objectif pédagogique clair
- [ ] Le temps estimé est réaliste
- [ ] La page d'intro explique bien les objectifs
- [ ] La page de fin félicite et guide vers la suite
- [ ] Les fautes d'orthographe ont été corrigées
- [ ] Le scénario a été testé par une autre personne

---

## 🆘 Support

- **Documentation** : https://killercoda.com/creators/documentation
- **Discord** : https://discord.gg/killercoda
- **Forum** : https://community.killercoda.com
- **Email** : support@killercoda.com

---

**Bonne publication !** 🚀

Si vous publiez ce scénario, n'oubliez pas de partager le lien dans le README principal de la formation !
