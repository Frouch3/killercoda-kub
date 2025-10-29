# Étape 1 : Créer des fichiers

## Méthode 1 : `touch` - Créer un fichier vide

La commande la plus simple pour créer un fichier est `touch`.

### Créer un fichier vide

```bash
cd ~
touch mon_fichier.txt
```

Vérifiez qu'il a été créé :

```bash
ls -l mon_fichier.txt
```

Vous voyez le fichier avec une taille de 0 octets (il est vide).

### Créer plusieurs fichiers en même temps

```bash
touch fichier1.txt fichier2.txt fichier3.txt
ls -l *.txt
```

💡 L'astérisque `*` est un **joker** qui signifie "n'importe quel caractère". Donc `*.txt` signifie "tous les fichiers qui se terminent par .txt".

### Utilité de `touch`

`touch` ne sert pas qu'à créer des fichiers ! Si le fichier existe déjà, `touch` **met à jour** sa date de modification :

```bash
ls -l mon_fichier.txt
# Attendez quelques secondes
touch mon_fichier.txt
ls -l mon_fichier.txt
```

La date a changé ! C'est utile pour marquer des fichiers comme récemment modifiés.

## Méthode 2 : `echo` avec redirection - Créer avec du contenu

Pour créer un fichier contenant du texte directement :

### Le symbole `>` (redirection)

```bash
echo "Bonjour, ceci est mon premier fichier !" > bienvenue.txt
```

Cette commande fait deux choses :
1. `echo` affiche le texte
2. `>` redirige cette sortie vers le fichier `bienvenue.txt`

Si le fichier n'existe pas, il est créé. **S'il existe déjà, il est écrasé !**

Vérifiez le contenu :

```bash
cat bienvenue.txt
```

### Le symbole `>>` (ajout à la fin)

Pour **ajouter** du texte à la fin d'un fichier existant sans l'écraser :

```bash
echo "Ceci est la première ligne" > notes.txt
echo "Ceci est la deuxième ligne" >> notes.txt
echo "Ceci est la troisième ligne" >> notes.txt
```

Affichez le contenu :

```bash
cat notes.txt
```

Vous voyez les trois lignes ! Le `>>` a ajouté à la fin sans effacer ce qui existait.

⚠️ **Important** :
- `>` écrase le fichier (attention !)
- `>>` ajoute à la fin (plus sûr)

## Méthode 3 : Créer un fichier avec plusieurs lignes

Vous pouvez créer un fichier multi-lignes avec un "here document" :

```bash
cat > ma_liste.txt << EOF
Pommes
Bananes
Oranges
Fraises
EOF
```

Explication :
- `cat >` crée le fichier
- `<< EOF` signifie "tout ce qui suit jusqu'à voir EOF"
- Vous tapez vos lignes
- `EOF` termine la saisie

Vérifiez :

```bash
cat ma_liste.txt
```

## Exercice pratique

Créez une structure de fichiers pour un projet :

```bash
# Créez un dossier projet
mkdir -p ~/projet/docs

# Allez dans ce dossier
cd ~/projet

# Créez plusieurs fichiers vides
touch README.md TODO.md CHANGELOG.md

# Créez un fichier avec du contenu
echo "# Mon Projet" > README.md
echo "" >> README.md
echo "Ceci est mon premier projet Linux." >> README.md

# Créez une liste de tâches
cat > TODO.md << EOF
# Liste des tâches

- [ ] Apprendre les commandes Linux
- [ ] Créer mon premier script
- [ ] Déployer une application
EOF

# Vérifiez vos fichiers
ls -l
cat README.md
cat TODO.md
```

## Résumé des commandes

```bash
touch fichier.txt               # Créer un fichier vide
touch f1.txt f2.txt f3.txt     # Créer plusieurs fichiers
echo "texte" > fichier.txt     # Créer avec contenu (écrase)
echo "texte" >> fichier.txt    # Ajouter à la fin
cat > fichier.txt << EOF       # Créer multi-lignes
# ... lignes ...
EOF
```

## Conventions de nommage

✅ **Bonnes pratiques** :
- Utilisez des extensions explicites (.txt, .md, .log, .conf)
- Pas d'espaces : utilisez `_` ou `-`
  - ✅ `mon_fichier.txt` ou `mon-fichier.txt`
  - ❌ `mon fichier.txt`
- Utilisez des minuscules
- Noms descriptifs : `notes_reunion.txt` plutôt que `notes.txt`

---

✅ Créez quelques fichiers de test, puis cliquez sur "Continuer" pour apprendre à afficher leur contenu.
