# Étape 2 : Rechercher des paquets

## Pourquoi rechercher ?

Avant d'installer, vous devez trouver le **nom exact** du paquet. Souvent, le nom du paquet diffère du nom du logiciel.

## Recherche simple

### Sur Ubuntu (apt)

```bash
apt search nginx
```

Vous voyez tous les paquets contenant "nginx" dans leur nom ou description.

### Équivalent Fedora (dnf)

```bash
dnf search nginx
```

## Recherche plus précise

La recherche basique renvoie beaucoup de résultats. Pour filtrer :

```bash
apt search nginx | grep "^nginx"
```

Cela affiche seulement les paquets dont le nom **commence** par "nginx".

## Rechercher par catégorie

### Outils réseau

```bash
apt search "network tool"
```

### Éditeurs de texte

```bash
apt search "text editor"
```

### Outils de développement

```bash
apt search compiler
```

## Obtenir des détails sur un paquet

Une fois trouvé le bon paquet :

```bash
apt show nom_du_paquet
```

**Exemple** :

```bash
apt show curl
```

Vous voyez :
- **Package** : curl
- **Version** : 7.81.0-1ubuntu1.15
- **Priority** : optional
- **Section** : web
- **Maintainer** : Ubuntu Developers
- **Installed-Size** : 459 kB
- **Depends** : libc6, libcurl4, zlib1g
- **Description** : command line tool for transferring data with URL syntax

💡 La section **Depends** montre les dépendances (paquets nécessaires).

## Vérifier si un paquet est déjà installé

```bash
apt list --installed | grep nom_paquet
```

Ou plus simple :

```bash
dpkg -l | grep nom_paquet
```

**Exemple** :

```bash
dpkg -l | grep wget
```

Si le paquet est installé, vous voyez une ligne commençant par `ii`.

## Trouver le paquet qui fournit une commande

Vous connaissez une commande mais pas le nom du paquet ?

```bash
dpkg -S $(which commande)
```

**Exemple** :

```bash
dpkg -S $(which python3)
```

Affiche : `python3-minimal: /usr/bin/python3`

Donc `python3` est fourni par le paquet `python3-minimal`.

## Exercice pratique

### 1. Rechercher des outils de compression

```bash
apt search compression
```

Vous voyez : gzip, bzip2, xz-utils, zip, unzip, etc.

### 2. Trouver un serveur web

```bash
apt search "web server"
```

Vous trouvez : nginx, apache2, lighttpd, etc.

### 3. Détails sur Apache

```bash
apt show apache2
```

Lisez la description, la taille, les dépendances.

### 4. Vérifier si git est installé

```bash
dpkg -l | grep git
```

Si vous voyez une ligne `ii git`, il est installé.

Ou simplement :

```bash
git --version
```

Si git est installé, vous voyez sa version.

### 5. Rechercher des jeux

```bash
apt search game | head -20
```

Oui, il y a même des jeux dans les dépôts !

## Différences apt search / dnf search

Les deux fonctionnent de manière très similaire :

```bash
# Ubuntu
apt search nginx
apt show nginx

# Fedora
dnf search nginx
dnf info nginx
```

## Astuce : pipe avec less

Quand il y a beaucoup de résultats :

```bash
apt search python | less
```

Vous pouvez naviguer avec :
- `Espace` : page suivante
- `q` : quitter

## Résumé des commandes

```bash
# Ubuntu (apt)
apt search nom                   # Rechercher un paquet
apt search "plusieurs mots"      # Recherche avec plusieurs mots
apt show nom                     # Détails sur un paquet
apt list --installed | grep nom  # Vérifier si installé
dpkg -l | grep nom              # Alternative
dpkg -S $(which cmd)            # Trouver le paquet d'une commande

# Équivalent Fedora (dnf)
dnf search nom                   # Rechercher
dnf info nom                     # Détails
dnf list installed | grep nom    # Vérifier si installé
rpm -qf $(which cmd)            # Trouver le paquet
```

---

✅ Recherchez quelques paquets intéressants, puis cliquez sur "Continuer" pour apprendre à installer !
