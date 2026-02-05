#!/bin/bash
# Script de publication d'une release GitHub avec numérotation correcte

set -e

REPO="assistant_entretien_chaudiere"
OWNER="pollomax847"
VERSION="1.1.0"
BUILD="15"
TAG="v${VERSION}-build${BUILD}"
APK_PATH="mobile/build/app/outputs/flutter-apk/app-release.apk"

echo "📦 Publication de la release GitHub"
echo "===================================="
echo "Repository: $OWNER/$REPO"
echo "Tag: $TAG"
echo "Version: $VERSION"
echo "Build: $BUILD"
echo ""

# Vérifier que gh CLI est installé
if ! command -v gh &> /dev/null; then
    echo "❌ GitHub CLI (gh) n'est pas installé"
    echo "Installation: https://github.com/cli/cli#installation"
    exit 1
fi

# Vérifier l'authentification GitHub
if ! gh auth status > /dev/null 2>&1; then
    echo "❌ Vous n'êtes pas authentifié avec GitHub"
    echo "Veuillez exécuter: gh auth login"
    exit 1
fi

# Vérifier si le tag existe déjà
if git rev-parse "$TAG" >/dev/null 2>&1; then
    echo "⚠️  Le tag $TAG existe déjà"
    read -p "Voulez-vous créer une nouvelle release? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 0
    fi
fi

# Créer le tag Git
echo "🏷️  Création du tag Git: $TAG"
git tag -a "$TAG" -m "Release $TAG" || echo "⚠️  Le tag existe déjà localement"

# Pousser le tag
echo "⬆️  Envoi du tag vers GitHub..."
git push origin "$TAG" 2>/dev/null || echo "⚠️  Le tag existe déjà sur GitHub"

# Attendre que le tag soit disponible
sleep 2

# Créer la release GitHub
echo "🚀 Création de la release GitHub..."

# Vérifier si APK existe
if [ -f "$APK_PATH" ]; then
    echo "📦 Attachement de l'APK..."
    gh release create "$TAG" \
        --repo "$OWNER/$REPO" \
        --title "Release $VERSION Build $BUILD" \
        --notes "
## Version $VERSION Build $BUILD

### Changements
- Ajout des photos par mesure VMC (débit et pression)
- Ajout des photos recommandées par non-conformité gaz
- Sauvegarde automatique des photos associées
- Corrections et améliorations de stabilité

### Installation
Téléchargez l'APK ci-dessous et installez-le sur votre appareil Android.

**Note**: Vous devrez d'abord permettre l'installation d'applications de sources inconnues dans les paramètres de sécurité de votre appareil.
" \
        "$APK_PATH#app-release.apk" || echo "⚠️  La release existe déjà"
else
    echo "⚠️  APK non trouvé - publication sans APK"
    gh release create "$TAG" \
        --repo "$OWNER/$REPO" \
        --title "Release $VERSION Build $BUILD" \
        --notes "
## Version $VERSION Build $BUILD

### Changements
- Mise à jour de version
- Détection automatique de mise à jour

Cette release contient une mise à jour du numéro de version.
L'application détectera automatiquement cette nouvelle version.
" || echo "⚠️  La release existe déjà"
fi

echo ""
echo "✅ Publication terminée!"
echo "🔗 Voir la release: https://github.com/$OWNER/$REPO/releases/tag/$TAG"
echo ""
echo "🔄 Mise à jour in-app:"
echo "- version.json à jour ✅"
echo "- Service GitHub mis à jour ✅"
echo "- Détection automatique à la prochaine compilation"
