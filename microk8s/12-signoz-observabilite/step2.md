# Étape 2 : Déployer Application Instrumentée

```bash
cat > instrumented-app.yaml <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: demo-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: demo
  template:
    metadata:
      labels:
        app: demo
    spec:
      containers:
      - name: app
        image: hashicorp/http-echo
        args: ["-text=Hello from instrumented app!"]
        env:
        - name: OTEL_EXPORTER_OTLP_ENDPOINT
          value: "http://signoz-otel-collector.signoz:4317"
EOF
microk8s kubectl apply -f instrumented-app.yaml
```{{exec}}

✅ Application déployée avec instrumentation OpenTelemetry !
