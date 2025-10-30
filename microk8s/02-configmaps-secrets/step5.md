# Étape 5 : Monter Secret comme Volume

## 📝 Objectif

Monter un **Secret** comme volume pour gérer des fichiers sensibles de manière sécurisée.

## 🔐 Pourquoi Monter des Secrets ?

Monter des Secrets comme volumes offre plus de sécurité :
- ✅ **Non visible** dans `kubectl describe pod`
- ✅ **Permissions restrictives** (0400 par défaut)
- ✅ Idéal pour **certificats TLS**, clés SSH, tokens
- ✅ **tmpfs** : les Secrets sont montés en RAM (pas sur disque)

## 📄 Créer un Secret pour TLS

Créons un certificat TLS auto-signé (pour la démo) :

```bash
# Générer une clé privée et un certificat
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout /tmp/tls.key \
  -out /tmp/tls.crt \
  -subj "/CN=example.com/O=Demo"
```{{exec}}

Créer un Secret de type TLS :
```bash
microk8s kubectl create secret tls tls-secret \
  --cert=/tmp/tls.crt \
  --key=/tmp/tls.key
```{{exec}}

## 📄 Créer un Pod avec Secret Monté

```bash
cat > app-with-tls.yaml <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: app-with-tls
  labels:
    app: secure
spec:
  containers:
  - name: app
    image: nginx:alpine
    ports:
    - containerPort: 443
    volumeMounts:
    # Monter le certificat TLS dans /etc/nginx/ssl
    - name: tls-volume
      mountPath: /etc/nginx/ssl
      readOnly: true  # Toujours en lecture seule pour les secrets

    # Monter notre SSH key
    - name: ssh-volume
      mountPath: /root/.ssh
      readOnly: true

  volumes:
  # Volume depuis le secret TLS
  - name: tls-volume
    secret:
      secretName: tls-secret
      defaultMode: 0400  # Permissions restrictives

  # Volume depuis le secret SSH
  - name: ssh-volume
    secret:
      secretName: ssh-key
      defaultMode: 0400
      items:
      - key: ssh-privatekey
        path: id_rsa
      - key: ssh-publickey
        path: id_rsa.pub
EOF
```{{exec}}

Appliquer le pod :
```bash
microk8s kubectl apply -f app-with-tls.yaml
```{{exec}}

## 🔍 Vérifier le Montage

Attendre que le pod soit prêt :
```bash
microk8s kubectl wait --for=condition=Ready pod/app-with-tls --timeout=60s
```{{exec}}

Lister les fichiers TLS :
```bash
microk8s kubectl exec app-with-tls -- ls -lah /etc/nginx/ssl
```{{exec}}

Notez les **permissions 0400** (lecture seule pour le propriétaire).

Vérifier le certificat :
```bash
microk8s kubectl exec app-with-tls -- cat /etc/nginx/ssl/tls.crt | head -3
```{{exec}}

Vérifier les clés SSH :
```bash
microk8s kubectl exec app-with-tls -- ls -lah /root/.ssh/
```{{exec}}

## 🔐 Sécurité des Volumes Secrets

Les Secrets montés comme volumes ont plusieurs avantages de sécurité :

### 1. **Montés en tmpfs (RAM)**
```bash
microk8s kubectl exec app-with-tls -- mount | grep ssl
```{{exec}}

Le volume est en **tmpfs** → les secrets ne touchent jamais le disque !

### 2. **Non visibles dans describe**
```bash
microk8s kubectl describe pod app-with-tls | grep -A 10 "Volumes:"
```{{exec}}

Les **valeurs** des secrets ne sont pas affichées (contrairement aux env vars).

### 3. **Permissions restrictives**
```bash
microk8s kubectl exec app-with-tls -- stat -c '%a %n' /etc/nginx/ssl/tls.key
```{{exec}}

Permissions **0400** = lecture seule, propriétaire uniquement.

## 🎯 Comparaison : Env Vars vs Volumes

| Critère | Variables d'Env | Volumes |
|---------|-----------------|---------|
| **Visibilité** | Visible dans `describe` | Masqué |
| **Stockage** | Mémoire du processus | tmpfs (RAM) |
| **Permissions** | Héritées du processus | Contrôlables (0400) |
| **Mise à jour** | Nécessite restart pod | Auto-update (60s) |
| **Usage** | Config simple | Certificats, clés, gros fichiers |

## 🧪 Test de Sécurité

Essayez de modifier le secret (devrait échouer car read-only) :
```bash
microk8s kubectl exec app-with-tls -- sh -c "echo 'hack' > /etc/nginx/ssl/tls.key" 2>&1 || echo "✅ Modification bloquée (read-only)"
```{{exec}}

## 🎯 Options de Montage Avancées

```yaml
volumes:
- name: secret-volume
  secret:
    secretName: mon-secret

    # Permissions des fichiers (0400 recommandé)
    defaultMode: 0400

    # Monter uniquement certaines clés
    items:
    - key: tls.crt
      path: certificate.pem
      mode: 0444  # Permission spécifique pour ce fichier

    # Rendre optionnel
    optional: true
```

## 📚 Récapitulatif

Vous avez appris à :
- ✅ Créer des **ConfigMaps** (config non sensible)
- ✅ Créer des **Secrets** (données sensibles)
- ✅ Injecter via **variables d'environnement**
- ✅ Monter comme **volumes** (ConfigMaps et Secrets)
- ✅ Comprendre les **différences de sécurité**

---

Cliquez sur **Continue** pour terminer l'exercice.
