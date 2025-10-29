# Félicitations ! Vous maîtrisez la manipulation de fichiers !

## Ce que vous avez appris

Au cours de cet exercice, vous avez découvert :

✅ **Création de fichiers** :
- `touch` - créer des fichiers vides
- `echo` - créer des fichiers avec du contenu
- Redirection `>` et `>>`

✅ **Affichage du contenu** :
- `cat` - afficher tout le contenu
- `less` - navigation interactive
- `head` - premières lignes
- `tail` - dernières lignes
- `wc` - compter les lignes/mots/caractères

✅ **Copie de fichiers** :
- `cp` - copier des fichiers
- `cp -r` - copier des dossiers récursivement
- `cp -i` - copier avec confirmation

✅ **Déplacement et renommage** :
- `mv` - déplacer des fichiers
- `mv` - renommer des fichiers
- `mv -i` - avec confirmation

✅ **Suppression** :
- `rm` - supprimer des fichiers
- `rm -i` - avec confirmation (recommandé)
- `rm -f` - suppression forcée (dangereux)

## Récapitulatif des commandes

```bash
# Création
touch fichier.txt                    # Créer un fichier vide
echo "texte" > fichier.txt          # Créer avec contenu (écrase)
echo "texte" >> fichier.txt         # Ajouter à la fin

# Affichage
cat fichier.txt                     # Afficher tout
less fichier.txt                    # Navigation (q pour quitter)
head fichier.txt                    # 10 premières lignes
head -n 5 fichier.txt              # 5 premières lignes
tail fichier.txt                    # 10 dernières lignes
tail -f fichier.log                # Suivre en temps réel
wc -l fichier.txt                  # Compter les lignes

# Copie
cp source.txt destination.txt       # Copier un fichier
cp -r dossier/ copie/              # Copier un dossier
cp -i fichier.txt sauvegarde.txt   # Copier avec confirmation

# Déplacement/Renommage
mv ancien.txt nouveau.txt           # Renommer
mv fichier.txt /autre/dossier/     # Déplacer
mv -i fichier.txt destination/     # Avec confirmation

# Suppression
rm fichier.txt                      # Supprimer
rm -i fichier.txt                  # Avec confirmation
rm -r dossier/                     # Supprimer dossier et contenu
```

## Astuces avancées

💡 **Wildcards (jokers)** :
```bash
ls *.txt                # Tous les fichiers .txt
cp *.jpg photos/        # Copier toutes les images .jpg
rm test*.txt            # Supprimer tous les test1.txt, test2.txt...
```

💡 **Copier plusieurs fichiers** :
```bash
cp fichier1.txt fichier2.txt fichier3.txt destination/
```

💡 **Préserver les permissions** :
```bash
cp -p fichier.txt copie.txt    # Garde date et permissions
```

💡 **Copie interactive complète** :
```bash
cp -ri dossier/ backup/        # Copie récursive avec confirmation
```

## Bonnes pratiques

✅ **Toujours faire** :
- Vérifier où vous êtes avec `pwd`
- Lister avant de supprimer avec `ls`
- Utiliser `-i` pour les opérations importantes
- Faire des sauvegardes avant modifications importantes
- Utiliser des noms de fichiers explicites

❌ **Ne jamais faire** :
- `rm -rf /` ou `rm -rf /*` (détruit le système !)
- Supprimer sans vérifier
- Utiliser `rm -rf` à la légère
- Oublier de sauvegarder les données importantes

## Exercices pratiques pour progresser

Pour vous entraîner davantage :

1. **Organisez vos fichiers** : Créez une structure de dossiers et organisez des fichiers dedans
2. **Faites des sauvegardes** : Copiez régulièrement vos fichiers importants
3. **Nettoyez** : Supprimez les fichiers temporaires ou inutiles
4. **Explorez** : Regardez le contenu de `/etc` pour voir des fichiers de configuration réels

## Prochaine étape

Maintenant que vous savez manipuler des fichiers, vous êtes prêt pour le scénario suivant :

**Scénario 3 : Éditeurs de texte** où vous apprendrez à modifier le contenu des fichiers avec nano et vim.

---

🎉 **Excellent travail !** Vous progressez rapidement dans votre maîtrise de Linux !
