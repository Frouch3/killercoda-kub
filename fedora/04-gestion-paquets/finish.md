# Félicitations ! Vous maîtrisez la gestion des paquets !

## Ce que vous avez appris

✅ **Comprendre les gestionnaires de paquets** :
- apt (Debian/Ubuntu) vs dnf (Fedora/RHEL)
- Dépôts et paquets
- Différences entre distributions

✅ **Rechercher des logiciels** :
- apt search / dnf search
- apt show / dnf info
- Vérifier si un paquet est installé

✅ **Installer des paquets** :
- apt install / dnf install
- Installation multiple
- Gestion des dépendances

✅ **Mettre à jour** :
- apt update && apt upgrade
- dnf upgrade
- Mises à jour de sécurité

✅ **Désinstaller et nettoyer** :
- apt remove vs apt purge
- autoremove et clean
- Maintenance régulière

## Tableau récapitulatif apt vs dnf

| Action | Ubuntu (apt) | Fedora (dnf) |
|--------|--------------|--------------|
| Mettre à jour liste | `apt update` | `dnf check-update` |
| Rechercher | `apt search nom` | `dnf search nom` |
| Infos paquet | `apt show nom` | `dnf info nom` |
| Installer | `apt install nom` | `dnf install nom` |
| Installer sans confirm | `apt install -y nom` | `dnf install -y nom` |
| Mettre à jour tout | `apt upgrade` | `dnf upgrade` |
| Désinstaller | `apt remove nom` | `dnf remove nom` |
| Désinstaller + config | `apt purge nom` | `dnf remove nom` |
| Supprimer inutiles | `apt autoremove` | `dnf autoremove` |
| Nettoyer cache | `apt clean` | `dnf clean all` |
| Lister installés | `apt list --installed` | `dnf list installed` |

## Commandes essentielles à retenir

```bash
# Maintenance quotidienne
sudo apt update && sudo apt upgrade -y
sudo apt autoremove -y

# Installation
sudo apt install nom_paquet

# Recherche
apt search mot_clé
apt show nom_paquet

# Nettoyage
sudo apt autoremove
sudo apt autoclean
```

## Bonnes pratiques

✅ **À FAIRE** :
- Mettre à jour régulièrement (au moins une fois par semaine)
- Utiliser apt update avant apt install
- Nettoyer avec autoremove régulièrement
- Vérifier l'espace disque : `df -h`
- Lire les descriptions avant d'installer

❌ **À ÉVITER** :
- Mélanger les gestionnaires (ne pas utiliser apt et snap en même temps pour le même logiciel)
- Installer depuis des sources non vérifiées
- Ignorer les mises à jour de sécurité
- Utiliser `--force` sans comprendre les conséquences

## Aller plus loin

### Autres gestionnaires

**Snap** (universel) :
```bash
sudo snap install nom
sudo snap refresh
```

**Flatpak** (universel) :
```bash
flatpak install nom
flatpak update
```

### PPAs (Ubuntu)

Pour des logiciels non officiels :
```bash
sudo add-apt-repository ppa:nom/ppa
sudo apt update
sudo apt install paquet
```

### DNF sur Fedora

Sur une vraie Fedora, vous utiliseriez :
```bash
sudo dnf groupinstall "Development Tools"
sudo dnf install @development-tools
```

## Script de maintenance complet

```bash
#!/bin/bash
# maintenance-complete.sh

echo "🔄 Maintenance du système Linux"
echo "==============================="
echo ""

echo "📋 Mise à jour de la liste..."
sudo apt update

echo ""
echo "⬆️  Installation des mises à jour..."
sudo apt upgrade -y

echo ""
echo "🧹 Nettoyage des paquets inutiles..."
sudo apt autoremove -y

echo ""
echo "💾 Nettoyage du cache..."
sudo apt autoclean

echo ""
echo "📊 Espace disque :"
df -h | grep "^/dev/"

echo ""
echo "✅ Maintenance terminée avec succès !"
```

## Prochaine étape

Vous êtes maintenant prêt pour :

**Scénario 5 : Utilisateurs et permissions** - Gérer les accès et la sécurité

---

🎉 **Excellent travail !** Vous savez maintenant gérer les logiciels sous Linux !
