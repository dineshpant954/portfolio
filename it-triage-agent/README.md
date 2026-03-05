# IT Support Triage & Resolution Agent

### Agentic AI system that classifies, retrieves, and resolves IT tickets autonomously

Built with: n8n · Groq (Llama 3.3 70B) · Supabase · Slack

---

## What This Does

An end-to-end agentic system for IT service desk automation. A user posts an IT issue in Slack, the agent classifies intent and priority, searches a knowledge base for relevant articles, checks policy rules to determine the right level of autonomy, and either resolves the issue automatically, proposes a fix for human approval, or escalates with full context. Every action is logged to an audit trail.

## Architecture

```
Slack #it-support
       |
       | Webhook
       v
  n8n Workflow Engine
       |
       +-- Triage Agent (Groq / Llama 3.3 70B)
       |        |
       |        +-- Classify: intent, priority, confidence
       |        +-- Extract search terms for KB
       |
       +-- KB Search (Supabase full-text search)
       |        |
       |        +-- Top 3 matching articles with relevance scores
       |
       +-- Policy Check
       |        |
       |        +-- Compare intent + confidence vs policy rules
       |        +-- Route decision:
       |             |
       |             +-- L3 (lights-out) --> Mock Tool APIs --> Slack reply
       |             +-- L2 (HITL) -------> #approvals --> Wait --> Execute
       |             +-- Escalate --------> #tier2 / #secops with context
       |             +-- Low confidence --> #human-triage
       |
       +-- Audit Log (Supabase) -- every step recorded
```

## Demo Video

> [Loom link — coming soon]

## Tech Decisions

### Why Groq over Claude/GPT
$0 cost. Groq's free tier provides 500K tokens/day on Llama 3.3 70B with sub-second inference. The API is OpenAI-compatible, so it works with n8n's built-in Groq Chat Model node. Llama 3.3 70B handles structured JSON output and tool-calling well enough for classification and resolution generation. In production, I'd benchmark Claude vs Llama on classification accuracy and potentially use Claude for complex resolution with Llama for triage.

### Why n8n over LangGraph
Visual workflow canvas that's screenshot-able for a portfolio. Native Groq node, 400+ integrations, built-in Slack and HTTP nodes, Wait node for HITL approval flows. Free when self-hosted via Docker. The workflow JSON is importable — anyone can clone this repo and have it running in 10 minutes.

### Why Supabase over Pinecone
Free pgvector for similarity search, plus full Postgres for tickets, audit logs, and KB articles in one database. Built-in REST API means n8n can query it via HTTP Request nodes without custom code. Row-level security available if this moves to production.

### What's Mocked vs Real
| Component | Status |
|---|---|
| LLM inference (Groq/Llama) | **Real** - actual AI classification and reasoning |
| Workflow orchestration (n8n) | **Real** - production-grade workflow engine |
| Knowledge base + search (Supabase) | **Real** - actual full-text search over 20 KB articles |
| Audit logging (Supabase) | **Real** - every action recorded with timestamps |
| Slack intake + notifications | **Real** - actual Slack bot interactions |
| Tool execution (Azure AD, Okta, SCCM) | **Mock** - Express server simulating enterprise APIs |

The mock APIs return realistic response payloads. In production, each mock endpoint would be replaced with the actual enterprise API call (Microsoft Graph for Azure AD, Okta Admin API, SCCM/Intune REST API).

## Quick Start

```bash
# 1. Clone repo
git clone https://github.com/dineshpant954/it-triage-agent.git
cd it-triage-agent

# 2. Copy env and add your keys
cp .env.example .env
# Edit .env: add GROQ_API_KEY, SUPABASE_URL, SUPABASE_KEY, SLACK_BOT_TOKEN

# 3. Start n8n + mock APIs
docker compose up -d

# 4. Set up Supabase
# Go to your Supabase project > SQL Editor
# Run schema.sql first, then seed.sql

# 5. Import n8n workflow
# Open http://localhost:5678
# Go to Workflows > Import from File > select n8n-workflows/it-triage-agent.json

# 6. Configure credentials in n8n
# Add: Groq API key, Slack bot token, Supabase URL + API key
# See n8n-workflows/README.md for detailed setup

# 7. Test it
# Go to Slack #it-support, type: "I'm locked out of my account"
```

## Sample Interactions

