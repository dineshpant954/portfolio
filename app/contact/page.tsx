import type { Metadata } from 'next';
import { Container } from '@/components/ui/Container';
import { contactCards, contactIntro } from '@/content/contact';

export const metadata: Metadata = { title: 'Contact' };

export default function Page() {
  return <main className='py-16'><Container><h1 className='text-4xl font-semibold'>Contact</h1><p className='mt-4'>{contactIntro}</p><div className='mt-8 grid gap-4 md:grid-cols-2'>{contactCards.map((c) => <a key={c.label} href={c.href} className='rounded-2xl border bg-white p-6 hover:border-accent'><h2 className='text-xl font-semibold'>{c.label}</h2><p className='mt-2 text-sm text-neutral-600'>{c.description}</p></a>)}</div><p className='mt-8 rounded-xl bg-accent/10 p-4 text-sm'>Open to roles in Product Management, Technical Program Management, AI/ML PM, and Strategy & Operations.</p></Container></main>;
}
