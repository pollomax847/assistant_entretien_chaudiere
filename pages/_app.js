import '../styles/globals.css'
import '../styles/theme.css'
import '../styles/notifications.css'
import { ThemeProvider } from '../components/ThemeProvider'
import { NotificationProvider } from '../components/Notification'
import { SessionProvider } from 'next-auth/react'

export default function App({ Component, pageProps: { session, ...pageProps } }) {
  return (
    <SessionProvider session={session}>
      <ThemeProvider>
        <NotificationProvider>
          <Component {...pageProps} />
        </NotificationProvider>
      </ThemeProvider>
    </SessionProvider>
  );
}
