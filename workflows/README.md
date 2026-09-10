# n8n Workflow

Place the exported working n8n workflow JSON in this directory as:

```text
rag-workflow.json
```

## Export from n8n

In the n8n Editor, open the workflow and use the top-right menu:

```text
... → Download
```

n8n exports workflows as JSON.

## Before committing

Open the exported JSON and verify that it does not contain secrets, API keys, passwords, tokens, or decrypted credentials.

Credential references are expected; secrets should remain configured inside n8n.

## Expected workflow

The working workflow contains:

### Ingestion flow
- Document upload/input
- Default Data Loader
- Google Gemini Embeddings
- Supabase Vector Store

### Retrieval flow
- Chat Trigger
- AI Agent
- Google Gemini Chat Model
- Simple Memory
- Supabase Vector Store as a retrieval tool
