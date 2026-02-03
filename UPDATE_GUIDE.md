# Système de Mise à Jour via GitHub

Ce système permet de distribuer des mises à jour de l'application sans passer par Google Play Store.

## 📋 Comment ça fonctionne

1. **Vérification automatique** : Au démarrage, l'app vérifie `version.json` sur GitHub
2. **Comparaison** : Compare le buildNumber actuel avec celui sur GitHub
3. **Notification** : Si une nouvelle version existe, affiche un dialogue
4. **Téléchargement** : Redirige vers le lien de téléchargement GitHub Release

## 🚀 Publier une mise à jour

### Étape 1 : Augmenter la version

Modifiez `mobile/pubspec.yaml` :
```yaml
version: 1.0.1+2  # format: version+buildNumber
```

### Étape 2 : Compiler l'APK

```bash
cd mobile
flutter clean
flutter build apk --release
```

L'APK sera dans : `mobile/build/app/outputs/flutter-apk/app-release.apk`

### Étape 3 : Créer une GitHub Release

1. Allez sur https://github.com/pollomax847/assitant_entreiten_chaudiere/releases
2. Cliquez sur "Create a new release"
3. Tag version : `v1.0.1` (correspond à la version dans pubspec.yaml)
4. Titre : `Version 1.0.1`
5. Description : Notes de version (nouveautés, corrections, etc.)
6. **Important** : Uploadez `app-release.apk` en tant qu'asset
7. Publiez la release

### Étape 4 : Mettre à jour version.json

Modifiez le fichier `version.json` à la racine du projet :

```json
{
  "version": "1.0.1",
  "buildNumber": "2",
  "downloadUrl": "https://github.com/pollomax847/assitant_entreiten_chaudiere/releases/download/v1.0.1/app-release.apk",
  "releaseNotes": "Nouveautés de la v1.0.1\n- Ajout de...\n- Correction de...\n- Amélioration de...",
  "minVersion": "1.0.0",
  "forceUpdate": false,
  "releaseDate": "2026-02-03"
}
```

**Champs importants** :
- `version` : Version affichée (doit correspondre au pubspec.yaml)
- `buildNumber` : Numéro de build (doit correspondre au pubspec.yaml)
- `downloadUrl` : URL de l'APK sur GitHub Releases (changez v1.0.1 et le nom du fichier si nécessaire)
- `releaseNotes` : Description des changements (utilisez `\n` pour les sauts de ligne)
- `forceUpdate` : `true` = mise à jour obligatoire, `false` = optionnelle

### Étape 5 : Commit et Push

```bash
git add version.json
git commit -m "Release v1.0.1"
git push origin main
```

## 📱 Côté utilisateur

### Vérification automatique
- Au démarrage de l'app (après 3 secondes)
- Popup si mise à jour disponible
- Choix "Plus tard" ou "Télécharger"

### Vérification manuelle
- Menu Préférences → À propos → "Vérifier les mises à jour"
- Message si déjà à jour ou proposition de téléchargement

### Installation
1. L'utilisateur clique sur "Télécharger"
2. Le navigateur télécharge l'APK
3. L'utilisateur ouvre l'APK téléchargé
4. Android propose d'installer la mise à jour
5. L'app se met à jour automatiquement

## ⚙️ Configuration

### Changer l'URL du repository

Si vous changez le nom du repository, modifiez dans `mobile/lib/services/github_update_service.dart` :

```dart
static const String _versionUrl = 
    'https://raw.githubusercontent.com/VOTRE_USERNAME/VOTRE_REPO/main/version.json';
```

### Forcer une mise à jour

Dans `version.json`, mettez :
```json
{
  "forceUpdate": true
}
```

L'utilisateur ne pourra pas fermer le dialogue et devra obligatoirement mettre à jour.

## 🔒 Sécurité

- Les APK sont hébergés sur GitHub (sécurisé)
- L'utilisateur doit autoriser l'installation depuis des sources inconnues
- Seul le propriétaire du repo peut publier des releases

## 📊 Exemple de workflow complet

```bash
# 1. Modifier la version
nano mobile/pubspec.yaml  # Changer version: 1.0.2+3

# 2. Build
cd mobile
flutter clean
flutter build apk --release

# 3. Créer GitHub Release avec l'APK

# 4. Mettre à jour version.json
nano version.json  # Modifier version, buildNumber, downloadUrl

# 5. Commit
git add version.json mobile/pubspec.yaml
git commit -m "Release v1.0.2"
git push origin main
```

## ✅ Avantages

- ✅ Pas besoin de Google Play Store
- ✅ Distribution instantanée
- ✅ Contrôle total sur les mises à jour
- ✅ Notes de version personnalisées
- ✅ Mises à jour forcées si nécessaire
- ✅ Gratuit (utilise GitHub)

## ⚠️ Limitations

- ⚠️ L'utilisateur doit autoriser l'installation depuis des sources inconnues
- ⚠️ Pas de mise à jour automatique en arrière-plan (nécessite action utilisateur)
- ⚠️ Nécessite une connexion internet pour vérifier les mises à jour
