// Fusionné depuis les fichiers séparés - Documentation VMC complète
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

La VMC hygroréglable type A offre une ventilation adaptée à l'humidité réelle du logement.

## Principe de fonctionnement

- Bouches d'extraction hygroréglables qui s'ouvrent selon le taux d'humidité
- Entrées d'air fixes dans les pièces de vie
- Augmentation du débit en cas d'excès d'humidité
- Réduction du débit en cas de faible humidité

## Avantages

- Adaptation automatique aux besoins réels
- Économies d'énergie (débit réduit en hiver)
- Meilleur confort intérieur
- Moins d'appels d'air extérieur froid

## Inconvénients

- Coût d'installation plus élevé qu'une simple flux
- Maintenance des éléments hygroréglables requise
- Efficacité dépendante du bon fonctionnement des capteurs

## Maintenance

Inspection annuelle des bouches hygroréglables pour vérifier:
- Absence d'encrassement
- Mobilité correcte du clapet
- Propreté des orifices de captation
''',
  
  'hygro-b': '''
# VMC Hygroréglable Type B

La VMC hygroréglable type B assure une régulation complète avec entrées d'air hygroréglables.

## Principe de fonctionnement

- Bouches d'extraction hygroréglables
- Entrées d'air hygroréglables adaptées au taux d'humidité
- Régulation complète du débit d'air entrant et sortant
- Adaptation aux conditions climatiques extérieures

## Avantages

- Performance énergétique maximale
- Régulation très fine des débits
- Meilleure qualité d'air intérieur
- Confort optimal toute l'année

## Inconvénients

- Coût d'installation élevé
- Maintenance régulière requise
- Plus complexe à diagnostiquer

## Maintenance

Inspection bi-annuelle:
- Nettoyage des bouches d'extraction et d'entrée
- Vérification des mécanismes hygroréglables
- Test de réactivité des capteurs d'humidité
- Mesure des débits réels
''',
  
  'double-flux': '''
# VMC Double Flux

La VMC double flux combine extraction et insufflation d'air frais filtré avec récupération de chaleur.

## Principe de fonctionnement

- Extraction de l'air vicié des pièces humides
- Insufflation d'air frais filtré dans les pièces de vie
- Échangeur thermique pour récupération de la chaleur (80-90%)
- Filtration de l'air entrant (pollens, particules fines)

## Avantages

- Qualité d'air intérieur excellente
- Récupération de chaleur (réduction consommation chauffage)
- Filtration complète de l'air
- Isolation acoustique améliorée
- Peut remplacer chauffage dans certains cas (PAC thermodynamique)

## Inconvénients

- Coût d'installation très élevé
- Encombrement important
- Maintenance complexe (filtres, échangeur)
- Consommation électrique plus élevée

## Maintenance

Inspection régulière (3-4 fois par an):
- Contrôle des filtres (changement tous les 3 à 6 mois)
- Nettoyage des bouches d'air
- Vérification du bon fonctionnement de l'échangeur
- Mesure des débits entrant et sortant
- Inspection du circuit de condensation
''',
  
  'vmc-gaz': '''
# VMC Gaz

La VMC gaz assure la ventilation du logement tout en évacuant les produits de combustion d'une chaudière gaz.

## Principe de fonctionnement

- Extraction de l'air vicié et des produits de combustion
- Circuits séparés ou combinés selon la configuration
- Débits adaptés aux besoins de chauffage et de ventilation
- Points de mesure spécifiques pour chaque circuit

## Points critiques de contrôle

1. **Tirage cheminée** : Vérifier l'absence de refoulement
2. **Étanchéité** : Vérifier les conduites d'évacuation gaz
3. **Débits** : Mesurer séparément ventilation et gaz
4. **Conduit** : Inspecter les dépôts de suie
5. **Sortie** : Vérifier l'absence d'obstruction

## Débits réglementaires

Selon l'Arrêté du 24 mars 1982 modifié et NF DTU 68.2 pour le gaz.

## Maintenance

Inspection annuelle obligatoire:
- Vérification du tirage au brûleur
- Mesure des débits
- Nettoyage des conduits si nécessaire
- Vérification de l'étanchéité
''',
};

// Checklist de maintenance par type de VMC
const Map<String, List<String>> vmcMaintenanceChecklist = {
  'simple-flux': [
    'Vérifier l\'état de propreté des bouches d\'extraction',
    'Nettoyer les grilles d\'entrée d\'air',
    'Écouter le bruit du moteur (anormal?)',
    'Vérifier l\'absence de vibrations excessives',
    'Contrôler l\'étalonnage des portes (2cm minimum)',
    'Mesurer les débits de chaque bouche',
    'Vérifier l\'existence de conduits de remplacement',
  ],
  'hygro-a': [
    'Vérifier l\'état des bouches hygroréglables',
    'Tester la mobilité du clapet de régulation',
    'Nettoyer les orifices de captation d\'humidité',
    'Mesurer les débits en différentes conditions',
    'Vérifier l\'absence de bloquage du mécanisme',
    'Contrôler l\'état des capteurs d\'humidité',
    'Tester la réactivité aux variations d\'humidité',
  ],
  'hygro-b': [
    'Inspecter les bouches d\'extraction hygroréglables',
    'Inspecter les entrées d\'air hygroréglables',
    'Tester les deux circuits indépendamment',
    'Mesurer les débits en conditions normales et humides',
    'Vérifier la synchronisation entrée/extraction',
    'Nettoyer tous les mécanismes mobiles',
    'Calibrer si nécessaire',
  ],
  'double-flux': [
    'Inspecter et changer les filtres si nécessaire',
    'Nettoyer les bouches d\'insufflation',
    'Nettoyer les bouches d\'extraction',
    'Vérifier le fonctionnement de l\'échangeur',
    'Mesurer les débits entrant et sortant',
    'Vérifier l\'absence de condensation anormale',
    'Nettoyer le circuit de condensation',
    'Inspecter les conduits pour poussière/moisissures',
  ],
  'vmc-gaz': [
    'Tester le tirage au brûleur (Déprimogène)',
    'Mesurer les débits de ventilation',
    'Mesurer les débits gaz',
    'Inspecter les conduits d\'évacuation',
    'Vérifier l\'absence de suie/dépôts',
    'Contrôler l\'étanchéité des raccordements',
    'Vérifier la sortie en toiture (absence obstruction)',
    'Mesurer CO2 et O2 d\'évacuation',
  ],
};
