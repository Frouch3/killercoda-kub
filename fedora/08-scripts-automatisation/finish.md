# Félicitations !

Vous avez terminé le scénario sur le scripting bash et l'automatisation sous Linux !

## Ce que vous avez appris

### Bases du scripting
- **Shebang** (`#!/bin/bash`) : Définir l'interpréteur
- **Commentaires** : Documenter le code
- **echo** : Afficher du texte
- **Exécution de commandes** : `$(commande)`
- **Codes de retour** : `$?` et `exit`
- **Redirections** : `>`, `>>`, `2>&1`
- **Pipelines** : `|`
- **Opérateurs logiques** : `&&`, `||`

### Variables
- **Déclaration** : `variable="valeur"`
- **Utilisation** : `$variable` ou `${variable}`
- **Variables spéciales** : `$0`, `$1`, `$@`, `$#`, `$$`, `$?`
- **Variables d'environnement** : `export`, `$USER`, `$HOME`, `$PATH`
- **read** : Lire l'entrée utilisateur
- **Opérations arithmétiques** : `$((expression))`
- **Manipulation de chaînes** : `${var:pos:len}`, `${var//search/replace}`
- **Tableaux** : `array=("val1" "val2")`, `${array[@]}`

### Conditions
- **if-then-else** : Tests conditionnels
- **Tests numériques** : `-eq`, `-ne`, `-gt`, `-ge`, `-lt`, `-le`
- **Tests de chaînes** : `=`, `!=`, `-z`, `-n`
- **Tests de fichiers** : `-e`, `-f`, `-d`, `-r`, `-w`, `-x`
- **Opérateurs logiques** : `&&`, `||`, `!`
- **Double crochets** : `[[ ]]` plus puissant que `[ ]`
- **case** : Tests multiples sur une variable

### Boucles et fonctions
- **for** : Itérer sur des listes
- **while** : Boucler tant que condition vraie
- **until** : Boucler tant que condition fausse
- **break** : Sortir d'une boucle
- **continue** : Passer à l'itération suivante
- **Fonctions** : Réutiliser du code
- **Paramètres** : `$1`, `$2`, etc.
- **Variables locales** : `local variable`
- **return** : Code de retour (0-255)

### Automatisation avec cron
- **Syntaxe crontab** : `* * * * * commande`
- **crontab -e** : Éditer
- **crontab -l** : Lister
- **Répertoires système** : `/etc/cron.{hourly,daily,weekly,monthly}/`
- **Logs** : Suivre l'exécution
- **systemd timers** : Alternative moderne

## Commandes essentielles

```bash
# Créer et exécuter un script
nano script.sh
chmod +x script.sh
./script.sh

# Debug
bash -x script.sh
set -e  # Arrêt sur erreur
set -x  # Mode debug

# Variables
variable="valeur"
echo "$variable"
read -p "Prompt: " variable

# Conditions
if [ condition ]; then
    echo "Vrai"
fi

# Boucles
for i in {1..10}; do
    echo $i
done

while [ condition ]; do
    commande
done

# Fonctions
ma_fonction() {
    local param=$1
    echo "Paramètre: $param"
    return 0
}

# Cron
crontab -e          # Éditer
crontab -l          # Voir
0 2 * * * script    # Tous les jours à 2h
```

## Exemples de scripts utiles

### Backup automatique

```bash
#!/bin/bash
BACKUP_DIR="/var/backups"
SOURCE="/home/user/data"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

tar -czf "${BACKUP_DIR}/backup_${TIMESTAMP}.tar.gz" "$SOURCE"

# Rotation (garder 7 jours)
find "$BACKUP_DIR" -name "backup_*.tar.gz" -mtime +7 -delete
```

### Surveillance de service

```bash
#!/bin/bash
SERVICE="nginx"

if ! systemctl is-active --quiet "$SERVICE"; then
    echo "Service arrêté, redémarrage..."
    systemctl start "$SERVICE"
    echo "Service $SERVICE redémarré" | mail -s "Alert" admin@example.com
fi
```

### Déploiement automatique

```bash
#!/bin/bash
set -e

cd /var/www/monapp
git pull origin main
npm install
npm run build
systemctl restart monapp
echo "Déploiement réussi - $(date)"
```

### Nettoyage automatique

