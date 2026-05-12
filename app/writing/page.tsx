import type { Metadata } from 'next';
import { Container } from '@/components/ui/Container';
import { SectionHeading } from '@/components/ui/SectionHeading';
import { PostCard } from '@/components/writing/PostCard';
import { posts } from '@/content/posts';

export const metadata: Metadata = { title: 'Writing' };
export default function Page() { return <main className='py-16'><Container><SectionHeading title='Writing' intro='A space for notes on product, AI, agentic systems, and the kinds of details that make technology actually useful.' /><div className='grid gap-6 md:grid-cols-2'>{posts.map((p) => <PostCard key={p.slug} post={p} />)}</div></Container></main>; }
