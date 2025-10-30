# 🎉 Félicitations !

Vous avez terminé l'exercice sur les **ConfigMaps** et **Secrets** !

## 📚 Ce que vous avez appris

### ConfigMaps
- ✅ Créer des ConfigMaps (CLI et YAML)
- ✅ Stocker des paires clé-valeur et des fichiers complets
- ✅ Les utiliser pour la **configuration non sensible**

### Secrets
- ✅ Créer des Secrets (generic, TLS, SSH)
- ✅ Comprendre l'encodage **base64**
- ✅ Gérer des **données sensibles** de manière sécurisée

### Injection
- ✅ **Variables d'environnement** (env, envFrom)
- ✅ **Volumes** (ConfigMaps et Secrets)
- ✅ Comprendre les différences de **sécurité**

## 🎯 Points Clés à Retenir

### 🔐 Sécurité

| ConfigMap | Secret |
|-----------|--------|
| Config **publique** | Données **sensibles** |
| Visible en clair | Encodé base64 |
| Pas de restrictions RBAC strictes | RBAC renforcé |
| Stockage disque normal | tmpfs (RAM) quand monté |

### 📦 Variables d'Env vs Volumes

| Variables d'Env | Volumes |
|----------------|---------|
| Simple à utiliser | Plus sécurisé |
| Visible dans `describe` | Masqué |
| Config statique (restart requis) | Peut s'auto-updater |
| Idéal pour valeurs simples | Idéal pour fichiers complets |

## 🏆 Bonnes Pratiques

### ✅ À FAIRE
- Utiliser **Secrets** pour mots de passe, tokens, certificats
- Utiliser **ConfigMaps** pour URLs, ports, noms de services
- Monter les Secrets comme **volumes** (plus sécurisé)
- Définir **defaultMode: 0400** pour les Secrets
- Utiliser **readOnly: true** pour les volumes secrets
- Activer le **chiffrement au repos** dans etcd (production)
- Utiliser **RBAC** pour limiter l'accès aux Secrets
- Utiliser **External Secrets Operator** ou **Sealed Secrets** en production

### ❌ À ÉVITER
- Ne **JAMAIS** committer de Secrets dans Git
- Ne pas utiliser ConfigMaps pour des données sensibles
- Ne pas logger les valeurs des Secrets
- Éviter `kubectl get secret -o yaml` en production
- Ne pas donner accès large aux Secrets (principle of least privilege)

## 🔄 Mise à Jour Dynamique

Les ConfigMaps/Secrets montés comme volumes se mettent à jour automatiquement :
- **Délai** : jusqu'à 60 secondes (kubelet sync period)
- **Application** : Certaines apps détectent automatiquement (recharge), d'autres nécessitent un signal (SIGHUP)
- **Variables d'env** : Ne se mettent **PAS** à jour (nécessite restart du pod)

## 🚀 Aller Plus Loin

### Outils Avancés
- **Sealed Secrets** : Chiffrer les Secrets pour Git
- **External Secrets Operator** : Sync depuis Vault, AWS Secrets Manager, etc.
- **SOPS** : Chiffrer les fichiers YAML
- **Vault** : Gestionnaire de secrets centralisé
- **cert-manager** : Gestion automatique de certificats TLS

### Prochains Exercices
- **Health Checks** : Liveness et Readiness Probes
- **Resource Limits** : Gérer CPU et RAM
- **StatefulSets** : Applications avec état persistant

## 📖 Commandes à Retenir

```bash
# ConfigMaps
kubectl create configmap <name> --from-literal=key=value
kubectl get configmaps
kubectl describe configmap <name>
kubectl edit configmap <name>

# Secrets
kubectl create secret generic <name> --from-literal=key=value
kubectl create secret tls <name> --cert=tls.crt --key=tls.key
kubectl get secrets
kubectl describe secret <name>

# Debug
kubectl get secret <name> -o jsonpath='{.data.key}' | base64 --decode
kubectl exec <pod> -- env | grep VAR
kubectl exec <pod> -- ls -la /path/to/volume
```

## 🧹 Nettoyage

Si vous voulez nettoyer les ressources créées :

```bash
microk8s kubectl delete pod app-with-config app-with-tls nginx-with-volume
microk8s kubectl delete configmap app-config database-config nginx-config
microk8s kubectl delete secret database-credentials ssh-key tls-secret
microk8s kubectl delete service nginx-svc
```{{exec}}

---

## 🎓 Prochaine Étape

Dans le prochain exercice, vous apprendrez les **Health Checks** (Liveness et Readiness Probes) pour rendre vos applications plus résilientes.

**Bravo pour votre travail ! 🚀**
