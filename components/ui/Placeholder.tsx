type Aspect = '16/9' | '4/5' | '1/1' | '3/4' | '21/9';

export default function Placeholder({
  label,
  aspect,
  className,
  tone = 'warm'
}: {
  label: string;
  aspect: Aspect;
  className?: string;
  tone?: 'warm' | 'muted';
}) {
  const palette = tone === 'muted'
    ? { bg: '#f2f0ea', border: '#3f4f63', primary: '#2b2b2b', secondary: '#6b7280' }
    : { bg: '#f8f5ef', border: '#364153', primary: '#222222', secondary: '#6b7280' };

  return (
    <div className={`w-full overflow-hidden rounded-2xl ${className ?? ''}`} style={{ aspectRatio: aspect }}>
      <svg role="img" aria-label={label} viewBox="0 0 1000 1000" className="h-full w-full" xmlns="http://www.w3.org/2000/svg">
        <rect x="0.5" y="0.5" width="999" height="999" fill={palette.bg} stroke={palette.border} strokeWidth="1" />
        <text x="500" y="475" textAnchor="middle" fill={palette.primary} fontSize="42" fontFamily="ui-sans-serif, system-ui, -apple-system, Segoe UI, sans-serif" fontWeight="500">{label}</text>
        <text x="500" y="530" textAnchor="middle" fill={palette.secondary} fontSize="24" fontFamily="ui-sans-serif, system-ui, -apple-system, Segoe UI, sans-serif" fontWeight="400">Replace in public/images/</text>
      </svg>
    </div>
  );
}
