# Étape 5 : Utiliser sudo et sécurité de base

## Introduction

**sudo** (Super User DO) permet d'exécuter des commandes avec les privilèges d'un autre utilisateur, généralement root (administrateur).

## Pourquoi utiliser sudo ?

Plutôt que de se connecter directement en root (dangereux !), sudo permet :

- D'exécuter ponctuellement des commandes privilégiées
- De tracer qui fait quoi (logs dans /var/log/auth.log)
- De limiter les dégâts en cas d'erreur
- D'appliquer le principe du **moindre privilège**

## Utilisation de base

```bash
# Commande normale (échoue)
apt update

# Avec sudo (fonctionne)
sudo apt update
```

Lors de la première utilisation, sudo demande VOTRE mot de passe (pas celui de root).

## Qui peut utiliser sudo ?

Les utilisateurs du groupe **sudo** (Ubuntu/Debian) ou **wheel** (Fedora/RHEL) :

```bash
# Voir si vous êtes dans le groupe sudo
groups
id | grep sudo
```

## Commandes sudo courantes

```bash
# Installer un paquet
sudo apt install tree

# Éditer un fichier système
sudo nano /etc/hosts

# Redémarrer un service
sudo systemctl restart ssh

# Voir les logs système
sudo journalctl -n 50

# Changer les permissions
sudo chmod 755 /usr/local/bin/mon_script

# Devenir root temporairement
sudo -i

# Exécuter en tant qu'autre utilisateur
sudo -u charlie ls /home/charlie
```

## Configuration de sudo

Le fichier **/etc/sudoers** contrôle qui peut utiliser sudo.

**ATTENTION** : Ne jamais éditer directement ! Utiliser **visudo** :

```bash
sudo visudo
```

### Exemples de configuration

```
# Permettre à bob d'exécuter toutes les commandes
bob ALL=(ALL:ALL) ALL

# Groupe admin peut tout faire
%admin ALL=(ALL) ALL

# charlie peut redémarrer nginx sans mot de passe
charlie ALL=(ALL) NOPASSWD: /usr/bin/systemctl restart nginx

# Groupe developpeurs peut installer des paquets
%developpeurs ALL=(ALL) /usr/bin/apt install *
```

## Ajouter un utilisateur au groupe sudo

```bash
# Ajouter charlie au groupe sudo
sudo usermod -aG sudo charlie

# Vérifier
id charlie
```

**Note** : charlie devra se déconnecter/reconnecter pour que ça prenne effet.

## Historique et logs

Sudo enregistre toutes les commandes exécutées :

```bash
# Voir les dernières utilisations de sudo
sudo journalctl | grep sudo | tail -20

# Sur certains systèmes
sudo cat /var/log/auth.log | grep sudo
```

## Bonnes pratiques de sécurité

### 1. Principe du moindre privilège

N'utilisez sudo QUE quand nécessaire :

```bash
# BON
ls /etc
sudo nano /etc/hosts

# MAUVAIS
sudo ls /etc
sudo nano mon_fichier.txt
```

### 2. Éviter sudo su ou sudo -i

Préférez les commandes ponctuelles :

```bash
# Moins bon
sudo su -
apt update
exit

# Meilleur
sudo apt update
```

### 3. Vérifier les commandes avant exécution

```bash
# Dangereux !
sudo rm -rf /

# Toujours vérifier le chemin
ls /tmp/ancien
sudo rm -rf /tmp/ancien
```

### 4. Protéger les fichiers sensibles

```bash
# Fichiers de configuration : 644 ou 640
sudo chmod 640 /etc/mysql/my.cnf

# Fichiers avec mots de passe : 600
chmod 600 ~/.ssh/id_rsa

# Exécutables système : 755
sudo chmod 755 /usr/local/bin/mon_script
```

### 5. Utiliser des groupes

Plutôt que donner sudo à tout le monde :

```bash
# Créer un groupe spécifique
sudo groupadd admins_web

# Ajouter des utilisateurs
sudo usermod -aG admins_web charlie
sudo usermod -aG admins_web bob

# Configurer sudo pour ce groupe
sudo visudo
# Ajouter : %admins_web ALL=(ALL) /usr/bin/systemctl restart nginx
```

## umask : Permissions par défaut

La commande **umask** définit les permissions par défaut des nouveaux fichiers :

```bash
# Voir le umask actuel
umask

# Umask commun : 0022
# Signifie : retirer write (2) pour group et others
# Fichiers : 666 - 022 = 644
# Répertoires : 777 - 022 = 755
```

Changer le umask :

```bash
# umask plus restrictif
umask 0027
# Fichiers : 640
# Répertoires : 750

touch nouveau.txt
ls -l nouveau.txt
```

Pour rendre permanent, ajoutez dans ~/.bashrc :

```bash
echo "umask 0027" >> ~/.bashrc
```

## Audit de sécurité simple

Vérifier les fichiers world-writable (dangereux) :

```bash
# Chercher dans /tmp
find /tmp -type f -perm -002 -ls 2>/dev/null

# Chercher les fichiers SUID
sudo find / -perm -4000 -type f 2>/dev/null
```

## Exercice pratique

1. Vérifiez que vous pouvez utiliser sudo :

```bash
sudo whoami
```

Devrait afficher : `root`

2. Créez un fichier nécessitant sudo :

```bash
sudo touch /etc/test_sudo.conf
```

3. Donnez-lui les bonnes permissions (644) :

```bash
sudo chmod 644 /etc/test_sudo.conf
ls -l /etc/test_sudo.conf
```

4. Vérifiez les logs sudo récents :

```bash
sudo journalctl | grep sudo | tail -5
```

## Résumé des bonnes pratiques

- ✅ Utiliser sudo plutôt que root direct
- ✅ N'accorder sudo qu'aux personnes de confiance
- ✅ Utiliser des groupes pour gérer les permissions
- ✅ Permissions strictes pour fichiers sensibles (600/640)
- ✅ Auditer régulièrement les permissions
- ❌ Éviter chmod 777
- ❌ Ne jamais partager les mots de passe
- ❌ Ne pas laisser sudo NOPASSWD sauf cas spécifique

Félicitations ! Vous maîtrisez maintenant la gestion des utilisateurs et des permissions sous Linux.
