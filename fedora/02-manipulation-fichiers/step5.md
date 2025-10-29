# Étape 5 : Supprimer des fichiers

## ⚠️ AVERTISSEMENT IMPORTANT

Sous Linux, **la suppression est définitive**. Il n'y a **pas de corbeille** en ligne de commande. Une fois supprimé, un fichier est **irrécupérable** (sauf avec des outils de récupération complexes).

**Soyez TOUJOURS prudent avec `rm` !**

## Commande `rm` - Remove (Supprimer)

### Syntaxe de base

```bash
rm fichier
```

### Supprimer un fichier simple

```bash
cd ~
# Créer un fichier de test
echo "Fichier temporaire" > temp.txt

# Le supprimer
rm temp.txt

# Vérifier qu'il n'existe plus
ls temp.txt    # Erreur : fichier introuvable
```

Le fichier a disparu définitivement.

### Supprimer plusieurs fichiers

```bash
# Créer des fichiers de test
touch test1.txt test2.txt test3.txt

# Les supprimer tous
rm test1.txt test2.txt test3.txt

# Vérifier
ls test*.txt   # Aucun fichier trouvé
```

### Supprimer avec des jokers

```bash
# Créer des fichiers temporaires
touch temp_1.txt temp_2.txt temp_3.txt

# Les supprimer tous d'un coup
rm temp_*.txt

# Vérifier
ls temp_*.txt  # Aucun fichier trouvé
```

⚠️ **Attention** : Les jokers sont puissants mais dangereux ! Vérifiez toujours avec `ls` d'abord :

```bash
# D'ABORD regarder ce qui sera supprimé
ls temp_*.txt

# ENSUITE supprimer
rm temp_*.txt
```

## Option `-i` : Mode interactif (RECOMMANDÉ)

L'option `-i` demande confirmation avant chaque suppression :

```bash
# Créer un fichier
echo "Important" > document.txt

# Supprimer avec confirmation
rm -i document.txt
```

Le système demande : `remove regular file 'document.txt'?`

Répondez :
- `y` ou `yes` : Oui, supprimer
- `n` ou `no` : Non, annuler

💡 **Bonne pratique** : Utilisez **TOUJOURS** `-i` pour les fichiers importants !

### Alias pour plus de sécurité

Vous pouvez créer un alias pour que `rm` utilise toujours `-i` :

```bash
alias rm='rm -i'
```

Maintenant, chaque fois que vous tapez `rm`, il demandera confirmation automatiquement !

Pour rendre cet alias permanent, ajoutez-le dans `~/.bashrc` :

```bash
echo "alias rm='rm -i'" >> ~/.bashrc
```

## Option `-f` : Mode force (DANGEREUX)

L'option `-f` (force) supprime **sans demander confirmation**, même si le fichier est protégé :

```bash
rm -f fichier.txt
```

⚠️ **NE JAMAIS UTILISER** `-f` à la légère ! C'est très dangereux.

❌ **JAMAIS JAMAIS JAMAIS** :
```bash
rm -rf /        # DÉTRUIT TOUT LE SYSTÈME
rm -rf /*       # DÉTRUIT TOUT LE SYSTÈME
rm -rf ~        # DÉTRUIT VOTRE DOSSIER PERSONNEL
```

## Supprimer des dossiers avec `-r`

Pour supprimer un **dossier et tout son contenu**, utilisez `-r` (récursif) :

```bash
# Créer un dossier avec du contenu
mkdir -p test_dossier/sous_dossier
touch test_dossier/fichier1.txt
touch test_dossier/sous_dossier/fichier2.txt

# Le supprimer avec tout son contenu
rm -r test_dossier

# Vérifier
ls test_dossier  # Erreur : dossier introuvable
```

### Suppression récursive avec confirmation

Pour plus de sécurité, combinez `-r` et `-i` :

```bash
rm -ri test_dossier
```

Le système demande confirmation pour **chaque fichier et dossier**. C'est long mais très sûr !

## Option `-v` : Mode verbeux

L'option `-v` affiche ce qui est supprimé :

```bash
touch file1.txt file2.txt
rm -v file1.txt file2.txt
```

Affiche :
```
removed 'file1.txt'
removed 'file2.txt'
```

Utile pour suivre ce qui se passe lors de suppressions multiples.

## Exercice pratique : Nettoyage sécurisé

### 1. Créer une structure de test

```bash
cd ~
mkdir -p nettoyage/logs
mkdir -p nettoyage/temp
mkdir -p nettoyage/important

# Créer des fichiers
echo "Log 1" > nettoyage/logs/app.log
echo "Log 2" > nettoyage/logs/error.log
echo "Temp 1" > nettoyage/temp/cache.tmp
echo "Temp 2" > nettoyage/temp/session.tmp
echo "Important !" > nettoyage/important/data.txt

# Créer des fichiers à la racine
touch nettoyage/old_file.txt
touch nettoyage/test.txt
```

### 2. Identifier ce qu'il faut supprimer

```bash
# Lister tout
ls -R nettoyage/
```

