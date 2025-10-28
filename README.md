# 🎓 Scénarios Killercoda - Formation Microk8s

Ce dossier contient les scénarios interactifs pour la plateforme **Killercoda** (anciennement Katacoda).

## 📂 Structure

```
KILLERCODA/
├── README.md                    # Ce fichier
├── 01-deployer-nginx/          # Exercice 1 : Déployer Nginx
│   ├── index.json              # Configuration du scénario
│   ├── intro.md                # Page d'introduction
│   ├── finish.md               # Page de fin
│   ├── setup.sh                # Installation Microk8s (background)
│   ├── foreground.sh           # Script initial visible
│   ├── step1.md à step7.md     # Les 7 étapes de l'exercice
│   └── verify-step*.sh         # Scripts de vérification
└── [autres exercices à venir]
```

## 🚀 Comment Utiliser Ces Scénarios

### Option 1 : Sur Killercoda.com (Recommandé)

1. **Créer un compte** sur [Killercoda.com](https://killercoda.com)

2. **Créer un nouveau scénario** :
   - Aller sur votre profil → "Create Scenario"
   - Uploader les fichiers du dossier `01-deployer-nginx/`

3. **Tester votre scénario** :
   - Killercoda va automatiquement provisionner un environnement
   - Le scénario sera accessible via une URL comme :
     `https://killercoda.com/votre-username/scenario/01-deployer-nginx`

4. **Partager avec vos apprenants** :
   - Envoyez-leur l'URL
   - Ils peuvent suivre l'exercice sans rien installer !

### Option 2 : En Local avec Docker (Pour Développement)

Vous pouvez tester le scénario localement avant de le publier :

```bash
# Installer l'outil Killercoda CLI (si disponible)
# Ou simplement tester les commandes manuellement dans un conteneur Ubuntu

# Lancer un conteneur Ubuntu
docker run -it --privileged ubuntu:22.04 /bin/bash

# Dans le conteneur, exécuter setup.sh manuellement
# Puis tester chaque commande des steps
```

## 📝 Scénarios Disponibles

### ✅ 01-deployer-nginx (Disponible)
- **Niveau** : Débutant
- **Durée** : 30-45 minutes
- **Objectifs** :
  - Créer un Deployment
  - Créer un Service
  - Scaler l'application
  - Consulter les logs
  - Faire un Rolling Update

### 🚧 À Venir

- **02-exposer-via-ingress** : Configuration d'un Ingress Controller
- **03-ajouter-pvc** : Stockage persistant avec PersistentVolumeClaims
- **04-deployer-symfony** : Application PHP Symfony complète
- **05-configurer-hpa** : Autoscaling avec Horizontal Pod Autoscaler
- **06-signoz-observabilite** : Tracing distribué avec Signoz

## 🛠️ Personnalisation des Scénarios

### Modifier le Temps Estimé

Dans `index.json` :
```json
{
  "time": "45 minutes"  ← Modifiez ici
}
```

### Ajouter/Retirer des Étapes

1. Modifier `index.json` → section `steps[]`
2. Créer le fichier `stepX.md` correspondant
3. Créer le script de vérification `verify-stepX.sh` (optionnel)

### Changer l'Image de Base

Dans `index.json` :
```json
{
  "backend": {
    "imageid": "ubuntu:2204"  ← Peut être: ubuntu:2004, debian, centos, etc.
  }
}
```

### Personnaliser l'Installation

Modifier `setup.sh` :
```bash
# Installer d'autres outils
apt-get update
apt-get install -y curl wget vim

# Installer d'autres versions de Microk8s
snap install microk8s --classic --channel=1.29/stable
```

## 🎨 Syntaxe Spéciale Killercoda

Dans les fichiers `.md`, vous pouvez utiliser :

### Exécution de Commandes Cliquables

```markdown
\`\`\`bash
kubectl get pods
\`\`\`{{exec}}
```
→ Rend la commande cliquable (exécution au clic)

### Copie dans le Presse-Papiers

```markdown
\`\`\`bash
kubectl get pods
\`\`\`{{copy}}
```
→ Ajoute un bouton "Copy" pour copier la commande

### Édition de Fichier

```markdown
\`\`\`yaml:nginx.yaml
apiVersion: v1
kind: Pod
\`\`\`{{create}}
```
→ Crée automatiquement le fichier avec le contenu

### Ouvrir un Fichier dans l'Éditeur

```markdown
Ouvrez le fichier dans l'éditeur : `nginx.yaml`{{open}}
```

### Ports Exposés

Si votre scénario expose des ports (ex: 8080), Killercoda peut créer automatiquement des onglets navigateur.

Dans `index.json` :
```json
{
  "environment": {
    "uilayout": "terminal-iframe",
    "uisettings": "yaml",
    "terminals": [
      {"name": "Terminal", "target": "host01"}
    ],
    "dashboards": [
      {"name": "Nginx", "port": 8080}
    ]
  }
}
```

## ✅ Scripts de Vérification

Les scripts `verify-stepX.sh` sont optionnels mais recommandés :

- ✅ Valident que l'utilisateur a bien effectué l'étape
- 🔴 Affichent des messages d'erreur utiles si ça ne marche pas
- 💡 Donnent des hints pour corriger

**Structure d'un script de vérification** :
```bash
#!/bin/bash

# Vérifier quelque chose
if ! kubectl get pods > /dev/null 2>&1; then
  echo "❌ Erreur: Aucun pod trouvé"
  echo "💡 Exécutez : kubectl apply -f deployment.yaml"
  exit 1
fi

echo "✅ Vérification réussie!"
exit 0
```

**Exit codes** :
- `0` : Succès → L'utilisateur peut continuer
- `1` : Échec → Affiche un message d'erreur

## 📊 Analytics et Suivi

Killercoda fournit des analytics :
- Nombre d'utilisateurs ayant commencé le scénario
- Taux de complétion par étape
- Temps moyen passé sur chaque étape
- Taux d'abandon

Utilisez ces données pour améliorer vos scénarios !

## 🐛 Debugging

### Tester Localement

```bash
cd KILLERCODA/01-deployer-nginx

# Exécuter le setup
bash setup.sh

# Tester les commandes step by step
cat step1.md  # Lire les instructions
# Exécuter les commandes manuellement

# Tester les vérifications
bash verify-step1.sh
```

### Logs dans Killercoda

Quand un scénario est publié, vous pouvez voir les logs :
- Logs du `setup.sh` (installation)
- Logs du `foreground.sh`
- Erreurs d'exécution

## 🤝 Contribuer

Pour ajouter un nouveau scénario :

1. Copier le dossier `01-deployer-nginx/` comme template
2. Modifier `index.json` avec le nouveau titre et les étapes
3. Écrire les fichiers `stepX.md`
4. Créer les scripts de vérification
5. Tester localement
6. Publier sur Killercoda

## 📖 Ressources

- [Documentation Killercoda](https://killercoda.com/creators)
- [Exemples de scénarios](https://github.com/killercoda/scenario-examples)
- [Forum communauté](https://community.killercoda.com/)

## 💰 Coût

**Killercoda est GRATUIT** pour :
- ✅ Créateurs de contenu éducatif
- ✅ Formateurs
- ✅ Professeurs
- ✅ Usage personnel / apprentissage

Pas de limite de scénarios ni d'utilisateurs !

---

**Bon courage pour la création de vos scénarios interactifs !** 🚀

Si vous avez des questions, n'hésitez pas à ouvrir une issue sur le repo GitHub.