```bash
#!/bin/bash
LOG_DIR="/var/log/monapp"
RETENTION_DAYS=30

# Compresser logs de plus de 7 jours
find "$LOG_DIR" -name "*.log" -mtime +7 -exec gzip {} \;

# Supprimer logs compressés de plus de 30 jours
find "$LOG_DIR" -name "*.log.gz" -mtime +$RETENTION_DAYS -delete
```

### Rapport système

```bash
#!/bin/bash
RAPPORT="/tmp/rapport_$(date +%Y%m%d).txt"

{
    echo "=== Rapport Système ==="
    echo "Date: $(date)"
    echo ""
    echo "=== CPU ==="
    uptime
    echo ""
    echo "=== Mémoire ==="
    free -h
    echo ""
    echo "=== Disque ==="
    df -h
    echo ""
    echo "=== Services ==="
    systemctl list-units --type=service --state=running
} > "$RAPPORT"

mail -s "Rapport Système" admin@example.com < "$RAPPORT"
```

## Patterns de scripting courants

### Gestion d'erreurs robuste

```bash
#!/bin/bash
set -euo pipefail

trap 'echo "Erreur ligne $LINENO"' ERR

# Votre code ici
```

### Logging structuré

```bash
#!/bin/bash
LOG_FILE="/var/log/monscript.log"

log() {
    echo "[$(date +%Y-%m-%d\ %H:%M:%S)] $1" | tee -a "$LOG_FILE"
}

log "INFO: Script démarré"
log "ERROR: Quelque chose a échoué"
```

### Configuration externe

```bash
#!/bin/bash
CONFIG_FILE="/etc/monscript.conf"

# Charger la config
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
else
    echo "Fichier de configuration introuvable"
    exit 1
fi

# Utiliser les variables de config
echo "Backup dir: $BACKUP_DIR"
```

### Mode dry-run

```bash
#!/bin/bash
DRY_RUN=false

while getopts "d" opt; do
    case $opt in
        d) DRY_RUN=true ;;
    esac
done

if $DRY_RUN; then
    echo "[DRY RUN] rm -rf /tmp/test"
else
    rm -rf /tmp/test
fi
```

## Outils et ressources

### Vérificateurs de code
- **shellcheck** : Linter pour scripts bash
  ```bash
  sudo apt install shellcheck
  shellcheck mon_script.sh
  ```

### Formatters
- **shfmt** : Formatter de code bash
  ```bash
  go install mvdan.cc/sh/v3/cmd/shfmt@latest
  shfmt -w mon_script.sh
  ```

### Documentation
- `man bash` : Manuel complet de bash
- [ShellCheck Wiki](https://www.shellcheck.net/)
- [Bash Guide](https://mywiki.wooledge.org/BashGuide)
- [Advanced Bash-Scripting Guide](https://tldp.org/LDP/abs/html/)

## Bonnes pratiques

1. **Toujours utiliser le shebang** : `#!/bin/bash`
2. **Utiliser set -e** pour arrêter sur erreur
3. **Quoter les variables** : `"$variable"`
4. **Préférer [[ ]] à [ ]**
5. **Utiliser local dans les fonctions**
6. **Chemins absolus** dans les scripts cron
7. **Logger les actions importantes**
8. **Gérer les erreurs** explicitement
9. **Commenter** le code complexe
10. **Tester** avant de déployer

## Checklist de script robuste

- [ ] Shebang présent
- [ ] set -euo pipefail
- [ ] Variables quotées
- [ ] Chemins absolus
- [ ] Vérification des arguments
- [ ] Gestion des erreurs
- [ ] Logging approprié
- [ ] Commentaires clairs
- [ ] Testé manuellement
- [ ] Validé avec shellcheck

## Prochaines étapes

Vous avez maintenant les compétences pour :
- Automatiser vos tâches d'administration système
- Créer des outils personnalisés
- Orchestrer des déploiements
- Surveiller des services
- Sauvegarder automatiquement

### Pour aller plus loin

- **Python** : Pour des scripts plus complexes
- **Ansible** : Automatisation à grande échelle
- **Docker** : Conteneurisation
- **CI/CD** : Pipelines d'intégration continue
- **Kubernetes** : Orchestration de conteneurs

## Ressources finales

- [Bash Hackers Wiki](https://wiki.bash-hackers.org/)
- [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html)
- [Bash Pitfalls](https://mywiki.wooledge.org/BashPitfalls)

Félicitations pour avoir terminé cette série de formations Linux ! Vous avez maintenant une base solide pour administrer des systèmes Linux et automatiser vos tâches.

Merci d'avoir suivi ces scénarios et bonne continuation dans votre apprentissage !
