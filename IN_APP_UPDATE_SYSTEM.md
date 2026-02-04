# 📱 Guide Complet - Système de Mise à Jour In-App

## Vue d'ensemble

Le système de mise à jour in-app permet aux utilisateurs de recevoir des notifications de nouvelles versions directement dans l'application, sans passer par le Play Store.

## Architecture

```
┌─────────────────────────────────────────┐
│      Application Flutter Mobile         │
├─────────────────────────────────────────┤
│  github_update_service.dart             │
│  - Vérifie les mises à jour             │
│  - Affiche les dialogues                │
│  - Télécharge via url_launcher          │
└─────────────────────────────────────────┘
              ↓
    ┌─────────────────────┐
    │   GitHub Releases   │
    │ pollomax847/        │
    │ assistant_entretien │
    │ _chaudiere          │
    └─────────────────────┘
              ↓
    ┌─────────────────────┐
    │   version.json      │
    │   (raw.github...)   │
    │   buildNumber: 7    │
    └─────────────────────┘
```

## Fichiers clés

### 1. `/version.json` (Racine du repo)
Manifeste de version accessible via GitHub Raw:
```json
{
  "version": "1.1.0",
  "buildNumber": "7",
  "downloadUrl": "https://github.com/pollomax847/assistant_entretien_chaudiere/releases/download/v1.1.0-build7/app-release.apk",
  "releaseNotes": "Détails des changements...",
  "minVersion": "1.0.0",
  "forceUpdate": false,
  "releaseDate": "2026-02-04"
}
```

**URL d'accès public:**
```
https://raw.githubusercontent.com/pollomax847/assistant_entretien_chaudiere/main/version.json
```

### 2. `mobile/lib/services/github_update_service.dart`
Service Dart qui:
- Récupère version.json depuis GitHub
- Compare buildNumber courant vs distant
- Affiche un dialogue si mise à jour disponible
- Lance le téléchargement via `url_launcher`

### 3. `mobile/pubspec.yaml`
Déclaration de la version:
```yaml
version: 1.1.0+7  # version: buildNumber
```

## Flux de vérification

```
1. App démarre
   ↓
2. Après 3 secondes, checkOnAppStart() est appelé
   ↓
3. Récupère version courante: PackageInfo → "1.1.0+7"
   ↓
4. Télécharge version.json depuis GitHub
   ↓
5. Compare: buildNumber_distant > buildNumber_actuel
   6 > 7? NON → Pas de mise à jour
   7 > 7? NON → Pas de mise à jour
   8 > 7? OUI → Mise à jour disponible!
   ↓
6. Si mise à jour:
   - Affiche dialogue avec changements
   - Utilisateur clique "Télécharger"
   - url_launcher ouvre le lien APK
   - Navigateur télécharge le fichier
   ↓
7. Utilisateur installe l'APK
```

## 🚀 Comment publier une mise à jour

### Étape 1: Incrémenter la version
Modifier `mobile/pubspec.yaml`:
```yaml
version: 1.1.1+8  # Exemple: nouvelle version mineure, build 8
```

### Étape 2: Compiler l'APK
```bash
cd mobile
flutter clean
flutter build apk --release
```

### Étape 3: Mettre à jour version.json
Modifier `/version.json`:
```json
{
  "version": "1.1.1",
  "buildNumber": "8",
  "downloadUrl": "https://github.com/pollomax847/assistant_entretien_chaudiere/releases/download/v1.1.1-build8/app-release.apk",
  "releaseNotes": "- Changement 1\n- Changement 2",
  "minVersion": "1.0.0",
  "forceUpdate": false,
  "releaseDate": "YYYY-MM-DD"
}
```

### Étape 4: Committer et pousser
```bash
git add mobile/pubspec.yaml version.json
git commit -m "chore: Release v1.1.1 build 8"
git push origin main
```

### Étape 5: Créer une release GitHub
```bash
# Utiliser le script fourni
chmod +x publish_release.sh
./publish_release.sh

# Ou manuellement avec GitHub CLI
gh release create v1.1.1-build8 \
  mobile/build/app/outputs/flutter-apk/app-release.apk \
  --repo pollomax847/assistant_entretien_chaudiere \
  --title "Release 1.1.1 Build 8" \
  --notes "Descriptions des changements"
```

**Important:** L'APK DOIT être nommé `app-release.apk` et uploadé à:
```
https://github.com/pollomax847/assistant_entretien_chaudiere/releases/download/vX.X.X-buildN/app-release.apk
```

### Étape 6: Les utilisateurs reçoivent la notification
- Au prochain démarrage, l'app détecte la nouvelle version
- Dialogue affiché automatiquement
- Utilisateur peut télécharger et installer

## ✅ Checklist de publication

- [ ] Tester l'APK localement sur un appareil
- [ ] Incrémenter version dans pubspec.yaml
- [ ] Compiler l'APK en release
- [ ] Mettre à jour version.json avec les bonnes URLs
- [ ] Vérifier le buildNumber (DOIT être > ancien buildNumber)
- [ ] Committer et pousser les changements
- [ ] Créer une release GitHub avec l'APK
- [ ] Attendre 1-2 minutes pour que version.json soit accessible
- [ ] Tester sur un appareil: Préférences → Vérifier les mises à jour

## 🐛 Debugging

### Les mises à jour ne s'affichent pas?

1. **Vérifier les logs:**
   ```bash
   flutter logs | grep UpdateCheck
   ```
   Cherchez:
   ```
   [UpdateCheck] Version actuelle: 1.1.0 (build 7)
   [UpdateCheck] Version sur GitHub: 1.1.1 (build 8)
   [UpdateCheck] Comparaison: 8 > 7 = true
   [UpdateCheck] ✅ Mise à jour disponible!
   ```

2. **Vérifier l'accès au version.json:**
   ```bash
   curl -v https://raw.githubusercontent.com/pollomax847/assistant_entretien_chaudiere/main/version.json
   ```
   Doit retourner 200 et le JSON valide

3. **Vérifier que l'APK existe:**
   ```bash
   curl -I https://github.com/pollomax847/assistant_entretien_chaudiere/releases/download/v1.1.1-build8/app-release.apk
   ```

4. **Vérifier la syntaxe JSON:**
   ```bash
   jq . version.json
   ```

## 🔒 Options de sécurité

### forceUpdate: true
Force les utilisateurs à mettre à jour (bouton "Annuler" désactivé):
```json
{
  "forceUpdate": true,
  "minVersion": "1.0.5"
}
```
Utilisé pour les mises à jour critiques de sécurité.

### minVersion
Version minimale requise:
```json
{
  "minVersion": "1.0.0",
  "version": "1.1.1"
}
```
Les applis < 1.0.0 reçoivent un message d'erreur.

## 📊 Historique des versions

| Build | Version | Date | APK | Notes |
|-------|---------|------|-----|-------|
| 6 | 1.1.0 | 2026-02-03 | ✅ | Version précédente |
| 7 | 1.1.0 | 2026-02-04 | ❌ | Correcion URLs GitHub |
| 8+ | 1.1.1+ | À venir | Prévu | Futures mises à jour |

## 🔗 Ressources

- [GitHub Releases API](https://docs.github.com/en/rest/releases/)
- [Flutter url_launcher](https://pub.dev/packages/url_launcher)
- [Flutter package_info_plus](https://pub.dev/packages/package_info_plus)

## 📞 Support

Si vous avez des questions ou des problèmes:
1. Vérifiez les logs avec `flutter logs`
2. Vérifiez que version.json est accessible en ligne
3. Vérifiez que les buildNumbers sont correctement incrémentés
