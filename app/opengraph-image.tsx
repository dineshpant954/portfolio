import { ImageResponse } from 'next/og';

export const size = { width: 1200, height: 630 };
export const contentType = 'image/png';

export default function OpenGraphImage() {
  return new ImageResponse(
    <div style={{ width: '100%', height: '100%', background: '#f8f5ef', display: 'flex', flexDirection: 'column', justifyContent: 'center', padding: '72px', color: '#1d3557' }}>
      <div style={{ width: '140px', height: '8px', background: '#1d3557', marginBottom: '36px' }} />
      <div style={{ fontFamily: 'Georgia, serif', fontSize: 78, lineHeight: 1.1 }}>Dinesh Pant</div>
      <div style={{ fontFamily: 'ui-sans-serif, system-ui', fontSize: 34, marginTop: '16px' }}>Product · AI · Strategy</div>
    </div>,
    size
  );
}
