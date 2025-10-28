# Étape 4 : Tester l'Application

## 📝 Objectif

Accéder à notre application Nginx depuis l'extérieur du cluster avec **port-forward**.

## 🎓 Qu'est-ce que port-forward ?

`kubectl port-forward` crée un **tunnel** entre votre machine locale et un pod ou service dans le cluster :
- Utile pour le développement et le debugging
- Ne nécessite pas d'Ingress ou NodePort
- Fonctionne temporairement (tant que la commande tourne)

## 🔌 Créer le Port-Forward

Ouvrons le port 8080 en local qui redirige vers le port 80 du Service :

```bash
microk8s kubectl port-forward svc/nginx-service 8080:80 &
```{{exec}}

Le `&` à la fin exécute la commande en arrière-plan.

## ✅ Vérifier que le Port-Forward Fonctionne

```bash
# Attendre 2 secondes que le port-forward démarre
sleep 2

# Tester avec curl
curl http://localhost:8080
```{{exec}}

Vous devriez voir le **code HTML** de la page d'accueil de Nginx ! 🎉

## 📊 Tester le Load-Balancing

Le Service fait automatiquement du load-balancing entre les 2 pods. Pour le voir en action, on va :

1. **Récupérer les noms des 2 pods** :
```bash
microk8s kubectl get pods -l app=nginx -o name
```{{exec}}

2. **Envoyer plusieurs requêtes** et voir quel pod répond :
```bash
for i in {1..10}; do
  echo "Requête $i :"
  curl -s http://localhost:8080 | grep -i "welcome"
done
```{{exec}}

## 🔍 Surveiller les Logs en Temps Réel

Ouvrons les logs d'un pod pour voir les requêtes arriver :

```bash
# Récupérer le nom du premier pod
POD_NAME=$(microk8s kubectl get pods -l app=nginx -o jsonpath='{.items[0].metadata.name}')

# Afficher les logs en temps réel
microk8s kubectl logs -f $POD_NAME
```{{exec}}

Laissez tourner quelques secondes, puis appuyez sur **Ctrl+C** pour arrêter.

## 🧪 Test Avancé : Vérifier les Headers HTTP

```bash
curl -I http://localhost:8080
```{{exec}}

Vous verrez :
- **HTTP/1.1 200 OK** : La requête a réussi
- **Server: nginx/1.25.x** : La version de Nginx
- **Content-Type: text/html** : Type de contenu

## 🛑 Arrêter le Port-Forward

Pour arrêter le port-forward qui tourne en arrière-plan :

```bash
pkill -f "port-forward"
```{{exec}}

## 🎯 Points Clés

- ✅ Port-forward permet d'accéder facilement à vos services
- ✅ Le Service fait automatiquement du load-balancing
- ✅ Chaque requête peut arriver sur un pod différent
- ✅ C'est parfait pour le développement, mais en production on utilise un Ingress

## 💡 En Production

En production, on n'utilise pas `port-forward` mais plutôt :
- **Ingress** : Pour exposer via HTTP/HTTPS avec un nom de domaine
- **LoadBalancer** : Pour les services non-HTTP (bases de données, etc.)
- **NodePort** : Pour accès direct via un port sur le nœud

---

Cliquez sur **Continue** pour passer au scaling.
