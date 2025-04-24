# Module VMC - Chauffage Expert

Ce module permet de vérifier la conformité des installations VMC selon les normes en vigueur.

## Fonctionnalités

- Vérification du type d'installation VMC
- Calcul du débit par bouche
- Vérification de la conformité des modules aux fenêtres
- Vérification de l'étalonnage des portes
- Affichage des résultats de conformité

## Structure des fichiers

```
modules/vmc/
├── css/
│   └── style.css      # Styles spécifiques au module
├── js/
│   └── vmc.js         # Logique de vérification
└── index.html         # Interface utilisateur
```

## Normes de débit

Les normes de débit sont configurées dans le fichier `vmc.js` :

- VMC simple flux classique : 15-30 m³/h
- VMC sanitaire : 20-40 m³/h
- Caisson Sekoia : 25-45 m³/h
- VTI : 30-50 m³/h

## Utilisation

1. Sélectionner le type d'installation VMC
2. Entrer le nombre de bouches
3. Entrer le débit total mesuré
4. Entrer le débit en m/s
5. Indiquer si les modules aux fenêtres sont conformes
6. Indiquer si l'étalonnage des portes a été vérifié
7. Cliquer sur "Vérifier conformité"

## Maintenance

Pour modifier les normes de débit, éditer le fichier `vmc.js` et mettre à jour l'objet `normesVMC`. 