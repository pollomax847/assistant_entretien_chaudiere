// Gestion de l'authentification
document.addEventListener('DOMContentLoaded', () => {
    setupAuthForm();
    setupOfflineMode();
    checkRememberedUser();
});

// Configuration du formulaire d'authentification
function setupAuthForm() {
    const form = document.getElementById('auth-form');
    if (!form) return;

    form.addEventListener('submit', (e) => {
        e.preventDefault();
        handleLogin();
    });
}

// Gestion de la connexion
function handleLogin() {
    const email = document.getElementById('email').value;
    const password = document.getElementById('password').value;
    const rememberMe = document.getElementById('remember-me').checked;

    // Vérification simple (à remplacer par une authentification réelle)
    if (email && password) {
        // Sauvegarder les informations de connexion si "Se souvenir de moi" est coché
        if (rememberMe) {
            localStorage.setItem('rememberedUser', JSON.stringify({ email }));
        } else {
            localStorage.removeItem('rememberedUser');
        }

        // Rediriger vers la page principale
        window.location.href = '/index.html';
    } else {
        showNotification('Veuillez remplir tous les champs', 'error');
    }
}

// Configuration du mode hors-ligne
function setupOfflineMode() {
    const offlineButton = document.getElementById('offline-mode');
    if (!offlineButton) return;

    offlineButton.addEventListener('click', () => {
        // Activer le mode hors-ligne
        localStorage.setItem('offlineMode', 'true');
        
        // Rediriger vers la page principale
        window.location.href = '/index.html';
    });
}

// Vérification de l'utilisateur mémorisé
function checkRememberedUser() {
    const rememberedUser = localStorage.getItem('rememberedUser');
    if (rememberedUser) {
        const { email } = JSON.parse(rememberedUser);
        document.getElementById('email').value = email;
        document.getElementById('remember-me').checked = true;
    }
}

// Affichage des notifications
function showNotification(message, type = 'info') {
    const notification = document.createElement('div');
    notification.className = `notification notification-${type}`;
    notification.textContent = message;
    
    document.body.appendChild(notification);
    
    setTimeout(() => {
        notification.classList.add('fade-out');
        setTimeout(() => {
            document.body.removeChild(notification);
        }, 300);
    }, 3000);
}

// Vérification de la connexion
function checkAuth() {
    const offlineMode = localStorage.getItem('offlineMode');
    const rememberedUser = localStorage.getItem('rememberedUser');
    
    if (!offlineMode && !rememberedUser) {
        window.location.href = '/auth.html';
    }
}

// Déconnexion
function handleLogout() {
    localStorage.removeItem('rememberedUser');
    localStorage.removeItem('offlineMode');
    window.location.href = '/auth.html';
} 