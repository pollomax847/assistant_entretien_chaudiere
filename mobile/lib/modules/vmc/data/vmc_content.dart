const Map<String, String> vmcContent = {
  'simple-flux': '''
# VMC Simple Flux

La Ventilation Mécanique Contrôlée (VMC) simple flux est un système de ventilation qui extrait l'air vicié des pièces humides et polluées vers l'extérieur.

## Principe de fonctionnement

- Extraction mécanique de l'air dans les pièces de service (cuisine, salle de bain, WC)
- Entrée d'air naturel par des grilles d'aération dans les pièces de vie
- Débit d'extraction constant ou variable selon les besoins

## Avantages

- Simple à installer
- Coût modéré
- Efficace pour l'extraction des polluants

## Inconvénients

- Pas de filtration de l'air entrant
- Dépendance aux conditions extérieures
- Risque de surpression en cas de vent fort

## Débits réglementaires

Les débits minimaux sont définis par la norme NF DTU 68.3 :

- Cuisine : 75 m³/h
- Salle de bain : 50 m³/h
- WC : 30 m³/h
- Autre salle d'eau : 50 m³/h
''',
  'double-flux': '''
# VMC Double Flux

La VMC double flux assure à la fois l'extraction de l'air vicié et l'insufflation d'air frais filtré.

## Types de VMC Double Flux

### Hygro-réglable A

- Régulation basée sur l'humidité relative
- Débit variable selon les besoins
- Économie d'énergie

### Hygro-réglable B

- Régulation plus précise
- Adaptation aux conditions intérieures
- Performance énergétique optimale

## Principe de fonctionnement

- Extraction de l'air vicié des pièces humides
- Insufflation d'air frais filtré dans les pièces de vie
- Échangeur thermique pour récupérer la chaleur
- Filtration de l'air entrant

## Avantages

- Qualité d'air intérieur améliorée
- Récupération de chaleur (jusqu'à 90%)
- Filtration des polluants extérieurs
- Confort acoustique

## Inconvénients

- Coût d'installation plus élevé
- Maintenance plus complexe
- Encombrement plus important

## Débits réglementaires

Les débits sont similaires à la VMC simple flux pour l'extraction, mais le système assure également l'insufflation.
''',
};
