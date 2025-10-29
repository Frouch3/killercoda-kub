#!/bin/bash
sleep 2
apt-get update -qq 2>/dev/null || true
apt-get install -y nano vim -qq 2>/dev/null || true
cd /root
rm -rf premier_test.txt mes_notes.txt test_vim.txt 2>/dev/null || true
cat > /root/.bash_profile << 'PROFILE'
if [ -f ~/.welcome_shown ]; then
    :
else
    clear
    echo "=========================================="
    echo "    Éditeurs de texte sous Linux        "
    echo "=========================================="
    echo ""
    echo "Vous allez apprendre nano et vim !"
    echo ""
    touch ~/.welcome_shown
fi
PS1='[\u@linux \W]\$ '
PROFILE
touch /root/.setup_complete
echo "✅ Environnement prêt"
