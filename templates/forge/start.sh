#!/usr/bin/env bash
set -euo pipefail
export A1111_DATA=${A1111_DATA:-/opt/webui}
export ROOT=${ROOT:-/workspace}
/link-models.sh || true
cd "$A1111_DATA"
. venv/bin/activate
exec bash webui.sh ${WEBUI_ARGS:-"--listen --api"}
