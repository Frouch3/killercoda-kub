# 🎉 Félicitations ! Exercice 2 Terminé !

Vous maîtrisez maintenant l'exposition d'applications via Ingress !

## ✅ Ce que Vous Avez Appris

### 🔧 **Ingress Controller**
- Activer le Nginx Ingress Controller sur Microk8s
- Comprendre son rôle de reverse proxy
- Voir ses logs et sa configuration

### 🌐 **Ressources Ingress**
- Créer une ressource Ingress avec host et paths
- Configurer le routing vers des Services
- Utiliser les annotations pour personnaliser le comportement

### 🔀 **Routing Avancé**
- Path-based routing (/, /api, /admin)
- Host-based routing (plusieurs domaines sur une IP)
- Combiner plusieurs services dans un Ingress

### 🧪 **Tests et Debugging**
- Tester avec curl et headers HTTP
- Simuler des noms de domaine locaux
- Consulter les logs de l'Ingress Controller

## 🎯 Concepts Clés

```
Architecture Ingress:

Internet
   |
   v
[Ingress Controller]  ← Lit les ressources Ingress
   |                  ← Configure Nginx automatiquement
   |
   +-- Host: web.local
   |     +-- Path: /     → web-service → web pods
   |     +-- Path: /api  → api-service → api pods
   |
   +-- Host: admin.local
         +-- Path: /     → admin-service → admin pods
```

## 🚀 Avantages de l'Ingress

- ✅ **Une seule IP** pour exposer plusieurs services
- ✅ **Routing intelligent** au niveau HTTP (L7)
- ✅ **TLS/SSL** centralisé
- ✅ **Moins coûteux** que plusieurs LoadBalancers
- ✅ **Features avancées** : rate-limiting, auth, rewrites, CORS

## 📊 Comparaison : Service vs Ingress

| Aspect | NodePort | LoadBalancer | Ingress |
|--------|----------|--------------|---------|
| **Niveau** | L4 (TCP) | L4 (TCP) | L7 (HTTP) |
| **IP** | IP du nœud | 1 IP par service | 1 IP partagée |
| **Coût** | Gratuit | Payant (cloud) | Gratuit (1 LB) |
| **SSL** | Manuel | Manuel | Automatisé |
| **Routing** | Port seulement | Port seulement | Host + Path |
| **Use Case** | Dev local | Production simple | Production HTTP |

## 💡 Prochaines Étapes

Vous êtes prêt pour :

1. **Exercice 3 : Stockage Persistant (PVC)**
   - Créer des volumes persistants
   - Monter des données dans vos pods
   - Gérer le cycle de vie du stockage

2. **TLS/HTTPS** (Bonus avancé)
   - Générer des certificats
   - Configurer HTTPS dans l'Ingress
   - Forcer la redirection HTTP → HTTPS

3. **Niveau Intermédiaire**
   - Déployer une application Symfony complète
   - Ingress avec base de données
   - Certificats Let's Encrypt automatiques

## 🔧 Commandes à Retenir

```bash
# Activer Ingress Controller
microk8s enable ingress

# Créer un Ingress
kubectl apply -f ingress.yaml

# Lister les Ingress
kubectl get ingress

# Détails d'un Ingress
kubectl describe ingress <name>

# Logs de l'Ingress Controller
kubectl logs -n ingress <pod-name>

# Tester avec curl
curl -H "Host: myapp.local" http://<ingress-ip>
```

## 📚 Ressources

- [Documentation Nginx Ingress](https://kubernetes.github.io/ingress-nginx/)
- [Annotations Nginx Ingress](https://kubernetes.github.io/ingress-nginx/user-guide/nginx-configuration/annotations/)
- [Kubernetes Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/)

## 🧹 Nettoyage (Optionnel)

```bash
microk8s kubectl delete ingress web-ingress
microk8s kubectl delete svc web-service api-service
microk8s kubectl delete deployment web-app api-app
microk8s kubectl delete configmap web-content
```

## 🎓 Certificat

```
╔════════════════════════════════════════════════╗
║                                                ║
║        🎓 CERTIFICAT D'ACCOMPLISSEMENT 🎓     ║
║                                                ║
║       Exercice 2 : Exposer via Ingress         ║
║                                                ║
║              ✅ COMPLÉTÉ AVEC SUCCÈS           ║
║                                                ║
║  Compétences acquises :                        ║
║  • Ingress Controller                          ║
║  • Ressources Ingress                          ║
║  • Path-based Routing                          ║
║  • Host-based Routing                          ║
║  • Debugging HTTP                              ║
║                                                ║
╚════════════════════════════════════════════════╝
```

---

**Excellent travail !** 🚀

Passez à l'Exercice 3 pour découvrir le stockage persistant avec PVC.

**Auteur** : Formation Microk8s
**Version** : 1.0
