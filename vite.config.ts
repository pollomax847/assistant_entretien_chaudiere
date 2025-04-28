import { defineConfig } from 'vite';
import { resolve, dirname } from 'path';
import { fileURLToPath } from 'url';
import fs from 'fs';
import path from 'path';
import type { Connect, ViteDevServer } from 'vite';
import type { ServerResponse } from 'http';

const __dirname = dirname(fileURLToPath(import.meta.url));

// Define MIME types mapping
const mimeTypes: Record<string, string> = {
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

// Static files plugin
function staticFilesPlugin() {
  return {
    name: 'static-files-plugin',
    configureServer(server: ViteDevServer) {
      server.middlewares.use((req: Connect.IncomingMessage, res: ServerResponse, next: Connect.NextFunction) => {
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
              } catch (err: unknown) {
                if (err instanceof Error) {
                  console.error(`[static-plugin] Error reading CSS file: ${err.message}`);
                }
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
            } catch (err: unknown) {
              if (err instanceof Error) {
                console.error(`[static-plugin] Error reading file: ${err.message}`);
              }
            }
          }
        }

        next();
      });
    }
  };
}

export default defineConfig({
  base: '/',
  root: './',
  publicDir: 'public',
  plugins: [staticFilesPlugin()],
  server: {
    port: 3000,
    cors: true,
    open: true,
    fs: {
      strict: false,
      allow: ['..', '/', './public', './src', './modules', './js']
    },
    watch: {
      usePolling: true
    }
  },
  resolve: {
    alias: {
      '@': resolve(__dirname, 'src'),
      '@modules': resolve(__dirname, 'src/modules'),
      '@utils': resolve(__dirname, 'src/utils'),
      '@components': resolve(__dirname, 'src/components'),
      '@config': resolve(__dirname, 'src/config'),
      'js': resolve(__dirname, 'js'),
      'public': resolve(__dirname, 'public'),
      'modules': resolve(__dirname, 'modules'),
      '/css': resolve(__dirname, 'public/css')
    }
  },
  build: {
    outDir: 'dist',
    assetsDir: 'assets',
    sourcemap: true,
    target: 'esnext',
    emptyOutDir: true,
    rollupOptions: {
      input: {
        main: resolve(__dirname, 'index.html'),
        auth: resolve(__dirname, 'auth.html')
      },
      output: {
        format: 'es',
        entryFileNames: 'js/[name]-[hash].js',
        chunkFileNames: 'js/[name]-[hash].js',
        assetFileNames: (assetInfo) => {
          const name = assetInfo.name || '';
          if (name.endsWith('.css')) {
            return 'css/[name]-[hash][extname]';
          }
          if (name.endsWith('.js')) {
            return 'js/[name]-[hash][extname]';
          }
          return 'assets/[name]-[hash][extname]';
        },
        inlineDynamicImports: false,
      }
    }
  },
  optimizeDeps: {
    include: [],
    exclude: []
  },
  css: {
    modules: {
      scopeBehaviour: 'local'
    },
    devSourcemap: true,
    postcss: {
      plugins: []
    }
  }
});