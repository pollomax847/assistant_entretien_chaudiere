#!/bin/bash
set -e

# Script de publication automatique de l'application
# Usage: ./publish.sh "Message de release"

# Couleurs pour les messages
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Fonction pour afficher les messages
info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

success() {
    echo -e "${GREEN}✓${NC} $1"
}

error() {
    echo -e "${RED}✗${NC} $1"
}

warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

# Vérifier que GitHub CLI est installé
if ! command -v gh &> /dev/null; then
    error "GitHub CLI (gh) n'est pas installé !"
    echo ""
    echo "Pour l'installer :"
    echo "  Ubuntu/Debian: sudo apt install gh"
    echo "  Ou visitez: https://cli.github.com/"
    exit 1
fi

# Vérifier l'authentification GitHub
if ! gh auth status &> /dev/null; then
    error "Vous n'êtes pas authentifié avec GitHub CLI"
    echo ""
    echo "Pour vous authentifier, exécutez :"
    echo "  gh auth login"
    exit 1
fi

# Récupérer le message de release
RELEASE_NOTES="$1"
if [ -z "$RELEASE_NOTES" ]; then
    error "Veuillez fournir un message de release !"
    echo "Usage: ./publish.sh \"Message de release\""
    exit 1
fi

# Aller dans le dossier du projet
cd "$(dirname "$0")"
PROJECT_ROOT=$(pwd)

info "Démarrage du processus de publication..."
echo ""

# 1. Lire la version actuelle
info "Lecture de la version actuelle..."
CURRENT_VERSION=$(grep '^version:' mobile/pubspec.yaml | sed 's/version: //' | sed 's/+.*//')
CURRENT_BUILD=$(grep '^version:' mobile/pubspec.yaml | sed 's/.*+//')

echo "  Version actuelle : $CURRENT_VERSION"
echo "  Build actuel     : $CURRENT_BUILD"
echo ""

# 2. Version fixée à 1.1.0, auto-incrémentation du build
NEW_VERSION="1.1.0"
NEW_BUILD=$((CURRENT_BUILD + 1))

info "Nouvelle version : $NEW_VERSION+$NEW_BUILD (build auto-incrémenté)"
echo ""

# Confirmation
read -p "Continuer avec cette version ? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    warning "Publication annulée"
    exit 0
fi

# 3. Mettre à jour pubspec.yaml
info "Mise à jour de pubspec.yaml..."
sed -i "s/^version: .*/version: $NEW_VERSION+$NEW_BUILD/" mobile/pubspec.yaml
success "pubspec.yaml mis à jour"
echo ""

# 4. Nettoyer et compiler l'APK
info "Nettoyage du projet..."
cd mobile
flutter clean > /dev/null 2>&1
success "Projet nettoyé"
echo ""

info "Compilation de l'APK (cela peut prendre 2-3 minutes)..."
flutter build apk --release

if [ ! -f "build/app/outputs/flutter-apk/app-release.apk" ]; then
    error "La compilation a échoué !"
    exit 1
fi

APK_PATH="build/app/outputs/flutter-apk/app-release.apk"
APK_SIZE=$(du -h "$APK_PATH" | cut -f1)
success "APK compilé avec succès ($APK_SIZE)"
echo ""

# 5. Créer le tag Git
cd "$PROJECT_ROOT"
TAG_NAME="v$NEW_VERSION"

info "Commit des changements..."
git add mobile/pubspec.yaml
git commit -m "Bump version to $NEW_VERSION build $NEW_BUILD" || warning "Aucun changement à commiter"

info "Création du tag $TAG_NAME..."
if git tag -l | grep -q "^$TAG_NAME$"; then
    warning "Le tag $TAG_NAME existe déjà, il sera supprimé"
    git tag -d "$TAG_NAME"
    git push origin :refs/tags/"$TAG_NAME" 2>/dev/null || true
fi

git tag -a "$TAG_NAME" -m "Release $NEW_VERSION - $RELEASE_NOTES"
success "Tag créé"
echo ""

# 6. Créer la GitHub Release et uploader l'APK
info "Création de la GitHub Release et upload de l'APK..."

# Supprimer la release si elle existe déjà
gh release delete "$TAG_NAME" --yes 2>/dev/null || true

# Créer la release avec l'APK
gh release create "$TAG_NAME" \
    "mobile/$APK_PATH#app-release.apk" \
    --title "Version $NEW_VERSION" \
    --notes "$RELEASE_NOTES" \
    --latest

success "Release créée et APK uploadé sur GitHub"
echo ""

# 7. Récupérer l'URL de l'APK
APK_URL=$(gh release view "$TAG_NAME" --json assets --jq '.assets[0].url' | sed 's|https://api.github.com/repos/|https://github.com/|' | sed 's|/assets/.*|/releases/download/'"$TAG_NAME"'/app-release.apk|')

info "URL de l'APK : $APK_URL"
echo ""

# 8. Mettre à jour version.json
info "Mise à jour de version.json..."

cat > version.json <<EOF
{
  "version": "$NEW_VERSION",
  "buildNumber": "$NEW_BUILD",
  "downloadUrl": "$APK_URL",
  "releaseNotes": "$RELEASE_NOTES",
  "minVersion": "1.0.0",
  "forceUpdate": false,
  "releaseDate": "$(date +%Y-%m-%d)"
}
EOF

success "version.json mis à jour"
echo ""

# 9. Commit et push
info "Commit et push des modifications..."
git add version.json
git commit -m "Update version.json for release $NEW_VERSION"
git push origin main
git push origin "$TAG_NAME"

success "Modifications poussées sur GitHub"
echo ""

# 10. Résumé final
echo -e "${GREEN}═══════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}          Publication terminée avec succès !${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════════════${NC}"
echo ""
echo "📦 Version      : $NEW_VERSION (build $NEW_BUILD)"
echo "🏷️  Tag         : $TAG_NAME"
echo "📱 APK         : $APK_SIZE"
echo "🔗 Release     : https://github.com/pollomax847/assitant_entreiten_chaudiere/releases/tag/$TAG_NAME"
echo "📥 Download    : $APK_URL"
echo ""
echo "Les utilisateurs recevront automatiquement la notification de mise à jour !"
echo ""
