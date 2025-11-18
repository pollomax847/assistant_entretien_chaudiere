# Documentation du Projet

## Architecture

### Structure des Modules

L'application est organisée en modules fonctionnels :

- **Modules de calcul** : Puissance, VMC, Radiateurs, etc.
- **Modules de vérification** : Conformité, Réglementation gaz
- **Modules utilitaires** : Export PDF, Préférences

### Technologies Utilisées

#### Frontend Web
- **Vite** : Build tool moderne
- **TypeScript** : Langage principal
- **CSS3** : Styles et animations
- **HTML5** : Structure

#### Backend
- **Node.js** : Runtime JavaScript
- **Express.js** : Framework web
- **CORS** : Gestion des origines croisées

#### Mobile
- **Flutter** : Framework mobile cross-platform
- **Dart** : Langage de programmation
- **Material Design** : Design system

## Guide de Développement

### Conventions de Code

1. **Nommage** :
   - Variables et fonctions : camelCase
   - Classes et composants : PascalCase
   - Constantes : UPPER_SNAKE_CASE
   - Fichiers : kebab-case

2. **Structure des fichiers** :
   - Un composant par fichier
   - Tests à côté des fichiers sources
   - Documentation inline pour les fonctions complexes

### Tests

```bash
# Lancer les tests
npm test

# Tests avec couverture
npm run test:coverage
```

### Déploiement

#### Web
L'application web peut être déployée sur :
- Vercel (configuration incluse)
- Netlify
- Serveur traditionnel

#### Mobile
- Google Play Store (Android)
- Apple App Store (iOS)

## API Reference

Voir `/docs/api.md` pour la documentation complète de l'API.

## Contribution

1. Fork le projet
2. Créer une branche feature (`git checkout -b feature/AmazingFeature`)
3. Commit les changements (`git commit -m 'Add some AmazingFeature'`)
4. Push vers la branche (`git push origin feature/AmazingFeature`)
5. Ouvrir une Pull Request

## License

Distribué sous licence MIT. Voir `LICENSE` pour plus d'informations.