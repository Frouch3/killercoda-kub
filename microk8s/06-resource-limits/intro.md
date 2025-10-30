# Exercice 4.5 : Resource Limits et QoS

## 🎯 Objectifs

- ✅ Comprendre **requests** vs **limits** (CPU/RAM)
- ✅ Découvrir les **QoS classes** (Guaranteed, Burstable, BestEffort)
- ✅ Éviter les **OOMKilled** (Out Of Memory)
- ✅ Optimiser l'utilisation des ressources du cluster

## 🎓 Pourquoi c'est Important ?

Sans limits :
- ❌ Un pod peut consommer 100% CPU/RAM du noeud
- ❌ Autres pods ralentis ou tués
- ❌ Cluster instable

Avec requests/limits :
- ✅ Isolation des ressources
- ✅ Scheduling optimal
- ✅ Prévention OOM
- ✅ Prérequis pour HPA (autoscaling)

## ⏱️ Durée : 25 minutes
