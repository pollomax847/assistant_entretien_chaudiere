const Map<String, String> vmcDocumentation = {
  'simple-flux': '''
# VMC Simple Flux Autoréglable

La Ventilation Mécanique Contrôlée (VMC) simple flux est un système de ventilation qui extrait l'air vicié des pièces humides et polluées vers l'extérieur.

## Principe de fonctionnement

- Extraction mécanique de l'air dans les pièces de service (cuisine, salle de bain, WC)
- Entrée d'air naturel par des grilles d'aération dans les pièces de vie
- Débit d'extraction constant, déterminé par la conception du système
- Circulation de l'air des pièces de vie vers les pièces de service

## Débits réglementaires (Arrêté du 24 mars 1982 modifié)

Le débit minimum doit être assuré en permanence. Les débits maximaux sont atteints en cas de besoin (présence, cuisson).

### Par type de logement

- **T1** : Cuisine 20-75 m³/h, Salle de bain 15 m³/h, WC 15 m³/h
- **T2** : Cuisine 30-90 m³/h, Salle de bain 15 m³/h, WC 15 m³/h
- **T3** : Cuisine 45-105 m³/h, Salle de bain 30 m³/h, WC 15 m³/h
- **T4** : Cuisine 45-120 m³/h, Salle de bain 30 m³/h, WC 30 m³/h
- **T5+** : Cuisine 45-135 m³/h, Salle de bain 30 m³/h, WC 30 m³/h

## Avantages

- Simple à installer et à entretenir
- Coût modéré d'installation et de fonctionnement
- Fiabilité éprouvée
- Efficace pour l'extraction des polluants et de l'humidité

## Inconvénients

- Pas de filtration de l'air entrant
- Dépendance aux conditions extérieures (température, vent)
- Débit constant ne s'adaptant pas aux besoins réels
- Pertes thermiques importantes en hiver

## Points de vérification

1. État des bouches d'extraction (encrassement)
2. Fonctionnement du caisson VMC (bruit anormal)
3. Présence et état des entrées d'air neuf
4. Mesure des débits d'extraction
5. Étalonnage des portes intérieures (jeu de 2 cm minimum)
''',
  
  'hygro-a': '''
# VMC Hygroréglable Type A

La VMC hygroréglable Type A est équipée de bouches d'extraction qui s'adaptent automatiquement à l'humidité intérieure.

## Principe de fonctionnement

- Bouches d'extraction hygroréglables modulant le débit selon l'humidité
- Entrées d'air autoréglables (débit constant)
- Adaptation automatique aux besoins réels
- Réduction des pertes thermiques en période d'inoccupation

## Débits réglementaires (Arrêté du 24 mars 1982 modifié)

### Par type de logement

- **T1** : Cuisine 10-50 m³/h, Salle de bain 10-40 m³/h, WC 5-30 m³/h
- **T2** : Cuisine 10-50 m³/h, Salle de bain 10-40 m³/h, WC 5-30 m³/h
- **T3** : Cuisine 15-50 m³/h, Salle de bain 10-40 m³/h, WC 5-30 m³/h
- **T4** : Cuisine 20-55 m³/h, Salle de bain 15-45 m³/h, WC 5-30 m³/h
- **T5+** : Cuisine 25-60 m³/h, Salle de bain 15-45 m³/h, WC 10-30 m³/h

## Avantages

- Économie d'énergie de 15 à 20% par rapport au simple flux
- Régulation automatique selon l'humidité
- Réduction des débits en période d'inoccupation
- Amélioration du confort (moins de courants d'air)

## Inconvénients

- Coût légèrement supérieur au simple flux
- Entretien spécifique des bouches hygroréglables
- Pas de filtration de l'air entrant (entrées d'air autoréglables)

## Points de vérification

1. Fonctionnement des bouches hygroréglables
2. État et encrassement des capteurs d'humidité
3. Débits minimum et maximum
4. Présence et état des entrées d'air autoréglables
''',

  'hygro-b': '''
# VMC Hygroréglable Type B

La VMC hygroréglable Type B est le système le plus performant en simple flux, avec régulation hygrométrique sur les bouches d'extraction ET les entrées d'air.

## Principe de fonctionnement

- Bouches d'extraction hygroréglables
- Entrées d'air hygroréglables (adaptation complète)
- Double régulation pour une efficacité maximale
- Débit total modulé selon les besoins réels

## Débits réglementaires (Arrêté du 24 mars 1982 modifié)

### Par type de logement

- **T1** : Cuisine 10-50 m³/h, Salle de bain 5-40 m³/h, WC 5-30 m³/h
- **T2** : Cuisine 10-50 m³/h, Salle de bain 5-40 m³/h, WC 5-30 m³/h
- **T3** : Cuisine 10-45 m³/h, Salle de bain 5-35 m³/h, WC 5-30 m³/h
- **T4** : Cuisine 15-45 m³/h, Salle de bain 5-35 m³/h, WC 5-30 m³/h
- **T5+** : Cuisine 15-50 m³/h, Salle de bain 10-40 m³/h, WC 5-30 m³/h

## Avantages

- Économie d'énergie maximale : 25 à 30% par rapport au simple flux
- Régulation complète entrée/extraction
- Meilleur confort thermique
- Qualité d'air optimisée selon les besoins

## Inconvénients

- Coût initial plus élevé
- Entretien régulier des entrées d'air et bouches hygroréglables
- Sensibilité à l'encrassement

## Points de vérification

1. Fonctionnement des bouches d'extraction hygroréglables
2. Fonctionnement des entrées d'air hygroréglables
3. État des capteurs d'humidité (entrées et extractions)
4. Débits minimum et maximum
5. Absence d'obstruction des grilles
''',

  'double-flux': '''
# VMC Double Flux

La VMC double flux assure à la fois l'extraction de l'air vicié et l'insufflation d'air frais filtré, avec récupération de chaleur.

## Principe de fonctionnement

- Extraction de l'air vicié des pièces humides
- Insufflation d'air frais filtré dans les pièces de vie
- Échangeur thermique récupérant jusqu'à 90% de la chaleur
- Double réseau de gaines (extraction et insufflation)
- Filtration complète de l'air entrant

## Débits réglementaires

### Par type de logement

- **T1-T2** : Cuisine 45-120 m³/h, Salle de bain 15-30 m³/h, WC 15-30 m³/h
- **T3** : Cuisine 45-135 m³/h, Salle de bain 15-30 m³/h, WC 15-30 m³/h
- **T4-T5+** : Cuisine 45-135 m³/h, Salle de bain 30 m³/h, WC 15-30 m³/h

## Avantages

- Économie d'énergie maximale (récupération de chaleur)
- Qualité d'air intérieur excellente
- Filtration des pollens et particules fines
- Confort acoustique (pas d'ouverture vers l'extérieur)
- Pas de courants d'air froid

## Inconvénients

- Coût d'installation élevé (double réseau)
- Maintenance importante (filtres, échangeur)
- Encombrement du caisson et des gaines
- Installation complexe en rénovation

## Points de vérification

1. État et propreté des filtres (tous les 6 mois)
2. État de l'échangeur thermique
3. Débits d'extraction et d'insufflation
4. Équilibre des débits entre extraction et insufflation
5. Absence de condensation dans les gaines
6. Fonctionnement du système de dégivrage (si équipé)
7. Contrôle du by-pass d'été
''',

  'vmc-gaz': '''
# VMC Gaz

La VMC Gaz est un système spécifique qui assure à la fois la ventilation du logement et l'évacuation des produits de combustion d'une chaudière ou d'un chauffe-eau gaz.

## Principe de fonctionnement

- Extraction de l'air vicié et des produits de combustion
- Circuit spécifique pour l'évacuation des fumées
- Sécurités renforcées (détecteur de CO, pressostat)
- Débits adaptés à la puissance de l'appareil à gaz

## Débits réglementaires (selon puissance de l'appareil)

### Configuration standard

- **T1** : Cuisine 45-75 m³/h (90 en grand débit), Salle de bain 15 m³/h, WC 15 m³/h
- **T2** : Cuisine 45-90 m³/h (105 en grand débit), Salle de bain 15 m³/h, WC 15 m³/h
- **T3** : Cuisine 45-105 m³/h (120 en grand débit), Salle de bain 15-30 m³/h, WC 15 m³/h
- **T4** : Cuisine 45-120 m³/h (135 en grand débit), Salle de bain 15-30 m³/h, WC 30 m³/h
- **T5+** : Cuisine 45-135 m³/h, Salle de bain 15-30 m³/h, WC 30 m³/h

## Avantages

- Système tout-en-un (ventilation + évacuation fumées)
- Gain de place (pas de conduit de fumée traditionnel)
- Solution adaptée aux logements sans conduit
- Sécurité renforcée

## Inconvénients

- Coût initial élevé
- Maintenance spécifique et obligatoire
- Compatibilité limitée aux appareils gaz étanches
- Arrêt de la ventilation = arrêt du chauffage

## Points de vérification (OBLIGATOIRES)

1. Étanchéité du circuit d'évacuation des fumées
2. Fonctionnement des dispositifs de sécurité
3. Débits d'extraction conformes à la puissance de l'appareil
4. Absence de refoulement de fumées
5. Contrôle annuel par professionnel qualifié
6. Vérification du détecteur de CO
7. État des joints et raccordements
''',
};

