/**
 * Service d'authentification
 * Gère l'authentification via Firebase Auth
 */

import { auth } from '../firebase.js';
import { 
    createUserWithEmailAndPassword, 
    signInWithEmailAndPassword,
    signOut,
    onAuthStateChanged,
    sendPasswordResetEmail,
    updateProfile
} from 'firebase/auth';

/**
 * Classe de service d'authentification
 */
class AuthService {
    /**
     * Inscrit un nouvel utilisateur
     * @param {string} email - Email de l'utilisateur
     * @param {string} password - Mot de passe de l'utilisateur
     * @param {string} [displayName] - Nom à afficher (optionnel)
     * @returns {Promise<object>} Utilisateur créé
     * @throws {Error} Erreur d'inscription
     */
    async signUp(email, password, displayName = null) {
        try {
            const userCredential = await createUserWithEmailAndPassword(auth, email, password);
            
            // Si un nom d'affichage est fourni, le mettre à jour
            if (displayName) {
                await updateProfile(userCredential.user, { displayName });
            }
            
            return userCredential.user;
        } catch (error) {
            // Traduit les erreurs Firebase en messages plus conviviaux
            const errorMessage = this._getErrorMessage(error);
            throw new Error(errorMessage);
        }
    }

    /**
     * Connecte un utilisateur existant
     * @param {string} email - Email de l'utilisateur
     * @param {string} password - Mot de passe de l'utilisateur
     * @returns {Promise<object>} Utilisateur connecté
     * @throws {Error} Erreur de connexion
     */
    async signIn(email, password) {
        try {
            const userCredential = await signInWithEmailAndPassword(auth, email, password);
            return userCredential.user;
        } catch (error) {
            const errorMessage = this._getErrorMessage(error);
            throw new Error(errorMessage);
        }
    }

    /**
     * Déconnecte l'utilisateur actuel
     * @returns {Promise<void>}
     * @throws {Error} Erreur de déconnexion
     */
    async logout() {
        try {
            await signOut(auth);
        } catch (error) {
            throw new Error("Erreur lors de la déconnexion: " + error.message);
        }
    }

    /**
     * Envoie un email de réinitialisation de mot de passe
     * @param {string} email - Email de l'utilisateur
     * @returns {Promise<void>}
     * @throws {Error} Erreur d'envoi d'email
     */
    async sendPasswordReset(email) {
        try {
            await sendPasswordResetEmail(auth, email);
        } catch (error) {
            const errorMessage = this._getErrorMessage(error);
            throw new Error(errorMessage);
        }
    }

    /**
     * S'abonne aux changements d'état d'authentification
     * @param {Function} callback - Fonction à appeler lors d'un changement d'état
     * @returns {Function} Fonction pour se désabonner
     */
    onAuthStateChange(callback) {
        return onAuthStateChanged(auth, callback);
    }

    /**
     * Récupère l'utilisateur actuellement connecté
     * @returns {object|null} Utilisateur connecté ou null
     */
    getCurrentUser() {
        return auth.currentUser;
    }

    /**
     * Traduit les codes d'erreur Firebase en messages conviviaux
     * @param {Error} error - Erreur Firebase
     * @returns {string} Message d'erreur traduit
     * @private
     */
    _getErrorMessage(error) {
        switch (error.code) {
            case 'auth/email-already-in-use':
                return "Cette adresse email est déjà utilisée.";
            case 'auth/invalid-email':
                return "L'adresse email n'est pas valide.";
            case 'auth/user-disabled':
                return "Ce compte a été désactivé.";
            case 'auth/user-not-found':
                return "Aucun compte ne correspond à cette adresse email.";
            case 'auth/wrong-password':
                return "Le mot de passe est incorrect.";
            case 'auth/weak-password':
                return "Le mot de passe est trop faible. Il doit contenir au moins 6 caractères.";
            case 'auth/too-many-requests':
                return "Trop de tentatives échouées. Veuillez réessayer plus tard.";
            case 'auth/network-request-failed':
                return "Problème de connexion réseau. Vérifiez votre connexion internet.";
            default:
                return error.message || "Une erreur est survenue lors de l'authentification.";
        }
    }
}

// Export d'une instance unique du service d'authentification
export const authService = new AuthService();