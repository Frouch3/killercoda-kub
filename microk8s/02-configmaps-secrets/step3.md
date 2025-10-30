# Étape 3 : Utiliser comme Variables d'Environnement

## 📝 Objectif

Injecter des ConfigMaps et Secrets dans un pod sous forme de **variables d'environnement**.

## 🎓 Pourquoi des Variables d'Environnement ?

C'est la méthode la plus courante pour passer de la configuration aux applications :
- ✅ Compatible avec toutes les applications (12-factor app)
- ✅ Simple à utiliser dans le code
- ✅ Pas de fichiers à gérer

## 📄 Créer un Pod avec ConfigMap et Secret

Créez un pod qui utilise nos ConfigMaps et Secrets :

```bash
cat > app-with-config.yaml <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: app-with-config
  labels:
    app: demo
spec:
  containers:
  - name: app
    image: busybox
    command: ["sh", "-c", "env | grep -E 'APP_|DB_|API_' | sort && sleep 3600"]
    env:
    # Injecter une seule valeur depuis un ConfigMap
    - name: APP_NAME
      valueFrom:
        configMapKeyRef:
          name: app-config
          key: APP_NAME

    - name: LOG_LEVEL
      valueFrom:
        configMapKeyRef:
          name: app-config
          key: LOG_LEVEL

    # Injecter une valeur depuis un Secret
    - name: DB_PASSWORD
      valueFrom:
        secretKeyRef:
          name: database-credentials
          key: DB_PASSWORD

    - name: API_KEY
      valueFrom:
        secretKeyRef:
          name: database-credentials
          key: API_KEY

    # Injecter TOUTES les clés d'un ConfigMap d'un coup
    envFrom:
    - configMapRef:
        name: database-config

    # Note: On peut aussi faire envFrom avec un Secret
    # - secretRef:
    #     name: database-credentials
EOF
```{{exec}}

Appliquer le pod :
```bash
microk8s kubectl apply -f app-with-config.yaml
```{{exec}}

## 🔍 Vérifier les Variables d'Environnement

Attendre que le pod soit prêt :
```bash
microk8s kubectl wait --for=condition=Ready pod/app-with-config --timeout=60s
```{{exec}}

Voir les logs (qui affichent les variables d'environnement) :
```bash
microk8s kubectl logs app-with-config
```{{exec}}

Vous devriez voir toutes les variables injectées !

## 🔐 Vérifier la Sécurité

Les variables d'environnement sont visibles dans les logs et avec `kubectl describe` :

```bash
microk8s kubectl describe pod app-with-config | grep -A 20 "Environment:"
```{{exec}}

⚠️ **Attention** : Les variables d'environnement sont visibles par :
- `kubectl describe pod`
- `kubectl exec` dans le conteneur
- Les logs si l'app les affiche

Pour plus de sécurité, utilisez des **volumes** (étapes suivantes).

## 🎯 Syntaxes Disponibles

```yaml
env:
  # 1. Valeur directe (éviter pour les secrets !)
  - name: MY_VAR
    value: "valeur-directe"

  # 2. Depuis un ConfigMap (une clé)
  - name: MY_VAR
    valueFrom:
      configMapKeyRef:
        name: mon-configmap
        key: ma-cle

  # 3. Depuis un Secret (une clé)
  - name: MY_VAR
    valueFrom:
      secretKeyRef:
        name: mon-secret
        key: ma-cle

# 4. Injecter TOUT un ConfigMap/Secret
envFrom:
  - configMapRef:
      name: mon-configmap
  - secretRef:
      name: mon-secret
```

## 🧪 Test Interactif

Exécutez une commande dans le pod pour voir les variables :

```bash
microk8s kubectl exec app-with-config -- env | grep -E 'APP_|DB_|API_' | sort
```{{exec}}

---

Cliquez sur **Continue** pour apprendre à monter des ConfigMaps comme volumes.
