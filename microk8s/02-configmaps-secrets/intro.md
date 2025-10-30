# Bienvenue dans l'Exercice 2.5 : ConfigMaps et Secrets

## 🎯 Objectifs

Dans cet exercice, vous allez apprendre à :

- ✅ Créer et gérer des **ConfigMaps** pour la configuration
- ✅ Créer et gérer des **Secrets** pour les données sensibles
- ✅ Injecter configuration via **variables d'environnement**
- ✅ Monter ConfigMaps et Secrets comme **volumes**
- ✅ Différencier données sensibles vs non-sensibles
- ✅ Appliquer les **bonnes pratiques** de sécurité

## 🎓 ConfigMaps vs Secrets

### ConfigMap
Un **ConfigMap** stocke des données de configuration **non sensibles** :
- Variables d'environnement (URLs, ports, noms de services)
- Fichiers de configuration (nginx.conf, application.yaml)
- Paramètres applicatifs publics

**Format** : Données en clair (non chiffrées)

### Secret
Un **Secret** stocke des données **sensibles** :
- Mots de passe et tokens
- Clés API
- Certificats TLS
- Credentials de base de données

**Format** : Données encodées en base64 (dans etcd, elles peuvent être chiffrées au repos)

## 🔐 Pourquoi séparer ?

- ✅ **Sécurité** : Les Secrets ont des contrôles d'accès renforcés (RBAC)
- ✅ **Audit** : On peut tracer l'accès aux Secrets
- ✅ **Chiffrement** : Possibilité de chiffrer les Secrets dans etcd
- ✅ **Bonnes pratiques** : Séparation des préoccupations

## 🛠️ Environnement

- Ubuntu 22.04 avec Microk8s
- kubectl configuré

## ⏱️ Durée Estimée

25 minutes

## 🚀 C'est Parti !

Attendez que l'environnement soit prêt (vous verrez "✅ Ready!"), puis cliquez sur **Start**.
