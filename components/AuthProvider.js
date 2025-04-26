'use client';

import { useSession, signIn, signOut } from 'next-auth/react';
import { useRouter } from 'next/router';
import { useEffect } from 'react';
import { showNotification } from './Notification';

export function AuthProvider({ children }) {
  const { data: session, status } = useSession();
  const router = useRouter();

  useEffect(() => {
    if (status === 'unauthenticated' && router.pathname !== '/auth') {
      router.push('/auth');
    }
  }, [status, router]);

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

  return children({
    session,
    status,
    signIn: handleSignIn,
    signOut: handleSignOut,
  });
} 