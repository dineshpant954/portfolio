import type { Config } from 'tailwindcss'

const config: Config = {
  content: ['./app/**/*.{js,ts,jsx,tsx,mdx}', './components/**/*.{js,ts,jsx,tsx,mdx}'],
  theme: {
    extend: {
      colors: {
        cream: '#f8f5ef',
        ink: '#222222',
        accent: '#1d3557'
      }
    }
  },
  plugins: []
}

export default config
