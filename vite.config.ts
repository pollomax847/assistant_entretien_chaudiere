import { defineConfig } from 'vite';
import { resolve, dirname } from 'path';
import { fileURLToPath } from 'url';
import fs from 'fs';
import path from 'path';

const __dirname = dirname(fileURLToPath(import.meta.url));

export default defineConfig({
  base: '/',
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
  publicDir: 'public',
  build: {
    outDir: 'dist',
    assetsDir: 'assets',
    sourcemap: true,
    target: 'esnext',
    rollupOptions: {
      input: {
        main: resolve(__dirname, 'index.html'),
      },
      output: {
        format: 'es',
        entryFileNames: 'assets/[name].[hash].js',
        chunkFileNames: 'assets/[name].[hash].js',
        assetFileNames: 'assets/[name].[hash].[ext]',
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