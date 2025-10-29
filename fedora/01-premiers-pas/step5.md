# Étape 5 : Supprimer des dossiers

## ⚠️ Attention : La suppression est définitive !

Contrairement à Windows ou macOS, Linux **n'a pas de corbeille** en ligne de commande. Quand vous supprimez quelque chose, c'est définitif !

Soyez donc toujours **très prudent** avant de supprimer.

## Méthode 1 : `rmdir` - Supprimer un dossier vide

La commande `rmdir` (remove directory) supprime **uniquement** les dossiers vides.

### Créons d'abord un dossier de test

```bash
cd ~
mkdir dossier_test
ls -l
```

### Supprimons-le

```bash
rmdir dossier_test
ls -l
```

Le dossier a disparu !

### Que se passe-t-il avec un dossier non vide ?

Créons un dossier avec des sous-dossiers :

```bash
mkdir -p test_suppression/sous_dossier
```

Essayons de le supprimer avec `rmdir` :

```bash
rmdir test_suppression
```

❌ **Erreur !** `rmdir` refuse de supprimer un dossier qui contient quelque chose. C'est une **sécurité** pour éviter les suppressions accidentelles.

## Méthode 2 : `rm -r` - Supprimer un dossier et son contenu

Pour supprimer un dossier **et tout ce qu'il contient**, utilisez `rm -r` :

- `rm` = remove (supprimer)
- `-r` = récursif (le dossier et tout son contenu)

### Suppression basique

```bash
rm -r test_suppression
ls -l
```

Le dossier et tous ses sous-dossiers ont été supprimés.

### Suppression avec confirmation : `rm -ri`

Pour plus de sécurité, utilisez l'option `-i` (interactive) qui demande confirmation :

```bash
mkdir -p test_securite/important/donnees
rm -ri test_securite
```

Le système vous demande de confirmer pour chaque élément. Répondez `y` (yes) ou `n` (no).

💡 **Conseil** : Utilisez toujours `-ri` quand vous supprimez des dossiers importants !

### Suppression sans confirmation : `rm -rf`

⚠️ **DANGER !** L'option `-f` (force) supprime **sans demander confirmation**.

```bash
mkdir dossier_danger
rm -rf dossier_danger
```

**NE JAMAIS utiliser** `rm -rf` à la légère, surtout avec des chemins système comme `/` ou `/home` !

## Exercice pratique de nettoyage

Nettoyons les dossiers de test que nous avons créés :

```bash
# Retournez dans votre dossier personnel
cd ~

# Listez vos dossiers
ls -l

# Supprimez les dossiers de test un par un avec confirmation
rm -ri mes_documents
rm -ri photos
rm -ri videos
rm -ri musique
rm -ri projets
rm -ri travail

# Vérifiez qu'ils ont été supprimés
ls -l
```

## Gardez la structure `mon_espace`

Ne supprimez **pas** le dossier `mon_espace` pour l'instant, nous allons le garder pour la vérification :

```bash
ls -l mon_espace
```

Vous devriez voir :
- `personnel/` avec `documents/` et `images/`
- `professionnel/` avec `projets/` et `formations/`

## Bonnes pratiques de suppression

✅ **À FAIRE** :
- Toujours vérifier avec `ls` avant de supprimer
- Utiliser `pwd` pour savoir où vous êtes
- Utiliser `-i` pour les suppressions importantes
- Faire une sauvegarde des données critiques

❌ **À NE JAMAIS FAIRE** :
- `rm -rf /` ou `rm -rf /*` (détruit tout le système !)
- Supprimer sans vérifier le chemin
- Utiliser `sudo rm -rf` sans être absolument certain
- Supprimer des dossiers système (`/etc`, `/bin`, `/usr`, etc.)

## Commandes de sécurité avant suppression

Avant de supprimer, vérifiez toujours :

```bash
# Où suis-je ?
pwd

# Que vais-je supprimer ?
ls -la nom_dossier

# Combien de fichiers vais-je supprimer ?
find nom_dossier -type f | wc -l

# Voir la structure complète
tree nom_dossier  # (si tree est installé)
# ou
ls -R nom_dossier
```

## Résumé des commandes

```bash
rmdir dossier              # Supprimer un dossier vide
rm -r dossier              # Supprimer un dossier et son contenu
rm -ri dossier             # Suppression avec confirmation (RECOMMANDÉ)
rm -rf dossier             # Suppression forcée (DANGEREUX)
ls -l                      # Vérifier avant de supprimer
pwd                        # Savoir où on est
```

## Alternatives plus sûres

Si vous voulez une "corbeille" en ligne de commande, vous pouvez installer `trash-cli` :

```bash
# Installation (pour plus tard)
sudo dnf install trash-cli

# Utilisation
trash mon_fichier          # Envoie dans la corbeille
trash-list                 # Voir le contenu de la corbeille
trash-restore              # Restaurer un fichier
trash-empty               # Vider la corbeille
```

Mais pour cet exercice, nous utilisons les commandes standard.

---

✅ Nettoyez vos dossiers de test (sauf `mon_espace`), puis cliquez sur "Continuer" pour terminer ce scénario !
