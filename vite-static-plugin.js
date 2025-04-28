import path from 'path';
import fs from 'fs';

/**
 * A Vite plugin to serve static files with correct MIME types
 */
export default function staticFilesPlugin() {
  return {
    name: 'static-files-plugin',
    configureServer(server) {
      // Add middleware to properly serve static files
      server.middlewares.use((req, res, next) => {
        // Define mime types mapping
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
        
        // Skip if no URL
        if (!req.url) {
          return next();
        }
        
        // Only handle GET requests
        if (req.method !== 'GET') {
          return next();
        }
        
        // Parse the URL
        let url = req.url;
        const queryStringIndex = url.indexOf('?');
        if (queryStringIndex !== -1) {
          url = url.substring(0, queryStringIndex);
        }
        
        console.log(`[static-plugin] Processing request: ${url}`);
        
        // Handle CSS files with higher priority
        if (url.endsWith('.css')) {
          console.log(`[static-plugin] Handling CSS request: ${url}`);
          
          // Get just the filename for more direct matching
          const basename = path.basename(url);
          console.log(`[static-plugin] CSS basename: ${basename}`);
          
          // Expanded paths to check for the file
          const possiblePaths = [
            path.join(process.cwd(), 'public', url.startsWith('/') ? url.substring(1) : url),
            path.join(process.cwd(), 'public/css', basename),
            path.join(process.cwd(), 'css', basename)
          ];

          console.log(`[static-plugin] Searching ${possiblePaths.length} possible paths for CSS file`);
          
          // Try each path until the file is found
          for (const cssPath of possiblePaths) {
            if (fs.existsSync(cssPath)) {
              try {
                console.log(`[static-plugin] Found CSS at: ${cssPath}`);
                const cssContent = fs.readFileSync(cssPath, 'utf-8');
                res.writeHead(200, {
                  'Content-Type': 'text/css; charset=utf-8',
                  'X-Content-Type-Options': 'nosniff',
                  'Cache-Control': 'no-cache, no-store, must-revalidate',
                  'Pragma': 'no-cache',
                  'Expires': '0'
                });
                return res.end(cssContent);
              } catch (err) {
                console.error(`[static-plugin] Error reading CSS file: ${err.message}`);
              }
            }
          }
          
          // Return content or default CSS
          console.warn(`[static-plugin] CSS file not found: ${url}, returning empty CSS`);
          return res.end(`/* CSS file not found: ${basename} */\n:root { --css-not-found: true; }`);
        }

        // Handle other file types
        const ext = path.extname(url).toLowerCase();
        if (mimeTypes[ext]) {
          const filePath = path.join(process.cwd(), 'public', url.startsWith('/') ? url.substring(1) : url);
          if (fs.existsSync(filePath)) {
            try {
              const content = fs.readFileSync(filePath);
              res.writeHead(200, {
                'Content-Type': `${mimeTypes[ext]}; charset=utf-8`,
                'X-Content-Type-Options': 'nosniff'
              });
              return res.end(content);
            } catch (err) {
              console.error(`[static-plugin] Error reading file: ${err.message}`);
            }
          }
        }

        // Let other middleware handle the request if we didn't serve it
        next();
      });
    }
  };
}