const Map<String, List<String>> vmcMaintenanceChecklist = {
  'simple-flux': [
    'Nettoyer les bouches d\'extraction tous les 3 mois',
    'Vérifier les entrées d\'air neuf tous les 6 mois',
    'Contrôler le caisson VMC annuellement',
    'Mesurer les débits tous les 3 ans',
    'Vérifier l\'étalonnage des portes',
  ],
  'hygro-a': [
    'Nettoyer les bouches hygroréglables tous les 6 mois',
    'Vérifier les entrées d\'air tous les 6 mois',
    'Contrôler le caisson VMC annuellement',
    'Mesurer les débits tous les 3 ans',
    'Tester la modulation des bouches annuellement',
  ],
  'hygro-b': [
    'Nettoyer les bouches hygroréglables tous les 6 mois',
    'Nettoyer les entrées d\'air hygroréglables tous les 6 mois',
    'Contrôler le caisson VMC annuellement',
    'Mesurer les débits tous les 3 ans',
    'Tester la modulation entrées/extractions annuellement',
  ],
  'double-flux': [
    'Changer/nettoyer les filtres tous les 6 mois minimum',
    'Nettoyer l\'échangeur thermique annuellement',
    'Contrôler l\'équilibre des débits annuellement',
    'Vérifier l\'absence de condensation dans les gaines',
    'Tester le by-pass d\'été avant la saison',
    'Contrôle complet par professionnel tous les 3 ans',
  ],
  'vmc-gaz': [
    'Contrôle OBLIGATOIRE par professionnel qualifié chaque année',
    'Vérifier les détecteurs de CO mensuellement',
    'Contrôler l\'étanchéité du circuit de fumées',
    'Nettoyer les bouches d\'extraction tous les 3 mois',
    'Vérifier les dispositifs de sécurité tous les 6 mois',
  ],
};
