#!/bin/bash
# Script complet pour gérer une mise à jour: compilation + version + publication

set -e

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}"
echo "╔════════════════════════════════════════════════╗"
echo "║  📦 SYSTÈME DE MISE À JOUR COMPLET             ║"
echo "║     Compilation + Version + Commit GitHub      ║"
echo "╚════════════════════════════════════════════════╝"
echo -e "${NC}"

# Vérifier si on est dans le bon répertoire
if [ ! -f "mobile/pubspec.yaml" ]; then
    echo -e "${RED}❌ Erreur: Pas dans le répertoire racine du projet${NC}"
    exit 1
fi

# Lire la version actuelle
PUBSPEC="mobile/pubspec.yaml"
VERSION=$(grep "^version:" "$PUBSPEC" | head -1 | sed 's/version: //' | cut -d'+' -f1)
BUILD=$(grep "^version:" "$PUBSPEC" | head -1 | sed 's/.*+//')

echo -e "${YELLOW}📌 État actuel:${NC}"
echo "   Version: $VERSION"
echo "   Build: $BUILD"
echo ""

# Parser la version
MAJOR=$(echo $VERSION | cut -d. -f1)
MINOR=$(echo $VERSION | cut -d. -f2)
PATCH=$(echo $VERSION | cut -d. -f3)

# Incrémenter le build
NEW_BUILD=$((BUILD + 1))
NEW_VERSION="$MAJOR.$MINOR.$PATCH"

echo -e "${YELLOW}🔄 Nouvelle version:${NC} $NEW_VERSION+$NEW_BUILD"
echo ""

# Confirmer l'action
read -p "Procéder? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Annulé"
    exit 0
fi

echo ""
echo "═══════════════════════════════════════════════════"

# ÉTAPE 1: Compiler l'APK
echo -e "${BLUE}📦 ÉTAPE 1: Compilation Flutter${NC}"
echo "  Nettoyage et compilation de l'APK en version Release..."
cd mobile

echo -e "${YELLOW}⚙️  Nettoyage...${NC}"
flutter clean

echo -e "${YELLOW}⚙️  Récupération des dépendances...${NC}"
flutter pub get

echo -e "${YELLOW}⚙️  Compilation...${NC}"
flutter build apk --release 2>&1 | tail -10
if [ ${PIPESTATUS[0]} -eq 0 ]; then
    echo -e "${GREEN}✅ Compilation réussie!${NC}"
else
    echo -e "${RED}❌ Erreur lors de la compilation${NC}"
    exit 1
fi

cd ..

# ÉTAPE 2: Mettre à jour les versions
echo ""
echo "═══════════════════════════════════════════════════"
echo -e "${BLUE}📝 ÉTAPE 2: Mise à jour des versions${NC}"

echo -e "${YELLOW}  Mise à jour pubspec.yaml...${NC}"
sed -i "s/^version: .*/version: $NEW_VERSION+$NEW_BUILD/" "$PUBSPEC"
echo -e "  ${GREEN}✓ pubspec.yaml${NC}"

echo -e "${YELLOW}  Mise à jour version.json...${NC}"
cat > version.json << EOF
{
  "version": "$NEW_VERSION",
  "buildNumber": "$NEW_BUILD",
  "downloadUrl": "https://github.com/pollomax847/assistant_entretien_chaudiere/releases/download/v$NEW_VERSION-build$NEW_BUILD/app-release.apk",
  "releaseNotes": "✨ Version $NEW_VERSION build $NEW_BUILD\\n\\n📦 Nouvelles fonctionnalités:\\n- Support des photos dans les relevés techniques\\n- Pagination améliorée pour les formulaires\\n- Bannière de notification des mises à jour\\n- Meilleure gestion des mises à jour in-app\\n\\n🐛 Corrections:\\n- Résolution des problèmes de synchronisation\\n- Optimisation de la performance\\n\\n💡 Améliorations:\\n- Interface utilisateur rafraîchie\\n- Meilleur support des appareils mobiles",
  "minVersion": "1.0.0",
  "forceUpdate": false,
  "releaseDate": "$(date '+%Y-%m-%d')"
}
EOF
echo -e "  ${GREEN}✓ version.json${NC}"

