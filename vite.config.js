import { defineConfig } from 'vite';

export default defineConfig({
    root: './',
    publicDir: 'static',
    build: {
        outDir: 'public',
        assetsDir: 'assets',
        emptyOutDir: true,
        rollupOptions: {
            input: {
                main: './index.html',
                auth: './auth.html'
            },
            output: {
                assetFileNames: (assetInfo) => {
                    if (assetInfo.name.endsWith('.css')) {
                        return 'css/[name]-[hash][extname]';
                    }
                    if (assetInfo.name.endsWith('.js')) {
                        return 'js/[name]-[hash][extname]';
                    }
                    return 'assets/[name]-[hash][extname]';
                }
            }
        }
    },
    server: {
        port: 3000,
        open: true
    }
}); 