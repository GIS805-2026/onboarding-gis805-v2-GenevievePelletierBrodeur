# Trace d'usage IA — GIS805

> Chaque interaction significative avec un outil IA doit être documentée ici.
> Ce fichier est **obligatoire** et évalué à chaque remise.

## Format par entrée

```
### YYYY-MM-DD — Séance SXX
- **Modèle :** (ChatGPT-4o, Claude, Copilot, etc.)
- **Prompt :** (copier-coller exact)
- **Résultat :** (résumé de ce que l'IA a produit)
- **Validation :** (comment vous avez vérifié/modifié le résultat)
- **Justification :** (pourquoi cette interaction était nécessaire)
```

---

<!-- Ajoutez vos entrées ci-dessous -->
### 2026-05-10 — Séance S01
- **Modèle :** GitHub Copilot Chat
- **Prompt :** « Aide-moi à compléter les sections Preuve, Validation, Risques / limites et Prochaines recommandations de mon Board Brief S01. Je veux expliquer pourquoi la base actuelle n’est pas suffisamment propre pour faire une analyse fiable en OLTP et pourquoi un entrepôt OLAP complet est nécessaire. »
- **Résultat :** Rédaction des 4 sections avec une logique claire : requête SQL pertinente, limites de l’OLTP, risques de biais temporel et recommandations pour un entrepôt dimensionnel historique.
- **Validation :** J’ai vérifié que le texte respecte le style du brief, qu’il mentionne le grain, l’OLTP vs OLAP et qu’il reste argumenté sans chiffres inventés.
- **Justification :** Cette interaction était nécessaire pour formuler une réponse structurée et professionnelle au CEO, en expliquant pourquoi on ne peut pas simplement exécuter une requête ad hoc sur un système transactionnel.

### 2026-05-10 — Séance S01
- **Modèle :** GitHub Copilot Chat
- **Prompt :** « Explique-moi la différence entre Commit, Commit & Push, Commit & Sync, Commit (Amend) dans VS Code et indique comment envoyer mon travail au prof. »
- **Résultat :** Explication claire de chaque option Git dans VS Code et recommandation d’utiliser `Commit & Push` pour envoyer les changements au professeur.
- **Validation :** J’ai comparé la réponse avec l’interface de VS Code et les options affichées dans le panneau Source Control.
- **Justification :** Je devais savoir précisément comment livrer mon travail GitHub de manière correcte et vérifiable pour la remise du brief.

---

### YYYY-MM-DD — Séance S02
