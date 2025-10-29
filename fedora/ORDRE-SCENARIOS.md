# 🔢 Ordre des scénarios - Configuration Killercoda

Ce document explique comment forcer l'ordre des scénarios sur Killercoda.

## ✅ Ce qui a été fait

Les scénarios ont été préparés pour être affichés dans le bon ordre :

1. **Numérotation des titres** : Chaque `index.json` a un titre commençant par "1.", "2.", etc.
2. **Nommage des dossiers** : Les dossiers sont préfixés `01-`, `02-`, etc.
3. **structure.json** : Fichier de configuration du parcours créé
4. **README.md** : Documentation complète du parcours

## 📋 Ordre obligatoire des scénarios

```
1️⃣ Premiers pas avec Fedora Linux (20-30 min)
   └─> Prérequis : Aucun

2️⃣ Manipulation de fichiers sous Fedora (25-35 min)
   └─> Prérequis : Scénario 1

3️⃣ Éditeurs de texte sous Linux (30-40 min)
   └─> Prérequis : Scénarios 1-2

4️⃣ Gestion des paquets sous Linux (30-40 min)
   └─> Prérequis : Scénarios 1-3

5️⃣ Utilisateurs et permissions (35-45 min)
   └─> Prérequis : Scénarios 1-4

6️⃣ Processus et services (35-45 min)
   └─> Prérequis : Scénarios 1-5

7️⃣ Réseau de base (35-45 min)
   └─> Prérequis : Scénarios 1-6

8️⃣ Scripts et automatisation (40-50 min)
   └─> Prérequis : Tous les scénarios précédents
```

**Durée totale** : 4h30 - 6h30

---

## 🚀 Méthode 1 : Créer un "Course" sur Killercoda (Recommandé)

Cette méthode force vraiment l'ordre et verrouille les scénarios suivants.

### Étapes détaillées

1. **Se connecter à Killercoda**
   - Aller sur https://killercoda.com
   - Sign in with GitHub

2. **Aller dans Creator Area**
   - Cliquer sur votre avatar (en haut à droite)
   - Sélectionner "Creator Area"

3. **Créer un nouveau Course**
   - Cliquer sur "Courses"
   - Cliquer sur "+ Create Course"
   - Remplir :
     ```
     Title: Formation Linux - De débutant à intermédiaire
     Description: Apprenez Linux de zéro avec 8 scénarios progressifs
     ```

4. **Ajouter les scénarios dans l'ordre**

   Pour chaque scénario, cliquer sur "+ Add Scenario" :

   ```
   Scenario 1:
   - Select: "01-premiers-pas"
   - ✅ Require completion before next scenario

   Scenario 2:
   - Select: "02-manipulation-fichiers"
   - ✅ Require completion before next scenario

   Scenario 3:
   - Select: "03-editeurs-texte"
   - ✅ Require completion before next scenario

   ... et ainsi de suite pour les 8 scénarios
   ```

5. **Configurer les options du Course**
   - ✅ Sequential access (accès séquentiel)
   - ✅ Show progress bar
   - ✅ Award certificate on completion (optionnel)

6. **Publier le Course**
   - Cliquer sur "Publish"
   - Le parcours sera accessible à : `https://killercoda.com/votre-username/course/formation-linux`

### Résultat

- ✅ Les scénarios sont verrouillés dans l'ordre
- ✅ Un apprenant ne peut pas sauter d'étapes
- ✅ Une barre de progression s'affiche
- ✅ Un certificat peut être généré à la fin

---

## 🔧 Méthode 2 : Via GitHub Integration + Numérotation

Si vous utilisez l'intégration GitHub avec Killercoda :

1. **Structure du repo**
   ```
   votre-repo/
   └── fedora/
       ├── README.md
       ├── 01-premiers-pas/        ← index.json avec title "1. ..."
       ├── 02-manipulation-fichiers/
       ├── ... (8 scénarios)
       └── 08-scripts-automatisation/
   ```

2. **Les titres numérotés** (déjà fait ✅)

   Chaque `index.json` a un titre numéroté :
   ```json
   {
     "title": "1. Premiers pas avec Fedora Linux",
     ...
   }
   ```

3. **Configuration GitHub**
   - Dans Killercoda → Settings → GitHub Integration
   - Sélectionner le repo
   - Path: `fedora/`
   - Killercoda détectera automatiquement les scénarios et les affichera dans l'ordre numérique

⚠️ **Note** : Ne PAS créer de fichier `structure.json` car cela empêche l'affichage des scénarios individuels

---

## 📱 Méthode 3 : Simple ordre alphabétique

Si vous ne voulez pas créer de Course mais juste afficher dans l'ordre :

**✅ Déjà fait !**

Les titres commencent par "1.", "2.", etc.
Killercoda les affichera dans l'ordre numérique.

**Limitations** :
- ❌ Pas de verrouillage : les utilisateurs peuvent sauter des scénarios
- ❌ Pas de barre de progression
- ❌ Pas de certificat

**Avantage** :
- ✅ Aucune configuration supplémentaire nécessaire

---

## 🎯 Recommandation

**Pour une formation officielle** : Utilisez la **Méthode 1** (Course)
- Contrôle total de la progression
- Meilleure expérience utilisateur
- Tracking des complétion

**Pour du contenu libre** : La **Méthode 3** suffit
- Les titres numérotés guident naturellement
- Plus de flexibilité pour les utilisateurs avancés

---

## 📊 Visualisation de la progression

Avec un Course Killercoda, les utilisateurs verront :

```
Formation Linux - De débutant à intermédiaire
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 37% (3/8)

✅ 1. Premiers pas avec Fedora Linux
✅ 2. Manipulation de fichiers sous Fedora
✅ 3. Éditeurs de texte sous Linux
🔒 4. Gestion des paquets sous Linux (Verrouillé)
🔒 5. Utilisateurs et permissions (Verrouillé)
🔒 6. Processus et services (Verrouillé)
🔒 7. Réseau de base (Verrouillé)
🔒 8. Scripts et automatisation (Verrouillé)
```

---

## 🔗 Liens utiles

- **Documentation Killercoda** : https://killercoda.com/creators/documentation
- **Créer un Course** : https://killercoda.com/creators/documentation/courses
- **GitHub Integration** : https://killercoda.com/creators/documentation/github

---

## ✅ Checklist de publication

Avant de publier votre parcours :

- [x] Les 8 scénarios sont créés et testés
- [x] Les titres sont numérotés (1., 2., 3., etc.)
- [x] Le fichier `structure.json` est créé
- [x] Le `README.md` explique l'ordre et les prérequis
- [ ] Un compte Killercoda est créé
- [ ] Le repo GitHub est connecté à Killercoda (optionnel)
- [ ] Un Course est créé avec les 8 scénarios dans l'ordre
- [ ] L'option "Require completion before next" est activée
- [ ] Le Course est publié
- [ ] Le lien du parcours est partagé avec les apprenants

---

**Votre formation est prête à être publiée !** 🎉

Pour toute question sur la publication, consultez la documentation Killercoda ou leur Discord.
