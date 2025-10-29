# Étape 4 : Mettre à jour le système

## Pourquoi mettre à jour ?

Les mises à jour apportent :
- **Correctifs de sécurité** 🔒
- **Corrections de bugs** 🐛
- **Nouvelles fonctionnalités** ✨
- **Améliorations de performance** ⚡

## Les deux étapes essentielles

### 1. Mettre à jour la liste (update)

```bash
sudo apt update
```

Rafraîchit la liste des paquets disponibles.

### 2. Installer les mises à jour (upgrade)

```bash
sudo apt upgrade
```

Installe toutes les mises à jour disponibles.

apt vous montre :
- Nombre de paquets à mettre à jour
- Espace disque nécessaire
- Demande confirmation

## Tout en une commande

```bash
sudo apt update && sudo apt upgrade -y
```

Le `&&` exécute la deuxième commande seulement si la première réussit.

## Mise à jour complète du système

Pour une mise à jour plus agressive (peut supprimer des paquets) :

```bash
sudo apt full-upgrade
```

Utilisez avec précaution !

## Voir quels paquets peuvent être mis à jour

```bash
apt list --upgradable
```

Affiche tous les paquets qui ont une mise à jour disponible.

## Mettre à jour un seul paquet

```bash
sudo apt install --only-upgrade nom_paquet
```

Exemple :

```bash
sudo apt install --only-upgrade nginx
```

## Équivalent Fedora (dnf)

```bash
# Fedora
sudo dnf check-update        # Vérifier les mises à jour
sudo dnf upgrade              # Installer les mises à jour
sudo dnf upgrade -y           # Sans confirmation

# Tout en une fois
sudo dnf upgrade -y
```

⚠️ Sur Fedora, `dnf upgrade` fait tout (pas besoin de check-update avant).

## Différence upgrade vs full-upgrade

| Commande | Comportement |
|----------|--------------|
| `apt upgrade` | Installe les mises à jour SANS supprimer de paquets |
| `apt full-upgrade` | Installe ET peut supprimer des paquets si nécessaire |

Pour un usage quotidien, `upgrade` suffit.

## Automatiser les mises à jour

### Créer un alias

Ajoutez dans `~/.bashrc` :

```bash
alias maj='sudo apt update && sudo apt upgrade -y'
```

Rechargez :

```bash
source ~/.bashrc
```

Maintenant tapez juste :

```bash
maj
```

### Script de mise à jour

```bash
cat > ~/update.sh << 'SCRIPT'
#!/bin/bash
echo "🔄 Mise à jour du système..."
sudo apt update
echo ""
echo "📦 Installation des mises à jour..."
sudo apt upgrade -y
echo ""
echo "🧹 Nettoyage..."
sudo apt autoremove -y
sudo apt autoclean
echo ""
echo "✅ Système à jour !"
SCRIPT

chmod +x ~/update.sh
```

Utilisez :

```bash
~/update.sh
```

## Mises à jour de sécurité uniquement

Sur Ubuntu, pour installer seulement les correctifs de sécurité :

```bash
sudo apt install unattended-upgrades
sudo unattended-upgrades
```

## Exercice pratique

### 1. Vérifier les mises à jour disponibles

```bash
sudo apt update
apt list --upgradable
```

### 2. Installer les mises à jour

```bash
sudo apt upgrade -y
```

### 3. Vérifier les versions

Avant/après mise à jour :

```bash
nginx -v
git --version
```

## Résumé des commandes

```bash
# Ubuntu (apt)
sudo apt update                     # Rafraîchir la liste
sudo apt upgrade                    # Installer mises à jour
sudo apt full-upgrade               # Mise à jour complète
apt list --upgradable               # Voir ce qui peut être mis à jour
sudo apt install --only-upgrade pkg # Un seul paquet

# Fedora (dnf)
sudo dnf check-update               # Vérifier
sudo dnf upgrade                    # Installer mises à jour
sudo dnf upgrade -y                 # Sans confirmation
dnf list updates                    # Voir disponibles
```

---

✅ Mettez à jour votre système, puis cliquez sur "Continuer" !
