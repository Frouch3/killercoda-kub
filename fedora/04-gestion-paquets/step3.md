# Étape 3 : Installer des logiciels

## Installation basique

### Sur Ubuntu (apt)

```bash
sudo apt install nom_du_paquet
```

apt vous demande confirmation (`Y/n`). Tapez `Y` puis `Entrée`.

### Équivalent Fedora (dnf)

```bash
sudo dnf install nom_du_paquet
```

## Votre première installation

Installons `tree`, un outil pour afficher l'arborescence des dossiers :

```bash
sudo apt install tree
```

Vous voyez :
- Les dépendances qui seront installées
- L'espace disque nécessaire
- Demande de confirmation

Tapez `Y` puis `Entrée`.

Testez :

```bash
tree ~
```

Vous voyez votre dossier personnel en arborescence !

## Installer plusieurs paquets en une fois

```bash
sudo apt install curl wget htop
```

Trois outils installés d'un coup !

- `curl` : télécharger des fichiers depuis des URLs
- `wget` : télécharger des fichiers (alternative à curl)
- `htop` : moniteur système interactif

Testez htop :

```bash
htop
```

(Appuyez sur `q` pour quitter)

## Installation sans confirmation

Pour les scripts, utilisez `-y` :

```bash
sudo apt install -y tree
```

Installe directement sans demander confirmation.

⚠️ Utilisez avec prudence !

## Voir ce qu'un paquet va installer

Pour voir les dépendances sans installer :

```bash
apt depends nom_paquet
```

Exemple :

```bash
apt depends nginx
```

## Installer un .deb téléchargé

Si vous avez téléchargé un fichier `.deb` :

```bash
sudo dpkg -i fichier.deb
```

Puis, pour installer les dépendances manquantes :

```bash
sudo apt --fix-broken install
```

## Exercice pratique

### 1. Installer des outils réseau

```bash
sudo apt install -y net-tools
```

Testez :

```bash
ifconfig
netstat -tuln
```

### 2. Installer un serveur web léger

```bash
sudo apt install -y nginx
```

Vérifiez qu'il tourne :

```bash
systemctl status nginx
```

Testez dans le navigateur (si disponible) : `http://localhost`

### 3. Installer des outils de développement

```bash
sudo apt install -y git build-essential
```

Vérifiez :

```bash
git --version
gcc --version
```

## Différences apt / dnf pour l'installation

```bash
# Ubuntu
sudo apt install paquet
sudo apt install -y paquet
sudo apt install paquet1 paquet2 paquet3

# Fedora  
sudo dnf install paquet
sudo dnf install -y paquet
sudo dnf install paquet1 paquet2 paquet3
```

Très similaires !

## Résumé

```bash
# Ubuntu (apt)
sudo apt install nom               # Installer
sudo apt install -y nom            # Sans confirmation
sudo apt install p1 p2 p3         # Plusieurs paquets
apt depends nom                    # Voir dépendances

# Fedora (dnf)
sudo dnf install nom               # Installer
sudo dnf install -y nom            # Sans confirmation
sudo dnf install p1 p2 p3         # Plusieurs paquets
dnf repoquery --requires nom       # Voir dépendances
```

---

✅ Installez quelques outils utiles, puis cliquez sur "Continuer" !
