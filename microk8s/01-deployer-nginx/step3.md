# Étape 3 : Créer le Service

## 📝 Objectif

Créer un **Service** pour exposer notre application Nginx et permettre l'accès aux pods.

## 🎓 Qu'est-ce qu'un Service ?

Un **Service** est un point d'entrée stable pour accéder à vos pods :
- Fournit une **IP fixe** (ClusterIP) même si les pods sont recréés
- Fait du **load-balancing** automatique entre les pods
- Utilise les **labels** pour sélectionner les pods cibles
- Expose les pods via DNS interne au cluster

## 📊 Types de Services

- **ClusterIP** (défaut) : Accessible uniquement dans le cluster
- **NodePort** : Accessible depuis l'extérieur via un port sur le nœud
- **LoadBalancer** : Crée un load balancer externe (cloud providers)

## 📄 Création du Service

Créez le fichier `nginx-service.yaml` :

```bash
cat > nginx-service.yaml <<EOF
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  selector:
    app: nginx
  ports:
  - protocol: TCP
    port: 80
    targetPort: 80
  type: ClusterIP
EOF
```{{exec}}

## 🔍 Explication du YAML

- **`selector.app: nginx`** : Le Service cible tous les pods avec le label `app=nginx`
- **`port: 80`** : Port du Service (comment les autres pods vous contactent)
- **`targetPort: 80`** : Port du conteneur (où tourne Nginx)
- **`type: ClusterIP`** : Accessible uniquement dans le cluster

## 🚀 Appliquer le Service

```bash
microk8s kubectl apply -f nginx-service.yaml
```{{exec}}

## ✅ Vérifier le Service

Listez les services :

```bash
microk8s kubectl get svc nginx-service
```{{exec}}

Vous verrez :
- **CLUSTER-IP** : L'IP interne du Service
- **PORT(S)** : Le port exposé (80/TCP)
- **TYPE** : ClusterIP

## 🔗 Voir les Endpoints

Les **endpoints** sont les IPs réelles des pods derrière le Service :

```bash
microk8s kubectl get endpoints nginx-service
```{{exec}}

Vous devriez voir **2 IPs** (une pour chaque pod), séparées par des virgules.

## 🔎 Détails du Service

Pour voir tous les détails :

```bash
microk8s kubectl describe svc nginx-service
```{{exec}}

Notez la section **Endpoints** qui liste les 2 pods.

## 🧪 Tester le Service

Testons que le Service fonctionne en envoyant une requête HTTP depuis l'intérieur du cluster :

```bash
# Récupérer l'IP du Service
SERVICE_IP=$(microk8s kubectl get svc nginx-service -o jsonpath='{.spec.clusterIP}')
echo "Service IP : $SERVICE_IP"

# Envoyer une requête HTTP
curl -s http://$SERVICE_IP | head -n 5
```{{exec}}

Vous devriez voir le début de la page HTML de Nginx !

## 🎯 Points Clés

- ✅ Le Service a une **IP fixe** qui ne change jamais
- ✅ Il fait automatiquement du **load-balancing** entre les 2 pods
- ✅ Si un pod meurt, Kubernetes met à jour automatiquement les endpoints
- ✅ Les autres applications peuvent utiliser le **DNS** : `http://nginx-service.default.svc.cluster.local`

---

Cliquez sur **Continue** quand vous avez créé et testé le Service.
