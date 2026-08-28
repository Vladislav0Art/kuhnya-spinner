#!/usr/bin/env bash
# Ставит спиннер-фразы из «Кухни» в настройки Claude Code.
#
#   ./apply.sh                  — набор max, режим replace (по умолчанию)
#   ./apply.sh shef             — набор шефа Баринова
#   ./apply.sh max,shef append — вперемешку с дефолтными глаголами
#   ./apply.sh --show           — показать, что сейчас стоит
#   ./apply.sh --restore        — откатить на последний бэкап
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SETTINGS="${CLAUDE_SETTINGS:-$HOME/.claude/settings.json}"

case "${1:-}" in
  --show)
    python3 - "$SETTINGS" <<'PY'
import json, sys
try:
    sv = json.load(open(sys.argv[1])).get("spinnerVerbs")
except FileNotFoundError:
    sv = None
if not sv:
    print("spinnerVerbs не задан — используются дефолтные глаголы Claude Code.")
else:
    print(f'mode: {sv["mode"]}, фраз: {len(sv["verbs"])}')
    for v in sv["verbs"][:5]:
        print(f"  {v}…")
    if len(sv["verbs"]) > 5:
        print(f"  … и ещё {len(sv['verbs']) - 5}")
PY
    exit 0 ;;
  --restore)
    latest="$(ls -1t "$SETTINGS".bak.* 2>/dev/null | head -1 || true)"
    [ -n "$latest" ] || { echo "Бэкапов нет."; exit 1; }
    cp "$latest" "$SETTINGS"
    echo "Восстановлено из $latest"
    exit 0 ;;
esac

SETS="${1:-max}"
MODE="${2:-replace}"
[ "$MODE" = "replace" ] || [ "$MODE" = "append" ] || { echo "mode: replace | append"; exit 1; }

cp "$SETTINGS" "$SETTINGS.bak.$(date +%Y%m%d-%H%M%S)"

python3 - "$SETTINGS" "$DIR/quotes" "$SETS" "$MODE" <<'PY'
import json, sys, pathlib

settings_path, quotes_dir, sets, mode = sys.argv[1:5]

verbs, seen = [], set()
for name in sets.split(","):
    f = pathlib.Path(quotes_dir) / f"{name.strip()}.json"
    if not f.exists():
        sys.exit(f"Нет такого набора: {f}")
    for item in json.loads(f.read_text(encoding="utf-8"))["verbs"]:
        v = item["text"] if isinstance(item, dict) else item
        if v not in seen:
            seen.add(v)
            verbs.append(v)

settings = json.loads(pathlib.Path(settings_path).read_text(encoding="utf-8"))
settings["spinnerVerbs"] = {"mode": mode, "verbs": verbs}
pathlib.Path(settings_path).write_text(
    json.dumps(settings, ensure_ascii=False, indent=2) + "\n", encoding="utf-8"
)
print(f"Поставлено {len(verbs)} фраз ({sets}, mode={mode}) → {settings_path}")
PY
