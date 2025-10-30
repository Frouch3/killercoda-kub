# 🎉 Félicitations !

Vous avez terminé l'exercice sur le **Troubleshooting et Debugging** dans Kubernetes !

## 📚 Ce que vous avez appris

### Problèmes Diagnostiqués et Résolus

✅ **CrashLoopBackOff** : Pod qui redémarre en boucle
- Commandes ou configuration incorrectes
- Utiliser `kubectl logs` et `kubectl logs --previous`

✅ **ImagePullBackOff** : Image Docker introuvable
- Vérifier nom et tag de l'image
- Credentials pour registries privés avec `imagePullSecrets`

✅ **Pod Pending** : Ressources insuffisantes
- Vérifier les requests/limits
- Analyser les ressources des nœuds avec `kubectl describe node`

✅ **Problèmes Réseau/DNS** : Pods qui ne communiquent pas
- Tester avec `nslookup`, `wget`, `curl`
- Vérifier les endpoints des services

✅ **Init Container Échoue** : Conteneur principal ne démarre pas
- Diagnostiquer avec `kubectl logs -c <init-container>`
- Comprendre l'exécution séquentielle

## 🔍 Méthodologie de Debugging

### Les 4 Piliers

```
1. LOGS     → kubectl logs <pod> [-c <container>] [--previous]
2. DESCRIBE → kubectl describe pod/node/service <name>
3. EVENTS   → kubectl get events [--field-selector ...]
4. EXEC     → kubectl exec <pod> -- <command>
```

### Processus de Debug Étape par Étape

```
1. Identifier le problème
   └─> kubectl get pods

2. Voir l'état détaillé
   └─> kubectl describe pod <name>

3. Consulter les logs
   └─> kubectl logs <pod> [-c <container>]

4. Vérifier les events
   └─> kubectl get events --sort-by='.lastTimestamp'

5. Tester en interactif
   └─> kubectl exec -it <pod> -- /bin/sh

6. Corriger et vérifier
   └─> kubectl apply -f ... && kubectl get pods
```

## 🎯 Cheatsheet : Commandes Essentielles

### Status et État

```bash
# Voir tous les pods avec leur état
kubectl get pods -A

# Watch en temps réel
kubectl get pods -w

# Filtrer par status
kubectl get pods --field-selector=status.phase=Pending

# Voir les restarts
kubectl get pods -o custom-columns=NAME:.metadata.name,RESTARTS:.status.containerStatuses[0].restartCount
```

### Logs

```bash
# Logs du conteneur principal
kubectl logs <pod>

# Logs d'un conteneur spécifique
kubectl logs <pod> -c <container>

# Logs du conteneur précédent (crashé)
kubectl logs <pod> --previous

# Suivre les logs en temps réel
kubectl logs <pod> -f

# 50 dernières lignes
kubectl logs <pod> --tail=50

# Logs depuis les 5 dernières minutes
kubectl logs <pod> --since=5m

# Logs de tous les pods d'un deployment
kubectl logs -l app=myapp --all-containers=true
```

### Describe et Events

```bash
# Détails + Events d'un pod
kubectl describe pod <pod>

# Détails d'un nœud
kubectl describe node <node>

# Détails d'un service
kubectl describe service <service>

# Tous les events, triés par date
kubectl get events --sort-by='.lastTimestamp'

# Events d'un pod spécifique
kubectl get events --field-selector involvedObject.name=<pod>

# Events warnings uniquement
kubectl get events --field-selector type=Warning
```

### Exec et Debug

```bash
# Exécuter une commande
kubectl exec <pod> -- <command>

# Shell interactif
kubectl exec -it <pod> -- /bin/sh

# Multi-container : spécifier le conteneur
kubectl exec -it <pod> -c <container> -- /bin/sh

# Tester réseau
kubectl exec <pod> -- curl <url>
kubectl exec <pod> -- wget -qO- <url>
kubectl exec <pod> -- nc -zv <host> <port>

# Tester DNS
kubectl exec <pod> -- nslookup <service>
kubectl exec <pod> -- cat /etc/resolv.conf

# Variables d'environnement
kubectl exec <pod> -- env

# Processus en cours
kubectl exec <pod> -- ps aux
```

### Ressources

```bash
# Utilisation des nœuds
kubectl top nodes

# Utilisation des pods
kubectl top pods

# Capacité et allocation d'un nœud
kubectl describe node <node> | grep -A 5 "Allocated resources"

# Requests et limits de tous les pods
kubectl get pods -o custom-columns=NAME:.metadata.name,CPU_REQ:.spec.containers[*].resources.requests.cpu,MEM_REQ:.spec.containers[*].resources.requests.memory
```

### Réseau

