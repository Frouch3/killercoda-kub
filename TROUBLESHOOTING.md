# 🔧 Troubleshooting - Scénarios Killercoda

Guide de résolution des problèmes courants sur Killercoda.

## ✅ Problèmes Résolus

### 1. ❌ "imageId unknown"
**Statut** : ✅ RÉSOLU

**Problème** : Les scénarios affichaient "imageId unknown"

**Solution appliquée** :
- Changé `"imageid": "ubuntu:2204"` en `"imageid": "ubuntu"` dans tous les `index.json`
- Tous les 6 scénarios corrigés

### 2. ❌ "microk8s: command not found"
**Statut** : ✅ RÉSOLU

**Problème** : Microk8s n'était pas installé quand l'utilisateur arrive sur le terminal

**Solution appliquée** :
- Amélioration du `setup.sh` avec logging détaillé
- Amélioration du `foreground.sh` avec spinner et timeout
- Vérification de l'installation avant de marquer comme prêt

### 3. ❌ "snap: command not found"
**Statut** : ✅ RÉSOLU

**Problème** : L'image `ubuntu` de Killercoda n'a pas snap préinstallé

**Solution appliquée** :
- Détection automatique de snap dans `setup.sh`
- Installation de `snapd` si absent
- Activation du service snapd
- Création du symlink `/snap`

---

## 🐛 Debugging

### Vérifier les Logs d'Installation

Si Microk8s ne s'installe pas, consultez les logs :

```bash
# Sur Killercoda, dans le terminal
cat /tmp/setup.log
```

Vous verrez toutes les étapes de l'installation avec timestamps :
```
[Tue Oct 28 14:30:00 UTC 2024] Démarrage de l'installation de Microk8s...
[Tue Oct 28 14:30:05 UTC 2024] Installation de Microk8s via snap...
[Tue Oct 28 14:31:30 UTC 2024] Microk8s installé avec succès
...
```

### Vérifier si le Setup est Terminé

```bash
# Le fichier devrait exister
ls -la /tmp/setup-complete

# Si pas présent, l'installation est encore en cours ou a échoué
```

### Suivre l'Installation en Temps Réel

```bash
# Suivre les logs pendant l'installation
tail -f /tmp/setup.log
```

Appuyez sur Ctrl+C pour arrêter.

### Installation Manuelle

Si l'installation automatique échoue :

```bash
# Installer Microk8s manuellement
snap install microk8s --classic --channel=1.28/stable

# Attendre qu'il soit prêt
microk8s status --wait-ready

# Activer les addons
microk8s enable dns storage

# Créer l'alias
echo "alias kubectl='microk8s kubectl'" >> ~/.bashrc
source ~/.bashrc

# Tester
microk8s kubectl version --short
```

---

## 🔍 Problèmes Connus

### Installation Lente

**Symptôme** : Le spinner tourne pendant plus de 2 minutes

**Causes possibles** :
- Serveurs Killercoda surchargés
- Téléchargement de l'image Microk8s lent
- Resources limitées sur l'environnement

**Solution** :
- Attendre jusqu'à 3 minutes (timeout du script)
- Consulter les logs : `cat /tmp/setup.log`
- Si timeout, installer manuellement

### Timeout après 3 Minutes

**Symptôme** :
```
⚠️  L'installation prend plus de temps que prévu
```

**Actions** :
1. Vérifier les logs : `cat /tmp/setup.log`
2. Regarder où ça bloque
3. Installer manuellement (voir ci-dessus)

### kubectl Version Échoue

**Symptôme** : `kubectl version` retourne une erreur

**Solutions** :
```bash
# Vérifier le statut de Microk8s
microk8s status

# Attendre qu'il soit prêt
microk8s status --wait-ready --timeout 120

# Réessayer
microk8s kubectl version
```

### Problèmes de Permissions

**Symptôme** : Erreurs de permissions avec `microk8s`

**Solution** :
```bash
# Ajouter l'utilisateur au groupe
sudo usermod -a -G microk8s $USER

# Appliquer les changements
newgrp microk8s

# Ou redémarrer le shell
exec bash
```

---

## 📋 Checklist de Vérification

Avant de démarrer un exercice sur Killercoda :

