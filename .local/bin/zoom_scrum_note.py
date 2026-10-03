#!/usr/bin/env python3
"""File today's Zoom AI Companion summary for the daily scrum as a Daily Scrum
note in the Obsidian vault.

Designed to run on your Mac via launchd (see com.mikefunk.zoom-scrum.plist).
It uses YOUR gws CLI auth (the login you set up yourself) -- nothing new is
granted to any third party, and Juno/Muse never touches your work Google
account. No new entries appear in Google's connected-apps list or Zoom's
installed apps.

The note is built from your Daily Scrum Meeting Template: {{date}} is filled
in and the "..." body placeholder is replaced with the summary text, exactly
as if you had pasted it yourself.

Usage:
    python3 zoom_scrum_note.py            # normal run
    python3 zoom_scrum_note.py --dry-run  # print what would happen, change nothing
"""

import base64
import datetime
import glob
import html
import json
import os
import re
import shutil
import subprocess
import sys
from html.parser import HTMLParser
from zoneinfo import ZoneInfo

# ------------------------------- config ------------------------------------
# Bootstrap mise: launchd runs with a minimal PATH, so add the mise shims
# directory (what `mise activate` puts on PATH) before resolving gws.
_mise_shims = os.path.expanduser("~/.local/share/mise/shims")
if os.path.isdir(_mise_shims) and _mise_shims not in os.environ.get("PATH", ""):
    os.environ["PATH"] = _mise_shims + os.pathsep + os.environ.get("PATH", "")

GWS_BIN = shutil.which("gws")
if GWS_BIN is None:
    # Last resort: ask mise directly where the binary lives.
    _mise = os.path.expanduser("~/.local/bin/mise")
    try:
        _r = subprocess.run([_mise, "which", "gws"],
                            capture_output=True, text=True, timeout=30)
        _p = _r.stdout.strip()
        if _r.returncode == 0 and _p and os.access(_p, os.X_OK):
            GWS_BIN = _p
    except OSError:
        pass
if GWS_BIN is None:
    raise SystemExit("gws not found: not on PATH and mise could not resolve it")
VAULT_DIR = os.path.expanduser("~/Notes")
TEMPLATE_PATH = os.path.join(VAULT_DIR, "Templates", "Daily Scrum Meeting Template.md")

# Zoom AI summary emails come from no-reply@zoom.us with a subject like
# "Meeting assets for Daily Scrum are ready!". Adjust if yours differ.
SEARCH_FROM = "no-reply@zoom.us"
SUBJECT_MUST_CONTAIN = "daily scrum"  # matched case-insensitively

TIMEZONE = "America/Los_Angeles"
# ---------------------------------------------------------------------------


def gws(*args):
    """Run a gws command and return parsed JSON."""
    result = subprocess.run(
        [GWS_BIN, *args, "--format", "json"],
        capture_output=True, text=True, timeout=60,
    )
    if result.returncode != 0:
        raise RuntimeError(f"gws failed: {result.stderr.strip() or result.stdout.strip()}")
    return json.loads(result.stdout or "{}")


def today():
    return datetime.datetime.now(ZoneInfo(TIMEZONE)).date()


def find_summary_message():
    """Return the Gmail message dict for today's scrum summary, or None."""
    query = f"from:{SEARCH_FROM} newer_than:2d"
    listing = gws("gmail", "users", "messages", "list",
                  "--params", json.dumps({"userId": "me", "q": query, "maxResults": 10}))
    for ref in listing.get("messages", []):
        msg = gws("gmail", "users", "messages", "get",
                  "--params", json.dumps({"userId": "me", "id": ref["id"], "format": "full"}))
        headers = {h["name"].lower(): h["value"]
                   for h in msg.get("payload", {}).get("headers", [])}
        subject = headers.get("subject", "")
        if SUBJECT_MUST_CONTAIN.lower() not in subject.lower():
            continue
        sent = datetime.datetime.fromtimestamp(
            int(msg["internalDate"]) / 1000, ZoneInfo(TIMEZONE)).date()
        if sent == today():
            return msg, subject
    return None, None


