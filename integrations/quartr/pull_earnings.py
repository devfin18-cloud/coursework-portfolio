"""Pull the latest earnings-call transcripts for a ticker from Quartr.

Usage:
    python pull_earnings.py AAPL            # list latest events + transcripts
    python pull_earnings.py AAPL --download # also download transcript files

Output files land in ./downloads/<TICKER>/.
"""

import sys
from pathlib import Path

from quartr_client import QuartrClient


def main() -> None:
    if len(sys.argv) < 2:
        sys.exit(__doc__)
    ticker = sys.argv[1].upper()
    download = "--download" in sys.argv

    q = QuartrClient()

    company = q.company(ticker)
    if not company:
        sys.exit(f"No Quartr company found for ticker {ticker}")
    print(f"{company['name']} (Quartr id {company['id']}, CIK {company.get('cik')})")

    print("\nLatest transcripts:")
    transcripts = q.transcripts(ticker, limit=5)
    if not transcripts:
        print("  none available on this plan")
    for t in transcripts:
        event = t.get("event") or {}
        title = event.get("title", f"event {t.get('eventId')}")
        print(f"  [{t['id']}] {title}  ({t.get('createdAt', '')[:10]})")
        if download and t.get("fileUrl"):
            dest_dir = Path("downloads") / ticker
            dest_dir.mkdir(parents=True, exist_ok=True)
            dest = dest_dir / f"transcript_{t['id']}.pdf"
            q.download(t["fileUrl"], dest)
            print(f"        saved -> {dest}")


if __name__ == "__main__":
    main()
