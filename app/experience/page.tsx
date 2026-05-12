import type { Metadata } from 'next';
import { Container } from '@/components/ui/Container';
import { capabilities, experienceEntries, experienceIntro } from '@/content/experience';

export const metadata: Metadata = { title: 'Experience' };

export default function Page() {
  return <main className='py-16'><Container><h1 className='title-serif text-4xl'>Experience</h1><p className='mt-4 max-w-3xl text-neutral-700'>{experienceIntro}</p><div className='mt-10 grid gap-5'>{experienceEntries.map((entry) => <section key={entry.title} className='surface p-6'><h2 className='text-xl font-semibold'>{entry.title}</h2><p className='mt-3 text-sm text-neutral-600'>{entry.summary}</p></section>)}</div><section className='mt-10'><h2 className='text-xl font-semibold'>Capabilities</h2><div className='mt-4 flex flex-wrap gap-2'>{capabilities.map((item) => <span key={item} className='rounded-full border border-neutral-300 bg-white px-3 py-1 text-xs text-neutral-700'>{item}</span>)}</div></section></Container></main>;
}
