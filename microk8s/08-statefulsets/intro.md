# Bienvenue dans l'Exercice 5.5 : StatefulSets et PostgreSQL

## 🎯 Objectifs

Dans cet exercice, vous allez apprendre à :

- ✅ Comprendre la différence entre **Deployment** et **StatefulSet**
- ✅ Déployer **PostgreSQL** avec un StatefulSet
- ✅ Gérer les **PVC dynamiques** par pod
- ✅ Tester la **persistance** des données
- ✅ Observer l'**ordre de création/suppression** des pods
- ✅ Configurer un **Headless Service**

## 🎓 Qu'est-ce qu'un StatefulSet ?

Un **StatefulSet** est un objet Kubernetes pour déployer des applications **stateful** (avec état) qui nécessitent :

### Identité Stable
- Chaque pod a un **nom prévisible** : `postgres-0`, `postgres-1`, `postgres-2`
- Le nom ne change **jamais**, même après redémarrage
- Idéal pour les bases de données, clusters, etc.

### Stockage Persistant par Pod
- Chaque pod a son **propre PVC** dédié
- Le PVC est **conservé** même si le pod est supprimé
- Réattaché automatiquement au même pod

### Ordre de Création et Suppression
- **Création** : `postgres-0` → `postgres-1` → `postgres-2` (séquentiel)
- **Suppression** : `postgres-2` → `postgres-1` → `postgres-0` (inverse)
- Garantit la cohérence pour les systèmes distribués

## 📊 Deployment vs StatefulSet

| Critère | Deployment | StatefulSet |
|---------|-----------|-------------|
| **Nom des pods** | Aléatoire (`app-7f8c9-xyz`) | Prévisible (`app-0`, `app-1`) |
| **Stockage** | PVC partagé ou non persistant | PVC dédié par pod |
| **Ordre** | Parallèle | Séquentiel |
| **Réseau** | IP éphémère | Identité réseau stable |
| **Cas d'usage** | Apps stateless (API, web) | Apps stateful (DB, cache) |

## 🔍 Pourquoi PostgreSQL Nécessite un StatefulSet ?

PostgreSQL est une base de données **stateful** :

1. **Données persistantes** : Chaque pod stocke des données
2. **Identité stable** : Pour la réplication (master/replica)
3. **Ordre important** : Le master doit démarrer avant les replicas
4. **DNS prévisible** : `postgres-0.postgres-service` pour se connecter

## 🛠️ Environnement

- Ubuntu 22.04 avec Microk8s
- kubectl configuré
- Storage class disponible

## ⏱️ Durée Estimée

35 minutes

## 🚀 C'est Parti !

Attendez que l'environnement soit prêt (vous verrez "✅ Ready!"), puis cliquez sur **Start**.
