# Assistant Entretien Chaudière

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=flat&logo=flutter&logoColor=white)](https://flutter.dev/)
[![React](https://img.shields.io/badge/React-20232A?style=flat&logo=react&logoColor=61DAFB)](https://reactjs.org/)
[![TypeScript](https://img.shields.io/badge/TypeScript-007ACC?style=flat&logo=typescript&logoColor=white)](https://www.typescriptlang.org/)

Application complète (web + mobile) pour les techniciens de chauffage, permettant de vérifier la conformité des installations, calculer des puissances, et générer des rapports d'intervention PDF.

## 📋 Description

L'Assistant Entretien Chaudière est un outil professionnel conçu pour faciliter le travail quotidien des techniciens en chauffage. L'application offre une suite complète de modules de calcul et de vérification, avec une interface intuitive et des fonctionnalités avancées comme l'export PDF et la synchronisation multi-plateforme.

## ✨ Fonctionnalités

### 🖥️ Application Web
- **Module Puissance Chauffage** : Calcul précis de la puissance nécessaire selon surface, hauteur, températures et isolation
- **Module Vase d'Expansion** : Calcul de la pression théorique et réglage en tours
- **Module Équilibrage Réseau** : Calcul du réglage en tours pour un équilibrage optimal
- **Module Radiateurs** : Calcul de puissance selon type et dimensions
- **Module ECS** : Analyse instantanée de la production d'eau chaude
- **Module Top Compteur Gaz** : Calcul de puissance à partir des relevés de compteur
- **Module VMC** : Vérification de conformité des installations de ventilation
- **Module Réglementation Gaz** : Vérification des règles de conformité CC2
- **Export PDF** : Génération de rapports d'intervention personnalisés et professionnels
- **Préférences** : Personnalisation complète de l'interface et des paramètres utilisateur

### 📱 Application Mobile
- Interface native optimisée pour smartphones et tablettes
- Synchronisation automatique avec l'application web
- Fonctionnement hors-ligne complet
- Export PDF natif avec partage direct
- Notifications de mise à jour automatique
- Thème adaptatif (clair/sombre)

## 🏗️ Architecture du Projet

```
assistant_entretien_chaudiere/
├── web/                          # Application web React/TypeScript
│   ├── src/                     # Code source frontend
│   ├── server/                  # Serveur backend Node.js/Express
│   ├── index.html              # Point d'entrée
│   ├── vite.config.ts          # Configuration Vite
│   └── tsconfig.json           # Configuration TypeScript
├── mobile/                      # Application mobile Flutter
│   ├── lib/                    # Code source Dart
│   ├── assets/                 # Ressources (images, icônes, polices)
│   ├── android/                # Configuration Android
│   ├── ios/                    # Configuration iOS
│   └── pubspec.yaml            # Dépendances et configuration Flutter
├── docs/                       # Documentation
├── test/                       # Tests unitaires
├── build/                      # Artefacts de build
├── version.json                # Informations de version pour les mises à jour
├── publish.sh                  # Script de publication automatique
└── README.md                  # Ce fichier
```

## 🚀 Installation et Démarrage

### Prérequis
- **Node.js** 14+ (pour l'application web)
- **Flutter** 3.0+ (pour l'application mobile)
- **Git** pour le contrôle de version

### Installation

1. **Cloner le dépôt :**
   ```bash
   git clone https://github.com/pollomax847/assistant_entretien_chaudiere.git
   cd assistant_entretien_chaudiere
   ```

2. **Installer les dépendances web :**
   ```bash
   npm install
   ```

3. **Installer les dépendances mobile :**
   ```bash
   cd mobile
   flutter pub get
   cd ..
   ```

### Démarrage

#### Application Web
```bash
# Développement complet (client + serveur)
npm run dev

# Développement frontend uniquement
npm run dev:client

# Développement backend uniquement
npm run dev:server

# Build de production
npm run build

# Aperçu de production
npm run preview

# Démarrage en production
npm start
```

#### Application Mobile
```bash
# Lancer en mode développement
npm run mobile

# Build APK Android
npm run mobile:build
```

## 🛠️ Technologies Utilisées

### Frontend Web
- **React 19** - Framework UI moderne
- **TypeScript** - Typage statique
- **Vite** - Outil de build rapide
- **Material Design** - Design system cohérent

### Backend Web
- **Node.js** - Runtime JavaScript
- **Express.js** - Framework serveur
- **CORS** - Gestion des requêtes cross-origin

### Mobile
- **Flutter** - Framework multi-plateforme
- **Dart** - Langage de programmation
- **Provider/Riverpod** - Gestion d'état
- **Shared Preferences** - Stockage local

### Outils de Développement
- **ESLint** - Linting du code
- **Jest** - Tests unitaires
- **GitHub CLI** - Automatisation des releases

## 📱 Déploiement et Publication

L'application mobile est publiée automatiquement via le script `publish.sh` :

```bash
./publish.sh "Description de la nouvelle version"
```

Ce script :
- Incrémente automatiquement le numéro de build
- Compile l'APK en mode release
- Crée un tag Git et une release GitHub
- Upload l'APK sur GitHub Releases
- Met à jour le fichier `version.json` pour les mises à jour automatiques

## 🤝 Contribution

Les contributions sont les bienvenues ! Voici comment participer :

1. **Fork** le projet
2. Créer une **branche** pour votre fonctionnalité (`git checkout -b feature/nouvelle-fonctionnalite`)
3. **Commiter** vos changements (`git commit -m 'Ajout nouvelle fonctionnalité'`)
4. **Pousser** vers la branche (`git push origin feature/nouvelle-fonctionnalite`)
5. Ouvrir une **Pull Request**

### Guidelines de développement
- Respecter les conventions de code (ESLint pour le web, Flutter analyze pour le mobile)
- Ajouter des tests pour les nouvelles fonctionnalités
- Mettre à jour la documentation si nécessaire
- Utiliser des commits descriptifs

## 📄 Licence

Ce projet est sous licence **MIT**. Voir le fichier [`LICENSE`](LICENSE) pour plus de détails.

## 📞 Support

Pour toute question ou problème :
- Ouvrir une [issue](https://github.com/pollomax847/assistant_entretien_chaudiere/issues) sur GitHub
- Consulter la [documentation](./docs/) pour les guides détaillés

---

**Développé avec ❤️ pour la communauté des techniciens de chauffage**
