'use client';

import Link from 'next/link';import { usePathname } from 'next/navigation';import { site } from '@/content/site';
const nav=[['/','Home'],['/work','Work'],['/experience','Experience'],['/writing','Writing'],['/about','About'],['/contact','Contact']];
export function SiteHeader(){const p=usePathname();return <header className='sticky top-0 z-50 border-b border-neutral-200/70 bg-cream/90 backdrop-blur'><div className='mx-auto flex max-w-6xl items-center justify-between px-4 py-3'><Link href='/' className='font-semibold'>{site.name}</Link><nav className='hidden gap-5 md:flex'>{nav.map(([h,l])=><Link key={h} href={h} className={p===h?'text-accent font-medium':'text-neutral-700'}>{l}</Link>)}</nav><span className='rounded-full bg-accent/10 px-3 py-1 text-xs text-accent'>{site.statusPill}</span></div></header>}

