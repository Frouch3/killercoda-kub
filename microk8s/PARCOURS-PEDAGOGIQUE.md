# 📚 Parcours Pédagogique Microk8s - Killercoda

Formation complète et progressive sur Kubernetes avec Microk8s (12 exercices, ~6h15).

---

## 🎯 Niveau Beginner (01-06) - 3h00

### 01. Déployer Nginx sur Kubernetes
**Durée** : 30-45 minutes
**Concepts** : Deployment, Service, Scaling, Rolling Update, kubectl essentiels
**Prérequis** : Aucun

### 02. ConfigMaps et Secrets
**Durée** : 25 minutes
**Concepts** : Configuration non-sensible vs sensible, env vars, volumes, bonnes pratiques sécurité
**Prérequis** : 01

### 03. Health Checks et Probes
**Durée** : 30 minutes
**Concepts** : Liveness, Readiness, Startup probes, auto-healing, zero-downtime
**Prérequis** : 01-02

### 04. Exposer via Ingress
**Durée** : 30 minutes
**Concepts** : Ingress Controller, routing HTTP, path-based routing, différence Service vs Ingress
**Prérequis** : 01-03

### 05. Stockage Persistant avec PVC
**Durée** : 30 minutes
**Concepts** : PersistentVolumes, PersistentVolumeClaims, StorageClasses, persistance des données
**Prérequis** : 01-04

### 06. Resource Limits et QoS
**Durée** : 25 minutes
**Concepts** : Requests vs Limits (CPU/RAM), QoS classes, OOMKilled, isolation ressources
**Prérequis** : 01-05

---

## 🚀 Niveau Intermediate (07-11) - 2h35

### 07. Autoscaling avec HPA
**Durée** : 30 minutes
**Concepts** : Metrics Server, Horizontal Pod Autoscaler, scaling automatique sous charge
**Prérequis** : 01-06

### 08. StatefulSets et PostgreSQL
**Durée** : 35 minutes
**Concepts** : Deployment vs StatefulSet, identité stable, ordre garanti, headless services, PostgreSQL
**Prérequis** : 01-06

### 09. Jobs et CronJobs
**Durée** : 25 minutes
**Concepts** : Run-to-completion, batch processing, tâches planifiées, retry policies
**Prérequis** : 01-06

### 10. Déployer Symfony avec PostgreSQL
**Durée** : 45 minutes
**Concepts** : Application complète, StatefulSet DB, Jobs migration, PHP-FPM + Nginx, Ingress
**Prérequis** : 01-09

### 11. Troubleshooting et Debugging
**Durée** : 40 minutes
**Concepts** : CrashLoopBackOff, ImagePullBackOff, Pending, réseau DNS, logs, events, cheatsheet
**Prérequis** : 01-10

---

## 🔬 Niveau Advanced (12) - 0h40

### 12. Observabilité avec Signoz
**Durée** : 40 minutes
**Concepts** : OpenTelemetry, traces distribuées, métriques, logs, instrumentation
**Prérequis** : 01-11

---

## 📊 Progression Recommandée

```
Débutant (6 exercices, 3h)
   ↓
   01. Nginx (bases K8s)
   ↓
   02. ConfigMaps/Secrets (configuration)
   ↓
   03. Health Checks (résilience)
   ↓
   04. Ingress (exposition)
   ↓
   05. PVC (stockage)
   ↓
   06. Resource Limits (optimisation)

Intermédiaire (5 exercices, 2h35)
   ↓
   07. HPA (autoscaling)
   ↓
   08. StatefulSets (apps stateful)
   ↓
   09. Jobs/CronJobs (tâches batch)
   ↓
   10. Symfony complet (app réelle)
   ↓
   11. Troubleshooting (debugging)

Avancé (1 exercice, 0h40)
   ↓
   12. Signoz (observabilité)
```

---

## 🎓 Compétences Acquises

### Après Beginner (01-06)
✅ Déployer et gérer des applications sur Kubernetes
✅ Configurer et sécuriser les applications
✅ Exposer les services via Ingress
✅ Gérer le stockage persistant
✅ Optimiser les ressources
✅ Assurer la résilience avec health checks

### Après Intermediate (07-11)
✅ Autoscaler automatiquement selon la charge
✅ Déployer des bases de données et apps stateful
✅ Exécuter des tâches batch et planifiées
✅ Déployer une application complète (Symfony + PostgreSQL)
✅ Diagnostiquer et résoudre les problèmes courants

