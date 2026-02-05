#!/bin/bash
# Script pour mettre à jour le Gist version.json

GIST_ID="4dde52dd2517fdde10148cd251ff505a"
VERSION_FILE="version.json"

echo "🔄 Mise à jour du Gist version.json..."
echo "Gist ID: $GIST_ID"

if [ ! -f "$VERSION_FILE" ]; then
    echo "❌ Fichier $VERSION_FILE introuvable"
    exit 1
fi

echo "📝 Contenu actuel:"
cat "$VERSION_FILE"
echo ""

# Mettre à jour le Gist
gh gist edit "$GIST_ID" "$VERSION_FILE"

if [ $? -eq 0 ]; then
    echo "✅ Gist mis à jour avec succès!"
    echo "🔗 URL: https://gist.github.com/pollomax847/$GIST_ID"
    echo "🔗 Raw: https://gist.githubusercontent.com/pollomax847/$GIST_ID/raw/version.json"
else
    echo "❌ Erreur lors de la mise à jour du Gist"
    exit 1
fi
