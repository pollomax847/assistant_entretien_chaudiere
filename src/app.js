import { FIREBASE_CONFIG } from './config/constants.js';
import { Navigation } from './components/Navigation.js';
import { ModuleManager } from './utils/ModuleManager.js';

// Initialisation de Firebase
const app = firebase.initializeApp(FIREBASE_CONFIG);
const analytics = firebase.analytics();
const auth = firebase.auth();
const db = firebase.firestore();

// Initialisation des composants
const navigation = new Navigation('navigation');
const moduleManager = new ModuleManager('module-container');

// Gestion de l'authentification
auth.onAuthStateChanged((user) => {
    const userInfo = document.getElementById('userInfo');
    const userName = document.getElementById('userName');
    const logoutBtn = document.getElementById('logoutBtn');

    if (user) {
        userName.textContent = user.email;
        userInfo.style.display = 'block';
        logoutBtn.addEventListener('click', () => auth.signOut());
    } else {
        window.location.href = '/auth.html';
    }
});

// Initialisation de la navigation
navigation.render();

// Gestion du routage
document.addEventListener('navigate', (e) => {
    const path = e.detail.path;
    navigation.setActiveModule(path);
    moduleManager.renderModule(path);
});

// Chargement du module par défaut
moduleManager.renderModule('/vmc'); 