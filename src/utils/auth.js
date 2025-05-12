import { getAuth, onAuthStateChanged, signOut, signInWithEmailAndPassword, createUserWithEmailAndPassword, sendPasswordResetEmail } from 'firebase/auth';
import { auth } from '../firebase/app.js';

// Gestion des formulaires
const loginForm = document.getElementById('loginForm');
const signupForm = document.getElementById('signupForm');
const resetForm = document.getElementById('resetForm');

// Gestion de la connexion
if (loginForm) {
  loginForm.addEventListener('submit', async (e) => {
    e.preventDefault();
    const email = document.getElementById('loginEmail').value;
    const password = document.getElementById('loginPassword').value;
    
    try {
      await signInWithEmailAndPassword(auth, email, password);
      window.location.href = '/';
    } catch (error) {
      showMessage(error.message, 'error');
    }
  });
}

// Gestion de la réinitialisation du mot de passe
if (resetForm) {
  resetForm.addEventListener('submit', async (e) => {
    e.preventDefault();
    const email = document.getElementById('resetEmail').value;
    
    try {
      await sendPasswordResetEmail(auth, email);
      showMessage('Email de réinitialisation envoyé', 'success');
    } catch (error) {
      showMessage(error.message, 'error');
    }
  });
}

// Gestion de l'état de l'authentification
onAuthStateChanged(auth, (user) => {
  const userInfo = document.getElementById('userInfo');
  const userName = document.getElementById('userName');
  const logoutBtn = document.getElementById('logoutBtn');

  if (user) {
    if (userInfo) userInfo.style.display = 'block';
    if (userName) userName.textContent = user.email;
    if (logoutBtn) {
      logoutBtn.addEventListener('click', () => {
        signOut(auth);
      });
    }
  } else {
    if (userInfo) userInfo.style.display = 'none';
  }
});

// Fonction utilitaire pour afficher les messages
function showMessage(message, type) {
  const messageDiv = document.getElementById('message');
  if (messageDiv) {
    messageDiv.textContent = message;
    messageDiv.className = `message ${type} visible`;
    setTimeout(() => messageDiv.className = 'message hidden', 5000);
  }
}

export { auth, onAuthStateChanged, signOut, signInWithEmailAndPassword, createUserWithEmailAndPassword, sendPasswordResetEmail };
