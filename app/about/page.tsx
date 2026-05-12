import type { Metadata } from 'next';
import { Container } from '@/components/ui/Container';
import Placeholder from '@/components/ui/Placeholder';
import { aboutContent } from '@/content/about';

export const metadata: Metadata = { title: 'About' };

export default function Page() {
  return <main className='py-16'><Container><h1 className='text-4xl font-semibold'>About</h1><p className='mt-4'>{aboutContent.intro}</p><h2 className='mt-8 text-2xl font-semibold'>How I think</h2><p className='mt-2'>{aboutContent.howIThink}</p><h2 className='mt-8 text-2xl font-semibold'>What I care about</h2><ul className='mt-2 list-disc pl-5'>{aboutContent.values.map((v) => <li key={v}>{v}</li>)}</ul><h2 className='mt-8 text-2xl font-semibold'>Life outside work</h2><p className='mt-2'>{aboutContent.life}</p><div className='mt-8 grid gap-4 md:grid-cols-3'><Placeholder label='Travel' aspect='3/4' /><Placeholder label='Fitness' aspect='3/4' /><Placeholder label='Reading' aspect='3/4' /></div><p className='mt-8 text-lg'>{aboutContent.softCta}</p></Container></main>;
}