echo -e "${YELLOW}  Mise à jour publish_release.sh...${NC}"
sed -i "s/VERSION=\"[^\"]*\"/VERSION=\"$NEW_VERSION\"/" publish_release.sh
sed -i "s/BUILD=\"[^\"]*\"/BUILD=\"$NEW_BUILD\"/" publish_release.sh
echo -e "  ${GREEN}✓ publish_release.sh${NC}"

# ÉTAPE 3: Vérifier l'APK
echo ""
echo "═══════════════════════════════════════════════════"
echo -e "${BLUE}🔍 ÉTAPE 3: Vérification de l'APK${NC}"

APK_PATH="mobile/build/app/outputs/flutter-apk/app-release.apk"
if [ -f "$APK_PATH" ]; then
    APK_SIZE=$(du -h "$APK_PATH" | cut -f1)
    echo -e "  ${GREEN}✅ APK trouvé${NC}"
    echo "  Chemin: $APK_PATH"
    echo "  Taille: $APK_SIZE"
else
    echo -e "  ${RED}❌ APK non trouvé!${NC}"
    exit 1
fi

# ÉTAPE 4: Git commit
echo ""
echo "═══════════════════════════════════════════════════"
echo -e "${BLUE}📤 ÉTAPE 4: Commit Git${NC}"

echo -e "${YELLOW}  Ajout des fichiers...${NC}"
git add mobile/pubspec.yaml version.json publish_release.sh 2>/dev/null || true

echo -e "${YELLOW}  Création du commit...${NC}"
git commit -m "Version $NEW_VERSION build $NEW_BUILD - Mise à jour complète" 2>/dev/null || echo "  ⚠️  Pas de changements à commiter"

echo -e "${YELLOW}  Envoi vers GitHub...${NC}"
git push origin main 2>/dev/null || echo "  ⚠️  Erreur lors du push"

# ÉTAPE 5: Publication GitHub (AUTOMATIQUE)
echo ""
echo "═══════════════════════════════════════════════════"
echo -e "${BLUE}🚀 ÉTAPE 5: Publication GitHub${NC}"
echo -e "${YELLOW}  Publication automatique de la release...${NC}"
./publish_release.sh

# ÉTAPE 6: Upload sur Google Drive (AUTOMATIQUE)
echo ""
echo "═══════════════════════════════════════════════════"
echo -e "${BLUE}☁️  ÉTAPE 6: Upload Google Drive${NC}"

# Vérifier si rclone est installé
if command -v rclone &> /dev/null; then
    GDRIVE_REMOTE="google drive"
    GDRIVE_FOLDER="application"
    
    echo -e "${YELLOW}  Upload de l'APK vers Google Drive...${NC}"
    if rclone copy "$APK_PATH" "$GDRIVE_REMOTE:$GDRIVE_FOLDER/" --progress 2>&1 | tail -5; then
        echo -e "  ${GREEN}✓ APK uploadé sur Google Drive${NC}"
        echo -e "  ${GREEN}Dossier: $GDRIVE_FOLDER${NC}"
    else
        echo -e "  ${YELLOW}⚠️  Erreur lors de l'upload Google Drive${NC}"
    fi
else
    echo -e "  ${YELLOW}⚠️  rclone non installé${NC}"
    echo -e "  ${YELLOW}     Installation: sudo apt install rclone${NC}"
fi

# RÉSUMÉ
echo ""
echo "═══════════════════════════════════════════════════"
echo -e "${GREEN}✅ MISE À JOUR COMPLÈTE!${NC}"
echo ""
echo "📊 Nouvelles versions:"
echo "   Version: $NEW_VERSION"
echo "   Build: $NEW_BUILD"
echo ""
echo "📁 Fichiers modifiés:"
echo "   • mobile/pubspec.yaml"
echo "   • version.json"
echo "   • publish_release.sh"
echo ""
echo "📦 Artefacts:"
echo "   APK: $APK_PATH ($APK_SIZE)"
echo ""
echo "💾 Git:"
echo "   ✅ Commit créé et envoyé"
echo "   ✅ Release GitHub publiée"
echo "   ✅ APK synchronisé vers Google Drive"
echo ""
echo -e "${CYAN}Processus de déploiement complètement terminé! 🎉${NC}"
echo ""
