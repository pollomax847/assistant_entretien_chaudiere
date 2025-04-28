import { createServer } from 'vite';
import express from 'express';
import path from 'path';
import fs from 'fs';

const app = express();

// Serve static files with correct MIME types
app.use('/css', (req, res, next) => {
  const filePath = path.join(process.cwd(), 'public', req.path);
  
  if (fs.existsSync(filePath)) {
    const ext = path.extname(filePath);
    if (ext === '.css') {
      res.setHeader('Content-Type', 'text/css; charset=utf-8');
      res.setHeader('X-Content-Type-Options', 'nosniff');
      fs.createReadStream(filePath).pipe(res);
    } else {
      next();
    }
  } else {
    next();
  }
});

// Serve other static files
app.use(express.static('public'));

export default app; 