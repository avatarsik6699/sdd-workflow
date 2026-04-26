#!/usr/bin/env bash
set -euo pipefail

payload="$(cat || true)"

command_text="$(python3 - <<'PY' "$payload"
import json
import sys

raw = sys.argv[1] if len(sys.argv) > 1 else ""
cmd = ""
if raw:
    try:
        data = json.loads(raw)
        if isinstance(data, dict):
            cmd = (
                data.get("tool_input", {}).get("command")
                or data.get("command")
                or ""
            )
    except Exception:
        cmd = ""
print(cmd)
PY
)"

if printf '%s' "$command_text" | grep -qiE '(DROP TABLE|DROP DATABASE|DELETE FROM [a-zA-Z_][a-zA-Z0-9_]* WHERE 1|TRUNCATE)'; then
  echo "Dangerous DB command blocked" >&2
  exit 2
fi
