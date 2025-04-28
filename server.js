import express from 'express';
import path from 'path';
import { createServer } from 'vite';
import fs from 'fs';

const app = express();
const port = process.env.PORT || 3000;

// Define MIME types mapping
const mimeTypes = {
  '.html': 'text/html',
  '.js': 'application/javascript',
  '.css': 'text/css',
  '.json': 'application/json',
  '.png': 'image/png',
  '.jpg': 'image/jpeg',
  '.gif': 'image/gif',
  '.svg': 'image/svg+xml',
  '.ico': 'image/x-icon'
};

// Middleware pour servir les fichiers statiques avec les bons types MIME
app.use((req, res, next) => {
  if (!req.url || req.method !== 'GET') {
    return next();
  }

  let url = req.url;
  const queryStringIndex = url.indexOf('?');
  if (queryStringIndex !== -1) {
    url = url.substring(0, queryStringIndex);
  }

  // Handle CSS files with higher priority
  if (url.endsWith('.css')) {
    const basename = path.basename(url);
    const possiblePaths = [
      path.join(process.cwd(), 'public', url.startsWith('/') ? url.substring(1) : url),
      path.join(process.cwd(), 'public/css', basename),
      path.join(process.cwd(), 'css', basename)
    ];

    for (const cssPath of possiblePaths) {
      if (fs.existsSync(cssPath)) {
        try {
          const cssContent = fs.readFileSync(cssPath, 'utf-8');
          res.writeHead(200, {
            'Content-Type': 'text/css; charset=utf-8',
            'X-Content-Type-Options': 'nosniff',
            'Cache-Control': 'public, max-age=31536000, immutable'
          });
          return res.end(cssContent);
        } catch (err) {
          console.error(`Error reading CSS file: ${err.message}`);
        }
      }
    }
  }

  // Handle other file types
  const ext = path.extname(url).toLowerCase();
  if (ext in mimeTypes) {
    const filePath = path.join(process.cwd(), 'public', url.startsWith('/') ? url.substring(1) : url);
    if (fs.existsSync(filePath)) {
      try {
        const content = fs.readFileSync(filePath);
        res.writeHead(200, {
          'Content-Type': `${mimeTypes[ext]}; charset=utf-8`,
          'X-Content-Type-Options': 'nosniff',
          'Cache-Control': 'public, max-age=31536000, immutable'
        });
        return res.end(content);
      } catch (err) {
        console.error(`Error reading file: ${err.message}`);
      }
    }
  }

  next();
});

async function startServer() {
  try {
    // Create Vite server in middleware mode
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
      // Servir les fichiers statiques depuis le répertoire src
      app.use('/src', express.static(path.join(__dirname, 'src')));

      // Route pour la page d'accueil
      app.get('/', (req, res) => {
        res.sendFile(path.join(__dirname, 'index.html'));
      });

      // Route pour la page d'authentification
      app.get('/auth', (req, res) => {
        res.sendFile(path.join(__dirname, 'auth.html'));
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
