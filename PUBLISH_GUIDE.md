# 🚀 Guide de Publication Automatique

Ce guide explique comment publier automatiquement une nouvelle version de l'application avec mise à jour in-app.

## 📋 Prérequis (Installation unique)

### 1. Installer GitHub CLI

**Ubuntu/Debian :**
```bash
sudo apt install gh
```

**Ou via snap :**
```bash
sudo snap install gh
```

**Vérifier l'installation :**
```bash
gh --version
```

### 2. S'authentifier avec GitHub

```bash
gh auth login
```

Suivez les étapes :
1. Choisir `GitHub.com`
2. Choisir `HTTPS`
3. Choisir `Login with a web browser`
4. Copier le code affiché
5. Appuyer sur Entrée pour ouvrir le navigateur
6. Coller le code et autoriser

**Vérifier l'authentification :**
```bash
gh auth status
```

Vous devriez voir : `✓ Logged in to github.com as [votre-nom]`

## 🎯 Publier une Nouvelle Version

### Méthode Simple (Une seule commande)

```bash
./publish.sh "Description de la mise à jour"
```

**Exemple :**
```bash
./publish.sh "Correction des boutons Tests et Contrôles, amélioration de l'interface"
```

### Ce que le script fait automatiquement

1. ✅ Incrémente la version et le build number
2. ✅ Met à jour `pubspec.yaml`
3. ✅ Compile l'APK en mode release
4. ✅ Crée un tag Git
5. ✅ Crée une GitHub Release
6. ✅ Upload l'APK sur GitHub
7. ✅ Met à jour `version.json` avec la bonne URL
8. ✅ Commit et push tous les changements

### Déroulement interactif

Le script vous demandera :
```
Nouvelle version [1.1.0] : 1.2.0
Nouveau build number [3] : 3
Continuer avec cette version ? (y/n) y
```

Appuyez sur `Entrée` pour garder les valeurs suggérées, ou entrez vos propres valeurs.

## 📱 Résultat

Après exécution, vous obtenez :
- 📦 APK uploadé sur GitHub Releases
- 🔗 URL publique de téléchargement
- 📱 Les utilisateurs reçoivent automatiquement la notification de MAJ

**Exemple de sortie :**
```
═══════════════════════════════════════════════════════
          Publication terminée avec succès !
═══════════════════════════════════════════════════════

📦 Version      : 1.2.0 (build 3)
🏷️  Tag         : v1.2.0
📱 APK         : 45M
🔗 Release     : https://github.com/pollomax847/assitant_entreiten_chaudiere/releases/tag/v1.2.0
📥 Download    : https://github.com/pollomax847/assitant_entreiten_chaudiere/releases/download/v1.2.0/app-release.apk

Les utilisateurs recevront automatiquement la notification de mise à jour !
```

## 🔧 Options Avancées

### Forcer une mise à jour obligatoire

Après la publication, éditez `version.json` et changez :
```json
"forceUpdate": true
```

Puis commit/push :
```bash
git add version.json
git commit -m "Force update for version X.X.X"
git push
```

### Vérifier les releases existantes

```bash
gh release list
```

### Supprimer une release

```bash
gh release delete v1.2.0
```

## ❓ Dépannage

### "GitHub CLI (gh) n'est pas installé"
→ Installez gh : `sudo apt install gh`

### "Vous n'êtes pas authentifié"
→ Exécutez : `gh auth login`

### "La compilation a échoué"
→ Vérifiez que Flutter est installé et à jour : `flutter doctor`

### Voir les logs détaillés
Le script affiche tous les messages. En cas d'erreur, le message sera en rouge.

## 📊 Workflow Recommandé

1. **Développer** vos fonctionnalités
2. **Tester** l'application localement
3. **Commit** vos changements de code
4. **Publier** avec `./publish.sh "Description des changements"`
5. **Vérifier** la release sur GitHub
6. **Attendre** que les utilisateurs reçoivent la notification

## 🎯 Avantages

✅ **Simple** : Une seule commande
✅ **Rapide** : 3-5 minutes total
✅ **Automatique** : Pas de manipulation manuelle
✅ **Fiable** : Pas d'oubli de version.json
✅ **Professionnel** : Releases GitHub comme les vrais projets

---

**Prêt à publier ?** 🚀
```bash
./publish.sh "Ma première release automatique !"
```
