# Étape 3 : Job de Migration

```bash
cat > migration-job.yaml <<EOF
apiVersion: batch/v1
kind: Job
metadata:
  name: symfony-migrations
spec:
  template:
    spec:
      containers:
      - name: migrations
        image: symfony/cli
        command: ["sh", "-c", "echo 'Migrations simul\u00e9es'; sleep 5"]
        envFrom:
        - configMapRef:
            name: symfony-config
      restartPolicy: Never
EOF
microk8s kubectl apply -f migration-job.yaml
microk8s kubectl wait --for=condition=complete job/symfony-migrations --timeout=60s
```{{exec}}

✅ Migrations exécutées !
