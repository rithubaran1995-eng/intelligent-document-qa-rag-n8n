-- ============================================================
-- AI-Powered Document Intelligence & Q&A System
-- Supabase / PostgreSQL / pgvector setup
--
-- Current embedding configuration:
--   Dimension: 3072
-- Table:
--   n8n
-- Retrieval RPC:
--   match_documents
-- ============================================================

-- Enable pgvector.
-- If the extension already exists, this statement is safe to run.
create extension if not exists vector with schema extensions;


-- ------------------------------------------------------------
-- Document / embedding table
-- ------------------------------------------------------------

create table if not exists public.n8n (
    id bigserial primary key,
    content text,
    metadata jsonb,
    embedding extensions.vector(3072)
);


-- ------------------------------------------------------------
-- Vector similarity search function used by the workflow
-- ------------------------------------------------------------

create or replace function public.match_documents (
    query_embedding extensions.vector(3072),
    match_count int default null,
    filter jsonb default '{}'
)
returns table (
    id bigint,
    content text,
    metadata jsonb,
    similarity float
)
language plpgsql
as $$
#variable_conflict use_column
begin
    return query
    select
        n8n.id,
        n8n.content,
        n8n.metadata,
        1 - (n8n.embedding <=> query_embedding) as similarity
    from public.n8n
    where n8n.metadata @> filter
    order by n8n.embedding <=> query_embedding
    limit match_count;
end;
$$;


-- ------------------------------------------------------------
-- Optional verification
-- ------------------------------------------------------------

-- Check table:
-- select * from public.n8n limit 5;

-- Check function:
-- select proname
-- from pg_proc
-- where proname = 'match_documents';
