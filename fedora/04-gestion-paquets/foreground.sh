#!/bin/bash
echo "⏳ Préparation..."
while [ ! -f /root/.setup_complete ]; do sleep 1; done
source /root/.bash_profile
echo "✅ Prêt !"
