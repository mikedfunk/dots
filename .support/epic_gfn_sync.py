#!/usr/bin/env python3
"""Weekly Epic library -> GeForce NOW cross-check.

Runs on Mike's Mac via launchd (com.mikefunk.epic-gfn-sync), Mondays 09:45 PT.
Pulls the Epic library via legendary, re-downloads NVIDIA's GFN catalog,
cross-references, and rewrites the Markdown report in his Obsidian vault.

Stdlib only. No AI in the loop: one-time AI cost, ongoing script.
"""
import json
import os
import re
import shutil
import subprocess
import sys
import unicodedata
import urllib.request
from datetime import datetime
from pathlib import Path
from zoneinfo import ZoneInfo

HOME = Path.home()
DATA = HOME / ".local" / "share" / "epic-gfn-sync"
VAULT = HOME / "Notes"
NOTE = VAULT / "Epic GFN Sync.md"
CATALOG_URL = "https://static.nvidiagrid.net/supported-public-game-list/locales/gfnpc-en-US.json"
TIMEZONE = "America/Los_Angeles"

LIB = DATA / "epic-library.json"
LIB_PREV = DATA / "epic-library-prev.json"
CAT = DATA / "gfn-catalog.json"
SEEN = DATA / "first_seen.json"
PREV_STATUS = DATA / "prev_status.json"

# Pin legendary-gl 0.21.1 for reproducibility. It needs Python >=3.10;
# macOS /usr/bin/python3 is 3.9, so resolve_legendary() hunts for a newer
# Python rather than letting uvx fall back to an old legendary release.
# NOTE: the library size does NOT depend on the legendary version -- the
# famous "only 84 games" bug was list-games defaulting to --platform Mac
# on macOS (see pull_library). Always pass --platform explicitly.
LEGENDARY_PIN = "legendary-gl==0.21.1"
MIN_PYTHON = (3, 10)


def _bootstrap_path():
    # launchd runs with a minimal PATH; make the usual user bin dirs visible
    # (covers uv installed via the official installer, cargo, homebrew, mise).
    path = os.environ.get("PATH", "")
    for d in (
        HOME / ".local" / "bin",
        HOME / ".cargo" / "bin",
        Path("/opt/homebrew/bin"),
        Path("/usr/local/bin"),
        HOME / ".local" / "share" / "mise" / "shims",
    ):
        if d.is_dir() and str(d) not in path.split(os.pathsep):
            path = str(d) + os.pathsep + path
    os.environ["PATH"] = path


def _python_version(exe):
    try:
        r = subprocess.run(
            [exe, "-c", "import sys; print(sys.version_info[0], sys.version_info[1])"],
            capture_output=True, text=True, timeout=15)
        if r.returncode == 0:
            major, minor = r.stdout.split()
            return (int(major), int(minor))
    except Exception:
        pass
    return None


def _find_modern_python():
    """Newest Python >=3.10 on PATH or in known locations.

    legendary-gl 0.21.1 refuses anything older, and macOS ships 3.9 --
    so find a newer interpreter for uvx to use.
    """
    _bootstrap_path()
    candidates = []
    for name in ("python3.13", "python3.12", "python3.11", "python3.10", "python3"):
        p = shutil.which(name)
        if p and p not in candidates:
            candidates.append(p)
    for p in ("/opt/homebrew/bin/python3",
              "/usr/local/bin/python3",
              str(HOME / ".local" / "share" / "mise" / "shims" / "python3")):
        if p not in candidates and os.path.isfile(p) and os.access(p, os.X_OK):
            candidates.append(p)
    best = None
    for cand in candidates:
        v = _python_version(cand)
        if v and v >= MIN_PYTHON and (best is None or v > best[0]):
            best = (v, cand)
    return best[1] if best else None


def resolve_legendary():
    """Command prefix for legendary: PATH, then uvx, then python module."""
    found = shutil.which("legendary")
    if found:
        return [found]
    if shutil.which("uvx"):
        # --from is needed: the PyPI package is legendary-gl,
        # but the executable it provides is named legendary.
        py = _find_modern_python()
        if py:
            return ["uvx", "--python", py, "--from", LEGENDARY_PIN, "legendary"]
        # No local Python >=3.10: let uv fetch a managed 3.12
        # (ARM64 on Apple Silicon; avoids the Bad-CPU-type x86_64 install).
        return ["uvx", "--python", "3.12", "--from", LEGENDARY_PIN, "legendary"]
    return [sys.executable, "-m", "legendary"]


