'use client';

import { useState } from 'react';
import { signIn } from 'next-auth/react';
import { useRouter } from 'next/router';
import { useTheme } from '@mui/material/styles';
import {
  Box,
  Container,
  Paper,
  Typography,
  TextField,
  Button,
  Alert,
} from '@mui/material';
import Head from 'next/head';
import { AuthProvider } from '@/components/AuthProvider';
import { showNotification } from '@/components/Notification';

export default function Auth() {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');
  const router = useRouter();
  const theme = useTheme();

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');

    try {
      const result = await signIn('credentials', {
        redirect: false,
        email,
        password,
      });

      if (result.error) {
        setError(result.error);
      } else {
        router.push('/');
      }
    } catch (error) {
      setError('Une erreur est survenue lors de la connexion');
    }
  };

  return (
    <AuthProvider>
      {({ signIn }) => (
        <>
          <Head>
            <title>Connexion - Chauffage Expert</title>
            <meta name="viewport" content="width=device-width, initial-scale=1.0" />
            <link rel="icon" href="/favicon.ico" />
          </Head>

          <Container maxWidth="sm">
            <Box
              sx={{
                minHeight: '100vh',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
              }}
            >
              <Paper
                elevation={3}
                sx={{
                  p: 4,
                  width: '100%',
                  backgroundColor: theme.palette.background.paper,
                }}
              >
                <Typography variant="h4" component="h1" gutterBottom align="center">
                  Connexion
                </Typography>
                
                {error && (
                  <Alert severity="error" sx={{ mb: 2 }}>
                    {error}
                  </Alert>
                )}

                <form onSubmit={handleSubmit}>
                  <TextField
                    fullWidth
                    label="Email"
                    type="email"
                    value={email}
                    onChange={(e) => setEmail(e.target.value)}
                    margin="normal"
                    required
                  />
                  
                  <TextField
                    fullWidth
                    label="Mot de passe"
                    type="password"
                    value={password}
                    onChange={(e) => setPassword(e.target.value)}
                    margin="normal"
                    required
                  />

                  <Button
                    type="submit"
                    variant="contained"
                    fullWidth
                    sx={{ mt: 3 }}
                  >
                    Se connecter
                  </Button>
                </form>
              </Paper>
            </Box>
          </Container>
        </>
      )}
    </AuthProvider>
  );
}