```bash
# Endpoints d'un service
kubectl get endpoints <service>

# Détails d'un service (selector, endpoints)
kubectl describe service <service>

# IP d'un pod
kubectl get pod <pod> -o jsonpath='{.status.podIP}'

# Labels d'un pod
kubectl get pod <pod> --show-labels

# Tester si un service a des endpoints
kubectl get endpoints <service> -o jsonpath='{.subsets[*].addresses[*].ip}'
```

### Images

```bash
# Images utilisées par les pods
kubectl get pods -o jsonpath='{.items[*].spec.containers[*].image}' | tr ' ' '\n' | sort -u

# Voir les image pull policies
kubectl get pods -o custom-columns=NAME:.metadata.name,IMAGE:.spec.containers[0].image,POLICY:.spec.containers[0].imagePullPolicy

# Secrets pour pull d'images
kubectl get secrets --field-selector type=kubernetes.io/dockerconfigjson
```

## 🚨 Problèmes Courants et Solutions Rapides

### CrashLoopBackOff
```bash
# Voir pourquoi
kubectl logs <pod> --previous
kubectl describe pod <pod>

# Causes : commande invalide, app qui crashe, config manquante
```

### ImagePullBackOff
```bash
# Voir l'erreur exacte
kubectl describe pod <pod> | grep -A 10 Events

# Causes : typo dans l'image, tag inexistant, registry privé sans credentials
```

### Pending
```bash
# Voir pourquoi pas schedulé
kubectl describe pod <pod> | grep -A 10 Events

# Vérifier ressources du nœud
kubectl describe node | grep -A 5 "Allocated resources"

# Causes : ressources insuffisantes, nodeSelector qui ne matche pas, taints
```

### Service ne répond pas
```bash
# Vérifier endpoints
kubectl get endpoints <service>

# Vérifier selector
kubectl describe service <service>

# Tester DNS
kubectl exec <pod> -- nslookup <service>

# Causes : selector incorrect, pas de pods avec les bons labels, service mal configuré
```

### Init Container échoue
```bash
# Voir les logs de l'init container
kubectl logs <pod> -c <init-container-name>

# Lister les init containers
kubectl get pod <pod> -o jsonpath='{.spec.initContainers[*].name}'

# Causes : commande échoue, dépendance non disponible, timeout
```

## 🏆 Bonnes Pratiques

### ✅ À FAIRE

- **Logs structurés** : Utiliser JSON pour faciliter le parsing
- **Health checks** : Implémenter liveness et readiness probes
- **Resources** : Toujours définir requests et limits
- **Labels** : Utiliser des labels cohérents et descriptifs
- **Monitoring** : Mettre en place Prometheus, Grafana, ou autre
- **Alerting** : Configurer des alertes sur les crashs et pending
- **Centralisation logs** : ELK, Loki, ou équivalent
- **Events** : Exporter les events pour l'historique (ils expirent après 1h)

### ❌ À ÉVITER

- Ne pas ignorer les warnings
- Ne pas négliger les requests/limits
- Ne pas utiliser `latest` en production
- Ne pas laisser tourner des pods en CrashLoopBackOff
- Ne pas oublier de nettoyer les ressources de test
- Ne pas avoir des logs trop verbeux (perf)

## 🛠️ Outils Avancés

### kubectl debug (Kubernetes 1.23+)
```bash
# Créer un pod de debug éphémère
kubectl debug <pod> -it --image=busybox

# Copier un pod pour debug
kubectl debug <pod> -it --copy-to=<pod>-debug --container=debug
```

### stern (Multi-pod logs)
```bash
stern <pod-prefix>
stern <pod-prefix> -c <container>
stern --selector app=myapp
```

### k9s (UI Terminal)
Interface TUI pour gérer et déboguer Kubernetes.

### kubectl-trace
Tracer les appels système avec BPF.

## 🔄 Prochaines Étapes

Pour aller plus loin :

1. **Monitoring** : Prometheus + Grafana
2. **Tracing** : Jaeger, Zipkin
3. **Logs Centralisés** : ELK, Loki
4. **Service Mesh** : Istio, Linkerd (observabilité avancée)
5. **eBPF** : Pixie, Hubble (deep visibility)

## 🧹 Nettoyage Final

Supprimer toutes les ressources créées dans cet exercice :

```bash
microk8s kubectl delete pod --all
microk8s kubectl delete service backend-service broken-service
```{{exec}}

---

## 🎓 Récapitulatif

Vous maîtrisez maintenant :
- Les 4 piliers du debugging (logs, describe, events, exec)
- Le diagnostic de 5 problèmes courants
- Les commandes essentielles pour troubleshooter
- Les bonnes pratiques de debugging

**Bravo pour votre travail ! Vous êtes maintenant équipé pour résoudre la plupart des problèmes dans Kubernetes. 🚀**
