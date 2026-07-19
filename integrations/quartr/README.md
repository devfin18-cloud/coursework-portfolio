# Quartr API integration

Pulls earnings-call transcripts, event summaries, and company data from the
[Quartr Public API](https://quartr.com/docs/) (v3) for use in earnings reviews
and financial models.

## Setup (one-time)

1. Get an API key: sign in at [portal.quartr.dev](https://portal.quartr.dev) →
   **API keys** → **New API Key**. (Quartr is a commercial API — key access
   depends on your plan.)
2. Create a file named `.env` in this folder containing exactly one line:

   ```
   QUARTR_API_KEY=paste_your_key_here
   ```

   The `.env` file is git-ignored — your key never gets committed.

## Usage

```bash
python pull_earnings.py AAPL             # list the 5 latest transcripts
python pull_earnings.py AAPL --download  # also save the transcript PDFs
```

Or from Python / a notebook:

```python
from quartr_client import QuartrClient
q = QuartrClient()
q.company("AAPL")           # company record (id, CIK, ISINs)
q.events("AAPL")            # latest events (earnings calls etc.)
q.transcripts("AAPL")       # latest transcript documents
```

## Endpoints used

| Endpoint | Purpose |
|---|---|
| `GET /companies?tickers=` | resolve a ticker to a Quartr company |
| `GET /events?tickers=` | earnings calls and other events |
| `GET /events/{id}/summary` | AI summary of an event |
| `GET /documents/transcripts?tickers=` | transcript documents |

Auth is a `x-api-key` header; default rate limit 50 req/s.
