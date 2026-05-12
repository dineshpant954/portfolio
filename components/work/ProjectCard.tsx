import Link from 'next/link';
import { Project } from '@/content/projects';

export function ProjectCard({ project }: { project: Project }) {
  return <article className='surface p-6 transition hover:-translate-y-0.5 hover:shadow-md'><p className='eyebrow'>{project.company}</p><h3 className='mt-3 text-xl font-semibold leading-tight'>{project.title}</h3><p className='mt-3 text-sm leading-6 text-neutral-700'>{project.summary}</p><p className='mt-4 border-l-2 border-accent/30 pl-3 text-sm font-medium text-neutral-800'>{project.impact}</p><div className='mt-4 flex flex-wrap gap-2'>{project.tags.map((tag) => <span key={tag} className='rounded-full bg-neutral-100 px-2.5 py-1 text-xs text-neutral-600'>{tag}</span>)}</div><Link href={`/work/${project.slug}`} className='mt-5 inline-block text-sm font-medium text-accent'>View case study →</Link></article>;
}
