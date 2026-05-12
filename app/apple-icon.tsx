import { ImageResponse } from 'next/og';

export const size = { width: 180, height: 180 };
export const contentType = 'image/png';

export default function AppleIcon() {
  return new ImageResponse(
    <div style={{ width: '100%', height: '100%', display: 'flex', alignItems: 'center', justifyContent: 'center', background: '#1d3557', borderRadius: 36, color: '#f8f5ef', fontFamily: 'Georgia, serif', fontSize: 112, fontWeight: 600 }}>d</div>,
    size
  );
}
