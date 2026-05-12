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

### 2026-05-11 — Séance S01
- **Modèle :** Claude Opus 4.7 (Claude Code)
- **Prompt :** « Comment me connecter à mon compte Claude? »
- **Résultat :** Explication des commandes Claude Code pour l'authentification : `/login` (avec deux options — Claude.ai pour les comptes Pro/Max, ou Anthropic Console pour une clé API), `/status` pour vérifier le compte actif, `/logout` pour se déconnecter et changer de compte.
- **Validation :** À compléter par l'étudiante après avoir testé les commandes `/login` et `/status` dans Claude Code.
- **Justification :** Connaître la procédure d'authentification dans Claude Code est nécessaire pour configurer correctement l'environnement de travail du cours et basculer entre comptes personnels et institutionnels si besoin.

### 2026-05-11 — Séance S01
- **Modèle :** Claude Opus 4.7 (Claude Code)
- **Prompt :** « J'ai déjà remise le answers S01, mais j'aimerais que tu regardes mes réponses en fonction de : [sections attendues — Question du CEO, Réponse exécutive, Décisions de modélisation, Preuve (SQL + résultat tabulaire), Validation, Risques/limites, Prochaine recommandation] »
- **Résultat :** Revue critique section par section du brief S01. Points forts identifiés : contraste OLTP/OLAP, grain explicite, risques concrets. Points à améliorer : (1) résultat tabulaire manquant dans Preuve, (2) Réponse exécutive qui esquive la question CEO, (3) Validation écrite au futur au lieu du passé, (4) coquilles (`diverger aient`, `L'entrepot`, `analyst`), (5) formatage inégal des Décisions de modélisation.
- **Validation :** À compléter par l'étudiante — vérifier chaque point en relisant le brief, et appliquer les corrections pertinentes lors des prochains briefs S02+.
- **Justification :** Obtenir un retour structuré sur la conformité aux sections attendues avant les prochaines remises, pour identifier les écarts récurrents et améliorer la qualité des livrables.

### 2026-05-11 — Séance S01
- **Modèle :** Claude Opus 4.7 (Claude Code)
- **Prompt :** « Pour la Preuve — résultat tabulaire absent (S01_executive_brief.md:30-55) [...] Peux tu me recommander quoi ajouter et comment rendre la section complete? » puis « Option C » (approche hybride YoY + proxy QoQ).
- **Résultat :** Exécution de la requête YoY originale sur `db/nexamart.duckdb` → 0 ligne (les données source ne contiennent que 2025, pas de 2024). Génération d'une requête proxy QoQ intra-2025 (Q1 vs Q4) qui retourne 8 paires catégorie × région en déclin (Pet Supplies Québec −2 973, Books & Media Alberta −2 774, etc.). Rédaction d'une version complète et copiable de la section Preuve combinant : (a) la requête YoY avec son résultat « 0 ligne » comme preuve empirique de la fragilité OLTP, (b) un mini-tableau QoQ assumé comme proxy, (c) une limite explicite.
- **Validation :** À compléter par l'étudiante — relire le proxy QoQ pour vérifier que la substitution de grain (annuel → trimestriel) est défendable, et confirmer les chiffres en réexécutant les requêtes localement avant tout collage dans le brief.
- **Justification :** Le brief S01 contenait la requête SQL mais aucun résultat tabulaire (lacune identifiée lors de la revue précédente). L'exécution sur les données réelles a également révélé une découverte structurante : la requête YoY originale n'était pas calculable faute de données 2024, ce qui renforce paradoxalement la thèse OLTP ≠ OLAP du brief.

### 2026-05-11 — Séance S01
- **Modèle :** Claude Opus 4.7 (Claude Code)
- **Prompt :** « Dans mon dépot : Pourquoi un ERP ne peut-il pas répondre directement à 'ventes par catégorie par région par trimestre' ? »
- **Résultat :** Synthèse en 5 raisons, sourcée sur les supports du dépôt : (1) ERP conçu pour enregistrer, pas analyser ([lab S01](docs/lab-guides/GIS805-01_lab.md)) ; (2) schéma normalisé 3NF vs étoile ([worked example S02](docs/worked-examples/s02-star-schema-walkthrough.md)) ; (3) concurrence ressources avec les opérations ([FAQ §1](docs/faq.md)) ; (4) absence d'historisation des dimensions (biais de dimension, [glossaire](docs/glossary.md)) ; (5) fragilité aux changements de schéma. Phrase de synthèse pour le CEO incluse.
- **Validation :** relire chaque source citée dans le dépôt et vérifier que la synthèse n'invente rien.
- **Justification :** Approfondir le contraste OLTP/OLAP avec une argumentation structurée et ancrée dans les documents officiels du cours, pour réutilisation dans les briefs et la défense orale.

---

### YYYY-MM-DD — Séance S02
