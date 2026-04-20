#!/bin/bash
set -euo pipefail

BASE="$HOME/Benchy"
RESULTS_FILE="$BASE/vkmark-results.txt"

mkdir -p "$BASE"

if ! command -v vkmark >/dev/null 2>&1; then
    echo "[!] vkmark not found. Run setup.sh first."
    echo "    Note: vkmark may not be available on all distros/architectures."
    exit 1
fi

if [[ -z "${DISPLAY:-}" ]]; then
    echo "[!] No DISPLAY set. Trying :0..."
    export DISPLAY=:0
fi

exec > >(tee -a "$RESULTS_FILE") 2>&1

echo "[*] Running vkmark..."
echo "[*] Date: $(date)"
echo ""

DISPLAY=:0 vkmark

echo ""
echo "[✓] Results saved to $RESULTS_FILE"
