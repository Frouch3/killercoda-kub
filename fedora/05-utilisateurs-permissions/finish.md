# Félicitations !

Vous avez terminé le scénario sur la gestion des utilisateurs et des permissions sous Linux !

## Ce que vous avez appris

### Gestion des utilisateurs
- **useradd** : Créer de nouveaux comptes utilisateurs
- **usermod** : Modifier les comptes existants
- **userdel** : Supprimer des comptes
- Fichiers /etc/passwd, /etc/shadow, /etc/group

### Permissions de fichiers
- Comprendre **rwx** (lecture, écriture, exécution)
- Différence entre propriétaire, groupe et autres
- Notation symbolique vs octale
- Permissions courantes (644, 755, 700, 600)

### Modification des permissions
- **chmod** : Modifier les permissions (symbolique et octal)
- **chown** : Changer le propriétaire et le groupe
- **chgrp** : Changer uniquement le groupe
- Option `-R` pour les modifications récursives

### Sécurité et sudo
- Utiliser **sudo** pour les commandes privilégiées
- Principe du moindre privilège
- Bonnes pratiques de sécurité
- Configuration avec visudo
- Permissions spéciales (SetUID, SetGID, Sticky bit)

## Commandes essentielles à retenir

```bash
# Utilisateurs
sudo useradd -m -s /bin/bash nom_utilisateur
sudo passwd nom_utilisateur
sudo usermod -aG groupe utilisateur
sudo userdel -r utilisateur

# Permissions
chmod 644 fichier.txt        # rw-r--r--
chmod 755 script.sh          # rwxr-xr-x
chmod u+x fichier            # Ajouter exécution propriétaire
chmod go-w fichier           # Retirer écriture groupe/autres

# Propriété
sudo chown user:group fichier
sudo chgrp groupe fichier

# Informations
ls -l                        # Afficher permissions
id utilisateur               # Infos utilisateur
groups utilisateur           # Groupes de l'utilisateur

# Sudo
sudo commande                # Exécuter avec privilèges
sudo -u user commande        # Exécuter en tant qu'autre user
```

## Bonnes pratiques de sécurité

1. **Toujours** utiliser sudo plutôt que se connecter en root
2. **Jamais** chmod 777 sauf cas très spécifique et temporaire
3. **Protéger** les fichiers sensibles avec 600 ou 640
4. **Limiter** l'accès sudo aux personnes de confiance
5. **Auditer** régulièrement les permissions critiques
6. **Appliquer** le principe du moindre privilège

## Pour aller plus loin

- **ACL** (Access Control Lists) : Permissions plus granulaires avec `setfacl` et `getfacl`
- **SELinux/AppArmor** : Sécurité obligatoire (Mandatory Access Control)
- **PAM** (Pluggable Authentication Modules) : Gestion avancée de l'authentification
- **Audit** : Tracer toutes les modifications de fichiers
- **LDAP/Active Directory** : Gestion centralisée des utilisateurs

## Ressources utiles

- `man chmod` : Manuel de chmod
- `man chown` : Manuel de chown
- `man sudoers` : Configuration détaillée de sudo
- `man useradd` : Toutes les options de useradd

## Prochaines étapes

Continuez votre apprentissage avec :
- **Scénario 06** : Gestion des processus et services
- **Scénario 07** : Configuration réseau de base
- **Scénario 08** : Scripts et automatisation

La maîtrise des permissions est **fondamentale** pour administrer efficacement un système Linux. Pratiquez régulièrement !

Merci d'avoir suivi ce scénario et bon courage pour la suite ! 🚀
