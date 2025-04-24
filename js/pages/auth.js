/**
 * Script de la page d'authentification
 * Gère les interactions et l'authentification
 */

import { authService } from '../services/auth-service.js';

// Attendre que le DOM soit chargé
document.addEventListener('DOMContentLoaded', () => {
    // Références aux éléments du DOM
    const tabs = document.querySelectorAll('.tab');
    const loginForm = document.getElementById('loginForm');
    const signupForm = document.getElementById('signupForm');
    const resetForm = document.getElementById('resetForm');
    const forgotPassword = document.getElementById('forgotPassword');
    const backToLogin = document.getElementById('backToLogin');
    const showTerms = document.getElementById('showTerms');
    const closeTerms = document.getElementById('closeTerms');
    const messageDiv = document.getElementById('message');
    const passwordInput = document.getElementById('signupPassword');
    const passwordStrength = document.getElementById('passwordStrength');
    const passwordConfirm = document.getElementById('signupPasswordConfirm');

    // Vérifier si l'utilisateur est déjà connecté
    authService.onAuthStateChange((user) => {
        if (user) {
            window.location.href = 'index.html';
        }
    });

    // Gestion des onglets
    tabs.forEach(tab => {
        tab.addEventListener('click', () => {
            // Retirer la classe active de tous les onglets
            tabs.forEach(t => t.classList.remove('active'));
            // Ajouter la classe active à l'onglet cliqué
            tab.classList.add('active');
            
            // Afficher le formulaire correspondant
            const tabName = tab.getAttribute('data-tab');
            document.querySelectorAll('.form-container').forEach(form => {
                form.classList.add('hidden');
            });
            document.getElementById(`${tabName}-form`).classList.remove('hidden');
            
            // Masquer le message d'erreur/succès
            hideMessage();
        });
    });

    // Gestion de la connexion
    loginForm.addEventListener('submit', async (e) => {
        e.preventDefault();
        
        // Récupérer les valeurs des champs
        const email = document.getElementById('loginEmail').value;
        const password = document.getElementById('loginPassword').value;

        try {
            // Désactiver le bouton pendant la connexion
            const submitBtn = loginForm.querySelector('button[type="submit"]');
            submitBtn.disabled = true;
            submitBtn.textContent = 'Connexion en cours...';
            
            // Tenter la connexion
            await authService.signIn(email, password);
            
            // Afficher un message de succès
            showMessage('Connexion réussie ! Redirection...', 'success');
            
            // Redirection vers la page principale après connexion
            setTimeout(() => {
                window.location.href = 'index.html';
            }, 1500);
        } catch (error) {
            // Afficher un message d'erreur
            showMessage(error.message, 'error');
            
            // Réactiver le bouton
            const submitBtn = loginForm.querySelector('button[type="submit"]');
            submitBtn.disabled = false;
            submitBtn.textContent = 'Se connecter';
        }
    });

    // Gestion de l'inscription
    signupForm.addEventListener('submit', async (e) => {
        e.preventDefault();
        
        // Récupérer les valeurs des champs
        const name = document.getElementById('signupName').value;
        const email = document.getElementById('signupEmail').value;
        const password = document.getElementById('signupPassword').value;
        const passwordConfirm = document.getElementById('signupPasswordConfirm').value;
        const termsAgreement = document.getElementById('termsAgreement').checked;

        // Vérifier que les mots de passe correspondent
        if (password !== passwordConfirm) {
            showMessage('Les mots de passe ne correspondent pas.', 'error');
            return;
        }

        // Vérifier que les conditions d'utilisation sont acceptées
        if (!termsAgreement) {
            showMessage('Vous devez accepter les conditions d\'utilisation.', 'error');
            return;
        }

        try {
            // Désactiver le bouton pendant l'inscription
            const submitBtn = signupForm.querySelector('button[type="submit"]');
            submitBtn.disabled = true;
            submitBtn.textContent = 'Inscription en cours...';
            
            // Tenter l'inscription
            await authService.signUp(email, password, name);
            
            // Afficher un message de succès
            showMessage('Inscription réussie ! Redirection...', 'success');
            
            // Redirection vers la page principale après inscription
            setTimeout(() => {
                window.location.href = 'index.html';
            }, 1500);
        } catch (error) {
            // Afficher un message d'erreur
            showMessage(error.message, 'error');
            
            // Réactiver le bouton
            const submitBtn = signupForm.querySelector('button[type="submit"]');
            submitBtn.disabled = false;
            submitBtn.textContent = 'S\'inscrire';
        }
    });

    // Gestion de la réinitialisation de mot de passe
    forgotPassword.addEventListener('click', (e) => {
        e.preventDefault();
        
        // Masquer le formulaire de connexion et afficher le formulaire de réinitialisation
        document.getElementById('login-form').classList.add('hidden');
        document.getElementById('reset-form').classList.remove('hidden');
        
        // Masquer le message d'erreur/succès
        hideMessage();
    });

    // Gestion du retour à la connexion
    backToLogin.addEventListener('click', () => {
        // Masquer le formulaire de réinitialisation et afficher le formulaire de connexion
        document.getElementById('reset-form').classList.add('hidden');
        document.getElementById('login-form').classList.remove('hidden');
        
        // Masquer le message d'erreur/succès
        hideMessage();
    });

    // Gestion de l'envoi du formulaire de réinitialisation
    resetForm.addEventListener('submit', async (e) => {
        e.preventDefault();
        
        // Récupérer l'email
        const email = document.getElementById('resetEmail').value;

        try {
            // Désactiver le bouton pendant l'envoi
            const submitBtn = resetForm.querySelector('button[type="submit"]');
            submitBtn.disabled = true;
            submitBtn.textContent = 'Envoi en cours...';
            
            // Envoyer l'email de réinitialisation
            await authService.sendPasswordReset(email);
            
            // Afficher un message de succès
            showMessage('Un email de réinitialisation a été envoyé à ' + email, 'success');
            
            // Réactiver le bouton
            submitBtn.disabled = false;
            submitBtn.textContent = 'Envoyer';
        } catch (error) {
            // Afficher un message d'erreur
            showMessage(error.message, 'error');
            
            // Réactiver le bouton
            const submitBtn = resetForm.querySelector('button[type="submit"]');
            submitBtn.disabled = false;
            submitBtn.textContent = 'Envoyer';
        }
    });

    // Gestion de l'affichage des conditions d'utilisation
    showTerms.addEventListener('click', (e) => {
        e.preventDefault();
        document.getElementById('termsDialog').classList.remove('hidden');
    });

    // Gestion de la fermeture des conditions d'utilisation
    closeTerms.addEventListener('click', () => {
        document.getElementById('termsDialog').classList.add('hidden');
    });

    // Gestion de l'évaluation de la force du mot de passe
    if (passwordInput) {
        passwordInput.addEventListener('input', evaluatePasswordStrength);
    }

    // Fonction pour évaluer la force du mot de passe
    function evaluatePasswordStrength() {
        const password = passwordInput.value;
        
        // Afficher l'indicateur de force uniquement si le mot de passe a été saisi
        if (password.length > 0) {
            passwordStrength.classList.remove('hidden');
        } else {
            passwordStrength.classList.add('hidden');
            return;
        }
        
        // Calculer la force du mot de passe
        let strength = 0;
        
        // Longueur minimale
        if (password.length >= 8) strength += 25;
        
        // Présence de lettres minuscules
        if (/[a-z]/.test(password)) strength += 25;
        
        // Présence de lettres majuscules
        if (/[A-Z]/.test(password)) strength += 25;
        
        // Présence de chiffres
        if (/[0-9]/.test(password)) strength += 25;
        
        // Présence de caractères spéciaux
        if (/[^a-zA-Z0-9]/.test(password)) strength += 25;
        
        // Limiter à 100%
        strength = Math.min(strength, 100);
        
        // Mettre à jour l'indicateur visuel
        const strengthBar = passwordStrength.querySelector('.strength-level');
        strengthBar.style.width = strength + '%';
        
        // Mettre à jour le texte
        const strengthText = passwordStrength.querySelector('.strength-text');
        
        if (strength < 25) {
            strengthBar.style.backgroundColor = '#ff4d4d';
            strengthText.textContent = 'Mot de passe très faible';
        } else if (strength < 50) {
            strengthBar.style.backgroundColor = '#ffa64d';
            strengthText.textContent = 'Mot de passe faible';
        } else if (strength < 75) {
            strengthBar.style.backgroundColor = '#ffff4d';
            strengthText.textContent = 'Mot de passe moyen';
        } else {
            strengthBar.style.backgroundColor = '#4dff4d';
            strengthText.textContent = 'Mot de passe fort';
        }
    }

    // Fonction pour afficher un message
    function showMessage(message, type = 'info') {
        messageDiv.textContent = message;
        messageDiv.className = `message ${type}`;
        messageDiv.classList.remove('hidden');
    }
    
    // Fonction pour masquer un message
    function hideMessage() {
        messageDiv.classList.add('hidden');
    }
});