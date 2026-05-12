import type { Metadata } from 'next';
import './globals.css';
import { SiteHeader } from '@/components/layout/SiteHeader';
import { SiteFooter } from '@/components/layout/SiteFooter';
import { site } from '@/content/site';

export const metadata: Metadata = {
  title: { default: site.title, template: '%s | Dinesh Pant' },
  description: site.description,
  openGraph: { title: site.title, description: site.description, images: ['/opengraph-image'] },
  twitter: { card: 'summary_large_image', title: site.title, description: site.description, images: ['/opengraph-image'] }
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return <html lang="en"><body><SiteHeader />{children}<SiteFooter /></body></html>;
}
