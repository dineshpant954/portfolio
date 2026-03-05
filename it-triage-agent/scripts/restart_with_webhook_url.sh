#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <https://public-url>"
  exit 1
fi

INPUT_URL="$1"
if [[ "$INPUT_URL" != https://* ]]; then
  echo "Error: WEBHOOK_URL must start with https://"
  exit 1
fi

NORMALIZED_URL="${INPUT_URL%/}/"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_LOCAL="$ROOT_DIR/.env.local"

if [[ -f "$ENV_LOCAL" ]]; then
  if rg -q '^WEBHOOK_URL=' "$ENV_LOCAL"; then
    sed -i "s#^WEBHOOK_URL=.*#WEBHOOK_URL=${NORMALIZED_URL}#" "$ENV_LOCAL"
  else
    printf '\nWEBHOOK_URL=%s\n' "$NORMALIZED_URL" >> "$ENV_LOCAL"
  fi
else
  printf 'WEBHOOK_URL=%s\n' "$NORMALIZED_URL" > "$ENV_LOCAL"
fi

echo "Wrote WEBHOOK_URL=${NORMALIZED_URL} to .env.local"

echo "Restarting n8n with .env + .env.local..."
docker compose --env-file .env --env-file .env.local down n8n
docker compose --env-file .env --env-file .env.local up -d n8n

echo "Done. n8n now uses WEBHOOK_URL=${NORMALIZED_URL}"
