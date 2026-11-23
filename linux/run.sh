#!/usr/bin/env bash
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$HERE/.." && pwd)"
cd "$HERE"

# Prefer a virtual environment inside this folder if one exists.
if [ -x "$HERE/.venv/bin/python" ]; then
    PY="$HERE/.venv/bin/python"
else
    PY="python3"
fi

# This repo can also be run with dependencies in the repo-root .deps folder
if [ -d "$ROOT/.deps" ]; then
    export PYTHONPATH="$ROOT/.deps${PYTHONPATH:+:$PYTHONPATH}"
fi

exec "$PY" GesturePilot_Linux.py