### Après Advanced (12)
✅ Monitorer et tracer les applications en production
✅ Instrumenter avec OpenTelemetry
✅ Analyser les performances et détecter les goulots

---

## 🛠️ Concepts Kubernetes Couverts

| Concept | Exercice(s) | Niveau |
|---------|-------------|--------|
| **Pods** | 01-03 | Beginner |
| **Deployments** | 01, 03-06 | Beginner |
| **Services** | 01, 04-05, 08 | Beginner |
| **Ingress** | 04, 10 | Beginner |
| **ConfigMaps** | 02, 10 | Beginner |
| **Secrets** | 02, 08, 10 | Beginner |
| **Probes (Health Checks)** | 03, 08, 10 | Beginner |
| **PersistentVolumes/Claims** | 05, 08, 10 | Beginner |
| **Resource Limits** | 06, 07, 10 | Beginner |
| **HorizontalPodAutoscaler** | 07 | Intermediate |
| **StatefulSets** | 08, 10 | Intermediate |
| **Jobs** | 09, 10 | Intermediate |
| **CronJobs** | 09 | Intermediate |
| **Headless Services** | 08 | Intermediate |
| **Init Containers** | 10, 11 | Intermediate |
| **Multi-container Pods** | 10, 11 | Intermediate |
| **Observability (OTel)** | 12 | Advanced |

---

## 📖 Workloads Kubernetes Couverts

| Workload | Description | Exercice |
|----------|-------------|----------|
| **Deployment** | Apps stateless, replicas identiques | 01-07, 10 |
| **StatefulSet** | Apps stateful, identité stable | 08, 10 |
| **Job** | Tâche unique (run-to-completion) | 09, 10 |
| **CronJob** | Tâche planifiée (schedule) | 09 |
| **DaemonSet** | (Non couvert) | - |

---

## 🎯 Objectifs Pédagogiques par Phase

### Phase 1 : Fondamentaux (01-04)
- Comprendre les objets de base (Pod, Deployment, Service)
- Gérer la configuration (ConfigMaps, Secrets)
- Assurer la résilience (Health Checks)
- Exposer les applications (Ingress)

### Phase 2 : Stockage et Ressources (05-06)
- Gérer la persistance des données (PVC)
- Optimiser les ressources (Limits, QoS)

### Phase 3 : Scaling et État (07-08)
- Autoscaler automatiquement (HPA)
- Gérer les applications stateful (StatefulSets)

### Phase 4 : Tâches et Production (09-11)
- Exécuter des tâches batch (Jobs/CronJobs)
- Déployer une app complète (Symfony)
- Diagnostiquer les problèmes (Troubleshooting)

### Phase 5 : Observabilité (12)
- Monitorer et tracer (Signoz, OpenTelemetry)

---

## 🚀 Utilisation

### Pour un Débutant Complet
1. Suivre l'ordre 01 → 12 (6h15 total)
2. Ne pas sauter d'exercices (prérequis importants)
3. Refaire les exercices 01-06 si nécessaire

### Pour un Utilisateur avec Expérience Docker
1. Commencer par 01 (bases K8s)
2. Accélérer sur 02-04 (concepts familiers)
3. Se concentrer sur 05-12 (spécificités K8s)

### Pour un Utilisateur K8s Confirmé
1. Révision rapide 01-06 (1h)
2. Focus sur 08-12 (apps stateful, troubleshooting, observabilité)

---

## 📝 Notes pour Formateurs

- **Exercices clés** : 01 (bases), 03 (résilience), 08 (stateful), 10 (complet), 11 (troubleshooting)
- **Exercices rapides** : 02, 06, 09 (25 min chacun)
- **Exercices complexes** : 10 (Symfony), 11 (troubleshooting), 12 (observabilité)
- **Points de pause** : Après 06 (fin Beginner), après 11 (fin Intermediate)

---

## 🔗 Ressources Complémentaires

- [Documentation Kubernetes](https://kubernetes.io/docs/home/)
- [Documentation Microk8s](https://microk8s.io/docs)
- [Cheatsheet kubectl](../CHEATSHEET.md)
- [Scénarios de debugging](../DEBUGGING-SCENARIOS.md)

---

**Formation créée par François Crespin**
**Dernière mise à jour** : Octobre 2025
