# 🧪 Guide de Test du Système de Mise à Jour In-App

## Vue d'ensemble

Ce dossier contient tous les outils pour tester le système de mise à jour in-app de l'application Chauffage Expert.

## 📁 Scripts de Test

### 1. `quick_test_update.sh` ⚡
**Usage le plus courant - Test rapide**

```bash
./quick_test_update.sh
```

- ✅ Affiche la version actuelle vs distante
- ✅ Indique si une mise à jour serait détectée
- ✅ Rapide et simple

**Quand l'utiliser:** Vérification rapide avant de lancer l'app

---

### 2. `test_update.sh` 🔍
**Test complet de la configuration**

```bash
./test_update.sh
```

- ✅ Vérifie tous les fichiers de configuration
- ✅ Teste la connectivité GitHub
- ✅ Valide l'intégration dans le code
- ✅ Affiche un résumé détaillé

**Quand l'utiliser:** Après avoir modifié la configuration ou avant un déploiement

---

### 3. `test_update.py` 🐍
**Test avec simulation du dialogue**

```bash
python3 test_update.py
```

- ✅ Simule le comportement de GitHubUpdateService
- ✅ Affiche un aperçu du dialogue de mise à jour
- ✅ Teste la connexion à GitHub
- ✅ Valide la logique de comparaison

**Quand l'utiliser:** Pour voir comment le dialogue apparaîtra à l'utilisateur

---

### 4. `test_update_integration.py` 🎯
**Suite complète de tests d'intégration**

```bash
python3 test_update_integration.py
```

- ✅ 10+ tests unitaires de comparaison de versions
- ✅ Tests de tous les flux utilisateur
- ✅ Vérification de l'intégration
- ✅ Validation complète du système

**Quand l'utiliser:** Avant une release importante ou après des modifications du code

---

## 🎮 Scénarios de Test

### Scénario 1: Tester la détection de mise à jour

1. **Modifier version.json pour simuler une nouvelle version:**
   ```bash
   # Sauvegarder l'original
   cp version.json version.json.backup
   
   # Éditer version.json et augmenter le buildNumber
   nano version.json  # Changer "buildNumber": "4" en "buildNumber": "5"
   ```

2. **Vérifier que la mise à jour sera détectée:**
   ```bash
   ./quick_test_update.sh
   ```

3. **Tester dans l'app:**
   ```bash
   cd mobile
   flutter run
   # Attendre 3 secondes - la popup devrait apparaître
   ```

4. **Restaurer l'original:**
   ```bash
   cp version.json.backup version.json
   ```

---

### Scénario 2: Tester la vérification manuelle

1. **Lancer l'app:**
   ```bash
   cd mobile
   flutter run
   ```

2. **Dans l'app:**
   - Aller dans le menu
   - Sélectionner "Préférences"
   - Descendre à "À propos"
   - Cliquer sur "Vérifier les mises à jour"

3. **Résultat attendu:**
   - Si version.json a un build supérieur → dialogue de mise à jour
   - Sinon → message "Vous utilisez la dernière version"

---

### Scénario 3: Tester la mise à jour forcée

1. **Modifier version.json:**
   ```json
   {
     "version": "1.2.0",
     "buildNumber": "5",
     "forceUpdate": true,  // ← Activer la mise à jour forcée
     ...
   }
   ```

2. **Lancer l'app:**
   ```bash
   cd mobile
   flutter run
   ```

3. **Résultat attendu:**
   - Dialogue avec icône ⚠️ "Mise à jour requise"
   - Impossible de fermer le dialogue
   - Seul le bouton "Télécharger" disponible

---

### Scénario 4: Tester la gestion des erreurs réseau

1. **Désactiver le WiFi/réseau**

2. **Lancer l'app et vérifier les mises à jour**

3. **Résultat attendu:**
   - Pas d'erreur visible pour l'utilisateur
   - L'app fonctionne normalement
   - En développement: logs dans la console

---

## 📊 Résultats de Test

Les résultats des tests sont documentés dans [TEST_RESULTS.md](TEST_RESULTS.md)

---

## 🔧 Architecture du Système

