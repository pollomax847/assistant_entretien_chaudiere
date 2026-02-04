# Guide de Troubleshooting - Mise à Jour In-App

## Problèmes Courants et Solutions

### 1. La mise à jour in-app ne s'affiche pas au démarrage

**Causes possibles:**
- L'app ne s'affiche pas sur le Google Play Store
- L'app est en développement (version de debug)
- Pas de nouvelle version disponible
- Délai de propagation Google Play (24-48 heures)

**Solutions:**
1. Vérifiez que l'app est publiée sur Google Play Console
2. Assurez-vous que le versionCode a augmenté
3. Testez avec une APK release signée
4. Vérifiez les logs (Logcat) pour les erreurs détaillées

### 2. Vérifier les logs de mise à jour

Exécutez ces commandes pour voir les logs détaillés:

```bash
# Voir tous les logs
flutter logs

# Filtrer sur la mise à jour
flutter logs | grep -i "update\|mise"

# Avec le plugin in_app_update
flutter logs | grep -E "updateAvailability|flexibleUpdate|immediateUpdate"
```

### 3. Points à vérifier en debug

**Version et BuildNumber:**
```bash
# Dans pubspec.yaml, vérifiez:
version: 1.1.0+7  # Format: version+buildNumber

# Chaque nouvelle version DOIT avoir un buildNumber plus élevé
# 1.1.0+7 → 1.1.0+8 → 1.1.0+9 etc.
```

**Version.json sur GitHub:**
```json
{
  "version": "1.1.0",
  "buildNumber": "6",
  "downloadUrl": "https://github.com/...",
  "forceUpdate": false
}
```

### 4. Configuration Android requise

**Dans android/app/build.gradle.kts:**
- ✅ minSdk >= 21
- ✅ targetSdk >= 30
- ✅ compileSdk = 34

**Dans pubspec.yaml:**
```yaml
dependencies:
  in_app_update: ^4.2.0  # ✅ OBLIGATOIRE
  package_info_plus: ^4.2.0
```

### 5. Permissions requises

**Dans android/app/src/main/AndroidManifest.xml:**
```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

### 6. Ordre de vérification des mises à jour

L'app essaie dans cet ordre:
1. **Google Play (UpdateService)** - via in_app_update
2. **GitHub (GitHubUpdateService)** - fallback si Play échoue

### 7. Test manuel

Dans les Préférences (⚙️), cliquez sur "Vérifier les mises à jour" pour forcer une vérification manuelle.

### 8. Testing sur APK de debug

Pour tester sur une APK de debug:
1. Les APK de debug ne peuvent pas utiliser l'API Google Play
2. Utilisez le fallback GitHub (automatique)
3. Téléchargement manuel du fichier APK

## Points de Dépannage Spécifiques

### UpdateService retourne `updateNotAvailable`

**Cela signifie:**
- L'app est à jour
- L'app n'est pas publiée sur Play Store
- L'app est de debug (Play Store l'ignore)

### UpdateService lance une exception

**Vérifiez:**
- Connexion internet active
- Google Play Services installé et à jour
- App signée avec les certificats Google Play
- Package name correspond à celui de Play Store

### Message: "Permission denied" ou "PlayStore error"

**Solutions:**
- Utilisez une APK release signée
- Installez Google Play Services à jour
- Vérifiez la signature et le certificat

## Mode Développement vs Production

| Mode | Mise à Jour | Source |
|------|-----------|--------|
| Debug APK | ❌ Google Play | ✅ GitHub (fallback) |
| Release APK (local) | ❌ Google Play | ✅ GitHub (fallback) |
| Release APK (Play Store) | ✅ Google Play | Pas de fallback |

## Commandes Utiles

```bash
# Voir la version actuellement compilée
grep "version:" mobile/pubspec.yaml

# Récupérer la version et buildNumber depuis l'APK
aapt dump badging mobile/build/app/outputs/apk/release/app-release.apk

# Vérifier les logs avec filtering
flutter logs --filter "in_app_update"

# Rebuild après changement pubspec
flutter clean && flutter pub get

# Build release
flutter build apk --release
```

## Dépannage Avancé

### 1. Logger détaillé

Vous verrez des logs comme:

```
🔄 Vérification des mises à jour via Google Play...
📱 Info mise à jour: UpdateAvailability.updateAvailable
✅ Mise à jour disponible!
```

ou

```
⚠️ Mise à jour Google Play échouée: PlatformException...
⏳ Fallback GitHub actif
```

### 2. Valider le JSON de version

```bash
# Sur le repo GitHub
curl https://raw.githubusercontent.com/pollomax847/assitant_entreiten_chaudiere/main/version.json
```

Le JSON doit être valide et contenir tous les champs requis.

### 3. Vérifier la URL d'APK

La URL dans `downloadUrl` doit être:
- Valide et accessible
- Pointant vers une APK v1 ou v2 signée
- Compatible avec la plateforme (arm64-v8a pour les appareils modernes)

