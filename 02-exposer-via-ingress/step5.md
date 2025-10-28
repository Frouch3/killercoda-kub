# Étape 5 : Multiple Paths (Routing Avancé)

## 📝 Objectif

Configurer plusieurs paths dans le même Ingress pour router vers différents services.

## 🎓 Path-Based Routing

L'Ingress peut router selon le **path** de l'URL :
- `web.local/` → Service A
- `web.local/api` → Service B
- `web.local/admin` → Service C

C'est très utile pour :
- Séparer frontend et backend
- Microservices sur différents paths
- APIs versionnées (v1, v2)

## 🚀 Déployer une Deuxième Application (API)

Créons une application "API" simple :

```bash
cat > api-deployment.yaml <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: api
  template:
    metadata:
      labels:
        app: api
    spec:
      containers:
      - name: api
        image: hashicorp/http-echo
        args:
        - "-text={\"status\":\"ok\",\"service\":\"api\",\"version\":\"1.0\"}"
        ports:
        - containerPort: 5678
---
apiVersion: v1
kind: Service
metadata:
  name: api-service
spec:
  selector:
    app: api
  ports:
  - protocol: TCP
    port: 80
    targetPort: 5678
EOF
```{{exec}}

```bash
microk8s kubectl apply -f api-deployment.yaml
```{{exec}}

## 📄 Mettre à Jour l'Ingress avec Multiple Paths

```bash
cat > web-ingress-multi.yaml <<EOF
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: web-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  ingressClassName: public
  rules:
  - host: web.local
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: web-service
            port:
              number: 80
      - path: /api
        pathType: Prefix
        backend:
          service:
            name: api-service
            port:
              number: 80
EOF
```{{exec}}

```bash
microk8s kubectl apply -f web-ingress-multi.yaml
```{{exec}}

## ✅ Tester le Routing

Test 1 : Accéder au frontend (/) :

```bash
curl http://web.local/ | head -5
```{{exec}}

Vous voyez le HTML de l'application web.

Test 2 : Accéder à l'API (/api) :

```bash
curl http://web.local/api
```{{exec}}

Vous voyez la réponse JSON de l'API ! 🎉

## 🔍 Comprendre le Routing

L'Ingress Controller a configuré Nginx pour :
```
web.local/      → web-service:80
web.local/api   → api-service:80
web.local/api/* → api-service:80
```

Tout se passe dans le **même Ingress**, sur la **même IP** !

## 📊 Voir la Configuration Effective

```bash
microk8s kubectl describe ingress web-ingress
```{{exec}}

La section **Rules** montre maintenant les 2 paths :
```
Host        Path    Backends
----        ----    --------
web.local
            /       web-service:80
            /api    api-service:80
```

## 🧪 Test Avancé : Multiples Requêtes

```bash
echo "=== Test Frontend ==="
curl -s http://web.local/ | grep "<h1>"

echo ""
echo "=== Test API ==="
curl -s http://web.local/api

echo ""
echo "=== Test API avec path ==="
curl -s http://web.local/api/users
```{{exec}}

## 🎯 Points Clés

- ✅ Un seul Ingress peut gérer **plusieurs services**
- ✅ Le routing se fait au niveau **HTTP/L7** (pas TCP/L4)
- ✅ Plus flexible et économique que plusieurs LoadBalancers
- ✅ Permet l'architecture **microservices** facilement

## 🔧 PathType : Prefix vs Exact

- **Prefix** : `/api` matche `/api`, `/api/users`, `/api/v1/...`
- **Exact** : `/api` matche **uniquement** `/api` (pas `/api/users`)

Exemple avec Exact :

```yaml
- path: /api
  pathType: Exact  # Seulement /api exact
```

## 💡 Annotations Utiles

```yaml
annotations:
  # Réécrire l'URL
  nginx.ingress.kubernetes.io/rewrite-target: /$2

  # Rate limiting
  nginx.ingress.kubernetes.io/limit-rps: "10"

  # CORS
  nginx.ingress.kubernetes.io/enable-cors: "true"

  # Timeouts
  nginx.ingress.kubernetes.io/proxy-read-timeout: "600"

  # Authentification basique
  nginx.ingress.kubernetes.io/auth-type: basic
  nginx.ingress.kubernetes.io/auth-secret: basic-auth
```

## 🏗️ Architecture Finale

```
Internet
   |
   v
Ingress Controller (Nginx)
   |
   +-- web.local/ --> web-service --> web-app pods
   |
   +-- web.local/api --> api-service --> api-app pods
```

---

Félicitations ! Vous maîtrisez l'Ingress !

Cliquez sur **Continue** pour le résumé final.
