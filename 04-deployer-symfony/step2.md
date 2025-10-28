# Étape 2 : Créer ConfigMap Symfony

```bash
cat > symfony-config.yaml <<EOF
apiVersion: v1
kind: ConfigMap
metadata:
  name: symfony-config
data:
  DATABASE_URL: "postgresql://symfony:symfony123@postgres:5432/symfony?serverVersion=15&charset=utf8"
  APP_ENV: "prod"
EOF
microk8s kubectl apply -f symfony-config.yaml
```{{exec}}

✅ Configuration créée !
