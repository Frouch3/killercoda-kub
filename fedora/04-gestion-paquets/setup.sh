#!/bin/bash
sleep 2
apt-get update -qq 2>/dev/null || true
cd /root
cat > /root/.bash_profile << 'PROFILE'
PS1='[\u@ubuntu \W]\$ '
PROFILE
touch /root/.setup_complete
echo "✅ Environnement prêt"
