# Étape 4 : Gérer les groupes et propriétaires

## Introduction

Chaque fichier appartient à un **propriétaire** (user) et un **groupe** (group). Les commandes **chown** et **chgrp** permettent de modifier ces propriétés.

## Afficher le propriétaire et le groupe

```bash
ls -l fichier_test.txt
```

Le format est : `permissions liens propriétaire groupe taille date nom`

Exemple :
```
-rw-r--r-- 1 root root 15 Oct 29 10:00 fichier_test.txt
              └─┘  └─┘
         propriétaire groupe
```

## Les groupes sous Linux

### Lister les groupes

Voir tous les groupes du système :

```bash
cat /etc/group
```

Voir les groupes de l'utilisateur actuel :

```bash
groups
id
```

### Créer un groupe

```bash
sudo groupadd developpeurs
sudo groupadd stagiaires
grep developpeurs /etc/group
```

### Ajouter un utilisateur à un groupe

```bash
# Ajouter charlie au groupe developpeurs
sudo usermod -aG developpeurs charlie

# Vérifier
id charlie
```

## Changer le propriétaire avec chown

La commande **chown** (change owner) modifie le propriétaire d'un fichier.

### Syntaxe de base

```bash
# Changer le propriétaire
sudo chown charlie fichier_test.txt

# Changer propriétaire ET groupe
sudo chown charlie:developpeurs fichier_test.txt

# Vérifier
ls -l fichier_test.txt
```

### Exemples pratiques

Créons des fichiers de test :

```bash
cd ~
echo "Document 1" > doc1.txt
echo "Document 2" > doc2.txt
echo "Document 3" > doc3.txt
ls -l doc*.txt
```

Changeons les propriétaires :

```bash
# doc1.txt appartient à charlie
sudo chown charlie doc1.txt

# doc2.txt appartient à charlie, groupe developpeurs
sudo chown charlie:developpeurs doc2.txt

ls -l doc*.txt
```

### Changer récursivement

L'option `-R` fonctionne aussi avec chown :

```bash
mkdir projet
touch projet/file1.txt projet/file2.txt
sudo chown -R charlie:developpeurs projet/
ls -lR projet/
```

## Changer le groupe avec chgrp

La commande **chgrp** (change group) modifie uniquement le groupe.

```bash
# Changer le groupe de doc3.txt
sudo chgrp developpeurs doc3.txt
ls -l doc3.txt

# Récursivement
sudo chgrp -R developpeurs projet/
```

## Cas pratiques

### 1. Projet collaboratif

Créons un répertoire pour une équipe :

```bash
sudo mkdir /opt/projet_equipe
sudo chown root:developpeurs /opt/projet_equipe
sudo chmod 770 /opt/projet_equipe
ls -ld /opt/projet_equipe
```

Résultat : `drwxrwx--- root developpeurs`

Seuls les membres du groupe "developpeurs" peuvent accéder !

### 2. Fichiers de logs

Les fichiers de logs appartiennent souvent à des utilisateurs spécifiques :

```bash
sudo touch /var/log/mon_application.log
sudo chown charlie:adm /var/log/mon_application.log
sudo chmod 640 /var/log/mon_application.log
ls -l /var/log/mon_application.log
```

### 3. Transfert de propriété

Quand un employé part, on transfère ses fichiers :

```bash
# Simuler des fichiers de charlie
sudo -u charlie touch /home/charlie/important.txt
ls -l /home/charlie/important.txt

# Transférer à bob
sudo chown bob:bob /home/charlie/important.txt
```

## Permissions spéciales

### SetUID (s)

Permet d'exécuter un fichier avec les droits de son propriétaire :

```bash
ls -l /usr/bin/passwd
```

Vous verrez : `-rwsr-xr-x` (le 's' remplace 'x')

Le `passwd` s'exécute avec les droits root même si lancé par un utilisateur normal.

### SetGID (s)

Sur un répertoire, les nouveaux fichiers héritent du groupe du répertoire :

```bash
sudo mkdir /opt/partage
sudo chgrp developpeurs /opt/partage
sudo chmod 2775 /opt/partage
ls -ld /opt/partage
```

Résultat : `drwxrwsr-x` (le 's' dans la section groupe)

### Sticky bit (t)

Sur un répertoire, seul le propriétaire peut supprimer ses fichiers :

```bash
ls -ld /tmp
```

Résultat : `drwxrwxrwt` (le 't' à la fin)

Même avec droits d'écriture, vous ne pouvez supprimer QUE vos fichiers !

## Exercice pratique

Créez un répertoire `collaboration` :

```bash
sudo mkdir /home/collaboration
```

Configurez-le pour qu'il appartienne à root et au groupe `developpeurs` :

```bash
sudo chown root:developpeurs /home/collaboration
```

Donnez les permissions 770 (rwxrwx---) :

```bash
sudo chmod 770 /home/collaboration
ls -ld /home/collaboration
```

Vérifiez que le résultat est : `drwxrwx--- root developpeurs`

Une fois correctement configuré, la vérification passera.
