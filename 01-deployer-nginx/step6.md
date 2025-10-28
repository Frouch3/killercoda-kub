# Étape 6 : Consulter les Logs

## 📝 Objectif

Apprendre à consulter et suivre les **logs** de vos pods pour le debugging et la surveillance.

## 🎓 Pourquoi les Logs sont Importants ?

Les logs sont **essentiels** pour :
- 🐛 **Debugging** : Comprendre pourquoi une application crashe
- 📊 **Monitoring** : Surveiller l'activité en temps réel
- 🔍 **Audit** : Retracer les actions passées
- ⚠️ **Alerting** : Détecter les erreurs et warnings

## 📋 Voir les Logs d'un Pod

D'abord, récupérons le nom d'un pod :

```bash
POD_NAME=$(microk8s kubectl get pods -l app=nginx -o jsonpath='{.items[0].metadata.name}')
echo "Pod sélectionné : $POD_NAME"
```{{exec}}

Maintenant affichons ses logs :

```bash
microk8s kubectl logs $POD_NAME
```{{exec}}

Par défaut, Nginx affiche peu de logs au démarrage. Générons du trafic pour voir des logs !

## 🚀 Générer du Trafic

Relançons le port-forward et générons des requêtes :

```bash
# Port-forward en arrière-plan
microk8s kubectl port-forward svc/nginx-service 8080:80 > /dev/null 2>&1 &

# Attendre que ça démarre
sleep 2

# Générer 20 requêtes
for i in {1..20}; do
  curl -s http://localhost:8080 > /dev/null
  echo "Requête $i envoyée"
  sleep 0.5
done
```{{exec}}

## 📊 Voir les Logs Avec le Trafic

Maintenant regardons les logs :

```bash
microk8s kubectl logs $POD_NAME
```{{exec}}

Vous devriez voir des lignes comme :
```
127.0.0.1 - - [01/Jan/2024:12:00:00 +0000] "GET / HTTP/1.1" 200 615 "-" "curl/7.81.0"
```

Chaque ligne représente une requête HTTP reçue par Nginx.

## ⏱️ Suivre les Logs en Temps Réel

L'option `-f` (follow) affiche les logs en continu :

```bash
microk8s kubectl logs -f $POD_NAME
```{{exec}}

Laissez tourner quelques secondes, puis appuyez sur **Ctrl+C** pour arrêter.

## 🔍 Filtrer les Logs

Vous pouvez utiliser `grep` pour filtrer :

```bash
# Voir seulement les erreurs (code 4xx ou 5xx)
microk8s kubectl logs $POD_NAME | grep -E " (4|5)[0-9]{2} "

# Voir seulement les GET
microk8s kubectl logs $POD_NAME | grep "GET"

# Compter le nombre de requêtes
microk8s kubectl logs $POD_NAME | grep -c "GET"
```{{exec}}

## 📦 Logs de Tous les Pods d'un Deployment

Pour voir les logs de **tous les pods** d'un deployment :

```bash
microk8s kubectl logs -l app=nginx --all-containers=true --prefix=true
```{{exec}}

Options :
- `-l app=nginx` : Sélectionne tous les pods avec ce label
- `--all-containers=true` : Affiche tous les conteneurs (utile si le pod a plusieurs conteneurs)
- `--prefix=true` : Affiche le nom du pod avant chaque ligne

## ⏪ Voir les Logs d'un Pod Précédent (Crashé)

Si un pod a crashé et a été redémarré, vous pouvez voir les logs **avant le crash** avec `--previous` :

```bash
# Exemple (ne fonctionnera que si un pod a redémarré)
# microk8s kubectl logs $POD_NAME --previous
```

C'est **très utile** pour diagnostiquer les crashes !

## 📊 Limiter le Nombre de Lignes

```bash
# Les 10 dernières lignes
microk8s kubectl logs $POD_NAME --tail=10

# Les logs depuis les 5 dernières minutes
microk8s kubectl logs $POD_NAME --since=5m
```{{exec}}

## 🎯 Points Clés

- ✅ `kubectl logs <pod>` : Affiche les logs
- ✅ `-f` : Suit les logs en temps réel (follow)
- ✅ `--previous` : Logs du conteneur précédent (avant crash)
- ✅ `-l app=nginx` : Logs de tous les pods avec ce label
- ✅ `--tail=N` : Affiche les N dernières lignes
- ✅ `--since=5m` : Logs depuis les 5 dernières minutes

## 💡 En Production

En production, on utilise des solutions de **log aggregation** :
- **ELK Stack** (Elasticsearch, Logstash, Kibana)
- **Loki** (de Grafana)
- **CloudWatch** (AWS)
- **Stackdriver** (GCP)

Ces outils centralisent les logs de tous les pods et permettent de faire des recherches avancées.

## 🛑 Nettoyer

Arrêtons le port-forward :

```bash
pkill -f "port-forward"
```{{exec}}

---

Cliquez sur **Continue** pour la dernière étape : le Rolling Update !
