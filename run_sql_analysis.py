"""Run the SQL analysis on the cleaned NHS A&E data.

Loads ae_clean_all_years.csv into an in-memory SQLite database, runs every
file in sql/ in order, prints each result and saves it to sql_outputs/.

Usage:
    python run_sql_analysis.py

Uses only the Python standard library.
"""

import csv
import re
import sqlite3
from pathlib import Path

ROOT = Path(__file__).parent
SQL_DIR = ROOT / "sql"
OUT_DIR = ROOT / "sql_outputs"
DATA = ROOT / "ae_clean_all_years.csv"


def load_data(con: sqlite3.Connection) -> int:
    con.executescript((SQL_DIR / "01_schema.sql").read_text())
    with DATA.open(newline="", encoding="utf-8") as fh:
        rows = list(csv.DictReader(fh))
    cols = list(rows[0].keys())
    con.executemany(
        f"INSERT INTO ae_raw ({', '.join(cols)}) VALUES ({', '.join('?' * len(cols))})",
        [tuple(r[c] for c in cols) for r in rows],
    )
    return len(rows)


def split_statements(sql: str) -> list[str]:
    """Split a file into statements, keeping only those with real SQL."""
    out, buf = [], []
    for line in sql.splitlines():
        buf.append(line)
        if sqlite3.complete_statement("\n".join(buf)):
            stmt = "\n".join(buf).strip()
            if any(ln.strip() and not ln.strip().startswith("--") for ln in stmt.splitlines()):
                out.append(stmt)
            buf = []
    return out


def output_name(path: Path, stmt: str, n: int) -> str:
    """Name a result file after the statement's numbered comment, if it has one."""
    m = re.search(r"^--\s*\d+\.\s*(.+)$", stmt, re.MULTILINE)
    if not m:
        return path.stem if n == 1 else f"{path.stem}_{n}"
    words = re.sub(r"[^a-z0-9 ]", "", m.group(1).lower()).split()[:5]
    return f"{path.stem}_{n}_{'_'.join(words)}"


def print_table(headers: list[str], rows: list[tuple]) -> None:
    if not rows:
        print("  (no rows)\n")
        return
    widths = [max(len(str(h)), *(len(str(r[i])) for r in rows)) for i, h in enumerate(headers)]
    line = "  " + "  ".join(str(h).ljust(w) for h, w in zip(headers, widths))
    print(line)
    print("  " + "  ".join("-" * w for w in widths))
    for r in rows:
        print("  " + "  ".join(str(v).ljust(w) for v, w in zip(r, widths)))
    print()


def main() -> None:
    OUT_DIR.mkdir(exist_ok=True)
    con = sqlite3.connect(":memory:")
    print(f"Loaded {load_data(con)} rows from {DATA.name}\n")

    for path in sorted(SQL_DIR.glob("*.sql")):
        if path.name == "01_schema.sql":
            continue
        print("=" * 70)
        print(path.name)
        print("=" * 70)
        for n, stmt in enumerate(split_statements(path.read_text()), 1):
            cur = con.execute(stmt)
            if cur.description is None:  # CREATE VIEW etc.
                continue
            headers = [d[0] for d in cur.description]
            title = re.search(r"^--\s*\d+\.\s*(.+)$", stmt, re.MULTILINE)
            if title:
                print(f"  {title.group(1)}")
            rows = cur.fetchall()
            print_table(headers, rows)
            name = output_name(path, stmt, n)
            with (OUT_DIR / f"{name}.csv").open("w", newline="", encoding="utf-8") as fh:
                csv.writer(fh).writerows([headers, *rows])
    print(f"Results saved to {OUT_DIR.name}/")


if __name__ == "__main__":
    main()
