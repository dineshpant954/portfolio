# Live Demo Script - IT Support Triage Agent

## Setup (before interview)
- [ ] n8n running at localhost:5678
- [ ] Mock APIs running at localhost:3001
- [ ] Slack workspace open with #it-support visible
- [ ] Supabase dashboard open (show audit log table)
- [ ] Split screen: Slack (left) + n8n workflow (right)

## Demo Flow (3-4 minutes)

### Demo 1: Lights-Out Resolution (45 seconds)

**Say:** "Let me show you a fully autonomous resolution. I'll type a common IT ticket in Slack."

**Type in #it-support:** `I'm locked out of my account and I have a client call in 15 minutes`

**What happens:**
1. n8n webhook fires (show green execution in n8n)
2. Groq classifies: account_unlock, P2 (user blocked + urgent), confidence 0.94
3. KB search returns KB-1002 (Account Lockout)
4. Policy check: L3 eligible, no approval needed
5. Mock tools execute: okta.verify_identity -> azure_ad.unlock_account
6. Slack reply appears in thread: "Your account has been unlocked. [details]"
7. Show audit log in Supabase: every step recorded

**Say:** "47 seconds, fully autonomous. Every action logged. In production, those mock API calls would be real Azure AD and Okta calls."

### Demo 2: HITL Resolution (60 seconds)

**Type in #it-support:** `VPN hasn't been working since the update last night`

**What happens:**
1. Classified: vpn_troubleshoot, P3, confidence 0.87
2. KB returns KB-2001 (VPN Troubleshooting) - matches known AnyConnect issue
3. Policy: L2, requires approval
4. Message appears in #agent-approvals with proposed action: "Push VPN client update"
5. **Click Approve** (or type `approve INC-XXXXX`)
6. Mock SCCM deployment triggered
7. User gets reply with diagnosis + ETA

**Say:** "The agent found the known issue in KB, proposed the fix, but waited for a human to approve before pushing software. That's the HITL pattern - human-in-the-loop. The agent does the research and proposes, the human decides."

### Demo 3: Security Escalation (30 seconds)

**Type in #it-support:** `Got a weird email asking me to verify my password. Looks suspicious.`

**What happens:**
1. Classified: phishing_report, is_security_incident: true
2. Policy: NEVER auto-resolve security. Route to #secops.
3. Rich escalation message appears in #secops with full context
4. User gets: "This has been flagged and escalated to our security team. Do NOT click any links."

**Say:** "Security incidents are hardcoded to escalate - the agent never tries to handle these autonomously. No confidence score overrides that. This is a conscious design decision."

### Wrap-up (30 seconds)

- Show the n8n workflow canvas (screenshot-worthy)
- Show Supabase audit log: timestamp, agent, action, tool, result for each step
- **Say:** "Total cost: $0. Groq free tier, n8n self-hosted, Supabase free. The mock APIs are labeled - in production, each would be a real enterprise integration."

## Talking Points if Asked

### "Why not Claude/GPT?"
Cost. Groq free tier gives 500K tokens/day on Llama 3.3 70B with sub-second inference. For a portfolio demo, that's more than enough. In production, I'd benchmark Claude vs Llama on classification accuracy and potentially use Claude for complex resolution with Llama for triage.

### "What about hallucination?"
Every resolution cites a KB article. If the agent can't find a match, it escalates instead of guessing. Confidence thresholds prevent low-confidence auto-resolution. The system is designed so the worst case is "human reviews it" - never "AI does something wrong silently."

### "How would this work at scale?"
n8n handles the orchestration but you'd move to n8n cloud or a Kubernetes deployment. The Groq free tier wouldn't be enough - you'd need the paid tier or a self-hosted model. Supabase would need to scale to a production Postgres instance with read replicas for the KB search.

### "What's the hardest design decision?"
Where to draw the automation boundary. Password reset is safe to automate - it's a single API call, reversible, and the user initiated the request. But software deployment touches the user's device, so it needs human approval. Security incidents require zero autonomy - hardcoded escalation, no exceptions. The trust ramp (L0-L3) is the framework for making these decisions systematically.

### "How do you measure success?"
Five metrics: deflection rate (% tickets resolved without human), MTTR (mean time to resolution), cost per ticket (direct comparison to manual), CSAT (user satisfaction), and reopen rate (are we actually fixing things). For the demo, I track all of these in the audit log and tickets table. In production, you'd build a Grafana dashboard.

## If Something Goes Wrong

- **n8n doesn't trigger:** Manually trigger the workflow with test data
- **Groq rate limit:** Say "Free tier has a rate limit. In production we'd use the paid tier. Let me show you the last successful execution in n8n." (Show execution history)
- **Slack issue:** Have screenshots ready as backup. Show the n8n execution log which captures all inputs and outputs regardless of Slack.
