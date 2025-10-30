# Bienvenue dans l'Exercice 2 : Exposer via Ingress

## 🎯 Objectifs

Dans cet exercice, vous allez apprendre à :

- ✅ Activer et configurer un **Ingress Controller** (Nginx)
- ✅ Créer une ressource **Ingress** pour exposer votre application
- ✅ Configurer des **routes HTTP** basées sur les paths
- ✅ Comprendre la différence entre Service et Ingress
- ✅ Tester l'accès via un nom de domaine local

## 🎓 Qu'est-ce qu'un Ingress ?

Un **Ingress** est un objet Kubernetes qui gère l'accès externe aux services :
- Expose plusieurs services via une **seule IP**
- Permet le **routing** basé sur l'URL (path-based routing)
- Supporte le **TLS/HTTPS**
- Fournit le **load-balancing** au niveau HTTP
- Bien plus puissant qu'un simple NodePort

## 🛠️ Environnement

Cet environnement contient :
- **Ubuntu 22.04** avec Microk8s
- **Nginx Ingress Controller** (sera activé dans l'exercice)
- kubectl configuré

## ⏱️ Durée Estimée

30 minutes

## 🚀 C'est Parti !

Attendez que l'environnement soit prêt (vous verrez "✅ Ready!"), puis cliquez sur **Start**.
