'use client';

import { createContext, useContext, useState, useEffect } from 'react';
import { useSession, signIn, signOut } from 'next-auth/react';
import { useRouter } from 'next/router';
import { showNotification } from '../components/Notification';

const AuthContext = createContext();

export function AuthProvider({ children }) {
  const { data: session, status } = useSession();
  const router = useRouter();
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    if (status === 'loading') {
      setIsLoading(true);
    } else {
      setIsLoading(false);
      
      // Rediriger vers la page de connexion si l'utilisateur n'est pas authentifié
      if (!session && router.pathname !== '/auth') {
        router.push('/auth');
      }
    }
  }, [session, status, router]);

  const handleSignIn = async (email, password) => {
    try {
      const result = await signIn('credentials', {
        redirect: false,
        email,
        password,
      });

      if (result?.error) {
        showNotification(result.error, 'error');
      } else {
        showNotification('Connexion réussie', 'success');
        router.push('/');
      }
    } catch (error) {
      showNotification('Une erreur est survenue', 'error');
    }
  };

  const handleSignOut = async () => {
    try {
      await signOut({ redirect: false });
      showNotification('Déconnexion réussie', 'success');
      router.push('/auth');
    } catch (error) {
      showNotification('Une erreur est survenue', 'error');
    }
  };

  if (isLoading) {
    return <div>Chargement...</div>;
  }

  return (
    <AuthContext.Provider value={{ session, status }}>
      {children}
    </AuthContext.Provider>
  );
}

export function useAuth() {
  const context = useContext(AuthContext);
  if (!context) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return context;
} 