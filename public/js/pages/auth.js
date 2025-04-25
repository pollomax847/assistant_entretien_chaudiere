import { auth } from '../firebase.js';
import { ThemeManager } from '../utils/ThemeManager.js';
import { 
    createUserWithEmailAndPassword, 
    signInWithEmailAndPassword,
    signOut,
    onAuthStateChanged,
    GoogleAuthProvider,
    signInWithPopup
} from 'firebase/auth';

// Fonction pour l'inscription
export async function signUp(email, password) {
    try {
        const userCredential = await createUserWithEmailAndPassword(auth, email, password);
        return userCredential.user;
    } catch (error) {
        throw new Error(error.message);
    }
}

// Fonction pour la connexion
export async function signIn(email, password) {
    try {
        const userCredential = await signInWithEmailAndPassword(auth, email, password);
        return userCredential.user;
    } catch (error) {
        throw new Error(error.message);
    }
}

// Fonction pour la déconnexion
export async function logout() {
    try {
        await signOut(auth);
    } catch (error) {
        throw new Error(error.message);
    }
}

// Fonction pour écouter les changements d'état d'authentification
export function onAuthStateChange(callback) {
    return onAuthStateChanged(auth, callback);
}

let themeManager;

document.addEventListener('DOMContentLoaded', () => {
    // Initialize theme manager
    themeManager = new ThemeManager();

    // Gestion de la modale des options de connexion
    const authOptionsModal = document.getElementById('authOptionsModal');
    const showAuthOptionsBtn = document.getElementById('showAuthOptions');
    const closeModalBtn = document.querySelector('.modal-close');
    const googleAuthBtn = document.getElementById('googleAuth');

    // Ouvrir la modale
    showAuthOptionsBtn?.addEventListener('click', () => {
        authOptionsModal.classList.remove('hidden');
        authOptionsModal.classList.add('visible');
    });

    // Fermer la modale
    const closeModal = () => {
        authOptionsModal.classList.remove('visible');
        authOptionsModal.classList.add('hidden');
    };

    closeModalBtn?.addEventListener('click', closeModal);
    authOptionsModal?.addEventListener('click', (e) => {
        if (e.target === authOptionsModal) {
            closeModal();
        }
    });

    // Gérer la connexion Google
    googleAuthBtn?.addEventListener('click', async () => {
        try {
            const provider = new GoogleAuthProvider();
            await signInWithPopup(auth, provider);
            window.location.href = '/';
        } catch (error) {
            showMessage(error.message, 'error');
        }
    });
});