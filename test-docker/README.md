# 🧪 Test des Scénarios Killercoda en Local

Ce répertoire permet de tester les scénarios Killercoda dans un environnement Docker qui simule les conditions réelles de Killercoda.

## 🚀 Lancement Rapide

```bash
cd test-docker
./test-scenario.sh
```

## 📋 Ce qui est testé

1. ✅ Installation de snapd (si absent)
2. ✅ Configuration du PATH pour /snap/bin
3. ✅ Installation de Microk8s via snap
4. ✅ Timeout et gestion d'erreurs
5. ✅ Scripts de vérification
6. ✅ Foreground.sh (expérience utilisateur)

## 🐳 Utilisation Manuelle

### Construire l'image

```bash
docker build -t killercoda-test .
```

### Lancer le conteneur en mode interactif

```bash
docker run -it --rm --privileged \
  -v /sys/fs/cgroup:/sys/fs/cgroup:rw \
  -v /lib/modules:/lib/modules:ro \
  killercoda-test /bin/bash
```

### Une fois dans le conteneur

```bash
# Lancer le setup en arrière-plan
./setup.sh &

# Afficher le foreground (ce que voit l'utilisateur)
./foreground.sh

# Vérifier que microk8s est installé
export PATH=$PATH:/snap/bin
microk8s version
microk8s status

# Tester un script de vérification
./verify-step1.sh
```

## 🔍 Debug

### Voir les logs du setup

```bash
docker run -it --rm --privileged \
  -v /sys/fs/cgroup:/sys/fs/cgroup:rw \
  killercoda-test /bin/bash -c "./setup.sh && cat /tmp/setup.log"
```

### Voir si snap est installé

```bash
docker run -it --rm --privileged \
  killercoda-test /bin/bash -c "which snap || echo 'snap not found'"
```

## ⚠️ Notes Importantes

1. **Mode Privilégié Requis** : Docker doit être lancé avec `--privileged` pour que snap et systemd fonctionnent
2. **Volumes cgroup** : Nécessaires pour que systemd fonctionne correctement
3. **Temps d'exécution** : Le test complet prend environ 5-7 minutes (installation de snapd + microk8s)

## 🎯 Conditions Simulées

L'environnement Docker simule:
- ✅ Ubuntu 22.04 (même version que Killercoda)
- ✅ Pas de snap préinstallé (comme Killercoda)
- ✅ PATH par défaut (sans /snap/bin)
- ✅ Outils de base (curl, wget, vim, git)

## 🔧 Tester d'autres scénarios

Pour tester le scénario 2 par exemple:

```bash
# Copier les scripts du scénario 2
cp ../02-exposer-via-ingress/setup.sh .
cp ../02-exposer-via-ingress/foreground.sh .
cp ../02-exposer-via-ingress/verify-step1.sh .

# Reconstruire et lancer
./test-scenario.sh
```

## ✅ Résultats Attendus

Si tout fonctionne correctement, vous devriez voir:

```
✅ Setup terminé avec succès
✅ microk8s est dans le PATH
✅ Microk8s est installé et fonctionnel
🎉 Test terminé
```

## ❌ En cas d'erreur

Consultez les logs:

```bash
docker run -it --rm --privileged \
  -v /sys/fs/cgroup:/sys/fs/cgroup:rw \
  killercoda-test /bin/bash -c "cat /tmp/setup.log"
```