def pull_library():
    cmd = resolve_legendary() + ["-A", "30", "list-games",
                                 "--platform", "Windows", "--json"]
    try:
        r = subprocess.run(cmd, capture_output=True, text=True, timeout=900)
    except FileNotFoundError as e:
        raise RuntimeError(
            "legendary not found. Install uv (https://docs.astral.sh/uv/) "
            "and the script will run legendary via uvx automatically."
        ) from e
    if r.returncode != 0:
        raise RuntimeError(f"legendary list-games failed: {r.stderr.strip()[-500:]}")
    data = json.loads(r.stdout)
    if not data:
        raise RuntimeError("legendary returned an empty library; refusing to overwrite")
    if LIB.exists():
        # Guard against partial pulls (e.g. a platform mix-up that only
        # lists a slice of the library): a real library never shrinks like this.
        try:
            prev_n = len(json.loads(LIB.read_text(encoding="utf-8")))
        except Exception:
            prev_n = 0
        if prev_n and len(data) < prev_n * 0.5:
            raise RuntimeError(
                f"legendary returned only {len(data)} games vs {prev_n} last time; "
                "refusing to overwrite (partial pull?)")
        LIB_PREV.write_text(LIB.read_text())
    LIB.write_text(json.dumps(data, indent=1))
    return data


def fetch_catalog():
    try:
        req = urllib.request.Request(CATALOG_URL, headers={"User-Agent": "Mozilla/5.0"})
        with urllib.request.urlopen(req, timeout=60) as resp:
            data = json.loads(resp.read())
        if not data:
            raise ValueError("empty catalog")
        CAT.write_text(json.dumps(data))
        return data
    except Exception as e:
        if CAT.exists():
            print(f"catalog download failed ({e}); using cached copy", file=sys.stderr)
            return json.loads(CAT.read_text())
        raise


def norm(s):
    s = unicodedata.normalize("NFKD", s or "").lower()
    s = re.sub(r"[™®|]", " ", s)
    s = re.sub(r"['\u2019]", "", s)
    s = re.sub(r"[^a-z0-9 ]", " ", s)
    return re.sub(r"\s+", " ", s).strip()


ED = re.compile(
    r"\b(standard|deluxe|definitive|goty|game of the year|enhanced|remastered|"
    r"ultimate|premium|collectors?|complete|desktop|vr|edition|directors? cut|"
    r"final cut|platinum|legendary status|midnight|digital)\b"
)


def keys(t):
    return {norm(t), norm(ED.sub(" ", t))} - {""}


def crosscheck(lib, catalog):
    epic_cat = [e for e in catalog if (e.get("store") or "").lower() == "epic"]
    epic_idx, full_idx = {}, {}
    for e in epic_cat:
        for k in keys(e.get("title", "")):
            epic_idx.setdefault(k, []).append(e)
    for e in catalog:
        for k in keys(e.get("title", "")):
            full_idx.setdefault(k, []).append(e)

    def find(idx, title):
        seen = {}
        for k in keys(title):
            for e in idx.get(k, []):
                seen[e["title"]] = e
        return list(seen.values())

    titles = sorted({e.get("app_title", "") for e in lib} - {""})
    rows = []
    for t in titles:
        eh = find(epic_idx, t)
        if eh and all(e.get("status") == "AVAILABLE" for e in eh):
            e = eh[0]
            rows.append({
                "game": t, "status": "Yes",
                "gfn_title": e["title"] if e["title"] != t else "",
                "optimized": "Yes" if e.get("isFullyOptimized") else "No",
            })
        elif eh:
            e = eh[0]
            rows.append({
                "game": t, "status": f"GFN lists it ({e.get('status')})",
                "gfn_title": e["title"] if e["title"] != t else "",
                "optimized": "—",
            })
        else:
            gh = find(full_idx, t)
            if gh:
                rows.append({
                    "game": t, "status": "Steam-only",
                    "gfn_title": ", ".join(f"{e['title']} [{e.get('store')}]" for e in gh[:3]),
                    "optimized": "—",
                })
            else:
                rows.append({"game": t, "status": "No", "gfn_title": "", "optimized": "—"})
    return rows


