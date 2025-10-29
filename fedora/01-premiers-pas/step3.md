# Étape 3 : Créer des dossiers

## La commande `mkdir` - Make Directory

Pour créer un nouveau dossier, on utilise la commande `mkdir` (make directory).

### Syntaxe de base

```bash
mkdir nom_du_dossier
```

## Créer votre premier dossier

Commençons par retourner dans votre dossier personnel :

```bash
cd ~
pwd
```

Le symbole `~` représente toujours votre dossier personnel. La commande `pwd` confirme que vous y êtes.

Maintenant, créez un dossier appelé `mes_documents` :

```bash
mkdir mes_documents
```

Vérifiez qu'il a bien été créé :

```bash
ls -l
```

Vous devriez voir votre nouveau dossier `mes_documents` dans la liste !

## Créer plusieurs dossiers en même temps

Vous pouvez créer plusieurs dossiers d'un coup :

```bash
mkdir photos videos musique
```

Vérifiez :

```bash
ls -l
```

Vous voyez maintenant trois nouveaux dossiers : `photos`, `videos` et `musique`.

## Créer des sous-dossiers

Pour créer un dossier à l'intérieur d'un autre, vous avez deux options :

### Option 1 : Créer pas à pas

```bash
mkdir projets
mkdir projets/web
mkdir projets/web/site1
```

### Option 2 : Créer toute la hiérarchie d'un coup avec `-p`

L'option `-p` (parents) crée automatiquement tous les dossiers intermédiaires nécessaires :

```bash
mkdir -p travail/cours/linux/exercices
```

Cette commande crée :
- `travail/`
- `travail/cours/`
- `travail/cours/linux/`
- `travail/cours/linux/exercices/`

Tout d'un coup ! C'est très pratique.

Vérifiez la structure créée :

```bash
ls -R travail
```

💡 L'option `-R` (récursif) affiche le contenu de tous les sous-dossiers.

## Exercice pratique

Créez une structure de dossiers pour organiser votre espace de travail personnel :

```bash
# Retournez dans votre dossier personnel
cd ~

# Créez cette structure :
mkdir -p mon_espace/personnel/documents
mkdir -p mon_espace/personnel/images
mkdir -p mon_espace/professionnel/projets
mkdir -p mon_espace/professionnel/formations
```

Vérifiez votre travail :

```bash
ls -R mon_espace
```

Vous devriez voir une belle arborescence organisée !

## Conseils de nommage

✅ **Bonnes pratiques** :
- Utilisez des noms explicites : `mes_documents` plutôt que `docs`
- Évitez les espaces : utilisez `_` ou `-` à la place
  - ✅ Bon : `mes_documents` ou `mes-documents`
  - ❌ Mauvais : `mes documents` (compliqué à manipuler)
- Utilisez des minuscules (Linux est sensible à la casse)
- Évitez les caractères spéciaux (@, #, %, etc.)

## Résumé des commandes

```bash
mkdir dossier           # Créer un dossier
mkdir d1 d2 d3         # Créer plusieurs dossiers
mkdir -p a/b/c         # Créer toute une hiérarchie
ls -R dossier          # Voir le contenu récursivement
```

---

✅ Une fois que vous avez créé votre structure de dossiers et vérifié qu'elle existe bien, cliquez sur "Continuer".
