# Chauffage Expert

Application web professionnelle pour les techniciens de chauffage, permettant de vérifier la conformité, calculer des puissances, et générer des PDF d'intervention.

## Fonctionnalités

- **Module Puissance Chauffage** : Calcul de la puissance nécessaire en fonction de la surface, hauteur, températures et isolation
- **Module Vase d'Expansion** : Calcul de la pression théorique et du réglage en tours
- **Module Équilibrage Réseau** : Calcul du réglage en tours pour l'équilibrage
- **Module Radiateurs** : Calcul de puissance selon le type et les dimensions
- **Module ECS** : Analyse instantanée de la production d'eau chaude
- **Module Top Compteur Gaz** : Calcul de puissance à partir des relevés
- **Module VMC** : Vérification de conformité des installations
- **Module Réglementation Gaz** : Vérification des règles CC2
- **Export PDF** : Génération de rapports d'intervention personnalisés
- **Préférences** : Personnalisation de l'interface et des paramètres

## Installation

1. Cloner le dépôt :
```bash
git clone https://github.com/votre-username/chauffage-expert.git
cd chauffage-expert
```

2. Installer les dépendances :
```bash
npm install
```

3. Lancer l'application en mode développement :
```bash
npm start
```

4. Construire l'application pour la production :
```bash
npm run build
```

## Structure du projet

```
chauffage-expert/
├── index.html          # Page principale
├── css/                # Styles CSS
│   ├── style.css       # Styles principaux
│   ├── theme.css       # Variables de thème
│   └── notifications.css # Styles des notifications
├── js/                 # Scripts JavaScript
│   ├── app.js          # Application principale
│   ├── pdf-export.js   # Gestion des exports PDF
│   └── preferences.js  # Gestion des préférences
├── modules/            # Modules de l'application
│   ├── module-puissance-chauffage.html
│   ├── module-vase-expansion.html
│   └── ...
└── assets/             # Ressources statiques
    └── icons/          # Icônes SVG
```

## Technologies utilisées

- HTML5
- CSS3 (Material Design)
- JavaScript natif
- html2pdf.js pour les exports PDF
- Signature Pad pour les signatures électroniques
- Vite pour le développement et le build

## Fonctionnement hors-ligne

L'application est conçue pour fonctionner hors-ligne grâce au stockage local du navigateur. Les données sont sauvegardées automatiquement et peuvent être exportées/importées.

## Personnalisation

Les techniciens peuvent personnaliser :
- Leur prénom
- Le thème (clair/sombre)
- L'unité de température
- Le logo de l'entreprise
- Le module par défaut

## Contribution

Les contributions sont les bienvenues ! N'hésitez pas à :
1. Fork le projet
2. Créer une branche pour votre fonctionnalité
3. Commiter vos changements
4. Pousser vers la branche
5. Ouvrir une Pull Request

## Licence

Ce projet est sous licence MIT. Voir le fichier `LICENSE` pour plus de détails.
