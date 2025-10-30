# 🎉 Félicitations !

Vous maîtrisez maintenant les **Resource Limits** !

## 📚 Récapitulatif

### Requests vs Limits

| | Requests | Limits |
|-|----------|--------|
| **Définition** | Minimum garanti | Maximum autorisé |
| **Scheduling** | Utilisé | Non utilisé |
| **CPU dépassé** | - | Throttling |
| **RAM dépassée** | - | OOMKilled |

### QoS Classes

| Classe | Condition | Priorité |
|--------|-----------|----------|
| **Guaranteed** | requests = limits | ⭐⭐⭐ |
| **Burstable** | requests < limits | ⭐⭐ |
| **BestEffort** | Pas de resources | ⭐ |

## 🎯 Bonnes Pratiques

✅ **Toujours** définir requests ET limits
✅ Utiliser **Guaranteed** pour apps critiques
✅ Requests ≈ utilisation normale, Limits ≈ pics
✅ Monitorer avec `kubectl top`

---

**Prochaine étape** : Autoscaling (HPA) 🚀
