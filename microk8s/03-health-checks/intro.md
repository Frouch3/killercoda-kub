# Bienvenue dans l'Exercice 3.5 : Health Checks et Probes

## 🎯 Objectifs

Dans cet exercice, vous allez apprendre à :

- ✅ Configurer des **Liveness Probes** (redémarrage automatique)
- ✅ Configurer des **Readiness Probes** (gestion du trafic)
- ✅ Configurer des **Startup Probes** (applications lentes)
- ✅ Simuler des défaillances et observer le comportement
- ✅ Comprendre les différents types de probes (HTTP, TCP, exec)
- ✅ Appliquer les bonnes pratiques de résilience

## 🎓 Qu'est-ce qu'une Probe ?

Une **Probe** (sonde) est un mécanisme que Kubernetes utilise pour vérifier la santé d'un conteneur.

### Les 3 Types de Probes

| Probe | Objectif | Action si échec |
|-------|----------|-----------------|
| **Liveness** | Le conteneur est-il **vivant** ? | **Redémarre** le conteneur |
| **Readiness** | Le conteneur est-il **prêt** à recevoir du trafic ? | **Retire** du Service (pas de trafic) |
| **Startup** | Le conteneur a-t-il **démarré** ? | Bloque les autres probes |

## 🔍 Pourquoi c'est Important ?

### Sans Probes
- ❌ App crash → Pod reste "Running" → Trafic vers pod mort
- ❌ App en "zombie" (processus bloqué) → Pas de redémarrage
- ❌ App en démarrage lent → Trafic trop tôt → Erreurs 502

### Avec Probes
- ✅ Auto-healing : Redémarrage automatique si crash
- ✅ Zero-downtime : Trafic uniquement vers pods sains
- ✅ Graceful startup : Pas de trafic avant que l'app soit prête

## 🛠️ Mécanismes de Vérification

Kubernetes supporte 3 types de checks :

### 1. **HTTP GET**
```yaml
livenessProbe:
  httpGet:
    path: /health
    port: 8080
  initialDelaySeconds: 10
  periodSeconds: 5
```
✅ **Idéal pour** : APIs web, microservices

### 2. **TCP Socket**
```yaml
livenessProbe:
  tcpSocket:
    port: 5432
  initialDelaySeconds: 5
  periodSeconds: 10
```
✅ **Idéal pour** : Bases de données, caches, TCP services

### 3. **Exec Command**
```yaml
livenessProbe:
  exec:
    command:
    - cat
    - /tmp/healthy
  initialDelaySeconds: 5
  periodSeconds: 5
```
✅ **Idéal pour** : Checks personnalisés, scripts

## 🛠️ Environnement

- Ubuntu 22.04 avec Microk8s
- kubectl configuré

## ⏱️ Durée Estimée

30 minutes

## 🚀 C'est Parti !

Attendez que l'environnement soit prêt (vous verrez "✅ Ready!"), puis cliquez sur **Start**.
