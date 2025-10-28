# Étape 1 : Activer l'Ingress Controller

## 📝 Objectif

Activer le **Nginx Ingress Controller** sur Microk8s pour gérer le trafic entrant.

## 🎓 Qu'est-ce qu'un Ingress Controller ?

Un **Ingress Controller** est un composant qui :
- Lit les ressources **Ingress** que vous créez
- Configure automatiquement un **reverse proxy** (Nginx dans notre cas)
- Route le trafic HTTP/HTTPS vers les bons services
- Gère le load-balancing et le SSL/TLS

Sans Ingress Controller, les ressources Ingress ne font rien !

## 🚀 Activer l'Addon Ingress

Microk8s fournit un addon Ingress clé en main :

```bash
microk8s enable ingress
```{{exec}}

Cette commande va :
- Déployer le **Nginx Ingress Controller** dans le namespace `ingress`
- Créer un Service de type **NodePort** pour recevoir le trafic
- Configurer les permissions nécessaires (RBAC)

L'activation prend environ 30-60 secondes.

## ✅ Vérifier l'Installation

Attendons que tous les pods de l'Ingress Controller soient prêts :

```bash
microk8s kubectl wait --namespace ingress \
  --for=condition=ready pod \
  --selector=name=nginx-ingress-microk8s \
  --timeout=120s
```{{exec}}

## 🔍 Explorer les Ressources Créées

Voir les pods de l'Ingress Controller :

```bash
microk8s kubectl get pods -n ingress
```{{exec}}

Vous devriez voir un pod `nginx-ingress-microk8s-controller-xxxxx` en état **Running**.

## 📊 Voir le Service de l'Ingress

```bash
microk8s kubectl get svc -n ingress
```{{exec}}

Le service expose les ports :
- **80** : Trafic HTTP
- **443** : Trafic HTTPS

## 🔎 Détails de l'Ingress Controller

```bash
microk8s kubectl describe pod -n ingress -l name=nginx-ingress-microk8s
```{{exec}}

Vous verrez que le pod :
- Utilise l'image `registry.k8s.io/ingress-nginx/controller`
- Monte des volumes pour la configuration
- A des arguments pour configurer Nginx

## 🎯 Points Clés

- ✅ L'Ingress Controller est un **pod comme les autres**
- ✅ Il écoute sur les **ports 80 et 443**
- ✅ Il surveille les ressources **Ingress** et se configure automatiquement
- ✅ Sans lui, les Ingress que vous créez ne font rien

## 💡 En Production

En production, on utilise souvent :
- **Nginx Ingress Controller** (ce que nous utilisons)
- **Traefik** (populaire, moderne)
- **HAProxy Ingress**
- **Istio Gateway** (pour service mesh)
- **AWS ALB Ingress** (sur AWS)
- **GCP Ingress** (sur GCP)

---

Cliquez sur **Continue** pour déployer une application.
