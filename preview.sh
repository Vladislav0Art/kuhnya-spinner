#!/usr/bin/env bash
# Прокручивает случайные фразы из текущего набора так, как их покажет спиннер.
#   ./preview.sh [сколько]
set -euo pipefail
SETTINGS="${CLAUDE_SETTINGS:-$HOME/.claude/settings.json}"
python3 - "$SETTINGS" "${1:-8}" "$(dirname "${BASH_SOURCE[0]}")" <<'PY'
import json, pathlib, random, sys, time
sv = json.load(open(sys.argv[1])).get("spinnerVerbs")
if not sv:
    sys.exit("spinnerVerbs не задан — сначала ./apply.sh")
n = min(int(sys.argv[2]), len(sv["verbs"]))
print(f'mode={sv["mode"]}, фраз: {len(sv["verbs"])}\n')
eps = {}
for f in sorted(pathlib.Path(sys.argv[3]).glob("quotes/*.json")):
    for item in json.loads(f.read_text(encoding="utf-8"))["verbs"]:
        if isinstance(item, dict) and item.get("ep"):
            eps[item["text"]] = item["ep"]

for v in random.sample(sv["verbs"], n):
    ep = f'  \033[2m[{eps[v]}]\033[0m' if v in eps else ""
    print(f"  \033[38;5;110m✳\033[0m {v}… \033[2m(esc to interrupt)\033[0m{ep}")
    time.sleep(1.2)
PY