```
┌─────────────────────────────────────────────────┐
│  App Flutter                                     │
│  ┌───────────────────────────────────────────┐  │
│  │ main.dart                                  │  │
│  │  └─ AppWithUpdateCheck                    │  │
│  │      └─ checkOnAppStart() après 3s        │  │
│  └───────────────────────────────────────────┘  │
│                    ↓                             │
│  ┌───────────────────────────────────────────┐  │
│  │ GitHubUpdateService                       │  │
│  │  - checkForUpdate()                       │  │
│  │  - showUpdateDialog()                     │  │
│  │  - downloadUpdate()                       │  │
│  └───────────────────────────────────────────┘  │
└─────────────────────────────────────────────────┘
                    ↓
          Récupère version.json
                    ↓
┌─────────────────────────────────────────────────┐
│  GitHub Repository                               │
│  https://raw.githubusercontent.com/             │
│    pollomax847/assitant_entreiten_chaudiere/    │
│    main/version.json                            │
└─────────────────────────────────────────────────┘
```

---

## 🚀 Workflow de Publication avec Mise à Jour

1. **Développement terminé**

2. **Tester localement:**
   ```bash
   ./test_update_integration.py
   ```

3. **Publier avec le script automatique:**
   ```bash
   ./publish.sh
   ```
   
   Le script `publish.sh`:
   - ✅ Incrémente automatiquement le buildNumber
   - ✅ Compile l'APK
   - ✅ Crée le tag Git
   - ✅ Crée la GitHub Release
   - ✅ Upload l'APK
   - ✅ Met à jour version.json
   - ✅ Push sur GitHub

4. **Les utilisateurs reçoivent la notification:**
   - Au prochain démarrage de l'app (après 3s)
   - OU lors d'une vérification manuelle

---

## 📝 Fichiers Importants

- `version.json` - Configuration de la version distante
- `mobile/pubspec.yaml` - Version de l'app
- `mobile/lib/services/github_update_service.dart` - Service de mise à jour
- `mobile/lib/main.dart` - Intégration du service
- `mobile/lib/screens/preferences_screen.dart` - Vérification manuelle

---

## ✅ Checklist Avant Release

- [ ] Tous les tests passent: `python3 test_update_integration.py`
- [ ] Version correctement incrémentée dans `pubspec.yaml`
- [ ] Build number supérieur au précédent
- [ ] APK compilé et testé: `flutter build apk --release`
- [ ] GitHub Release créée avec l'APK
- [ ] `version.json` mis à jour avec:
  - [ ] Bonne version
  - [ ] Bon buildNumber
  - [ ] URL correcte vers l'APK
  - [ ] Notes de version claires
- [ ] `version.json` pushé sur GitHub (branche main)
- [ ] Test de téléchargement depuis GitHub fonctionnel

---

## 🐛 Dépannage

### L'app ne détecte pas la mise à jour

1. Vérifier les versions:
   ```bash
   ./quick_test_update.sh
   ```

2. Vérifier que version.json est accessible:
   ```bash
   curl https://raw.githubusercontent.com/pollomax847/assitant_entreiten_chaudiere/main/version.json
   ```

3. Vérifier les logs de l'app:
   ```bash
   flutter run
   # Regarder les logs pour "Erreur vérification mise à jour GitHub"
   ```

### Le téléchargement ne fonctionne pas

1. Vérifier l'URL dans version.json
2. Vérifier que la Release GitHub existe
3. Vérifier que l'APK est bien attaché à la Release

### Tests échouent

1. Vérifier la structure des fichiers:
   ```bash
   ./test_update.sh
   ```

2. Vérifier la connexion internet

3. Vérifier que les dépendances sont installées:
   ```bash
   pip3 install requests packaging
   ```

---

## 📚 Documentation Supplémentaire

- [UPDATE_GUIDE.md](UPDATE_GUIDE.md) - Guide complet du système de mise à jour
- [PUBLISH_GUIDE.md](PUBLISH_GUIDE.md) - Guide de publication
- [TEST_RESULTS.md](TEST_RESULTS.md) - Résultats des tests

---

**Dernière mise à jour:** 3 février 2026  
**Statut:** ✅ Système opérationnel et testé