- [ ] L'environnement affiche "✅ Environnement prêt!"
- [ ] `microk8s kubectl version` fonctionne
- [ ] `microk8s status` affiche "microk8s is running"
- [ ] Les addons DNS et Storage sont activés

Vérification rapide :
```bash
# Tout en une commande
microk8s status && microk8s kubectl version --short && echo "✅ OK"
```

---

## 🛠️ Scripts Améliorés

### setup.sh

Le script `setup.sh` a été amélioré avec :

✅ **Logging détaillé** : Tous les logs dans `/tmp/setup.log`
✅ **Gestion d'erreurs** : Arrêt si installation échoue
✅ **Timeout** : 120 secondes maximum pour `status --wait-ready`
✅ **Vérification finale** : Test de `kubectl` avant de marquer comme prêt

### foreground.sh

Le script `foreground.sh` a été amélioré avec :

✅ **Spinner d'attente** : Affichage visuel de la progression
✅ **Compteur de temps** : Voir combien de temps ça prend
✅ **Timeout** : 3 minutes max, puis message d'aide
✅ **Messages d'aide** : Instructions si problème
✅ **Vérification** : Test de kubectl avant d'afficher "Prêt"

---

## 🔄 Réinitialiser l'Environnement

Si tout va mal, vous pouvez réinitialiser :

### Sur Killercoda

1. Cliquer sur "Restart Scenario"
2. Attendre le rechargement complet
3. L'installation recommence à zéro

### Manuellement

```bash
# Supprimer Microk8s
snap remove microk8s --purge

# Nettoyer les fichiers temporaires
rm -f /tmp/setup-complete /tmp/setup.log /tmp/kubectl-test.log

# Réinstaller
snap install microk8s --classic --channel=1.28/stable
```

---

## 📞 Support

### Logs à Fournir

Si vous rencontrez un problème, fournissez :

1. **Logs d'installation** :
```bash
cat /tmp/setup.log
```

2. **Statut Microk8s** :
```bash
microk8s status
```

3. **Version kubectl** :
```bash
microk8s kubectl version
```

4. **Informations système** :
```bash
uname -a
snap list microk8s
```

### Où Demander de l'Aide

- **Killercoda Community** : https://community.killercoda.com/
- **Microk8s Discourse** : https://discuss.kubernetes.io/tag/microk8s
- **GitHub Issues** : Ouvrir une issue sur le repo de la formation

---

## 💡 Optimisations Possibles

### Réduire le Temps d'Installation

**Option 1** : Utiliser une image pré-configurée
```json
{
  "backend": {
    "imageid": "kubernetes-kubeadm-1node"
  }
}
```

Inconvénient : Ce n'est pas Microk8s

**Option 2** : Créer une image Docker custom avec Microk8s pré-installé

Avantage : Démarrage quasi-instantané
Inconvénient : Complexité supplémentaire

**Option 3** : Activer seulement les addons nécessaires

Dans `setup.sh`, commenter les addons non-essentiels :
```bash
# microk8s enable storage  # Désactiver si pas besoin de PVC
```

---

## ✅ Tests de Non-Régression

Avant de publier une mise à jour :

```bash
# 1. Vérifier les index.json
for f in */index.json; do
  echo "=== $f ==="
  grep imageid "$f"
done
# Tous devraient afficher "ubuntu" (pas "ubuntu:2204")

# 2. Vérifier les permissions
for f in */setup.sh */foreground.sh; do
  [ -x "$f" ] && echo "✅ $f" || echo "❌ $f manque +x"
done

# 3. Vérifier que les scripts ne sont pas vides
for f in */setup.sh; do
  [ -s "$f" ] && echo "✅ $f non vide" || echo "❌ $f vide!"
done
```

---

## 📅 Historique des Corrections

| Date | Problème | Solution | Statut |
|------|----------|----------|--------|
| 2024-10-28 | imageId unknown | Changé en `ubuntu` | ✅ Résolu |
| 2024-10-28 | microk8s not found | Scripts améliorés | ✅ Résolu |
| 2024-10-28 | snap: command not found | Installation de snapd ajoutée | ✅ Résolu |

---

**Dernière mise à jour** : 28 octobre 2024
