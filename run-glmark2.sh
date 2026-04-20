#!/bin/bash
set -euo pipefail

BASE="$HOME/Benchy"
RESULTS_FILE="$BASE/glmark2-results.txt"

COMPLETED_DIR="$BASE/DONE"
mkdir -p "$COMPLETED_DIR"

mkdir -p "$BASE"

if ! command -v glmark2-es2 >/dev/null 2>&1; then
    echo "[!] glmark2-es2 not found. Run setup.sh first."
    exit 1
fi

if [[ -z "${DISPLAY:-}" ]]; then
    echo "[!] No DISPLAY set. Trying :0..."
    export DISPLAY=:0
fi

exec > >(tee -a "$RESULTS_FILE") 2>&1

echo "[*] Running glmark2-es2..."
echo "[*] Date: $(date)"
echo ""

DISPLAY=:0 glmark2-es2

echo ""
echo "[✓] Results saved to $RESULTS_FILE"

mv "$(realpath "$0")" "$COMPLETED_DIR/"
