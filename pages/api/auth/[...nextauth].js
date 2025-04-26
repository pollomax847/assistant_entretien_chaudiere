import NextAuth from 'next-auth';
import CredentialsProvider from 'next-auth/providers/credentials';
import { compare } from 'bcryptjs';

export const authOptions = {
  providers: [
    CredentialsProvider({
      name: 'Credentials',
      credentials: {
        email: { label: "Email", type: "email" },
        password: { label: "Password", type: "password" }
      },
      async authorize(credentials) {
        // Ici, vous devriez vérifier les credentials contre votre base de données
        // Pour l'exemple, nous utilisons un utilisateur en dur
        const user = {
          id: '1',
          email: 'test@example.com',
          name: 'Test User',
          password: '$2a$10$XKQvz8UqZz5Zz5Zz5Zz5Z.z5Zz5Zz5Zz5Zz5Zz5Zz5Zz5Zz5Zz5Z'
        };

        if (!credentials?.email || !credentials?.password) {
          throw new Error('Veuillez remplir tous les champs');
        }

        if (credentials.email !== user.email) {
          throw new Error('Email incorrect');
        }

        const isValid = await compare(credentials.password, user.password);

        if (!isValid) {
          throw new Error('Mot de passe incorrect');
        }

        return {
          id: user.id,
          email: user.email,
          name: user.name,
        };
      }
    })
  ],
  pages: {
    signIn: '/auth',
  },
  callbacks: {
    async jwt({ token, user }) {
      if (user) {
        token.id = user.id;
      }
      return token;
    },
    async session({ session, token }) {
      if (token) {
        session.user.id = token.id;
      }
      return session;
    }
  },
  secret: process.env.NEXTAUTH_SECRET,
};

export default NextAuth(authOptions); 