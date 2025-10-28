# Étape 3 : Créer l'Ingress

## 📝 Objectif

Créer une ressource **Ingress** pour exposer notre application avec un nom de domaine.

## 🎓 Anatomie d'un Ingress

Un Ingress définit :
- **Host** : Le nom de domaine (ex: app.example.com)
- **Paths** : Les chemins URL à router (ex: /)
- **Backend** : Le Service cible et son port
- **Règles** : Où envoyer le trafic selon l'URL

## 📄 Créer l'Ingress

```bash
cat > web-ingress.yaml <<EOF
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
EOF
```{{exec}}

## 🔍 Explication

- **`ingressClassName: public`** : Utilise le Nginx Ingress Controller
- **`host: web.local`** : Nom de domaine (simulé localement)
- **`path: /`** : Toutes les URLs commençant par /
- **`pathType: Prefix`** : Matcher tous les paths commençant par /
- **`backend.service.name`** : Le Service à contacter
- **`annotations.rewrite-target`** : Réécrire l'URL avant de l'envoyer au backend

## 🚀 Appliquer l'Ingress

```bash
microk8s kubectl apply -f web-ingress.yaml
```{{exec}}

## ✅ Vérifier l'Ingress

```bash
microk8s kubectl get ingress web-ingress
```{{exec}}

Vous verrez :
- **HOSTS** : web.local
- **ADDRESS** : L'IP du LoadBalancer (peut prendre quelques secondes)
- **PORTS** : 80

## 🔎 Détails de l'Ingress

```bash
microk8s kubectl describe ingress web-ingress
```{{exec}}

Regardez la section **Rules** :
```
Host        Path  Backends
----        ----  --------
web.local
            /   web-service:80 (10.1.x.x:80,10.1.x.x:80)
```

L'Ingress Controller a automatiquement :
- Détecté notre nouvelle ressource Ingress
- Configuré Nginx pour router `web.local/` vers `web-service`
- Résolu les endpoints du Service

## 🎯 Points Clés

- ✅ L'Ingress est juste une **configuration**
- ✅ Le Controller **lit** cette configuration et configure Nginx
- ✅ Le trafic passe par : **Client → Ingress Controller → Service → Pods**
- ✅ Un seul Ingress peut gérer **plusieurs domaines et paths**

---

Cliquez sur **Continue** pour tester l'accès.
