# 📦 Guide Complet du Système de Mise à Jour In-App

## 🎯 Vue d'Ensemble

L'application dispose d'un système de mise à jour automatique qui:
- ✅ Détecte les nouvelles versions automatiquement au démarrage
- ✅ Affiche une bannière persistante quand une mise à jour est disponible
- ✅ Permet aux utilisateurs de télécharger et installer manuellement via 3 points d'accès
- ✅ Supporte les mises à jour forcées (mandatory)
- ✅ Fonctionne avec GitHub Releases

---

## 🚀 Processus de Déploiement Complet

### **Étape 1: Incrémenter la Version**

```bash
./increment_version.sh
```

Ce script:
- Augmente le build number automatiquement
- Met à jour `mobile/pubspec.yaml`
- Met à jour `version.json`
- Met à jour les scripts de publication

### **Étape 2: Compiler l'APK**

```bash
cd mobile
flutter clean
flutter build apk --release
cd ..
```

### **Étape 3: Publier sur GitHub**

```bash
./publish_release.sh
```

Ce script:
- Crée un tag Git
- Crée une release GitHub
- Attache l'APK compilé
- Configure tout pour la détection automatique

### **RACCOURCI: Faire tout automatiquement**

```bash
./deploy_update.sh
```

Ce script unique:
1. ✅ Incrémente la version
2. ✅ Compile l'APK
3. ✅ Publie la release GitHub
4. ✅ Met à jour tous les fichiers

---

## 📋 Fichiers Impliqués

### Fichiers à Modifier Automatiquement

| Fichier | Contenu | Automatique |
|---------|---------|------------|
| `mobile/pubspec.yaml` | Version et build number | ✅ |
| `version.json` | Infos de version et URL | ✅ |
| `publish_release.sh` | Version/Build du script | ✅ |

### Fichiers d'Infrastructure

| Fichier | Purpose |
|---------|---------|
| `mobile/lib/services/github_update_service.dart` | Service de mise à jour |
| `mobile/lib/utils/widgets/update_banner_widget.dart` | Widget bannière |
| `mobile/lib/screens/home_screen.dart` | Intégration dans l'accueil |
| `mobile/lib/screens/preferences_screen.dart` | Bouton dans paramètres |

---

## 🔍 Structure de version.json

```json
{
  "version": "1.1.0",
  "buildNumber": "8",
  "downloadUrl": "https://github.com/pollomax847/assistant_entretien_chaudiere/releases/download/v1.1.0-build8/app-release.apk",
  "releaseNotes": "Description des changements...",
  "minVersion": "1.0.0",
  "forceUpdate": false,
  "releaseDate": "2026-02-04"
}
```

### Champs Importants

- **version**: Version sémantique (M.m.p)
- **buildNumber**: Numéro de build (entier, incrémenté à chaque release)
- **downloadUrl**: URL directe vers l'APK sur GitHub
- **releaseNotes**: Description des changements (supports `\n`)
- **forceUpdate**: `true` = mise à jour obligatoire, `false` = optionnelle
- **minVersion**: Version minimale requise pour utiliser l'app

---

## 🔄 Flux de Détection Automatique

```
Utilisateur ouvre l'app
          ↓
Démarrage de HomeScreen
          ↓
_checkForUpdates() lancé
          ↓
Essai Google Play d'abord
     ↓          ↓
   Succès    Erreur → Fallback GitHub
     ↓          ↓
   Affiche       GitHubUpdateService.checkForUpdate()
   Bannière                    ↓
     ↓                Récupère https://raw.githubusercontent.com/.../version.json
     ↓                    ↓
     ↓              Compare buildNumbers
     ↓                    ↓
     ↓              buildGithub > buildLocal?
     ↓                 ↓        ↓
     ↓               OUI      NON
     ↓                ↓        ↓
     ↓            Affiche   Rien
     ↓            Bannière
     ↓
User peut:
  1. Cliquer "Télécharger" → Ouvre URL → Télécharge APK
  2. Cliquer "X" → Masque bannière (si optionnelle)
  3. Cliquer bouton AppBar → Même action
  4. Aller à Paramètres → Cliquer "Vérifier"
```

---

## 📍 Points d'Accès pour l'Utilisateur

### 1️⃣ Accueil (Plus Visible)
```
Écran principal
  ↓
Carte bleue: "Vérifier les mises à jour"
  ↓
[Vérifier] → Lance recherche
```

### 2️⃣ AppBar (Toujours Visible)
```
En haut à droite: Icône ☁️ (téléchargement)
  ↓
Clique → Vérification manuelle
```

### 3️⃣ Paramètres
```
Paramètres → À propos
  ↓
"Vérifier les mises à jour"
  ↓
Clique → Vérification manuelle
```

---

## 🧪 Test du Système

### Vérifier que tout est configuré:

```bash
./test_update_system.sh
```

### Vérifier manuellement:

```bash
# Vérifier la synchronisation des versions
grep "^version:" mobile/pubspec.yaml
grep '"version"' version.json

# Vérifier les services de mise à jour
grep "checkForUpdate" mobile/lib/services/github_update_service.dart

# Vérifier les boutons
grep "cloud_download\|Vérifier les mises à jour" mobile/lib/screens/home_screen.dart
```

---

## 🚨 Scénarios Spéciaux

### Mise à Jour Forcée

Pour forcer une mise à jour (l'utilisateur ne peut pas ignorer):

```json
{
  ...
  "forceUpdate": true,
  "releaseNotes": "🚨 MISE À JOUR OBLIGATOIRE\n\nCette version corrige des bugs critiques."
}
```

→ Bannière **ROUGE** + Dialog **obligatoire** + Pas de bouton fermer

### Désactiver les Mises à Jour

```json
{
  ...
  "buildNumber": "0"
}
```

→ Aucune mise à jour ne sera détectée

### Test en Développement

Modifier temporairement `version.json`:

```bash
# Test: créer une fausse mise à jour
cp version.json version.json.backup
sed -i 's/"buildNumber": "[^"]*"/"buildNumber": "999"/' version.json

# Recompiler et tester
cd mobile && flutter run

# Restaurer
mv version.json.backup version.json
```

---

## ✅ Checklist avant Déploiement

- [ ] Exécuter les tests: `./test_update_system.sh`
- [ ] Vérifier que l'APK se compile: `cd mobile && flutter build apk --release`
- [ ] Vérifier que GitHub CLI est installé: `gh --version`
- [ ] Authentifié à GitHub: `gh auth status`
- [ ] Notes de version mises à jour dans `version.json`
- [ ] Build number correct dans `pubspec.yaml`
- [ ] Aucune erreur de compilation

---

## 📊 Versions Actuelles

```bash
# Lire les versions:
grep "^version:" mobile/pubspec.yaml       # Version dans l'app
grep '"buildNumber"' version.json          # Version disponible en ligne
```

---

## 🔗 Ressources

- **GitHub Releases**: https://github.com/pollomax847/assistant_entretien_chaudiere/releases
- **version.json URL**: https://raw.githubusercontent.com/pollomax847/assistant_entretien_chaudiere/main/version.json
- **Service**: `mobile/lib/services/github_update_service.dart`
- **Bannière**: `mobile/lib/utils/widgets/update_banner_widget.dart`

---

## 🎯 Résumé Rapide

```bash
# Nouvelle mise à jour? Une commande suffit:
./deploy_update.sh

# C'est tout! L'app va automatiquement détecter la nouvelle version
# et afficher une bannière aux utilisateurs.
```

🚀 **Système de mise à jour prêt pour la production!**
