import type { Metadata } from 'next';
import { Container } from '@/components/ui/Container';
import { SectionHeading } from '@/components/ui/SectionHeading';
import { ProjectCard } from '@/components/work/ProjectCard';
import { projects } from '@/content/projects';

export const metadata: Metadata = { title: 'Work' };
export default function Page() { return <main className='py-16'><Container><SectionHeading title='Work' intro='Work across agentic AI, internal tools, workflow automation, payments, and enterprise product delivery.' /><div className='grid gap-6 md:grid-cols-2'>{projects.map((p) => <ProjectCard key={p.slug} project={p} />)}</div></Container></main>; }
