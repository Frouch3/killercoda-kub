# Étape 1 : Se repérer dans le système

## Les trois commandes essentielles

Avant de commencer à explorer, vous devez connaître trois commandes de base :

### 1. `pwd` - Où suis-je ?

La commande `pwd` (Print Working Directory) affiche le répertoire dans lequel vous vous trouvez actuellement.

Essayez-la maintenant :

```bash
pwd
```

Vous devriez voir quelque chose comme `/root` ou `/home/votre_nom`. C'est votre **position actuelle** dans le système.

### 2. `ls` - Que contient ce dossier ?

La commande `ls` (list) affiche le contenu du répertoire actuel.

```bash
ls
```

Cette commande vous montre tous les fichiers et dossiers visibles.

Pour voir **plus de détails**, utilisez l'option `-l` (format long) :

```bash
ls -l
```

Vous verrez maintenant :
- Les permissions (qui peut lire/écrire/exécuter)
- Le propriétaire du fichier
- La taille du fichier
- La date de modification

Pour voir **tous les fichiers** (y compris les fichiers cachés qui commencent par un point) :

```bash
ls -la
```

💡 **Astuce** : `-la` combine deux options : `-l` (format long) et `-a` (all = tous les fichiers)

### 3. `whoami` - Qui suis-je ?

Cette commande affiche votre nom d'utilisateur actuel :

```bash
whoami
```

## Exercice pratique

Maintenant, exécutez ces trois commandes dans l'ordre et observez les résultats :

```bash
whoami
pwd
ls -la
```

**Comprenez ce que vous voyez** :
- La première ligne vous dit quel utilisateur vous êtes
- La deuxième ligne vous dit où vous êtes dans le système
- La troisième ligne vous montre ce qui se trouve dans ce dossier

---

✅ Une fois que vous avez exécuté ces commandes et compris leur rôle, cliquez sur "Continuer" pour passer à l'étape suivante.