Disons que nous voulons supprimer :
- Les fichiers temporaires (*.tmp)
- Les logs (*.log)
- Les fichiers de test (test.txt, old_file.txt)

Mais **garder** :
- Le dossier important/ et son contenu

### 3. Supprimer de façon sécurisée

```bash
# D'ABORD vérifier ce qui sera supprimé
ls nettoyage/temp/*.tmp
ls nettoyage/logs/*.log

# ENSUITE supprimer avec confirmation
rm -iv nettoyage/temp/*.tmp
rm -iv nettoyage/logs/*.log
rm -iv nettoyage/test.txt
rm -iv nettoyage/old_file.txt

# Vérifier ce qui reste
ls -R nettoyage/
```

Le dossier `important/` et son contenu sont toujours là ! ✅

### 4. Supprimer les dossiers vides

```bash
# Les dossiers logs et temp sont vides, on peut les supprimer
rmdir nettoyage/logs
rmdir nettoyage/temp

# Ou utiliser rm -r avec confirmation
rm -riv nettoyage/logs
rm -riv nettoyage/temp

# Vérifier
ls nettoyage/
```

## Alternatives plus sûres

### Déplacer vers une "corbeille" temporaire

Au lieu de supprimer directement, déplacez vers un dossier temporaire :

```bash
# Créer une corbeille
mkdir -p ~/.corbeille

# "Supprimer" en déplaçant
mv fichier_a_supprimer.txt ~/.corbeille/

# Vider la corbeille plus tard
rm -rf ~/.corbeille/*
```

### Utiliser `trash-cli` (à installer)

Il existe un outil qui ajoute une corbeille en ligne de commande :

```bash
# Installation (pour référence)
sudo dnf install trash-cli

# Utilisation
trash fichier.txt           # Envoie dans la corbeille
trash-list                  # Voir le contenu
trash-restore              # Restaurer un fichier
trash-empty                # Vider la corbeille
```

## Vérifications avant suppression

**TOUJOURS faire ces vérifications avant de supprimer** :

```bash
# 1. Où suis-je ?
pwd

# 2. Qu'est-ce que je vais supprimer ?
ls -l fichiers_a_supprimer*

# 3. Combien de fichiers ?
ls fichiers_a_supprimer* | wc -l

# 4. Quelle taille totale ?
du -sh fichiers_a_supprimer*

# 5. Y a-t-il des fichiers importants ?
ls -la fichiers_a_supprimer*
```

## Erreurs courantes à éviter

❌ **DANGER** :
```bash
rm -rf /            # DÉTRUIT TOUT (catastrophique)
rm -rf /*           # DÉTRUIT TOUT (catastrophique)
rm -rf ~            # Supprime votre dossier personnel
rm -rf .* # Peut supprimer des fichiers système
rm -rf *            # Supprime tout dans le dossier actuel (vérifier pwd d'abord !)
```

✅ **SÛR** :
```bash
rm -i fichier.txt              # Avec confirmation
rm -ri dossier/                # Récursif avec confirmation
ls fichier* && rm -i fichier*  # Vérifier puis supprimer
```

## Protection contre les suppressions accidentelles

### 1. Créer un alias sûr

```bash
echo "alias rm='rm -i'" >> ~/.bashrc
source ~/.bashrc
```

### 2. Utiliser un script de sauvegarde

```bash
cat > ~/safe_rm.sh << 'EOF'
#!/bin/bash
# Script de suppression sécurisée
mkdir -p ~/.corbeille
for file in "$@"; do
    if [ -e "$file" ]; then
        mv "$file" ~/.corbeille/
        echo "Déplacé vers corbeille : $file"
    fi
done
EOF

chmod +x ~/safe_rm.sh

# Utilisation
~/safe_rm.sh fichier_a_supprimer.txt
```

## Résumé des commandes

```bash
rm fichier.txt                  # Supprimer un fichier
rm -i fichier.txt              # Avec confirmation (RECOMMANDÉ)
rm -v fichier.txt              # Mode verbeux
rm file1 file2 file3           # Supprimer plusieurs fichiers
rm *.tmp                       # Supprimer avec joker
rm -r dossier/                 # Supprimer dossier et contenu
rm -ri dossier/                # Récursif avec confirmation (RECOMMANDÉ)
rm -rf dossier/                # Force récursif (DANGEREUX)
```

## Règles d'or de la suppression

1. **Toujours vérifier avec `pwd` et `ls` avant de supprimer**
2. **Utiliser `-i` pour les fichiers importants**
3. **Ne JAMAIS utiliser `rm -rf /` ou `rm -rf /*`**
4. **Faire des sauvegardes avant de supprimer des données importantes**
5. **Préférer `mv` vers une corbeille plutôt que `rm`**
6. **Réfléchir deux fois avant d'utiliser `-f`**
7. **Tester avec `ls` avant d'utiliser des jokers**

---

✅ Nettoyez vos fichiers de test en toute sécurité, puis cliquez sur "Continuer" pour terminer ce scénario !
