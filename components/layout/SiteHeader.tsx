'use client';
import Link from 'next/link';
import { usePathname } from 'next/navigation';
import { site } from '@/content/site';

const nav = [['/', 'Home'], ['/work', 'Work'], ['/experience', 'Experience'], ['/writing', 'Writing'], ['/about', 'About'], ['/contact', 'Contact']];

export function SiteHeader() {
  const pathname = usePathname();
  return <header className='sticky top-0 z-50 border-b border-neutral-200/60 bg-cream/85 backdrop-blur-md'><div className='mx-auto flex max-w-6xl items-center justify-between gap-4 px-4 py-3'><Link href='/' className='text-sm font-semibold tracking-wide'>{site.name}</Link><nav className='hidden items-center gap-5 md:flex'>{nav.map(([href, label]) => <Link key={href} href={href} className={`text-sm transition ${pathname === href ? 'text-accent' : 'text-neutral-600 hover:text-neutral-900'}`}>{label}</Link>)}</nav><span className='rounded-full border border-accent/20 bg-accent/10 px-3 py-1 text-[11px] text-accent'>{site.statusPill}</span></div></header>;
}
