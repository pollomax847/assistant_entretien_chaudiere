# Module VMC - Assistant Entretien Chaudière

## Vue d'ensemble

Le module VMC permet de vérifier la conformité des débits de ventilation mécanique contrôlée selon les normes réglementaires françaises (Arrêté du 24 mars 1982 modifié).

## Fonctionnalités

### 1. Vérification des débits VMC
- Saisie des mesures par pièce (cuisine, salle de bain, WC, autre salle d'eau)
- Comparaison automatique avec les débits réglementaires min/max
- Calcul du pourcentage de conformité global
- Diagnostic et recommandations personnalisés

### 2. Types de VMC supportés
- **Simple Flux Autoréglable** : Système de base avec extraction à débit constant
- **Hygroréglable Type A** : Bouches d'extraction modulables selon l'humidité
- **Hygroréglable Type B** : Entrées et extractions hygroréglables (performance maximale)
- **Double Flux** : Récupération de chaleur et filtration de l'air entrant
- **VMC Gaz** : Ventilation + évacuation des produits de combustion

### 3. Types de logement supportés
- T1 (1 pièce principale)
- T2 (2 pièces principales)
- T3 (3 pièces principales)
- T4 (4 pièces principales)
- T5+ (5 pièces principales et plus)

### 4. Export PDF
- Génération d'un rapport de diagnostic professionnel
- Tableau détaillé des mesures et conformités
- Recommandations personnalisées
- Format PDF imprimable ou partageable

### 5. Documentation intégrée
- Fiches techniques complètes pour chaque type de VMC
- Principes de fonctionnement
- Avantages et inconvénients
- Points de vérification lors de l'entretien
- Checklists de maintenance spécifiques

## Structure des fichiers

```
lib/modules/vmc/
├── vmc_calculator.dart              # Calculs et données réglementaires
├── vmc_integration_screen.dart      # Interface principale de vérification
├── vmc_pdf_generator.dart           # Générateur de rapports PDF
├── vmc_documentation.dart           # Contenu documentaire
├── vmc_documentation_screen.dart    # Interface de documentation
└── README.md                        # Ce fichier
```

## Utilisation

### Vérification des débits

1. Sélectionner le type de logement (T1 à T5+)
2. Choisir le type de VMC installée
3. Consulter le tableau de référence des débits réglementaires
4. Saisir les débits mesurés pour chaque pièce (en m³/h)
5. Le diagnostic s'affiche automatiquement avec :
   - État de chaque mesure (conforme/non conforme)
   - Pourcentage de conformité global
   - Message de diagnostic
   - Recommandations d'action

### Export du rapport

Cliquer sur le bouton "Export PDF" pour générer un rapport professionnel contenant :
- Informations générales (logement, VMC, date)
- Résultat global avec pourcentage de conformité
- Tableau détaillé de toutes les mesures
- Recommandations d'action

### Consultation de la documentation

- Icône "i" dans la barre d'application pour accéder à la documentation
- Vue contextuelle du type de VMC sélectionné
- Accès à toutes les fiches techniques depuis le menu principal

## Débits réglementaires

Les débits min/max sont définis selon l'Arrêté du 24 mars 1982 modifié et varient selon :
- Le type de VMC (simple flux, hygro A/B, double flux, VMC gaz)
- Le type de logement (T1 à T5+)
- Le type de pièce (cuisine, salle de bain, WC, autre salle d'eau)

### Exemple pour VMC Simple Flux en T3
- Cuisine : 45-105 m³/h
- Salle de bain : 30 m³/h
- WC : 15 m³/h
- Autre salle d'eau : 15 m³/h

## Conversions disponibles

Le module `VMCCalculator` propose également :
- Conversion m³/h ↔ m/s (selon diamètre)
- Conversion Pa ↔ mmCE (colonne d'eau)
- Vérification de compatibilité entrées d'air / extraction

## Maintenance et entretien

Chaque type de VMC dispose d'une checklist de maintenance spécifique :
- Fréquence des interventions
- Points de contrôle obligatoires
- Opérations de nettoyage et remplacement

**Attention** : La VMC Gaz nécessite un contrôle annuel OBLIGATOIRE par un professionnel qualifié.

## Intégration future

- Historique des mesures et suivi dans le temps
- Alertes de maintenance préventive
- Intégration avec d'autres modules (chaudière, qualité d'air)
- Photos et annotations des installations

## Conformité réglementaire

Ce module respecte :
- Arrêté du 24 mars 1982 modifié (débits de ventilation)
- NF DTU 68.3 (installations de ventilation mécanique)
- Réglementation thermique en vigueur

---

*Dernière mise à jour : Février 2026*
