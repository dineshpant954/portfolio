import { site } from './site';

export const contactIntro = "I'm always open to thoughtful conversations around product, AI, agentic systems, strategy, and interesting opportunities — whether it's a role, a problem, or just a sharp idea.";

export const contactCards = [
  { label: 'Email', description: 'Best for direct opportunities', href: site.social.email },
  { label: 'LinkedIn', description: 'Professional profile and messaging', href: site.social.linkedin },
  { label: 'GitHub', description: 'Projects, code, and experiments', href: site.social.github },
  { label: 'Portfolio', description: 'Current external portfolio site', href: site.social.portfolio }
] as const;