class _HtmlToText(HTMLParser):
    """Convert an HTML email body to readable plain text.

    Drops <style>/<script>/<head> content entirely and treats block-level
    elements as line breaks so the result reads like the rendered email.
    """

    BLOCK_TAGS = frozenset({
        "p", "div", "br", "li", "ul", "ol", "h1", "h2", "h3", "h4", "h5", "h6",
        "tr", "table", "thead", "tbody", "section", "article", "header",
        "footer", "blockquote", "hr", "pre",
    })
    SKIP_TAGS = frozenset({"style", "script", "head", "noscript"})

    def __init__(self):
        super().__init__()
        self.parts = []
        self._skip_depth = 0

    def handle_starttag(self, tag, attrs):
        if tag in self.SKIP_TAGS:
            self._skip_depth += 1
        elif not self._skip_depth:
            if tag in ("h1", "h2"):
                self.parts.append("\n## ")
            elif tag in ("h3", "h4", "h5", "h6"):
                self.parts.append("\n### ")
            elif tag in self.BLOCK_TAGS:
                self.parts.append("\n")

    def handle_endtag(self, tag):
        if tag in self.SKIP_TAGS:
            self._skip_depth = max(0, self._skip_depth - 1)
        elif not self._skip_depth and tag in self.BLOCK_TAGS:
            self.parts.append("\n")

    def handle_data(self, data):
        if not self._skip_depth:
            self.parts.append(data)

    def get_text(self):
        text = html.unescape("".join(self.parts))
        lines = [re.sub(r"[ \t\xa0]+", " ", ln).strip() for ln in text.splitlines()]
        cleaned, prev_blank = [], False
        for ln in lines:
            if ln:
                cleaned.append(ln)
                prev_blank = False
            elif not prev_blank:
                cleaned.append("")
                prev_blank = True
        return "\n".join(cleaned).strip()


def _decode_part(part):
    data = (part.get("body") or {}).get("data", "")
    if not data:
        return ""
    # Gmail uses base64url without padding
    data += "=" * (-len(data) % 4)
    return base64.urlsafe_b64decode(data).decode("utf-8", errors="replace")


# Trailing Zoom email boilerplate to drop from the note (matched
# case-insensitively, line by line, from the end of the summary).
_ZOOM_FOOTER_PATTERNS = (
    "unsubscribe",
    "this email was sent",
    "you are receiving",
    "zoom communications",
    "zoom.us",
    "privacy policy",
    "all rights reserved",
    "©",
)


def _strip_zoom_footer(text):
    lines = text.split("\n")
    while lines and any(pat in lines[-1].lower() for pat in _ZOOM_FOOTER_PATTERNS):
        lines.pop()
    stripped = "\n".join(lines).strip()
    return stripped or text


def extract_body(msg):
    """Prefer text/plain; fall back to text/html with tags stripped."""
    payload = msg.get("payload", {})
    parts = payload.get("parts", [payload])
    html_body = ""
    for part in parts:
        mime = part.get("mimeType", "")
        if mime == "text/plain":
            text = _decode_part(part).strip()
            if text:
                return _strip_zoom_footer(text)
        elif mime == "text/html" and not html_body:
            html_body = _decode_part(part)
        # recurse into multipart containers
        for sub in part.get("parts", []):
            if sub.get("mimeType") == "text/plain":
                text = _decode_part(sub).strip()
                if text:
                    return _strip_zoom_footer(text)
            elif sub.get("mimeType") == "text/html" and not html_body:
                html_body = _decode_part(sub)
    if html_body:
        converter = _HtmlToText()
        converter.feed(html_body)
        return _strip_zoom_footer(converter.get_text())
    return ""


def note_path_for(date):
    now = datetime.datetime.now(ZoneInfo(TIMEZONE))
    ampm = "am" if now.hour < 12 else "pm"
    hour12 = now.hour % 12 or 12
    stamp = f"{hour12}.{now.minute:02d}{ampm}"
    return os.path.join(VAULT_DIR, f"{date.isoformat()} {stamp} Daily Scrum.md")


def existing_note_today(date):
    matches = glob.glob(os.path.join(VAULT_DIR, f"{date.isoformat()}*Daily Scrum.md"))
    return matches[0] if matches else None


def build_note(date, summary_text):
    with open(TEMPLATE_PATH) as f:
        template = f.read()
    note = template.replace("{{date}}", date.isoformat())
    # The template's "..." line is where the pasted summary goes.
    note = re.sub(r"(?m)^\.\.\.\s*$", summary_text.strip(), note, count=1)
    return note


def main():
    dry_run = "--dry-run" in sys.argv
    date = today()

    already = existing_note_today(date)
    if already:
        print(f"Note already exists, nothing to do: {already}")
        return 0

    msg, subject = find_summary_message()
    if msg is None:
        print("No Zoom summary email for today's scrum found yet. Will try again next run.")
        return 0

    summary_text = extract_body(msg)
    if not summary_text:
        print(f"Found '{subject}' but could not extract a body. Giving up.")
        return 1

    path = note_path_for(date)
    if dry_run:
        print(f"[dry run] Would write {len(summary_text)} chars of summary to:\n  {path}")
        print(f"[dry run] From email subject: {subject}")
        return 0

    with open(path, "w") as f:
        f.write(build_note(date, summary_text))
    print(f"Wrote {path} ({len(summary_text)} chars from '{subject}')")
    return 0


if __name__ == "__main__":
    sys.exit(main())
