#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

echo "Starting n8n, mock-apis, and cloudflared quick tunnel..."
docker compose -f docker-compose.yml -f docker-compose.tunnel.quick.yml up -d

echo "Waiting for Cloudflare quick tunnel URL from logs..."
for _ in $(seq 1 30); do
  URL="$(docker compose -f docker-compose.yml -f docker-compose.tunnel.quick.yml logs cloudflared 2>/dev/null | sed -nE 's#.*(https://[a-zA-Z0-9.-]+\.trycloudflare\.com).*#\1#p' | head -n1)"
  if [[ -n "$URL" ]]; then
    break
  fi
  sleep 2
done

if [[ -z "${URL:-}" ]]; then
  echo "Unable to automatically detect a trycloudflare URL yet."
  echo "Run: docker compose -f docker-compose.yml -f docker-compose.tunnel.quick.yml logs -f cloudflared"
  exit 1
fi

echo
printf '✅ Quick tunnel URL: %s\n' "$URL"
echo
cat <<INSTRUCTIONS
Next steps:
1) Set n8n webhook base URL and restart n8n:
   ./scripts/restart_with_webhook_url.sh ${URL}
2) In n8n, open your Slack Trigger node and copy the Production Webhook URL.
3) Paste that full URL into Slack App > Event Subscriptions > Request URL.
4) Slack will send a challenge POST to verify the endpoint.
INSTRUCTIONS
