# Bienvenue dans l'Exercice 10 : Troubleshooting et Debugging

## 🎯 Objectifs

Dans cet exercice, vous allez apprendre à :

- ✅ Diagnostiquer un **CrashLoopBackOff** et corriger un pod qui crashe
- ✅ Résoudre un **ImagePullBackOff** (image inexistante)
- ✅ Déboguer un **Pod Pending** (ressources insuffisantes)
- ✅ Résoudre des **problèmes réseau** et DNS entre pods
- ✅ Analyser les **Init Containers** qui échouent
- ✅ Maîtriser les commandes essentielles de debugging

## 🔍 Les 4 Piliers du Debugging Kubernetes

### 1. LOGS
```bash
kubectl logs <pod>                    # Logs du conteneur
kubectl logs <pod> -c <container>     # Multi-container
kubectl logs <pod> --previous         # Logs du conteneur crashé
kubectl logs <pod> --tail=50          # 50 dernières lignes
kubectl logs <pod> -f                 # Suivre en temps réel
```

### 2. DESCRIBE
```bash
kubectl describe pod <pod>            # Détails + Events
kubectl describe node <node>          # État du nœud
kubectl describe service <svc>        # Endpoints du service
```

### 3. EVENTS
```bash
kubectl get events                    # Tous les événements
kubectl get events --sort-by='.lastTimestamp'
kubectl get events --field-selector involvedObject.name=<pod>
```

### 4. EXEC
```bash
kubectl exec <pod> -- <command>       # Exécuter une commande
kubectl exec -it <pod> -- /bin/sh     # Shell interactif
kubectl exec <pod> -- curl <url>      # Tester réseau
kubectl exec <pod> -- nslookup <svc>  # Tester DNS
```

## 🚨 Scénarios Courants

Ce tutoriel couvre 5 scénarios réalistes :

1. **CrashLoopBackOff** : Application qui redémarre en boucle
2. **ImagePullBackOff** : Image Docker introuvable
3. **Pending** : Ressources CPU/RAM insuffisantes
4. **Réseau/DNS** : Pods qui ne communiquent pas
5. **Init Container** : Initialisation qui échoue

## 🛠️ Environnement

- Ubuntu 22.04 avec Microk8s
- kubectl configuré
- Namespace par défaut

## ⏱️ Durée Estimée

40 minutes

## 🚀 C'est Parti !

Attendez que l'environnement soit prêt (vous verrez "✅ Ready!"), puis cliquez sur **Start**.
