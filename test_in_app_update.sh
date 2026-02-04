#!/bin/bash

# Script de test pour vérifier la mise à jour in-app
# Utilisation: ./test_in_app_update.sh

echo "🔍 Vérification de la configuration de mise à jour in-app..."
echo ""

# Couleurs
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

ERRORS=0

# 1. Vérifier que in_app_update est dans pubspec.yaml
echo "1️⃣  Vérification de in_app_update dans pubspec.yaml..."
if grep -q "in_app_update:" mobile/pubspec.yaml; then
    echo -e "${GREEN}✅ in_app_update trouvé dans pubspec.yaml${NC}"
else
    echo -e "${RED}❌ in_app_update MANQUANT dans pubspec.yaml${NC}"
    ERRORS=$((ERRORS + 1))
fi
echo ""

# 2. Vérifier que UpdateService existe
echo "2️⃣  Vérification de UpdateService..."
if [ -f "mobile/lib/services/update_service.dart" ]; then
    echo -e "${GREEN}✅ Fichier update_service.dart trouvé${NC}"
    
    if grep -q "class UpdateService" mobile/lib/services/update_service.dart; then
        echo -e "${GREEN}✅ Classe UpdateService définie${NC}"
    else
        echo -e "${RED}❌ Classe UpdateService non trouvée${NC}"
        ERRORS=$((ERRORS + 1))
    fi
    
    if grep -q "InAppUpdate.checkForUpdate" mobile/lib/services/update_service.dart; then
        echo -e "${GREEN}✅ Utilise InAppUpdate.checkForUpdate()${NC}"
    else
        echo -e "${RED}❌ InAppUpdate.checkForUpdate() non trouvé${NC}"
        ERRORS=$((ERRORS + 1))
    fi
else
    echo -e "${RED}❌ Fichier update_service.dart non trouvé${NC}"
    ERRORS=$((ERRORS + 1))
fi
echo ""

# 3. Vérifier que FirstLaunchDialog existe
echo "3️⃣  Vérification de FirstLaunchDialog..."
if [ -f "mobile/lib/screens/first_launch_dialog.dart" ]; then
    echo -e "${GREEN}✅ Fichier first_launch_dialog.dart trouvé${NC}"
    
    if grep -q "class FirstLaunchDialog" mobile/lib/screens/first_launch_dialog.dart; then
        echo -e "${GREEN}✅ Classe FirstLaunchDialog définie${NC}"
    else
        echo -e "${RED}❌ Classe FirstLaunchDialog non trouvée${NC}"
        ERRORS=$((ERRORS + 1))
    fi
else
    echo -e "${YELLOW}⚠️  Fichier first_launch_dialog.dart non trouvé (optionnel)${NC}"
fi
echo ""

# 4. Vérifier que HomeScreen utilise les services de mise à jour
echo "4️⃣  Vérification dans HomeScreen..."
if grep -q "UpdateService\|GitHubUpdateService" mobile/lib/screens/home_screen.dart; then
    echo -e "${GREEN}✅ HomeScreen utilise les services de mise à jour${NC}"
else
    echo -e "${RED}❌ HomeScreen n'utilise pas les services de mise à jour${NC}"
    ERRORS=$((ERRORS + 1))
fi
echo ""

# 5. Vérifier PreferencesProvider
echo "5️⃣  Vérification de PreferencesProvider..."
if [ -f "mobile/lib/utils/preferences_provider.dart" ]; then
    echo -e "${GREEN}✅ Fichier preferences_provider.dart trouvé${NC}"
    
    if grep -q "isFirstLaunch" mobile/lib/utils/preferences_provider.dart; then
        echo -e "${GREEN}✅ Flag isFirstLaunch présent${NC}"
    else
        echo -e "${YELLOW}⚠️  Flag isFirstLaunch non trouvé${NC}"
    fi
    
    if grep -q "setFirstLaunchCompleted" mobile/lib/utils/preferences_provider.dart; then
        echo -e "${GREEN}✅ Méthode setFirstLaunchCompleted présente${NC}"
    else
        echo -e "${YELLOW}⚠️  Méthode setFirstLaunchCompleted non trouvée${NC}"
    fi
else
    echo -e "${RED}❌ Fichier preferences_provider.dart non trouvé${NC}"
    ERRORS=$((ERRORS + 1))
fi
echo ""

# 6. Vérifier GitHubUpdateService
echo "6️⃣  Vérification de GitHubUpdateService..."
if [ -f "mobile/lib/services/github_update_service.dart" ]; then
    echo -e "${GREEN}✅ Fichier github_update_service.dart trouvé${NC}"
    
    if grep -q "class GitHubUpdateService" mobile/lib/services/github_update_service.dart; then
        echo -e "${GREEN}✅ Classe GitHubUpdateService définie${NC}"
    else
        echo -e "${RED}❌ Classe GitHubUpdateService non trouvée${NC}"
        ERRORS=$((ERRORS + 1))
    fi
else
    echo -e "${RED}❌ Fichier github_update_service.dart non trouvé${NC}"
    ERRORS=$((ERRORS + 1))
fi
echo ""

# 7. Vérifier version.json
echo "7️⃣  Vérification de version.json..."
if [ -f "version.json" ]; then
    echo -e "${GREEN}✅ Fichier version.json trouvé${NC}"
    
    if grep -q "buildNumber" version.json; then
        echo -e "${GREEN}✅ buildNumber présent dans version.json${NC}"
    else
        echo -e "${RED}❌ buildNumber manquant dans version.json${NC}"
        ERRORS=$((ERRORS + 1))
    fi
else
    echo -e "${RED}❌ Fichier version.json non trouvé${NC}"
    ERRORS=$((ERRORS + 1))
fi
echo ""

# 8. Vérifier les imports
echo "8️⃣  Vérification des imports..."
if grep -q "import 'package:in_app_update/in_app_update.dart'" mobile/lib/services/update_service.dart; then
    echo -e "${GREEN}✅ Import in_app_update correct${NC}"
else
    echo -e "${RED}❌ Import in_app_update manquant${NC}"
    ERRORS=$((ERRORS + 1))
fi
echo ""

# Résumé
echo "═══════════════════════════════════════════════════════"
if [ $ERRORS -eq 0 ]; then
    echo -e "${GREEN}✅ Tous les vérifications sont passées!${NC}"
    echo ""
    echo "Prochaines étapes:"
    echo "1. Exécuter: flutter pub get"
    echo "2. Tester sur un émulateur ou appareil"
    echo "3. Vérifier les logs: flutter logs | grep -E '🔄|✅|❌'"
else
    echo -e "${RED}❌ $ERRORS vérification(s) échouée(s)${NC}"
    echo ""
    echo "Corrections requises:"
    echo "- Ajouter in_app_update: ^4.2.0 dans pubspec.yaml"
    echo "- Vérifier les fichiers de service"
    echo "- Vérifier les imports"
fi
echo "═══════════════════════════════════════════════════════"
