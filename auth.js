import { auth } from './firebase.js';
import { 
    createUserWithEmailAndPassword, 
    signInWithEmailAndPassword,
    signOut,
    onAuthStateChanged
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