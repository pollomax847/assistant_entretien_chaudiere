#!/bin/bash

# Configuration
GITHUB_TOKEN="Iv23lis2nS8WZOlmx4bC"
BRANCH_NAME="update-$(date +%Y%m%d-%H%M%S)"
COMMIT_MESSAGE="Mise à jour automatique du $(date +%d/%m/%Y)"
PR_TITLE="Mise à jour automatique"
PR_BODY="Mise à jour automatique des fichiers"
OWNER="pollomax847"
REPO="assitant_entreiten_chaudiere"

# Fonction pour afficher les erreurs en rouge
error() {
    echo -e "\033[31m[ERREUR] $1\033[0m"
    exit 1
}

# Fonction pour afficher les succès en vert
success() {
    echo -e "\033[32m[SUCCÈS] $1\033[0m"
}

# Vérification de l'état du dépôt
if ! git status &> /dev/null; then
    error "Ce répertoire n'est pas un dépôt Git"
fi

# Vérification des modifications
if [ -z "$(git status --porcelain)" ]; then
    success "Aucune modification à commiter"
    exit 0
fi

# Création d'une nouvelle branche
if ! git checkout -b $BRANCH_NAME; then
    error "Impossible de créer la branche $BRANCH_NAME"
fi
success "Branche $BRANCH_NAME créée"

# Ajout des modifications
if ! git add .; then
    error "Impossible d'ajouter les fichiers"
fi
success "Fichiers ajoutés au staging"

# Commit des modifications
if ! git commit -m "$COMMIT_MESSAGE"; then
    error "Impossible de créer le commit"
fi
success "Commit créé avec succès"

# Push vers GitHub
if ! git push origin $BRANCH_NAME; then
    error "Impossible de pousser les modifications vers GitHub"
fi
success "Modifications poussées vers GitHub"

# Création de la pull request
PR_RESPONSE=$(curl -s -X POST \
  -H "Authorization: token $GITHUB_TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  https://api.github.com/repos/$OWNER/$REPO/pulls \
  -d "{
    \"title\": \"$PR_TITLE\",
    \"body\": \"$PR_BODY\",
    \"head\": \"$BRANCH_NAME\",
    \"base\": \"main\"
  }")

if [[ $PR_RESPONSE == *"errors"* ]]; then
    error "Erreur lors de la création de la pull request: $PR_RESPONSE"
fi

success "Pull request créée avec succès !"
echo "URL de la pull request: $(echo $PR_RESPONSE | grep -o '"html_url": "[^"]*' | cut -d'"' -f4)"

# Créer les dossiers nécessaires s'ils n'existent pas
mkdir -p public/css
mkdir -p public/js
mkdir -p public/assets

# Déplacer les fichiers CSS
cp css/* public/css/
cp style.css public/css/

# Déplacer les fichiers JS
cp js/* public/js/
cp script.js public/js/

# Déplacer les assets
cp -r assets/* public/assets/

# Déplacer le fichier index.html
cp index.html public/

# Installer les dépendances
npm install

# Construire le projet
npm run build

echo "Mise à jour terminée !" 