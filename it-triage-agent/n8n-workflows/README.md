# n8n Workflow Setup Guide

## Importing the Workflow

1. Start n8n: `docker compose up -d` from the project root
2. Open http://localhost:5678 (default login: admin/admin)
3. Go to **Workflows** > **Import from File**
4. Select `it-triage-agent.json`
5. The workflow will appear with all nodes and connections pre-configured

## Configuring Credentials

You need to set up 3 credentials in n8n:

### 1. Groq API Key
- Go to **Settings** > **Credentials** > **Add Credential**
- Search for **Groq** (or **OpenAI-compatible** if Groq native node is unavailable)
- If using OpenAI-compatible:
  - Base URL: `https://api.groq.com/openai/v1`
  - API Key: Your Groq API key from [console.groq.com](https://console.groq.com)
- If using native Groq node:
  - API Key: Your Groq API key
- Apply this credential to all 3 Groq Chat Model nodes (Triage, Resolver, Escalation)

### 2. Slack Bot Token
- Go to [api.slack.com/apps](https://api.slack.com/apps) and create a new app
- Bot Token Scopes needed:
  - `channels:history` - read messages in channels
  - `channels:read` - list channels
  - `chat:write` - send messages
  - `users:read` - get user info
- Install the app to your workspace
- Copy the Bot User OAuth Token (`xoxb-...`)
- In n8n: **Settings** > **Credentials** > **Add Credential** > **Slack API**
- Paste the bot token
- Apply to all Slack nodes

### 3. Supabase (via HTTP Headers)
- The workflow uses HTTP Request nodes with headers for Supabase
- Headers are set using environment variables in each HTTP node:
  - `apikey`: Your Supabase anon key
  - `Authorization`: `Bearer {your_service_key}`
- Set these in your `.env` file or directly in n8n's environment settings

## Slack Channel Setup

Create these channels in your Slack workspace:

| Channel | Purpose |
|---|---|
| `#it-support` | User-facing intake channel. Users post IT issues here. |
| `#agent-approvals` | HITL approval requests. Agents approve/deny proposed actions. |
| `#tier2-support` | Escalation target for complex technical issues. |
| `#secops` | Security incident escalations. Phishing, malware, etc. |
| `#human-triage` | Low-confidence tickets that need manual classification. |

Invite the Slack bot to all 5 channels.

## Workflow Nodes Overview

```
Slack Trigger → Extract Message → Create Ticket (Supabase)
    → Triage Agent (Groq) → Parse Classification
    → Search KB (Supabase) + Fetch Policy (Supabase)
    → Check Policy & Route → Audit Log
    → Route Switch:
        ├── Lights-Out: Resolver → Mock Tool → Slack Reply → Update Ticket
        ├── HITL: Resolver → #approvals → Update Ticket → Slack Ack
        ├── Escalate: Escalation Agent → #tier2/#secops → Slack Reply → Update Ticket
        └── Human Triage: #human-triage → Slack Reply
```

## Testing

After setup, test with these messages in `#it-support`:

1. **Lights-Out test:** `I'm locked out of my account and I have a client call in 15 minutes`
   - Expected: Auto-resolve via mock APIs, reply in thread

2. **HITL test:** `VPN hasn't been working since the update last night`
   - Expected: Proposal posted to #agent-approvals

3. **Escalation test:** `Got a suspicious email asking me to verify my password`
   - Expected: Escalated to #secops

4. **Low-confidence test:** `Something is broken`
   - Expected: Routed to #human-triage

## Troubleshooting

- **Workflow doesn't trigger:** Verify the Slack bot is invited to #it-support and has `channels:history` scope
- **Groq errors:** Check your API key. Free tier has 30 requests/minute limit. If rate-limited, wait 60 seconds.
- **Supabase 404:** Verify the `search_kb_text` function exists (run schema.sql), check URL and API key
- **Mock API errors:** Ensure mock-apis container is running (`docker compose ps`). The URL in n8n should be `http://mock-apis:3001` when running in Docker, or `http://localhost:3001` if n8n is running outside Docker.

## Customization

### Adding new intents
1. Add KB articles to Supabase (INSERT into kb_articles)
2. Add a policy rule (INSERT into policy_rules)
3. The triage agent will automatically classify to the new intent if the system prompt taxonomy is updated

### Changing LLM model
Update the model name in each Groq Chat Model node. Options:
- `llama-3.3-70b-versatile` (default, best quality)
- `llama-3.1-8b-instant` (faster, lower quality)
- `mixtral-8x7b-32768` (alternative, good for structured output)
