#!/bin/bash

echo "🔍 Test des URLs de mise à jour GitHub"
echo "======================================"

# Tester l'accès au fichier version.json
echo -e "\n1️⃣  Test accès version.json:"
echo "URL: https://raw.githubusercontent.com/pollomax847/assitant_entreiten_chaudiere/main/version.json"
curl -s -o /dev/null -w "Status: %{http_code}\n" \
  https://raw.githubusercontent.com/pollomax847/assitant_entreiten_chaudiere/main/version.json

echo -e "\n2️⃣  Contenu du fichier version.json:"
curl -s https://raw.githubusercontent.com/pollomax847/assitant_entreiten_chaudiere/main/version.json | jq '.' || echo "Erreur de parsing JSON"

# Tester l'accès aux releases GitHub
echo -e "\n\n3️⃣  Test accès page releases GitHub:"
echo "URL: https://github.com/pollomax847/assitant_entreiten_chaudiere/releases"
curl -s -o /dev/null -w "Status: %{http_code}\n" \
  https://github.com/pollomax847/assitant_entreiten_chaudiere/releases

# Vérifier si le nom du repo est correct
echo -e "\n4️⃣  Vérification du nom du repository:"
echo "Repos pubsub847:"
curl -s https://api.github.com/users/pollomax847/repos | jq '.[] | {name}' | grep -i "assis\|entret\|chaud"

echo -e "\n\n✅ Test terminé"
