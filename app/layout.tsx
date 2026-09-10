import { Analytics } from '@vercel/analytics/next'
import type { Metadata, Viewport } from 'next'
import './globals.css'
import { RegisterSW } from '@/components/register-sw'
import { ResponsiveScale } from '@/components/responsive-scale'

export const metadata: Metadata = {
  title: 'Multicaixa Express',
  description: 'App de simulacao MULTICAIXA Express',
  generator: 'v0.app',
  manifest: '/manifest.webmanifest',

  icons: {
    icon: '/icon-512.png',
    apple: '/apple-icon.png',
  },

  appleWebApp: {
    capable: true,
    statusBarStyle: 'black-translucent',
    title: 'MCX Express',
  },
}

export const viewport: Viewport = {
  colorScheme: 'light dark',
  themeColor: [
    { media: '(prefers-color-scheme: light)', color: '#FF8600' },
    { media: '(prefers-color-scheme: dark)', color: '#FF8600' },
  ],
}

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode
}>) {
  return (
    <html lang="pt">
      <body className="antialiased">
        <RegisterSW />
        {children}
        {process.env.NODE_ENV === 'production' && <Analytics />}
      </body>
    </html>
  )
}
