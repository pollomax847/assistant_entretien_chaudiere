#!/bin/bash

# Script de test du système de mise à jour in-app
# Ce script teste que le système de mise à jour fonctionne correctement

echo "=========================================="
echo "🧪 Test du système de mise à jour in-app"
echo "=========================================="
echo ""

# Couleurs
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Fonction pour afficher un succès
success() {
    echo -e "${GREEN}✓${NC} $1"
}

# Fonction pour afficher une info
info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

# Fonction pour afficher un avertissement
warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

# Fonction pour afficher une erreur
error() {
    echo -e "${RED}✗${NC} $1"
}

# 1. Vérifier que version.json existe
echo "1️⃣  Vérification de version.json"
if [ -f "version.json" ]; then
    success "Fichier version.json trouvé"
    
    # Lire le contenu
    VERSION=$(grep '"version"' version.json | sed 's/.*: "\(.*\)".*/\1/')
    BUILD=$(grep '"buildNumber"' version.json | sed 's/.*: "\(.*\)".*/\1/')
    URL=$(grep '"downloadUrl"' version.json | sed 's/.*: "\(.*\)".*/\1/')
    
    info "Version disponible: $VERSION (build $BUILD)"
    info "URL de téléchargement: $URL"
else
    error "Fichier version.json non trouvé !"
    exit 1
fi
echo ""

# 2. Vérifier la version dans pubspec.yaml
echo "2️⃣  Vérification de la version actuelle"
if [ -f "mobile/pubspec.yaml" ]; then
    CURRENT_VERSION=$(grep '^version:' mobile/pubspec.yaml | sed 's/version: //' | sed 's/+.*//')
    CURRENT_BUILD=$(grep '^version:' mobile/pubspec.yaml | sed 's/.*+//')
    
    success "Version actuelle: $CURRENT_VERSION (build $CURRENT_BUILD)"
    info "Build actuel: $CURRENT_BUILD"
else
    error "Fichier pubspec.yaml non trouvé !"
    exit 1
fi
echo ""

# 3. Comparer les versions
echo "3️⃣  Comparaison des versions"
if [ "$BUILD" -gt "$CURRENT_BUILD" ]; then
    success "Une mise à jour est disponible ! (build $BUILD > $CURRENT_BUILD)"
    warning "Le système devrait détecter la mise à jour"
elif [ "$BUILD" -eq "$CURRENT_BUILD" ]; then
    info "Version identique (build $BUILD = $CURRENT_BUILD)"
    warning "Aucune mise à jour ne sera détectée"
else
    warning "Version dans version.json plus ancienne (build $BUILD < $CURRENT_BUILD)"
    warning "Aucune mise à jour ne sera détectée"
fi
echo ""

# 4. Tester l'accessibilité de l'URL
echo "4️⃣  Test de connectivité GitHub"
if curl -s --head "https://raw.githubusercontent.com/pollomax847/assitant_entreiten_chaudiere/main/version.json" | grep "200 OK" > /dev/null; then
    success "Le fichier version.json est accessible sur GitHub"
    
    # Récupérer le contenu depuis GitHub
    REMOTE_VERSION=$(curl -s "https://raw.githubusercontent.com/pollomax847/assitant_entreiten_chaudiere/main/version.json" | grep '"version"' | sed 's/.*: "\(.*\)".*/\1/')
    REMOTE_BUILD=$(curl -s "https://raw.githubusercontent.com/pollomax847/assitant_entreiten_chaudiere/main/version.json" | grep '"buildNumber"' | sed 's/.*: "\(.*\)".*/\1/')
    
    info "Version sur GitHub: $REMOTE_VERSION (build $REMOTE_BUILD)"
else
    error "Impossible d'accéder à version.json sur GitHub"
    warning "Vérifiez que le fichier a bien été poussé sur GitHub"
fi
echo ""

# 5. Vérifier le service GitHubUpdateService
echo "5️⃣  Vérification du service de mise à jour"
if [ -f "mobile/lib/services/github_update_service.dart" ]; then
    success "Service GitHubUpdateService trouvé"
    
    # Vérifier que l'URL est correcte dans le service
    URL_IN_SERVICE=$(grep '_versionUrl' mobile/lib/services/github_update_service.dart | grep -o 'https://[^"]*')
    
    if [ "$URL_IN_SERVICE" = "https://raw.githubusercontent.com/pollomax847/assitant_entreiten_chaudiere/main/version.json" ]; then
        success "URL correcte dans le service"
    else
        error "URL incorrecte dans le service: $URL_IN_SERVICE"
    fi
else
    error "Service GitHubUpdateService non trouvé !"
fi
echo ""

# 6. Vérifier l'intégration dans main.dart
echo "6️⃣  Vérification de l'intégration"
if grep -q "GitHubUpdateService().checkOnAppStart" mobile/lib/main.dart; then
    success "Vérification au démarrage activée"
else
    error "Vérification au démarrage non trouvée dans main.dart"
fi

if grep -q "GitHubUpdateService().checkManually" mobile/lib/screens/preferences_screen.dart; then
    success "Vérification manuelle disponible dans les préférences"
else
    warning "Vérification manuelle non trouvée dans preferences_screen.dart"
fi
echo ""

# 7. Résumé
echo "=========================================="
echo "📊 Résumé du test"
echo "=========================================="
echo ""
echo "Version actuelle de l'app : $CURRENT_VERSION (build $CURRENT_BUILD)"
echo "Version dans version.json : $VERSION (build $BUILD)"

if [ "$BUILD" -gt "$CURRENT_BUILD" ]; then
    echo ""
    success "✅ Le système devrait détecter une mise à jour !"
    echo ""
    echo "📱 Pour tester :"
    echo "   1. Compilez et installez l'app (build $CURRENT_BUILD)"
    echo "   2. Ouvrez l'app (attendre 3 secondes)"
    echo "   3. Une popup devrait apparaître pour la version $VERSION"
    echo "   OU"
    echo "   4. Allez dans Préférences > Vérifier les mises à jour"
else
    echo ""
    warning "⚠️  Aucune mise à jour ne sera détectée"
    echo ""
    echo "Pour tester, vous devez :"
    echo "   1. Augmenter buildNumber dans version.json"
    echo "   2. Réexécuter ce script"
fi

echo ""
echo "=========================================="
