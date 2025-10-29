# Étape 2 : Explorer l'arborescence Linux

## Comprendre l'organisation de Linux

Contrairement à Windows (avec ses disques C:, D:, etc.), Linux organise tout dans **une seule arborescence** qui commence à la **racine** notée `/`.

```
/                    ← La racine (point de départ)
├── home/           ← Dossiers personnels des utilisateurs
├── etc/            ← Fichiers de configuration
├── var/            ← Données variables (logs, caches)
├── usr/            ← Programmes et bibliothèques
├── bin/            ← Commandes essentielles
├── tmp/            ← Fichiers temporaires
└── root/           ← Dossier de l'administrateur
```

## Explorer les principaux dossiers

### 1. Lister le contenu de la racine

Pour voir tous les dossiers principaux du système :

```bash
ls /
```

Vous voyez tous les dossiers qui se trouvent à la racine du système.

### 2. Explorer `/home` - Les dossiers personnels

Le dossier `/home` contient les espaces personnels de chaque utilisateur :

```bash
ls -l /home
```

Chaque utilisateur a son propre dossier ici pour stocker ses fichiers personnels.

### 3. Explorer `/etc` - Les configurations

Le dossier `/etc` contient tous les fichiers de configuration du système :

```bash
ls /etc
```

C'est ici que sont stockés les paramètres de tous les programmes et services.

### 4. Explorer `/var` - Les données variables

Le dossier `/var` contient des données qui changent pendant le fonctionnement du système :

```bash
ls /var
```

On y trouve notamment :
- `/var/log` - les fichiers de logs (journaux)
- `/var/cache` - les données en cache
- `/var/tmp` - fichiers temporaires qui persistent après un redémarrage

Regardons les logs par exemple :

```bash
ls /var/log
```

### 5. Explorer `/usr` - Les programmes

Le dossier `/usr` contient la plupart des programmes installés :

```bash
ls /usr
```

Vous y trouverez :
- `/usr/bin` - les commandes utilisateur
- `/usr/lib` - les bibliothèques partagées
- `/usr/share` - les fichiers partagés (documentation, icônes, etc.)

## Exercice pratique

Explorez ces dossiers en combinant `ls` avec différentes options :

```bash
# Voir le contenu détaillé de /etc
ls -l /etc | head -20

# Compter combien il y a de fichiers dans /usr/bin
ls /usr/bin | wc -l

# Voir les fichiers de log récents
ls -lt /var/log | head -10
```

💡 **Explications** :
- `| head -20` : affiche seulement les 20 premières lignes
- `| wc -l` : compte le nombre de lignes (donc de fichiers)
- `-lt` : trie par date de modification (le plus récent en premier)

## Points importants à retenir

🔹 **`/`** est la racine du système (tout part de là)
🔹 **`/home`** contient vos fichiers personnels
🔹 **`/etc`** contient les configurations
🔹 **`/var`** contient les données variables (logs, caches)
🔹 **`/usr`** contient les programmes installés

---

✅ Explorez ces dossiers, puis cliquez sur "Continuer" pour apprendre à créer vos propres dossiers.
