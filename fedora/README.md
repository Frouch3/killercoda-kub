# Formation Linux - De débutant à intermédiaire

Cette formation complète vous guide progressivement dans l'apprentissage de Linux, du niveau débutant au niveau intermédiaire.

## 📚 Parcours de formation (8 scénarios)

Les scénarios doivent être suivis **dans l'ordre** pour une progression optimale :

### Niveau Débutant

#### 1️⃣ Premiers pas avec Fedora (20-30 min)
**Prérequis** : Aucun
**Compétences acquises** :
- Navigation dans le système de fichiers
- Commandes de base (pwd, ls, cd)
- Création et suppression de dossiers
- Compréhension de l'arborescence Linux

#### 2️⃣ Manipulation de fichiers (25-35 min)
**Prérequis** : Scénario 1
**Compétences acquises** :
- Créer des fichiers (touch, echo)
- Afficher le contenu (cat, less, head, tail)
- Copier et déplacer (cp, mv)
- Supprimer en sécurité (rm)

#### 3️⃣ Éditeurs de texte (30-40 min)
**Prérequis** : Scénarios 1-2
**Compétences acquises** :
- Maîtriser nano
- Découvrir vim (bases)
- Éditer des fichiers de configuration
- Choisir le bon éditeur

### Niveau Débutant avancé

#### 4️⃣ Gestion des paquets (30-40 min)
**Prérequis** : Scénarios 1-3
**Compétences acquises** :
- Comprendre apt (Ubuntu) vs dnf (Fedora)
- Rechercher et installer des logiciels
- Mettre à jour le système
- Désinstaller et nettoyer

#### 5️⃣ Utilisateurs et permissions (35-45 min)
**Prérequis** : Scénarios 1-4
**Compétences acquises** :
- Créer et gérer des utilisateurs
- Comprendre les permissions (rwx)
- Modifier permissions et propriétaires
- Utiliser sudo correctement

### Niveau Intermédiaire

#### 6️⃣ Processus et services (35-45 min)
**Prérequis** : Scénarios 1-5
**Compétences acquises** :
- Surveiller les processus (ps, top, htop)
- Gérer les processus (kill, signaux)
- Contrôler les services (systemctl)
- Consulter les logs (journalctl)

#### 7️⃣ Réseau de base (35-45 min)
**Prérequis** : Scénarios 1-6
**Compétences acquises** :
- Diagnostiquer la connectivité réseau
- Configuration réseau basique
- Gérer le pare-feu
- Analyser les connexions

#### 8️⃣ Scripts et automatisation (40-50 min)
**Prérequis** : Tous les scénarios précédents
**Compétences acquises** :
- Écrire des scripts bash
- Variables, conditions, boucles
- Créer des fonctions
- Automatiser avec cron

---

## 🚀 Comment publier sur Killercoda avec ordre forcé

### Option 1 : Via l'interface Killercoda (Recommandé)

1. **Créer un compte** sur [killercoda.com](https://killercoda.com)
2. **Connecter votre dépôt GitHub** contenant les scénarios
3. **Créer un "Course"** (Parcours) :
   - Aller dans "Creator Area"
   - Cliquer sur "Create Course"
   - Donner un titre : "Formation Linux complète"
   - Ajouter une description

4. **Ajouter les scénarios dans l'ordre** :
   - Cliquer sur "Add Scenario"
   - Sélectionner "01-premiers-pas"
   - Configurer : "Require completion before next" ✅
   - Répéter pour chaque scénario dans l'ordre

5. **Publier le parcours** :
   - Chaque scénario sera verrouillé jusqu'à ce que le précédent soit complété
   - Les utilisateurs suivront obligatoirement l'ordre défini

### Option 2 : Via fichier de configuration

Le fichier `structure.json` définit la structure du cours :

```json
{
  "title": "Formation Linux - De débutant à intermédiaire",
  "details": {
    "steps": [
      {"title": "1. Premiers pas", "text": "01-premiers-pas"},
      {"title": "2. Manipulation fichiers", "text": "02-manipulation-fichiers"},
      ...
    ]
  }
}
```

⚠️ **Note** : Cette méthode nécessite une configuration avancée sur Killercoda.

### Option 3 : Numéroration dans les titres

Dans chaque `index.json`, préfixer le titre avec le numéro :

```json
{
  "title": "1. Premiers pas avec Fedora",
  "description": "⚠️ Commencez par ce scénario avant les autres"
}
```

Killercoda affichera les scénarios par ordre alphabétique.

---

## 📊 Progression recommandée

```
Débutant (Scénarios 1-3)
   ↓
   • Compréhension du système
   • Manipulation de fichiers
   • Édition de base
   ↓
Débutant avancé (Scénarios 4-5)
   ↓
   • Administration système
   • Gestion de logiciels
   • Sécurité de base
   ↓
Intermédiaire (Scénarios 6-8)
   ↓
   • Processus et services
   • Configuration réseau
   • Automatisation
   ↓
Prêt pour des formations avancées !
```

---

## 🎯 Objectifs d'apprentissage globaux

À la fin de ce parcours, vous serez capable de :

✅ Naviguer efficacement dans un système Linux
✅ Gérer fichiers et dossiers avec confiance
✅ Éditer des fichiers de configuration
✅ Installer et maintenir des logiciels
✅ Gérer utilisateurs et permissions
✅ Contrôler les processus et services
✅ Configurer et diagnostiquer le réseau
✅ Automatiser des tâches répétitives

---

## 💡 Conseils pédagogiques

### Pour les formateurs

- **Imposez l'ordre** : Les scénarios sont conçus pour être suivis séquentiellement
- **Vérifiez la compréhension** : Chaque scénario a des exercices pratiques
- **Encouragez la pratique** : Linux s'apprend en faisant
- **Durée totale** : Comptez 4-6 heures pour tout le parcours
- **Pause recommandée** : Après le scénario 4

### Pour les apprenants

- **Ne sautez pas d'étapes** : Chaque scénario construit sur le précédent
- **Pratiquez les exercices** : Ne vous contentez pas de lire
- **Prenez des notes** : Créez votre propre aide-mémoire
- **Répétez** : N'hésitez pas à refaire un scénario
- **Allez plus loin** : Essayez des variantes des commandes apprises

---

## 📖 Documentation complémentaire

- [Linux Command Line Basics](https://www.linux.org/)
- [Ubuntu Documentation](https://help.ubuntu.com/)
- [Fedora Documentation](https://docs.fedoraproject.org/)
- [Bash Scripting Guide](https://www.gnu.org/software/bash/manual/)

---

## 🔧 Support et contributions

Si vous trouvez des erreurs ou avez des suggestions d'amélioration :

1. Ouvrir une issue sur GitHub
2. Proposer une pull request
3. Contacter le formateur

---

## 📜 Licence

Cette formation est mise à disposition sous licence [choisir une licence : MIT, CC-BY, etc.].

---

**Bonne formation !** 🐧
