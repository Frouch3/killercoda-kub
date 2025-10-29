# Étape 2 : Gérer les processus

## Introduction

Au-delà de simplement lister les processus, Linux permet de les **contrôler** : les arrêter, les mettre en pause, changer leur priorité, etc.

## Les signaux (signals)

Les processus communiquent via des **signaux**. Ce sont des interruptions logicielles.

### Signaux courants

| Signal | Numéro | Action | Usage |
|--------|--------|--------|-------|
| SIGTERM | 15 | Terminer proprement | Arrêt normal |
| SIGKILL | 9 | Tuer immédiatement | Arrêt forcé |
| SIGHUP | 1 | Hang up | Recharger config |
| SIGINT | 2 | Interrupt | Ctrl+C |
| SIGSTOP | 19 | Pause | Suspendre |
| SIGCONT | 18 | Continue | Reprendre |
| SIGUSR1 | 10 | User defined | Personnalisé |
| SIGUSR2 | 12 | User defined | Personnalisé |

### Voir tous les signaux

```bash
kill -l
```

## Arrêter un processus avec kill

La commande **kill** envoie un signal à un processus.

### Syntaxe

```bash
kill [OPTIONS] PID
```

### Exemples

Créons un processus pour expérimenter :

```bash
# Lancer un processus en arrière-plan
sleep 300 &
```

Le `&` lance en arrière-plan. Notez le PID affiché.

Voir le processus :

```bash
jobs
ps aux | grep sleep
```

### Terminer proprement (SIGTERM)

```bash
# Trouver le PID
PID=$(pgrep sleep)
echo "PID du sleep: $PID"

# Terminer (signal par défaut = SIGTERM)
kill $PID

# Vérifier
ps aux | grep sleep
```

Le processus a le temps de nettoyer avant de s'arrêter.

### Tuer brutalement (SIGKILL)

Si un processus ne répond pas à SIGTERM :

```bash
# Lancer un autre sleep
sleep 400 &
PID=$(pgrep sleep)

# Tuer avec SIGKILL (-9)
kill -9 $PID

# ou
kill -KILL $PID
```

**Attention** : SIGKILL ne peut pas être intercepté. Le processus meurt instantanément sans nettoyage.

## Arrêter par nom avec killall

**killall** tue tous les processus d'un nom donné :

```bash
# Lancer plusieurs sleep
sleep 500 &
sleep 600 &
sleep 700 &

# Voir tous les sleep
pgrep -a sleep

# Tuer tous les sleep
killall sleep

# Vérifier
pgrep sleep
```

**Attention** : Tue TOUS les processus de ce nom !

## Arrêter par motif avec pkill

**pkill** est plus flexible (accepte regex) :

```bash
# Lancer des processus
sleep 800 &
sleep 900 &

# Tuer par motif
pkill sleep

# Tuer les processus d'un utilisateur
# pkill -u nom_utilisateur
```

## Gérer les processus en avant/arrière-plan

### Lancer en arrière-plan

```bash
# & à la fin = arrière-plan
sleep 1000 &
```

### Voir les jobs

```bash
jobs
```

### Mettre en arrière-plan (Ctrl+Z puis bg)

```bash
# Lancer un processus
sleep 2000

# Appuyer sur Ctrl+Z (suspend le processus)
# Puis le remettre en arrière-plan :
bg
```

### Ramener en avant-plan (fg)

```bash
# Lancer en arrière-plan
sleep 3000 &

# Voir les jobs
jobs

# Ramener en avant
fg

# Ctrl+C pour arrêter
```

### Commandes utiles

```bash
jobs           # Lister les jobs du shell actuel
jobs -l        # Avec les PID
fg %1          # Ramener job 1 en avant-plan
bg %2          # Mettre job 2 en arrière-plan
kill %3        # Tuer job 3
```

## Détacher un processus avec nohup

**nohup** permet à un processus de survivre après déconnexion :

```bash
# Lancer un processus long
nohup sleep 5000 &

# Sortie dans nohup.out
cat nohup.out
```

Même si vous fermez le terminal, le processus continue !

## Alternative moderne : disown

```bash
# Lancer un processus
sleep 6000 &

# Le détacher du shell
disown

# Voir les jobs (il n'y est plus)
jobs

# Mais il tourne toujours
ps aux | grep sleep
```

## Changer la priorité (nice et renice)

Linux utilise des **priorités** (nice values) de -20 (haute) à 19 (basse).

### Lancer avec priorité basse (nice)

```bash
# Priorité normale (0)
sleep 100 &

# Basse priorité (10)
nice -n 10 sleep 200 &

# Très basse priorité (19)
nice -n 19 sleep 300 &

# Vérifier (colonne NI)
ps -l
```

### Modifier une priorité existante (renice)

```bash
# Lancer un processus
sleep 400 &
PID=$!

# Baisser sa priorité
renice -n 15 $PID

# Vérifier
ps -l | grep sleep
```

Seul root peut augmenter la priorité (nice négatif) :

```bash
sudo renice -n -10 $PID
```

## Limiter les ressources

La commande **ulimit** limite les ressources :

```bash
# Voir les limites actuelles
ulimit -a

# Limiter la taille des fichiers créés (en Ko)
ulimit -f 1000

# Limiter le nombre de processus
ulimit -u 100

# Limiter la mémoire (en Ko)
ulimit -v 1000000
```

## Monitorer un processus spécifique

### Avec watch

```bash
# Surveiller un processus
watch -n 1 'ps aux | grep sleep'
```

Actualise chaque seconde.

### Avec top filtré

```bash
# Top pour un PID spécifique
top -p $(pgrep sleep | head -1)
```

## Exercice pratique

1. Lancez plusieurs processus sleep :

```bash
sleep 1000 &
sleep 2000 &
sleep 3000 &
```

2. Listez-les :

```bash
pgrep -a sleep
```

3. Tuez tous les processus sleep :

```bash
killall sleep
```

4. Vérifiez qu'ils sont bien arrêtés :

```bash
pgrep sleep
```

Devrait ne rien retourner.

5. Créez un fichier de validation :

```bash
touch ~/processus_geres
```

Une fois le fichier créé, la vérification passera.
