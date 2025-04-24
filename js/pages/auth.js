import { FIREBASE_CONFIG } from '../../src/config/constants.js';

// Initialize Firebase
firebase.initializeApp(FIREBASE_CONFIG);

document.addEventListener('DOMContentLoaded', () => {
    const loginForm = document.getElementById('loginForm');
    const signupForm = document.getElementById('signupForm');
    const resetForm = document.getElementById('resetForm');

    // Login handling
    loginForm?.addEventListener('submit', async (e) => {
        e.preventDefault();
        const email = document.getElementById('loginEmail').value;
        const password = document.getElementById('loginPassword').value;
        
        try {
            await firebase.auth().signInWithEmailAndPassword(email, password);
            window.location.href = '/dashboard.html';
        } catch (error) {
            showMessage(error.message, 'error');
        }
    });

    // Reset password handling
    resetForm?.addEventListener('submit', async (e) => {
        e.preventDefault();
        const email = document.getElementById('resetEmail').value;
        
        try {
            await firebase.auth().sendPasswordResetEmail(email);
            showMessage('Email de réinitialisation envoyé', 'success');
        } catch (error) {
            showMessage(error.message, 'error');
        }
    });
});

function showMessage(message, type) {
    const messageDiv = document.getElementById('message');
    messageDiv.textContent = message;
    messageDiv.className = `message ${type} visible`;
    setTimeout(() => messageDiv.className = 'message hidden', 5000);
}
