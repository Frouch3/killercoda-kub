# Étape 4 : Monter ConfigMap comme Volume

## 📝 Objectif

Monter un **ConfigMap** comme volume dans un pod pour créer des fichiers de configuration.

## 🎓 Pourquoi des Volumes ?

Monter des ConfigMaps comme volumes permet de :
- ✅ Créer des **fichiers de configuration** complets (nginx.conf, application.yaml)
- ✅ Mettre à jour la config **sans redémarrer** le pod (avec subPath optionnel)
- ✅ Organiser plusieurs fichiers dans un répertoire
- ✅ Plus propre que des variables d'environnement pour les gros fichiers

## 📄 Créer un ConfigMap pour Nginx

Créons un ConfigMap avec une configuration nginx complète :

```bash
cat > nginx-config.yaml <<EOF
apiVersion: v1
kind: ConfigMap
metadata:
  name: nginx-config
data:
  nginx.conf: |
    events {
      worker_connections 1024;
    }
    http {
      server {
        listen 80;
        server_name localhost;

        location / {
          return 200 "Hello from ConfigMap!\n";
          add_header Content-Type text/plain;
        }

        location /health {
          return 200 "OK\n";
        }
      }
    }

  custom.conf: |
    # Fichier de configuration personnalisé
    client_max_body_size 50M;
    keepalive_timeout 65;
EOF
```{{exec}}

Appliquer le ConfigMap :
```bash
microk8s kubectl apply -f nginx-config.yaml
```{{exec}}

## 📄 Créer un Pod qui Monte le ConfigMap

```bash
cat > nginx-with-volume.yaml <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: nginx-with-volume
  labels:
    app: nginx
spec:
  containers:
  - name: nginx
    image: nginx:alpine
    ports:
    - containerPort: 80
    volumeMounts:
    # Monter le ConfigMap dans /etc/nginx
    - name: nginx-config-volume
      mountPath: /etc/nginx/nginx.conf
      subPath: nginx.conf  # Monter uniquement ce fichier (pas tout le répertoire)

    # Monter un autre fichier dans un répertoire différent
    - name: nginx-config-volume
      mountPath: /etc/nginx/conf.d/custom.conf
      subPath: custom.conf

  volumes:
  # Définir le volume depuis le ConfigMap
  - name: nginx-config-volume
    configMap:
      name: nginx-config
EOF
```{{exec}}

Appliquer le pod :
```bash
microk8s kubectl apply -f nginx-with-volume.yaml
```{{exec}}

## 🔍 Vérifier le Montage

Attendre que le pod soit prêt :
```bash
microk8s kubectl wait --for=condition=Ready pod/nginx-with-volume --timeout=60s
```{{exec}}

Vérifier que les fichiers sont bien montés :
```bash
microk8s kubectl exec nginx-with-volume -- cat /etc/nginx/nginx.conf
```{{exec}}

Vérifier le deuxième fichier :
```bash
microk8s kubectl exec nginx-with-volume -- cat /etc/nginx/conf.d/custom.conf
```{{exec}}

## 🧪 Tester Nginx

Créer un Service pour exposer nginx :
```bash
microk8s kubectl expose pod nginx-with-volume --port=80 --name=nginx-svc
```{{exec}}

Tester l'accès :
```bash
microk8s kubectl run curl-test --image=curlimages/curl:latest --rm -it --restart=Never -- curl http://nginx-svc
```{{exec}}

Vous devriez voir : `Hello from ConfigMap!`

## 🔄 Mise à Jour du ConfigMap

Une des forces des volumes : la config se met à jour automatiquement !

```bash
microk8s kubectl patch configmap nginx-config --patch '{"data":{"nginx.conf":"events {\n  worker_connections 1024;\n}\nhttp {\n  server {\n    listen 80;\n    location / {\n      return 200 \"Updated Config!\\n\";\n      add_header Content-Type text/plain;\n    }\n  }\n}"}}'
```{{exec}}

Attendre quelques secondes (60s max pour la propagation) :
```bash
sleep 10
```{{exec}}

Tester à nouveau :
```bash
microk8s kubectl run curl-test2 --image=curlimages/curl:latest --rm -it --restart=Never -- curl http://nginx-svc
```{{exec}}

⚠️ **Note** : Nginx doit être rechargé pour prendre en compte la nouvelle config (reload, pas restart).

## 🎯 Options de Montage

```yaml
volumes:
- name: config-volume
  configMap:
    name: mon-configmap
    # Options disponibles :

    # Monter uniquement certaines clés
    items:
    - key: nginx.conf
      path: nginx.conf

    # Permissions des fichiers (défaut: 0644)
    defaultMode: 0644

    # Rendre optionnel (pas d'erreur si le ConfigMap n'existe pas)
    optional: true
```

---

Cliquez sur **Continue** pour apprendre à monter des Secrets comme volumes.
