"""Minimal Quartr Public API (v3) client.

Auth: set QUARTR_API_KEY in the environment or in a .env file next to this
module (KEY=value lines). Get a key at https://portal.quartr.dev -> API keys.

Docs: https://quartr.com/docs/  ·  Base URL: https://api.quartr.com/public/v3
"""

import os
from pathlib import Path

import requests

BASE_URL = "https://api.quartr.com/public/v3"


def _load_key() -> str:
    key = os.environ.get("QUARTR_API_KEY")
    if not key:
        env_file = Path(__file__).parent / ".env"
        if env_file.exists():
            for line in env_file.read_text().splitlines():
                if line.startswith("QUARTR_API_KEY="):
                    key = line.split("=", 1)[1].strip().strip('"')
    if not key:
        raise RuntimeError(
            "No Quartr API key found. Create one at https://portal.quartr.dev, "
            "then either `export QUARTR_API_KEY=...` or put QUARTR_API_KEY=... "
            f"in {Path(__file__).parent / '.env'}"
        )
    return key


class QuartrClient:
    def __init__(self, api_key: str | None = None):
        self.session = requests.Session()
        self.session.headers["x-api-key"] = api_key or _load_key()

    def _get(self, path: str, **params) -> dict:
        r = self.session.get(f"{BASE_URL}{path}", params=params, timeout=30)
        if r.status_code == 403:
            raise RuntimeError(
                "403 Forbidden - your key is invalid or your plan lacks this dataset."
            )
        r.raise_for_status()
        return r.json()

    # -- companies ---------------------------------------------------------
    def company(self, ticker: str) -> dict | None:
        data = self._get("/companies", tickers=ticker, limit=1)["data"]
        return data[0] if data else None

    # -- events (earnings calls, capital-market days, ...) -----------------
    def events(self, ticker: str, limit: int = 10) -> list[dict]:
        return self._get(
            "/events", tickers=ticker, limit=limit, direction="desc"
        )["data"]

    def event_summary(self, event_id: int) -> dict:
        return self._get(f"/events/{event_id}/summary")

    # -- transcripts -------------------------------------------------------
    def transcripts(self, ticker: str, limit: int = 10) -> list[dict]:
        return self._get(
            "/documents/transcripts",
            tickers=ticker, limit=limit, direction="desc", expand="event",
        )["data"]

    def download(self, file_url: str, dest: Path) -> Path:
        r = self.session.get(file_url, timeout=60)
        r.raise_for_status()
        dest.write_bytes(r.content)
        return dest
