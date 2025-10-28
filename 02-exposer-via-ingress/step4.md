# Étape 4 : Tester l'Accès

## 📝 Objectif

Tester que notre application est accessible via l'Ingress.

## 🔍 Récupérer l'IP de l'Ingress

L'Ingress Controller écoute sur localhost dans notre environnement :

```bash
INGRESS_IP=$(microk8s kubectl get ingress web-ingress -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
echo "Ingress IP: $INGRESS_IP"
```{{exec}}

Si l'IP n'est pas encore disponible, attendez quelques secondes et réessayez.

## 🧪 Test 1 : Requête avec Host Header

Testons avec curl en spécifiant le header `Host` :

```bash
curl -H "Host: web.local" http://127.0.0.1
```{{exec}}

Vous devriez voir le HTML de votre application ! 🎉

## 🧪 Test 2 : Sans Host Header

Essayons sans le header Host :

```bash
curl http://127.0.0.1
```{{exec}}

Vous obtiendrez une erreur **404** car l'Ingress attend le host `web.local`.

## 🔧 Simuler un Nom de Domaine Local

En production, vous auriez un vrai DNS. Ici, on simule avec `/etc/hosts` :

```bash
echo "127.0.0.1 web.local" >> /etc/hosts
```{{exec}}

Maintenant on peut utiliser le nom de domaine directement :

```bash
curl http://web.local
```{{exec}}

Parfait ! L'Ingress route correctement vers notre Service.

## 📊 Tester le Load-Balancing

Générons plusieurs requêtes pour voir que l'Ingress distribue le trafic :

```bash
for i in {1..10}; do
  echo "Requête $i:"
  curl -s http://web.local | grep -o "<h1>.*</h1>"
  sleep 0.3
done
```{{exec}}

## 🔍 Voir les Logs de l'Ingress Controller

Les logs de l'Ingress Controller montrent toutes les requêtes :

```bash
POD=$(microk8s kubectl get pods -n ingress -l name=nginx-ingress-microk8s -o jsonpath='{.items[0].metadata.name}')
microk8s kubectl logs -n ingress $POD --tail=20
```{{exec}}

Vous verrez les requêtes HTTP avec leur code de réponse (200, 404, etc.).

## 🎯 Points Clés

- ✅ L'Ingress utilise le **header Host** pour router
- ✅ Même IP, plusieurs domaines possibles (virtual hosting)
- ✅ Le load-balancing se fait au niveau HTTP (plus intelligent que NodePort)
- ✅ On peut voir tous les logs au même endroit

## 💡 En Production

En production, vous configureriez :
- Un **vrai DNS** pointant vers l'IP de l'Ingress
- Un **certificat TLS** pour HTTPS
- Des **annotations** pour le rate-limiting, CORS, etc.
- Un **monitoring** des métriques de l'Ingress

---

Cliquez sur **Continue** pour voir le routing avancé.
