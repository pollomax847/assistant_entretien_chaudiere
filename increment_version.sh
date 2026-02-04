#!/bin/bash
# Script pour incrémenter la version et préparer une nouvelle mise à jour

set -e

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔄 Script d'incrémentation de version${NC}"
echo "=========================================="

# Lire la version actuelle
PUBSPEC="mobile/pubspec.yaml"
VERSION=$(grep "^version:" "$PUBSPEC" | head -1 | sed 's/version: //' | cut -d'+' -f1)
BUILD=$(grep "^version:" "$PUBSPEC" | head -1 | sed 's/.*+//')

echo -e "${YELLOW}Version actuelle:${NC} $VERSION (build $BUILD)"

# Parser la version
MAJOR=$(echo $VERSION | cut -d. -f1)
MINOR=$(echo $VERSION | cut -d. -f2)
PATCH=$(echo $VERSION | cut -d. -f3)

# Incrémenter le build
NEW_BUILD=$((BUILD + 1))
NEW_VERSION="$MAJOR.$MINOR.$PATCH"

echo -e "${YELLOW}Nouvelle version:${NC} $NEW_VERSION (build $NEW_BUILD)"
echo ""

# Demander confirmation
read -p "Êtes-vous sûr? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Annulé"
    exit 0
fi

echo ""
echo -e "${BLUE}📝 Mise à jour des fichiers...${NC}"

# 1. Mettre à jour pubspec.yaml
echo "1️⃣  Mise à jour pubspec.yaml..."
sed -i "s/^version: .*/version: $NEW_VERSION+$NEW_BUILD/" "$PUBSPEC"
echo -e "   ${GREEN}✓ pubspec.yaml${NC}"

# 2. Mettre à jour version.json
echo "2️⃣  Mise à jour version.json..."
cat > version.json << EOF
{
  "version": "$NEW_VERSION",
  "buildNumber": "$NEW_BUILD",
  "downloadUrl": "https://github.com/pollomax847/assistant_entretien_chaudiere/releases/download/v$NEW_VERSION-build$NEW_BUILD/app-release.apk",
  "releaseNotes": "✨ Version $NEW_VERSION build $NEW_BUILD - Mise à jour mineure\n\n📦 Nouvelles fonctionnalités:\n- Support des photos dans les relevés techniques\n- Pagination améliorée pour les formulaires\n- Bannière de notification des mises à jour\n- Meilleure gestion des mises à jour in-app\n\n🐛 Corrections:\n- Résolution des problèmes de synchronisation\n- Optimisation de la performance\n\n💡 Améliorations:\n- Interface utilisateur rafraîchie\n- Meilleur support des appareils mobiles",
  "minVersion": "1.0.0",
  "forceUpdate": false,
  "releaseDate": "$(date '+%Y-%m-%d')"
}
EOF
echo -e "   ${GREEN}✓ version.json${NC}"

# 3. Mettre à jour publish_release.sh
echo "3️⃣  Mise à jour publish_release.sh..."
sed -i "s/VERSION=\"[^\"]*\"/VERSION=\"$NEW_VERSION\"/" publish_release.sh
sed -i "s/BUILD=\"[^\"]*\"/BUILD=\"$NEW_BUILD\"/" publish_release.sh
echo -e "   ${GREEN}✓ publish_release.sh${NC}"

# 4. Mettre à jour quick_test_update.sh
echo "4️⃣  Mise à jour quick_test_update.sh..."
sed -i "s/EXPECTED_VERSION=\"[^\"]*\"/EXPECTED_VERSION=\"$NEW_VERSION\"/" quick_test_update.sh
sed -i "s/EXPECTED_BUILD=\"[^\"]*\"/EXPECTED_BUILD=\"$NEW_BUILD\"/" quick_test_update.sh
echo -e "   ${GREEN}✓ quick_test_update.sh${NC}"

echo ""
echo -e "${GREEN}✅ Fichiers mis à jour avec succès!${NC}"
echo ""
echo -e "${YELLOW}Prochaines étapes:${NC}"
echo "1️⃣  Compiler l'APK: cd mobile && flutter clean && flutter build apk --release"
echo "2️⃣  Publier la release: ./publish_release.sh"
echo "3️⃣  Commiter les changements: git add . && git commit -m 'Version $NEW_VERSION build $NEW_BUILD'"
echo ""
echo -e "${BLUE}📝 Notes:${NC}"
echo "- Éditer version.json pour les notes de version détaillées"
echo "- Éditer publish_release.sh pour les notes complètes si besoin"
echo "- Les clients vont automatiquement détecter la nouvelle version!"