def _esc(s):
    return s.replace("|", "\\|")


def write_report(rows, seen, new_games, newly_playable, prev_status, now):
    n_yes = sum(1 for r in rows if r["status"] == "Yes")
    n_steam = sum(1 for r in rows if r["status"] == "Steam-only")
    n_opt = sum(1 for r in rows if r["status"] == "Yes" and r["optimized"] == "Yes")

    order = {"Yes": 0, "Steam-only": 1}
    rows = sorted(rows, key=lambda r: (order.get(r["status"], 2), r["game"].lower()))
    by_game = {r["game"]: r for r in rows}

    L = []
    A = L.append
    A("# Epic Games on GeForce NOW")
    A("")
    stamp = (f"{now.month}/{now.day}/{now.year} "
             f"{now.hour % 12 or 12}:{now.minute:02d} {'am' if now.hour < 12 else 'pm'} PT")
    A(f"Last synced: {stamp} · {len(rows)} games owned")
    A("")
    A("## Summary")
    A("")
    A(f"- Playable on GFN via Epic: **{n_yes}** ({n_opt} fully optimized)")
    A(f"- On GFN via Steam version only: **{n_steam}**")
    A(f"- Not on GeForce NOW: **{len(rows) - n_yes - n_steam}**")
    A("")
    A("## Newly playable on GeForce NOW")
    A("")
    if newly_playable:
        for g in newly_playable:
            A(f"- **{_esc(g)}** (was: {prev_status[g]})")
    else:
        A("Nothing newly playable since last sync.")
    A("")
    A("## New in your Epic library")
    A("")
    if new_games:
        for g in new_games:
            r = by_game.get(g, {"status": "?", "game": g})
            A(f"- **{_esc(g)}** [{r['status']}] · added {seen[g]}")
    else:
        A("No new games since last sync.")
    A("")
    A("## All games")
    A("")
    A("| Game | GFN | GFN title | Optimized | Added |")
    A("|---|---|---|---|---|")
    for r in rows:
        A(f"| {_esc(r['game'])} | {r['status']} | {_esc(r['gfn_title'])} | "
          f"{r['optimized']} | {seen.get(r['game'], '')} |")
    A("")
    NOTE.write_text("\n".join(L))


def main():
    _bootstrap_path()
    DATA.mkdir(parents=True, exist_ok=True)
    now = datetime.now(ZoneInfo(TIMEZONE))
    today = now.date().isoformat()

    lib = pull_library()
    catalog = fetch_catalog()
    rows = crosscheck(lib, catalog)

    seen = json.loads(SEEN.read_text()) if SEEN.exists() else {}
    new_games = sorted(r["game"] for r in rows if r["game"] not in seen)
    for g in new_games:
        seen[g] = today
    SEEN.write_text(json.dumps(seen, indent=1, sort_keys=True))

    prev_status = json.loads(PREV_STATUS.read_text()) if PREV_STATUS.exists() else {}
    prev_games = set(prev_status)
    newly_playable = sorted(
        r["game"] for r in rows
        if r["game"] in prev_games
        and r["status"] == "Yes"
        and prev_status[r["game"]] != "Yes"
    )
    PREV_STATUS.write_text(
        json.dumps({r["game"]: r["status"] for r in rows}, indent=1, sort_keys=True))

    write_report(rows, seen, new_games, newly_playable, prev_status, now)

    n_yes = sum(1 for r in rows if r["status"] == "Yes")
    n_steam = sum(1 for r in rows if r["status"] == "Steam-only")
    print(f"synced {len(rows)} games ({n_yes} GFN-playable, {n_steam} Steam-only)")
    if newly_playable:
        print("NEWLY PLAYABLE ON GFN:")
        for g in newly_playable:
            print(f"  + {g} (was: {prev_status[g]})")
    if new_games:
        print("NEW GAMES:")
        by_game = {r["game"]: r for r in rows}
        for g in sorted(new_games):
            print(f"  + {g} [{by_game[g]['status']}]")
    if not newly_playable and not new_games:
        print("no changes since last sync")


if __name__ == "__main__":
    try:
        main()
    except Exception as e:
        print(f"SYNC FAILED: {e}", file=sys.stderr)
        sys.exit(1)
