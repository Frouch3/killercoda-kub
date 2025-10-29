# Étape 2 : Afficher le contenu des fichiers

## Commande `cat` - Afficher tout le contenu

La commande `cat` (concatenate) affiche le contenu complet d'un ou plusieurs fichiers.

### Afficher un fichier

Si vous avez créé les fichiers de l'étape précédente :

```bash
cd ~/projet
cat README.md
```

Le contenu s'affiche directement dans le terminal.

### Afficher plusieurs fichiers

```bash
cat README.md TODO.md
```

Les deux fichiers sont affichés l'un après l'autre.

### Numéroter les lignes

```bash
cat -n README.md
```

L'option `-n` ajoute des numéros de ligne. Très utile pour référencer des lignes spécifiques !

⚠️ **Limite de `cat`** : Si le fichier est très long, tout défile rapidement. Pour les longs fichiers, utilisez `less`.

## Commande `less` - Navigation interactive

`less` permet de naviguer dans un fichier page par page.

### Créons d'abord un fichier plus long

```bash
cd ~
# Créer un fichier avec 50 lignes
for i in {1..50}; do echo "Ligne numéro $i"; done > long_fichier.txt
```

### Ouvrir avec `less`

```bash
less long_fichier.txt
```

**Commandes dans `less`** :
- `Espace` ou `f` : Page suivante
- `b` : Page précédente
- `↓` : Ligne suivante
- `↑` : Ligne précédente
- `g` : Aller au début
- `G` : Aller à la fin
- `/motclé` : Rechercher "motclé"
- `n` : Occurrence suivante
- `q` : Quitter

Essayez de naviguer, puis tapez `q` pour quitter.

💡 **Astuce** : `less` est parfait pour lire des logs ou de la documentation !

## Commande `head` - Premières lignes

Pour voir seulement le **début** d'un fichier :

```bash
head long_fichier.txt
```

Par défaut, `head` affiche les **10 premières lignes**.

### Afficher un nombre personnalisé de lignes

```bash
head -n 5 long_fichier.txt    # 5 premières lignes
head -n 20 long_fichier.txt   # 20 premières lignes
```

💡 Utile pour vérifier rapidement le format d'un fichier de données.

## Commande `tail` - Dernières lignes

Pour voir seulement la **fin** d'un fichier :

```bash
tail long_fichier.txt
```

Par défaut, `tail` affiche les **10 dernières lignes**.

### Afficher un nombre personnalisé de lignes

```bash
tail -n 5 long_fichier.txt    # 5 dernières lignes
tail -n 20 long_fichier.txt   # 20 dernières lignes
```

### Suivre un fichier en temps réel avec `-f`

C'est **très utile** pour suivre des logs en direct :

```bash
# Dans un premier temps, créons un fichier de log
touch ~/application.log

# Suivre le fichier en temps réel
tail -f ~/application.log
```

Le terminal reste "bloqué" et affiche toutes les nouvelles lignes ajoutées au fichier.

Pour tester, **ouvrez un deuxième terminal** (ou arrêtez `tail -f` avec `Ctrl+C`) et ajoutez des lignes :

```bash
echo "Nouvelle ligne de log" >> ~/application.log
```

Vous verriez la ligne apparaître dans le `tail -f` !

💡 **Usage professionnel** : `tail -f` est LA commande pour surveiller des logs d'applications ou de services.

## Commande `wc` - Compter

`wc` (word count) compte les lignes, mots et caractères.

```bash
wc long_fichier.txt
```

Résultat : `50  100  450 long_fichier.txt`
- 50 lignes
- 100 mots
- 450 caractères

### Options utiles

```bash
wc -l long_fichier.txt    # Seulement le nombre de lignes
wc -w long_fichier.txt    # Seulement le nombre de mots
wc -c long_fichier.txt    # Seulement le nombre d'octets
```

💡 Très utile pour savoir combien de lignes contient un fichier de données.

## Exercice pratique

### 1. Créez un fichier de citations

```bash
cd ~
cat > citations.txt << EOF
La vie est un mystère qu'il faut vivre, et non un problème à résoudre.
Le succès c'est d'aller d'échec en échec sans perdre son enthousiasme.
Il n'est jamais trop tard pour devenir ce que vous auriez pu être.
La seule façon de faire du bon travail est d'aimer ce que vous faites.
L'éducation est l'arme la plus puissante qu'on puisse utiliser pour changer le monde.
Celui qui déplace une montagne commence par déplacer de petites pierres.
Le meilleur moment pour planter un arbre était il y a 20 ans. Le deuxième meilleur moment est maintenant.
EOF
```

### 2. Explorez ce fichier

```bash
# Afficher tout
cat citations.txt

# Afficher avec numéros de ligne
cat -n citations.txt

# Afficher les 3 premières citations
head -n 3 citations.txt

# Afficher les 2 dernières citations
tail -n 2 citations.txt

# Compter combien il y a de citations (lignes)
wc -l citations.txt

# Compter combien de mots au total
wc -w citations.txt
```

### 3. Créez un fichier plus complexe

```bash
# Générer un fichier avec 100 lignes
for i in {1..100}; do
    echo "Entrée $i - Date: $(date +%Y-%m-%d) - Statut: OK"
done > rapport.txt

# Explorer ce fichier
head -n 10 rapport.txt      # 10 premières entrées
tail -n 10 rapport.txt      # 10 dernières entrées
wc -l rapport.txt           # Nombre total d'entrées
less rapport.txt            # Navigation complète (q pour quitter)
```

## Résumé des commandes

```bash
cat fichier.txt              # Afficher tout le contenu
cat -n fichier.txt          # Avec numéros de ligne
less fichier.txt            # Navigation interactive (q pour quitter)
head fichier.txt            # 10 premières lignes
head -n 5 fichier.txt       # 5 premières lignes
tail fichier.txt            # 10 dernières lignes
tail -n 5 fichier.txt       # 5 dernières lignes
tail -f fichier.log         # Suivre en temps réel (Ctrl+C pour arrêter)
wc -l fichier.txt           # Compter les lignes
wc -w fichier.txt           # Compter les mots
```

## Quelle commande utiliser ?

| Situation | Commande recommandée |
|-----------|---------------------|
| Fichier court (< 50 lignes) | `cat` |
| Fichier long | `less` |
| Vérifier le format d'un fichier | `head -n 10` |
| Voir les derniers événements | `tail` |
| Suivre un log en direct | `tail -f` |
| Compter des lignes | `wc -l` |

---

✅ Pratiquez l'affichage de fichiers, puis cliquez sur "Continuer" pour apprendre à copier des fichiers.
