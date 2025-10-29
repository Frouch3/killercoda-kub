# Étape 3 : Modifier les permissions avec chmod

## Introduction

La commande **chmod** (change mode) permet de modifier les permissions des fichiers et répertoires.

## Syntaxe de base

Deux méthodes existent :
1. **Symbolique** : `chmod u+x fichier` (plus lisible)
2. **Octale** : `chmod 755 fichier` (plus rapide)

## Méthode symbolique

Format : `chmod [qui][opération][permission] fichier`

**Qui** :
- `u` : user (propriétaire)
- `g` : group (groupe)
- `o` : others (autres)
- `a` : all (tous)

**Opération** :
- `+` : ajouter
- `-` : retirer
- `=` : définir exactement

**Permission** : `r`, `w`, `x`

## Exemples symboliques

Reprenons notre script de l'étape précédente :

```bash
cd ~
ls -l script_test.sh
```

Ajoutons la permission d'exécution pour le propriétaire :

```bash
chmod u+x script_test.sh
ls -l script_test.sh
```

Maintenant le script est exécutable :

```bash
./script_test.sh
```

Autres exemples :

```bash
# Retirer la permission de lecture pour les autres
chmod o-r fichier_test.txt

# Ajouter l'écriture pour le groupe
chmod g+w fichier_test.txt

# Donner toutes les permissions au propriétaire
chmod u+rwx fichier_test.txt

# Retirer toutes les permissions aux autres
chmod o-rwx fichier_test.txt

# Permissions complètes pour tous
chmod a+rwx fichier_test.txt
```

## Méthode octale

Plus rapide quand on veut définir toutes les permissions d'un coup :

```bash
# rwxr-xr-x (755)
chmod 755 script_test.sh

# rw-r--r-- (644)
chmod 644 fichier_test.txt

# rwx------ (700) - privé complet
chmod 700 fichier_test.txt

# rw-rw-r-- (664)
chmod 664 fichier_test.txt
```

## Permissions courantes

| Octal | Symbolique | Usage |
|-------|------------|-------|
| 644 | -rw-r--r-- | Fichiers normaux |
| 755 | -rwxr-xr-x | Scripts/exécutables |
| 700 | -rwx------ | Fichiers privés |
| 600 | -rw------- | Fichiers sensibles |
| 777 | -rwxrwxrwx | Tout le monde (DANGEREUX!) |

## Modifier récursivement

L'option `-R` applique les permissions récursivement :

```bash
# Donner 755 à tous les fichiers d'un répertoire
chmod -R 755 test_permissions/

ls -l test_permissions/
```

**Attention** : Soyez prudent avec `-R` sur de grands répertoires !

## Cas pratiques

### 1. Créer un script exécutable

```bash
cat > mon_script.sh << 'EOF'
#!/bin/bash
echo "Script fonctionnel!"
date
EOF

chmod +x mon_script.sh
./mon_script.sh
```

### 2. Fichier de configuration protégé

```bash
echo "password=secret123" > config.conf
chmod 600 config.conf
ls -l config.conf
```

Seul le propriétaire peut lire/écrire !

### 3. Répertoire de partage

```bash
mkdir partage
chmod 755 partage
ls -ld partage
```

Tout le monde peut lire, seul le propriétaire peut écrire.

## Exercice pratique

Créez un fichier `exercice.txt` et donnez-lui les permissions suivantes :
- Propriétaire : lecture + écriture
- Groupe : lecture seule
- Autres : aucune permission

```bash
touch exercice.txt
chmod 640 exercice.txt
ls -l exercice.txt
```

Vérifiez que le résultat est : `-rw-r-----`

Créez également un script `hello.sh` qui affiche "Hello World" et rendez-le exécutable :

```bash
echo '#!/bin/bash' > hello.sh
echo 'echo "Hello World"' >> hello.sh
chmod +x hello.sh
./hello.sh
```

Une fois ces fichiers créés avec les bonnes permissions, la vérification passera.
