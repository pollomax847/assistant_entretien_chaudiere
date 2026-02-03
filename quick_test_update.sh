#!/bin/bash

# Script de test rapide pour le système de mise à jour in-app
# Usage: ./quick_test_update.sh

echo "🚀 Test Rapide du Système de Mise à Jour"
echo "========================================"
echo ""

# Couleurs
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Lire les versions
CURRENT=$(grep '^version:' mobile/pubspec.yaml | sed 's/version: //' | tr -d ' ')
CURRENT_VER=$(echo $CURRENT | cut -d'+' -f1)
CURRENT_BUILD=$(echo $CURRENT | cut -d'+' -f2)

REMOTE_VER=$(grep '"version"' version.json | sed 's/.*: "\(.*\)".*/\1/')
REMOTE_BUILD=$(grep '"buildNumber"' version.json | sed 's/.*: "\(.*\)".*/\1/')

echo -e "${BLUE}Version actuelle:${NC} $CURRENT_VER (build $CURRENT_BUILD)"
echo -e "${BLUE}Version distante:${NC} $REMOTE_VER (build $REMOTE_BUILD)"
echo ""

# Déterminer le statut
if [ "$REMOTE_BUILD" -gt "$CURRENT_BUILD" ]; then
    echo -e "${GREEN}✓ Mise à jour disponible !${NC}"
    echo ""
    echo "L'app devrait afficher une popup de mise à jour"
elif [ "$REMOTE_BUILD" -eq "$CURRENT_BUILD" ]; then
    echo -e "${YELLOW}= Versions identiques${NC}"
    echo ""
    echo "Aucune mise à jour ne sera proposée"
else
    echo -e "${YELLOW}⚠ Version locale plus récente${NC}"
    echo ""
    echo "Version en développement"
fi

echo ""
echo "Pour tester:"
echo "  1. cd mobile && flutter run"
echo "  2. Attendre 3 secondes"
echo "  3. OU aller dans Préférences > Vérifier les mises à jour"
