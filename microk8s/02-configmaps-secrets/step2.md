# Étape 2 : Créer un Secret

## 📝 Objectif

Créer un **Secret** pour stocker des données sensibles de manière sécurisée.

## 🔐 Qu'est-ce qu'un Secret ?

Un **Secret** Kubernetes stocke des données sensibles :
- Mots de passe
- Tokens d'API
- Clés SSH
- Certificats TLS

Les Secrets sont encodés en **base64** et peuvent être chiffrés au repos dans etcd.

## 📄 Méthode 1 : Créer depuis la ligne de commande

```bash
microk8s kubectl create secret generic database-credentials \
  --from-literal=DB_USER="admin" \
  --from-literal=DB_PASSWORD="SuperSecretPassword123!" \
  --from-literal=API_KEY="sk-1234567890abcdef"
```{{exec}}

## 🔍 Vérifier le Secret

Voir les Secrets :
```bash
microk8s kubectl get secrets
```{{exec}}

Voir les détails (notez que les valeurs sont masquées) :
```bash
microk8s kubectl describe secret database-credentials
```{{exec}}

Voir le contenu en YAML (les valeurs sont en base64) :
```bash
microk8s kubectl get secret database-credentials -o yaml
```{{exec}}

## 🔓 Décoder un Secret (pour debug)

Extraire et décoder une valeur :
```bash
microk8s kubectl get secret database-credentials -o jsonpath='{.data.DB_PASSWORD}' | base64 --decode
echo ""
```{{exec}}

⚠️ **Attention** : Ne jamais afficher les Secrets en production !

## 📄 Méthode 2 : Créer avec un fichier YAML

Créons un Secret pour une clé SSH :

```bash
# D'abord, encoder les valeurs en base64
echo -n "my-ssh-key-content" | base64
```{{exec}}

```bash
cat > ssh-secret.yaml <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: ssh-key
type: Opaque
data:
  # Valeurs encodées en base64 (utilisez : echo -n "valeur" | base64)
  ssh-privatekey: bXktc3NoLWtleS1jb250ZW50
  ssh-publickey: c3NoLXJzYSBBQUFBLi4u
stringData:
  # Alternative : stringData encode automatiquement en base64
  known_hosts: |
    github.com ssh-rsa AAAAB3NzaC1yc2E...
EOF
```{{exec}}

Appliquer le Secret :
```bash
microk8s kubectl apply -f ssh-secret.yaml
```{{exec}}

## 🎯 Types de Secrets

Kubernetes supporte plusieurs types de Secrets :

| Type | Usage |
|------|-------|
| `Opaque` | Données génériques (défaut) |
| `kubernetes.io/service-account-token` | Token de ServiceAccount |
| `kubernetes.io/dockerconfigjson` | Credentials Docker Registry |
| `kubernetes.io/tls` | Certificats TLS |
| `kubernetes.io/ssh-auth` | Clés SSH |
| `kubernetes.io/basic-auth` | Authentification basique |

## 🔐 Bonnes Pratiques

- ✅ **Utilisez RBAC** pour limiter l'accès aux Secrets
- ✅ **Chiffrez etcd** au repos (encryption at rest)
- ✅ **Utilisez stringData** dans les YAML pour éviter d'encoder manuellement
- ✅ **Ne commitez JAMAIS** de Secrets dans Git
- ✅ Utilisez des outils comme **Sealed Secrets** ou **External Secrets Operator** pour la prod
- ⚠️ Les Secrets ne sont **pas chiffrés** dans les manifestes YAML (juste encodés base64)

## 🔍 Comparaison ConfigMap vs Secret

```bash
# Voir les deux côte à côte
echo "=== ConfigMaps ===" && microk8s kubectl get configmaps
echo "" && echo "=== Secrets ===" && microk8s kubectl get secrets
```{{exec}}

---

Cliquez sur **Continue** quand vous avez créé les Secrets.
