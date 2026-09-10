# AI-Powered Document Intelligence & Q&A System

> A production-oriented Retrieval-Augmented Generation (RAG) workflow using n8n, Google Gemini, Supabase Vector Store, PostgreSQL/pgvector, and an AI Agent.

[![n8n](https://img.shields.io/badge/n8n-Workflow%20Automation-orange)](https://n8n.io/)
[![Google Gemini](https://img.shields.io/badge/Google%20Gemini-LLM%20%26%20Embeddings-blue)](https://ai.google.dev/)
[![Supabase](https://img.shields.io/badge/Supabase-PostgreSQL%20%2B%20pgvector-green)](https://supabase.com/)
[![RAG](https://img.shields.io/badge/Architecture-RAG-purple)](https://en.wikipedia.org/wiki/Retrieval-augmented_generation)

## Overview

This project implements an AI-powered document question-answering system using Retrieval-Augmented Generation (RAG).

Users can upload documents, convert document content into vector embeddings, store those embeddings in Supabase using PostgreSQL/pgvector, and ask natural-language questions about the uploaded content.

The n8n AI Agent retrieves relevant document chunks through semantic vector search and passes the retrieved context to Google Gemini to generate a context-aware answer.

### Core pipeline

```text
Document
   │
   ▼
n8n Data Loader
   │
   ▼
Google Gemini Embeddings
   │
   ▼
3072-dimensional vectors
   │
   ▼
Supabase / pgvector
   │
   │
   │       Retrieval
   │         ▲
User Query ─┴─> AI Agent
                 │
                 ▼
          Vector Similarity Search
                 │
                 ▼
          Relevant Document Chunks
                 │
                 ▼
          Google Gemini Chat Model
                 │
                 ▼
             AI Answer
```

## Features

- Document ingestion through n8n
- Google Gemini embeddings
- 3072-dimensional vector storage
- Supabase Vector Store
- PostgreSQL + pgvector
- Semantic similarity search
- n8n AI Agent
- Google Gemini chat generation
- Conversation memory
- Separate ingestion and retrieval flows
- Reusable Supabase SQL setup
- Importable n8n workflow export

## Technology Stack

| Technology | Role |
|---|---|
| n8n | Workflow orchestration and AI Agent |
| Google Gemini | LLM response generation |
| Gemini Embeddings | Document/query vectorization |
| Supabase | Hosted PostgreSQL and vector storage |
| pgvector | Vector storage and similarity search |
| PostgreSQL | Document metadata and retrieval function |
| RAG | Grounding LLM responses in retrieved documents |

## Architecture

The system contains two logical flows.

### 1. Document ingestion flow

```text
Upload Document
      ↓
Default Data Loader
      ↓
Content Processing / Chunking
      ↓
Google Gemini Embeddings
      ↓
Supabase Vector Store
      ↓
PostgreSQL + pgvector
```

### 2. Retrieval and generation flow

```text
User Question
      ↓
Chat Trigger
      ↓
n8n AI Agent
      ↓
Query Embedding
      ↓
Supabase Vector Store
      ↓
Semantic Similarity Search
      ↓
Relevant Document Chunks
      ↓
Google Gemini Chat Model
      ↓
Context-Aware Answer
```

See [docs/architecture.md](docs/architecture.md) for the detailed architecture description.

## Database Schema

The project uses a table named `n8n`:

```sql
id          BIGSERIAL PRIMARY KEY
content     TEXT
metadata    JSONB
embedding   extensions.vector(3072)
```

The `embedding` dimension must match the output dimension produced by the Gemini embedding node.

The retrieval RPC is:

```text
match_documents(query_embedding, match_count, filter)
```

and performs vector similarity search against the `n8n` table.

See [supabase/setup.sql](supabase/setup.sql).

## Setup

### Prerequisites

- An n8n instance
- A Google Gemini API key
- A Supabase project
- Git
- A supported document to test the workflow

### 1. Create the Supabase database objects

Open the Supabase SQL Editor and run:

```text
supabase/setup.sql
```

The SQL enables pgvector if needed, creates the `n8n` table, and creates the `match_documents` retrieval function.

### 2. Configure n8n credentials

Configure the following credentials directly in n8n:

- Google Gemini API credential
- Supabase credential

Do not place API keys or database secrets in this repository.

### 3. Import the n8n workflow

Export the working workflow from n8n and place it at:

```text
workflows/rag-workflow.json
```

n8n supports downloading a workflow as JSON from the Editor UI and importing JSON files into another n8n instance.

### 4. Verify embedding dimensions

The ingestion and retrieval paths must use compatible embedding configuration.

Current project configuration:

```text
Embedding dimension: 3072
Vector column:       extensions.vector(3072)
```

### 5. Run

Start the workflow, upload a document, and ask questions about its contents.

## Example

A resume or technical document can be uploaded and queried with questions such as:

```text
What programming languages are mentioned?
What AI technologies are listed?
What projects are described?
What are the candidate's technical skills?
```

The AI Agent retrieves relevant chunks from Supabase before generating the answer.

## Repository Structure

```text
intelligent-document-qa-rag-n8n/
│
├── workflows/
│   ├── rag-workflow.json          # Add exported n8n workflow here
│   └── README.md
│
├── supabase/
│   └── setup.sql                  # Database + vector search function
│
├── docs/
│   └── architecture.md            # Detailed architecture
│
├── screenshots/
│   └── README.md                  # Add workflow screenshots here
│
├── .gitignore
├── LICENSE
└── README.md
```

## Security

Never commit:

- Google Gemini API keys
- Supabase service-role keys
- Database passwords
- n8n API keys
- OAuth tokens
- Decrypted n8n credential exports
- `.env` files containing secrets

Use n8n's credential manager for secrets.

## Limitations

- Retrieval quality depends on document parsing, chunking, embedding quality, and retrieval settings.
- The current database schema is configured for 3072-dimensional embeddings.
- Production deployments should add authentication, access control, monitoring, evaluation, and document lifecycle management.
- Large-scale vector indexing should be designed according to the selected pgvector data type and indexing strategy.

## Future Improvements

- Multi-user authentication
- Per-user document isolation
- Document update/delete support
- Source citations in answers
- Hybrid keyword + semantic search
- Reranking
- RAG evaluation metrics
- Document management UI
- Streaming responses
- Observability and tracing
- Production Docker deployment
- Automated workflow versioning to GitHub

## Resume Description

**AI-Powered Document Intelligence & Q&A System**  
*n8n | Google Gemini | Supabase | pgvector | RAG | AI Agents*

- Developed a RAG-based document Q&A system using n8n, Google Gemini, and Supabase Vector Store.
- Implemented 3072-dimensional embeddings and semantic vector search using PostgreSQL/pgvector.
- Integrated an AI Agent with Gemini to retrieve relevant document context and generate context-aware responses.
- Designed separate document ingestion and retrieval-generation workflows for an end-to-end LLM application.

## Author

**Rithubaran G**

Final-Year Computer Science Engineering Student

Interests: AI/LLM Applications, RAG, Python, Automation, AI Agents, and B2B Software Solutions.

## License

This project is released under the MIT License. See [LICENSE](LICENSE).
