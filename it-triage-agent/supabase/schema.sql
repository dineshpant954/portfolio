-- ============================================================
-- IT Support Triage Agent - Database Schema
-- Run this in Supabase SQL Editor before seed.sql
-- ============================================================

-- Enable required extensions
CREATE EXTENSION IF NOT EXISTS vector;
CREATE EXTENSION IF NOT EXISTS pg_trgm;

-- ============================================================
-- KNOWLEDGE BASE ARTICLES
-- ============================================================
CREATE TABLE kb_articles (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  article_id TEXT UNIQUE NOT NULL,
  title TEXT NOT NULL,
  category TEXT NOT NULL,
  subcategory TEXT,
  content TEXT NOT NULL,
  resolution_steps TEXT,
  automation_eligible BOOLEAN DEFAULT false,
  automation_level TEXT CHECK (automation_level IN ('L0', 'L1', 'L2', 'L3')),
  tools_required TEXT[],
  embedding vector(1536),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_kb_category ON kb_articles(category);
CREATE INDEX idx_kb_article_id ON kb_articles(article_id);

-- Full-text search index (used instead of embeddings for the demo)
CREATE INDEX idx_kb_textsearch ON kb_articles USING gin(
  to_tsvector('english', title || ' ' || content || ' ' || COALESCE(resolution_steps, ''))
);

-- Trigram index for fuzzy matching
CREATE INDEX idx_kb_title_trgm ON kb_articles USING gin(title gin_trgm_ops);

-- ============================================================
-- TICKETS
-- ============================================================
CREATE TABLE tickets (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  ticket_id TEXT UNIQUE NOT NULL,
  source TEXT NOT NULL,
  user_id TEXT,
  user_name TEXT,
  raw_text TEXT NOT NULL,

  -- AI classification
  category TEXT,
  subcategory TEXT,
  intent TEXT,
  priority TEXT CHECK (priority IN ('P1', 'P2', 'P3', 'P4')),
  confidence NUMERIC(4,3),

  -- Resolution
  status TEXT DEFAULT 'open' CHECK (status IN ('open', 'triaged', 'in_progress', 'awaiting_approval', 'resolved', 'escalated', 'closed')),
  resolution_mode TEXT CHECK (resolution_mode IN ('lights_out', 'hitl', 'escalated', 'manual')),
  resolution_summary TEXT,
  resolved_by TEXT,

  -- KB retrieval
  kb_articles_matched JSONB,

  -- Timing
  created_at TIMESTAMPTZ DEFAULT NOW(),
  first_response_at TIMESTAMPTZ,
  resolved_at TIMESTAMPTZ,

  -- Metadata
  slack_channel TEXT,
  slack_thread_ts TEXT
);

CREATE INDEX idx_tickets_status ON tickets(status);
CREATE INDEX idx_tickets_intent ON tickets(intent);
CREATE INDEX idx_tickets_created ON tickets(created_at);

-- ============================================================
-- AUDIT LOG (append-only)
-- ============================================================
CREATE TABLE audit_log (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  ticket_id TEXT REFERENCES tickets(ticket_id),
  timestamp TIMESTAMPTZ DEFAULT NOW(),
  agent_name TEXT NOT NULL,
  action TEXT NOT NULL,
  input_summary TEXT,
  output_summary TEXT,
  tool_called TEXT,
  tool_parameters JSONB,
  tool_result JSONB,
  confidence NUMERIC(4,3),
  policy_decision TEXT,
  duration_ms INTEGER,
  error TEXT
);

CREATE INDEX idx_audit_ticket ON audit_log(ticket_id);
CREATE INDEX idx_audit_timestamp ON audit_log(timestamp);

-- ============================================================
-- POLICY RULES
-- ============================================================
CREATE TABLE policy_rules (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  intent TEXT NOT NULL,
  max_automation_level TEXT NOT NULL,
  requires_approval BOOLEAN DEFAULT true,
  approval_channel TEXT,
  confidence_threshold NUMERIC(4,3) DEFAULT 0.850,
  tools_allowed TEXT[],
  escalation_target TEXT,
  is_active BOOLEAN DEFAULT true,
  notes TEXT
);

-- ============================================================
-- HELPER FUNCTION: Search KB by vector similarity
-- (For future use with embedding model)
-- ============================================================
CREATE OR REPLACE FUNCTION search_kb(
  query_embedding vector(1536),
  match_threshold FLOAT DEFAULT 0.5,
  match_count INT DEFAULT 5
)
RETURNS TABLE (
  article_id TEXT,
  title TEXT,
  category TEXT,
  content TEXT,
  resolution_steps TEXT,
  automation_eligible BOOLEAN,
  automation_level TEXT,
  tools_required TEXT[],
  similarity FLOAT
)
LANGUAGE plpgsql AS $$
BEGIN
  RETURN QUERY
  SELECT
    ka.article_id,
    ka.title,
    ka.category,
    ka.content,
    ka.resolution_steps,
    ka.automation_eligible,
    ka.automation_level,
    ka.tools_required,
    1 - (ka.embedding <=> query_embedding) AS similarity
  FROM kb_articles ka
  WHERE 1 - (ka.embedding <=> query_embedding) > match_threshold
  ORDER BY ka.embedding <=> query_embedding
  LIMIT match_count;
END;
$$;

-- ============================================================
-- HELPER FUNCTION: Search KB by full-text search
-- (Used for demo - no embedding model needed)
-- ============================================================
CREATE OR REPLACE FUNCTION search_kb_text(
  search_query TEXT,
  match_count INT DEFAULT 5
)
RETURNS TABLE (
  article_id TEXT,
  title TEXT,
  category TEXT,
  content TEXT,
  resolution_steps TEXT,
  automation_eligible BOOLEAN,
  automation_level TEXT,
  tools_required TEXT[],
  relevance FLOAT
)
LANGUAGE plpgsql AS $$
BEGIN
  RETURN QUERY
  SELECT
    ka.article_id,
    ka.title,
    ka.category,
    ka.content,
    ka.resolution_steps,
    ka.automation_eligible,
    ka.automation_level,
    ka.tools_required,
    ts_rank(
      to_tsvector('english', ka.title || ' ' || ka.content || ' ' || COALESCE(ka.resolution_steps, '')),
      plainto_tsquery('english', search_query)
    )::FLOAT AS relevance
  FROM kb_articles ka
  WHERE to_tsvector('english', ka.title || ' ' || ka.content || ' ' || COALESCE(ka.resolution_steps, ''))
        @@ plainto_tsquery('english', search_query)
  ORDER BY relevance DESC
  LIMIT match_count;
END;
$$;
