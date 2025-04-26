'use client';

import { useEffect, useState } from 'react';
import Head from 'next/head';
import Image from 'next/image';
import { useRouter } from 'next/router';
import { AuthProvider } from '@/components/AuthProvider';
import { showNotification } from '@/components/Notification';
import { useSession } from 'next-auth/react';

export default function Home() {
  const { data: session, status } = useSession();
  const router = useRouter();
  const [sidebarHidden, setSidebarHidden] = useState(false);
  const [modules, setModules] = useState([
    {
      id: 'module-puissance-chauffage',
      title: 'Puissance Chauffage',
      icon: '/assets/icons/calculator.svg',
      description: 'Calcul de la puissance de chauffage nécessaire'
    },
    {
      id: 'module-vase-expansion',
      title: 'Vase d\'Expansion',
      icon: '/assets/icons/water.svg',
      description: 'Calcul et vérification du vase d\'expansion'
    },
    {
      id: 'module-equilibrage',
      title: 'Équilibrage Réseau',
      icon: '/assets/icons/balance.svg',
      description: 'Calculs d\'équilibrage du réseau de chauffage'
    },
    {
      id: 'module-radiateurs',
      title: 'Radiateurs',
      icon: '/assets/icons/radiator.svg',
      description: 'Calculs et vérifications des radiateurs'
    },
    {
      id: 'module-ecs',
      title: 'ECS Instantané',
      icon: '/assets/icons/water-drop.svg',
      description: 'Calculs pour l\'eau chaude sanitaire'
    }
  ]);

  useEffect(() => {
    if (status === 'unauthenticated') {
      router.push('/auth');
    }
  }, [status, router]);

  useEffect(() => {
    // Check sidebar state from localStorage
    const savedSidebarState = localStorage.getItem('sidebarHidden');
    if (savedSidebarState === 'true') {
      setSidebarHidden(true);
    }
  }, []);

  const toggleSidebar = () => {
    setSidebarHidden(!sidebarHidden);
    localStorage.setItem('sidebarHidden', !sidebarHidden);
  };

  if (status === 'loading') {
    return <div>Chargement...</div>;
  }

  if (!session) {
    return null;
  }

  return (
    <AuthProvider>
      {({ signOut }) => (
        <>
          <Head>
            <title>Chauffage Expert</title>
            <meta name="viewport" content="width=device-width, initial-scale=1.0" />
            <link rel="icon" href="/favicon.ico" />
          </Head>

          <div className={`app-container ${sidebarHidden ? 'sidebar-hidden' : ''}`}>
            <button className="sidebar-toggle" onClick={toggleSidebar}>
              <Image src="/assets/icons/menu.svg" alt="Menu" width={24} height={24} />
            </button>

            <aside className="sidebar">
              <div className="sidebar-header">
                <h2>Chauffage Expert</h2>
                <div className="user-info">
                  <span className="user-name">{session?.user?.email || 'Invité'}</span>
                  <button className="btn btn-primary" onClick={signOut}>
                    Déconnexion
                  </button>
                </div>
              </div>
              <nav className="sidebar-nav">
                <ul>
                  {modules.map(module => (
                    <li key={module.id}>
                      <a href={`#${module.id}`}>
                        <Image src={module.icon} alt={module.title} width={24} height={24} />
                        {module.title}
                      </a>
                    </li>
                  ))}
                </ul>
              </nav>
              <div className="sidebar-footer">
                <span title="Statut de la connexion">⚫</span>
                <span>{session?.user?.name || 'Technicien'}</span>
              </div>
            </aside>

            <main className="main-content">
              <header className="main-header">
                <h1>Tableau de bord</h1>
                <div className="header-actions">
                  <input type="search" placeholder="Rechercher un module..." />
                  <button className="btn btn-icon">
                    <Image src="/assets/icons/star.svg" alt="Favoris" width={24} height={24} />
                  </button>
                </div>
              </header>

              <div id="module-container">
                {/* Le contenu du module sera chargé ici */}
              </div>

              <div className="modules-grid">
                {modules.map(module => (
                  <div key={module.id} className="module-card">
                    <Image src={module.icon} alt={module.title} width={48} height={48} />
                    <h3>{module.title}</h3>
                    <p>{module.description}</p>
                  </div>
                ))}
              </div>
            </main>
          </div>
        </>
      )}
    </AuthProvider>
  );
}
