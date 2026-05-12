/**
 * To swap placeholders for real images, drop files into public/images/
 * and replace <Placeholder> with <Image src='/images/...' /> in the relevant components.
 */
export const site = {
  name: 'Dinesh Pant',
  title: 'Dinesh Pant — Product, AI, Strategy',
  description: 'Portfolio of Dinesh Pant — product manager building agentic AI systems and enterprise products. Engineer by training, PM by craft, MBA by finish. Six years across Amadeus, Microsoft, Beats, and Vertiv.',
  location: 'United States · Open to relocation',
  statusPill: 'Open to PM, TPM, AI PM roles',
  social: {
    linkedin: 'https://www.linkedin.com/in/dineshpant/',
    email: 'mailto:dinesh@example.com',
    github: 'https://github.com/dineshpant954',
    portfolio: 'https://dineshpant954.github.io/portfolio'
  }
} as const;
