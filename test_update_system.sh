#!/bin/bash

# Script de test du système de mise à jour in-app
# Vérifie que tout est configuré correctement

REPO_OWNER="pollomax847"
REPO_NAME="assistant_entretien_chaudiere"
VERSION_FILE="version.json"
PUBSPEC_FILE="mobile/pubspec.yaml"

echo "🔍 Test du système de mise à jour in-app"
echo "=========================================="
echo ""

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

check_mark="✅"
cross_mark="❌"
warning="⚠️"

test_count=0
pass_count=0

# Fonction pour tester
test_item() {
    local name="$1"
    local cmd="$2"
    
    test_count=$((test_count + 1))
    echo -n "[$test_count] $name... "
    
    if eval "$cmd" > /dev/null 2>&1; then
        echo -e "${GREEN}${check_mark}${NC}"
        pass_count=$((pass_count + 1))
        return 0
    else
        echo -e "${RED}${cross_mark}${NC}"
        return 1
    fi
}

# Test 1: Vérifie que version.json existe localement
test_item "Fichier version.json existe" "[ -f '$VERSION_FILE' ]"

# Test 2: Vérifie que pubspec.yaml existe
test_item "Fichier pubspec.yaml existe" "[ -f '$PUBSPEC_FILE' ]"

# Test 3: Vérifie la syntaxe JSON de version.json
test_item "version.json est du JSON valide" "jq empty < '$VERSION_FILE'"

# Test 4: Récupère les versions
echo ""
echo "📋 Informations de version:"
echo "---"

PUBSPEC_VERSION=$(grep "^version:" "$PUBSPEC_FILE" | head -1 | cut -d' ' -f2)
PUBSPEC_BUILD=$(echo "$PUBSPEC_VERSION" | cut -d'+' -f2)

echo "pubspec.yaml:"
echo "  Version: $PUBSPEC_VERSION"
echo "  Build: $PUBSPEC_BUILD"

VERSION_JSON_VERSION=$(jq -r '.version' < "$VERSION_FILE")
VERSION_JSON_BUILD=$(jq -r '.buildNumber' < "$VERSION_FILE")

echo ""
echo "version.json:"
echo "  Version: $VERSION_JSON_VERSION"
echo "  Build: $VERSION_JSON_BUILD"

# Test 5: Vérifier que les versions correspondent
echo ""
echo -n "[5] Versions synchronisées... "
if [ "$PUBSPEC_BUILD" == "$VERSION_JSON_BUILD" ]; then
    echo -e "${GREEN}${check_mark}${NC}"
    pass_count=$((pass_count + 1))
else
    echo -e "${RED}${cross_mark}${NC} (pubspec: $PUBSPEC_BUILD, version.json: $VERSION_JSON_BUILD)"
fi
test_count=$((test_count + 1))

# Test 6: Vérifier l'URL du version.json
echo ""
echo "🌐 URLs de mise à jour:"
echo "---"

DOWNLOAD_URL=$(jq -r '.downloadUrl' < "$VERSION_FILE")
VERSION_URL="https://raw.githubusercontent.com/$REPO_OWNER/$REPO_NAME/main/version.json"

echo "version.json URL:"
echo "  $VERSION_URL"

echo ""
echo "APK download URL:"
echo "  $DOWNLOAD_URL"

# Test 7: Vérifier que version.json est accessible en ligne
test_count=$((test_count + 1))
echo -n "[6] Accès à version.json en ligne... "
STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$VERSION_URL")
if [ "$STATUS" == "200" ]; then
    echo -e "${GREEN}${check_mark}${NC} (HTTP 200)"
    pass_count=$((pass_count + 1))
else
    echo -e "${YELLOW}${warning}${NC} (HTTP $STATUS)"
    if [ "$STATUS" == "404" ]; then
        echo "    Attendez 1-2 minutes après le push pour que le fichier soit accessible"
    fi
fi

# Test 8: Vérifier la structure JSON en ligne
if [ "$STATUS" == "200" ]; then
    test_count=$((test_count + 1))
    echo -n "[7] JSON valide en ligne... "
    REMOTE_JSON=$(curl -s "$VERSION_URL")
    if echo "$REMOTE_JSON" | jq empty > /dev/null 2>&1; then
        echo -e "${GREEN}${check_mark}${NC}"
        pass_count=$((pass_count + 1))
    else
        echo -e "${RED}${cross_mark}${NC}"
    fi
fi

# Test 9: Vérifier le repository GitHub
test_count=$((test_count + 1))
echo ""
echo -n "[8] Repository GitHub existe... "
REPO_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "https://github.com/$REPO_OWNER/$REPO_NAME")
if [ "$REPO_STATUS" == "200" ]; then
    echo -e "${GREEN}${check_mark}${NC}"
    pass_count=$((pass_count + 1))
else
    echo -e "${RED}${cross_mark}${NC}"
fi

# Test 10: Vérifier les releases
test_count=$((test_count + 1))
echo -n "[9] Page des releases accessible... "
RELEASES_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "https://github.com/$REPO_OWNER/$REPO_NAME/releases")
if [ "$RELEASES_STATUS" == "200" ]; then
    echo -e "${GREEN}${check_mark}${NC}"
    pass_count=$((pass_count + 1))
else
    echo -e "${RED}${cross_mark}${NC}"
fi

# Résumé
echo ""
echo "=========================================="
echo "📊 Résumé: $pass_count/$test_count tests réussis"
echo ""

if [ "$pass_count" == "$test_count" ]; then
    echo -e "${GREEN}✨ Tous les tests sont passés!${NC}"
    echo ""
    echo "Prochaines étapes:"
    echo "1. Compiler l'APK: cd mobile && flutter build apk --release"
    echo "2. Créer une release GitHub avec: ./publish_release.sh"
    echo "3. Attendre 1-2 minutes pour que version.json soit accessible"
    echo "4. Tester sur un appareil: Préférences → Vérifier les mises à jour"
    exit 0
else
    echo -e "${YELLOW}⚠️  Certains tests ont échoué${NC}"
    echo ""
    echo "Points à corriger:"
    
    if [ "$PUBSPEC_BUILD" != "$VERSION_JSON_BUILD" ]; then
        echo "- Les numéros de build ne correspondent pas"
        echo "  Mettez à jour version.json: \"buildNumber\": \"$PUBSPEC_BUILD\""
    fi
    
    if [ "$STATUS" != "200" ] && [ "$STATUS" != "" ]; then
        echo "- version.json n'est pas accessible en ligne"
        echo "  Vérifiez que le fichier a été pushé sur GitHub"
    fi
    
    exit 1
fi
