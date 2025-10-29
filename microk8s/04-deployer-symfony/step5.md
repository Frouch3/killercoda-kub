# Étape 5 : Exposer via Ingress

```bash
echo "127.0.0.1 symfony.local" >> /etc/hosts

cat > symfony-ingress.yaml <<EOF
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: symfony-ingress
spec:
  ingressClassName: public
  rules:
  - host: symfony.local
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: symfony-service
            port:
              number: 80
EOF
microk8s kubectl apply -f symfony-ingress.yaml
sleep 5
curl -H "Host: symfony.local" http://127.0.0.1
```{{exec}}

🎉 Application accessible !
