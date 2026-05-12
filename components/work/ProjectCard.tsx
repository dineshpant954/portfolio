
import Link from 'next/link'; import { Project } from '@/content/projects';
export function ProjectCard({project}:{project:Project}){return <article className="rounded-2xl border border-neutral-200 bg-white p-6 hover:-translate-y-0.5 transition"><p className="text-sm text-accent">{project.company}</p><h3 className="mt-2 text-xl font-semibold">{project.title}</h3><p className="mt-2 text-sm text-neutral-700">{project.summary}</p><p className="mt-3 text-sm font-medium">Impact: {project.impact}</p><div className="mt-4 flex flex-wrap gap-2">{project.tags.map(t=><span key={t} className="rounded-full bg-neutral-100 px-3 py-1 text-xs">{t}</span>)}</div><Link href={`/work/${project.slug}`} className="mt-5 inline-block text-accent">View case study →</Link></article>}

