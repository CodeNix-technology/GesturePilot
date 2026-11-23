#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

# Dependencies were installed locally with:
#   pip3 install --target .deps -r requirements.txt
export PYTHONPATH="$PWD/.deps${PYTHONPATH:+:$PYTHONPATH}"

exec python3 combined_controller_clean.py
