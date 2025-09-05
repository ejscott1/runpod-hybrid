#!/usr/bin/env bash
set -euo pipefail
export COMFY_ROOT=${COMFY_ROOT:-/opt/ComfyUI}
export ROOT=${ROOT:-/workspace}

/link-models.sh || true
cd "$COMFY_ROOT"

exec python main.py ${COMFY_ARGS:-"--listen 0.0.0.0 --port 8188"}
