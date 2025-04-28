import express from 'express';
import path from 'path';
import middleware from './middleware.js';
import { createServer } from 'vite';

const app = express();
const port = process.env.PORT || 3000;

// Use the middleware
app.use(middleware);

async function startServer() {
  try {
    // Create Vite server
    const vite = await createServer({
      server: {
        middlewareMode: true,
        app
      }
    });

    // Use Vite's middleware
    app.use(vite.middlewares);

    // Only serve static files in production
    if (process.env.NODE_ENV === 'production') {
      // Servir les fichiers statiques depuis le répertoire public
      app.use(express.static(path.join(__dirname, 'public'), {
        setHeaders: (res, path) => {
          if (path.endsWith('.css')) {
            res.setHeader('Content-Type', 'text/css; charset=utf-8');
          }
        }
      }));

      // Servir les fichiers statiques depuis le répertoire src
      app.use('/src', express.static(path.join(__dirname, 'src')));

      // Route pour la page d'accueil
      app.get('/', (req, res) => {
        res.sendFile(path.join(__dirname, 'index.html'));
      });

      // Route de secours pour rediriger toute autre route vers index.html (SPA)
      app.get('*', (req, res) => {
        res.sendFile(path.join(__dirname, 'index.html'));
      });
    }

    // Function to try starting the server on a given port
    const tryStartServer = (portToTry) => {
      return new Promise((resolve, reject) => {
        const server = app.listen(portToTry)
          .on('listening', () => {
            console.log(`Serveur démarré sur http://localhost:${portToTry}`);
            resolve(server);
          })
          .on('error', (err) => {
            if (err.code === 'EADDRINUSE') {
              console.log(`Port ${portToTry} est occupé, tentative sur le port ${portToTry + 1}`);
              resolve(tryStartServer(portToTry + 1));
            } else {
              reject(err);
            }
          });
      });
    };

    await tryStartServer(port);
  } catch (error) {
    console.error('Error starting server:', error);
    process.exit(1);
  }
}

startServer();
