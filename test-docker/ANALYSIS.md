# 🔍 Analyse du Test Docker

## ❌ Problème Identifié

Le test dans Docker **échoue** car:

```
error: cannot communicate with server: dial unix /run/snapd.socket: connect: no such file or directory
```

### Pourquoi?

1. **Docker vs VM**:
   - Killercoda utilise des **VMs réelles** avec systemd complet
   - Docker utilise des **conteneurs** sans systemd par défaut
   - snapd **nécessite systemd** pour fonctionner correctement

2. **snapd et systemd**:
   ```
   daemon stop requested to wait for socket activation
   ```
   - snapd attend que systemd active son socket
   - Sans systemd, snapd démarre puis s'arrête immédiatement
   - Le socket `/run/snapd.socket` n'est jamais créé

3. **Installation snapd prend 52s** (apt-get update + install)
   - Cela laisse seulement 128s (180s - 52s) pour microk8s
   - Mais microk8s ne peut même pas commencer car snapd ne fonctionne pas

## ✅ Ce qui fonctionne

1. **Détection de snapd** : ✅
2. **Installation de snapd** : ✅
3. **Configuration du PATH** : ✅
4. **Détection de systemd** : ✅

## ❌ Ce qui ne fonctionne pas

1. **snapd sans systemd** : ❌
2. **Installation de microk8s** : ❌ (dépend de snapd)

## 🎯 Conclusion

**Le test Docker n'est pas représentatif de l'environnement Killercoda réel.**

Killercoda:
- ✅ VM Ubuntu avec systemd complet
- ✅ snapd fonctionne normalement
- ✅ Toutes les commandes systemctl fonctionnent

Docker:
- ❌ Conteneur sans systemd
- ❌ snapd ne peut pas fonctionner sans systemd
- ❌ Impossible de tester réellement l'installation

## 💡 Solutions

### Option 1: Faire confiance au script pour Killercoda

Le script `setup.sh` est **correct pour Killercoda** car:

```bash
if systemctl is-system-running &> /dev/null || [ -d /run/systemd/system ]; then
    # ✅ Cette branche s'exécutera sur Killercoda
    systemctl enable --now snapd.socket
    sleep 5
else
    # ❌ Cette branche s'exécute dans Docker (pas dans Killercoda)
    /usr/lib/snapd/snapd &
    sleep 10
fi
```

Sur Killercoda (VM réelle):
- systemd est disponible (`/run/systemd/system` existe)
- snapd fonctionnera correctement
- microk8s s'installera normalement

### Option 2: Simplifier le script

Supprimer la détection de snapd et supposer que Killercoda a déjà snap:

```bash
#!/bin/bash

# Logfile pour debug
LOGFILE="/tmp/setup.log"
exec > >(tee -a $LOGFILE) 2>&1

echo "[$(date)] Démarrage de l'installation de Microk8s..."

# Ajouter /snap/bin au PATH
export PATH=$PATH:/snap/bin
echo 'export PATH=$PATH:/snap/bin' >> /root/.bashrc

# Installer Microk8s via snap
echo "[$(date)] Installation de Microk8s via snap..."
snap install microk8s --classic --channel=1.28/stable

# ... reste du script
```

**Avantage**: Plus rapide (pas d'installation de snapd)
**Inconvénient**: Suppose que snap est déjà installé

### Option 3: Vérifier la documentation Killercoda

Regarder si l'image `ubuntu` de Killercoda a snap préinstallé:
- Si **OUI** → Utiliser Option 2 (simplifier)
- Si **NON** → Garder le script actuel (avec installation snapd)

## 📊 Temps d'installation estimés

Sur Killercoda (VM réelle):

| Étape | Temps | Cumulé |
|-------|-------|--------|
| apt-get update + install snapd | ~50s | 50s |
| snap install microk8s | ~90s | 140s |
| microk8s status --wait-ready | ~60s | 200s |
| enable dns + storage | ~30s | 230s |
| **TOTAL** | | **~230s (3m50s)** |

**Notre timeout actuel**: 420s (7 min) → ✅ Suffisant

## 🔧 Recommandation

1. **NE PAS utiliser Docker pour tester** (pas représentatif)
2. **Garder le script actuel** avec installation de snapd
3. **Tester directement sur Killercoda**
4. **Augmenter les timeouts** si nécessaire après tests réels

## 📝 Script final recommandé

Le script actuel dans `01-deployer-nginx/setup.sh` est **correct** pour Killercoda.

Les problèmes précédents ("/snap/bin not in PATH", etc.) sont **résolus**:
- ✅ PATH configuré
- ✅ Timeouts augmentés
- ✅ Logs détaillés
- ✅ Gestion d'erreurs

**Prochaine étape**: Tester sur Killercoda réel (pas dans Docker)
