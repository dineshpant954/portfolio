import type { Metadata } from 'next';
import { Container } from '@/components/ui/Container';
import { capabilities, experienceEntries, experienceIntro } from '@/content/experience';

export const metadata: Metadata = { title: 'Experience' };

export default function Page() {

  return <main className='py-16'><Container><h1 className='text-4xl font-semibold'>Experience</h1><p className='mt-4'>{experienceIntro}</p>{experienceEntries.map((entry) => <section key={entry.title} className='mt-10 rounded-2xl border bg-white p-6'><h2 className='text-2xl font-semibold'>{entry.title}</h2><ul className='mt-3 list-disc space-y-2 pl-5'>{entry.bullets.map((b) => <li key={b}>{b}</li>)}</ul></section>)}<section className='mt-10'><h2 className='text-2xl font-semibold'>Selected capabilities</h2><div className='mt-4 flex flex-wrap gap-2'>{capabilities.map((c) => <span key={c} className='rounded-full border bg-white px-3 py-1 text-sm'>{c}</span>)}</div></section></Container></main>;