### 1. Password Lockout - Lights-Out (L3)
**User types:** `I'm locked out of my account and I have a client call in 15 minutes`

**Agent does:**
- Classifies: `account_unlock`, P2-High, confidence 0.94
- Retrieves: KB-1002 "Account Lockout After Failed Attempts" (relevance: 0.91)
- Policy: L3 eligible, no approval needed
- Executes: `okta.verify_identity` (push notification) -> `azure_ad.unlock_account`
- Replies in Slack thread: "Your account has been unlocked. You had 5 failed login attempts which triggered the lockout. I've sent a verification push to your Okta Verify app and unlocked your AD account. You should be able to log in now. If it happens again, wait 30 minutes for auto-unlock or reach out here."
- **Total time: ~47 seconds**

### 2. VPN Connectivity - HITL (L2)
**User types:** `VPN hasn't been working since the update last night`

**Agent does:**
- Classifies: `vpn_troubleshoot`, P3-Medium, confidence 0.87
- Retrieves: KB-2001 "VPN Connection Troubleshooting" (relevance: 0.89)
- Policy: L2, requires approval
- Posts to #agent-approvals: "Proposed: Push AnyConnect 4.10 update via SCCM. Known issue with 4.9.x on macOS Sonoma. Approve?"
- On approval: Executes `cmdb.query_asset` + `sccm.deploy_software`
- Replies to user with diagnosis + ETA
- **Total time: ~8 min (including human review)**

### 3. Software Install - HITL (L2)
**User types:** `Need Figma installed for my design work this sprint`

**Agent does:**
- Classifies: `software_install`, P4-Low, confidence 0.92
- Retrieves: KB-3001 "Standard Software Catalog" + KB-3002 "Software Install Process"
- Policy: L2, requires approval + entitlement check
- Posts to #agent-approvals: "Figma requested. User is in Product (Design entitled). 42/50 licenses available. Deploy via SCCM?"
- On approval: Executes `sccm.deploy_software`
- **Total time: ~30 min (pending manager confirmation)**

### 4. Phishing Report - Escalate
**User types:** `Got a suspicious email asking me to verify my password. Looks fishy.`

**Agent does:**
- Classifies: `phishing_report`, P1-Critical, `is_security_incident: true`
- Policy: NEVER auto-resolve. Hardcoded escalation.
- Posts to #secops: Full context package with classification, KB refs, recommended next steps
- Replies to user: "This has been flagged as a potential security incident and escalated to our security team. Do NOT click any links or reply to the email. Your ticket ID is INC-XXXXX."
- **Total time: ~12 seconds to escalate**

## What I'd Build Next

- **Production API integration:** Replace mock endpoints with real Azure AD (Microsoft Graph), Okta Admin API, and Intune/SCCM REST APIs behind a service account with least-privilege scoping
- **Embedding-based KB search:** Add an embedding model (Cohere free tier or local sentence-transformers) to replace full-text search with pgvector semantic search for better retrieval accuracy
- **Feedback loop:** Track resolution outcomes (reopens, CSAT) and feed back into confidence threshold tuning and KB gap detection
- **Multi-channel intake:** Add Microsoft Teams bot and email parsing (via n8n IMAP node) alongside Slack

## Repository Structure

```
it-triage-agent/
├── README.md                          # This file
├── docker-compose.yml                 # n8n + mock APIs
├── .env.example                       # Environment variables template
├── supabase/
│   ├── schema.sql                     # Tables: kb_articles, tickets, audit_log, policies
│   └── seed.sql                       # 20 KB articles + 5 policy rules
├── n8n-workflows/
│   ├── it-triage-agent.json           # Main workflow (importable to n8n)
│   └── README.md                      # Import + configuration guide
├── mock-apis/
│   ├── server.js                      # Express server for mock tool execution
│   ├── package.json
│   └── Dockerfile
├── prompts/
│   ├── triage-system-prompt.md        # Classification prompt
│   ├── resolver-system-prompt.md      # Resolution generation prompt
│   └── escalation-system-prompt.md    # Escalation packaging prompt
└── portfolio/
    ├── demo-script.md                 # Interview demo walkthrough
    └── architecture-diagram.svg       # Architecture diagram
```

---

**Author:** Dinesh Pant | MBA Candidate, Kelley School of Business | [Portfolio](https://dineshpant954.github.io/portfolio)
