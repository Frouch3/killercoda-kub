# Félicitations ! Vous maîtrisez les éditeurs de texte Linux !

## Ce que vous avez appris

Au cours de cet exercice, vous avez découvert :

✅ **nano - L'éditeur accessible** :
- Interface intuitive avec raccourcis affichés
- Créer, éditer, sauvegarder des fichiers
- Rechercher et remplacer
- Couper, copier, coller
- Configuration personnalisée

✅ **vim - L'éditeur puissant** :
- Les modes : Normal, Insertion, Visuel, Commande
- Navigation efficace
- Commandes de manipulation de texte
- Recherche et remplacement avancés
- Configuration avec .vimrc

✅ **Édition de fichiers de configuration** :
- Fichiers système avec sudo
- Personnalisation du shell (.bashrc)
- Bonnes pratiques de sauvegarde
- Vérification de syntaxe

## Récapitulatif nano

```bash
nano fichier.txt           # Ouvrir un fichier

# Raccourcis essentiels
Ctrl+O                     # Sauvegarder
Ctrl+X                     # Quitter
Ctrl+K                     # Couper ligne
Ctrl+U                     # Coller
Ctrl+W                     # Rechercher
Ctrl+\                     # Remplacer
Alt+U                      # Annuler
Ctrl+_                     # Aller à une ligne
```

## Récapitulatif vim

```bash
vim fichier.txt            # Ouvrir un fichier

# Modes
Esc                        # Mode NORMAL
i                          # Mode INSERTION
v                          # Mode VISUEL
:                          # Mode COMMANDE

# Navigation (mode NORMAL)
h j k l                    # ← ↓ ↑ →
w / b                      # Mot suivant / précédent
gg / G                     # Début / Fin du fichier
0 / $                      # Début / Fin de ligne

# Édition (mode NORMAL)
dd                         # Supprimer ligne
yy                         # Copier ligne
p                          # Coller
u                          # Annuler
Ctrl+r                     # Refaire

# Commandes
:w                         # Sauvegarder
:q                         # Quitter
:wq                        # Sauvegarder et quitter
:q!                        # Quitter sans sauvegarder
:set number                # Numéros de ligne
:%s/ancien/nouveau/g       # Remplacer tout
```

## Quel éditeur utiliser ?

### Utilisez **nano** pour :
- ✅ Modifications rapides
- ✅ Débuter sous Linux
- ✅ Fichiers courts
- ✅ Éditions occasionnelles

### Utilisez **vim** pour :
- ✅ Travail quotidien sur serveur
- ✅ Fichiers longs et complexes
- ✅ Éditions intensives
- ✅ Automatisation avec scripts

### La meilleure approche : Les deux !
- Commencez par **nano** pour apprendre
- Progressez vers **vim** pour l'efficacité
- Gardez les deux dans votre boîte à outils

## Prochaines étapes

Maintenant que vous savez éditer des fichiers, vous êtes prêt pour :

**Scénario 4 : Gestion des paquets** - Installer et gérer des logiciels

**Scénario 5 : Utilisateurs et permissions** - Sécuriser vos fichiers

**Scénario 6 : Processus et services** - Gérer les applications qui tournent

## Ressources pour aller plus loin

### Pour nano :
- Aide intégrée : `Ctrl+G` dans nano
- Page man : `man nano`

### Pour vim :
- Tutoriel interactif : `vimtutor` (tapez dans le terminal)
- Aide : `:help` dans vim
- Page man : `man vim`

### Sites web :
- OpenVim : Tutoriel interactif en ligne
- Vim Adventures : Apprendre vim en jouant

## Conseil final

💡 **La pratique fait le maître** : Plus vous utiliserez ces éditeurs, plus vous serez rapide et efficace. N'ayez pas peur de faire des erreurs, c'est en pratiquant qu'on apprend !

---

🎉 **Bravo !** Vous êtes maintenant capable d'éditer n'importe quel fichier sous Linux !
