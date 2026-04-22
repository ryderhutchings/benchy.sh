#!/bin/bash
set -euo pipefail

BASE="$HOME/Benchy"
RESULTS_FILE="$BASE/geekbench6-results.txt"
COMPLETED_DIR="$BASE/DONE"
GB_DIR=$(find "$BASE/geekbench6" -maxdepth 1 -type d -name "Geekbench-6.*" | head -n 1)
GB_BIN="$GB_DIR/geekbench6"
SCRIPT_PATH="$(realpath "$0")"



mkdir -p "$BASE" "$COMPLETED_DIR"

if [[ ! -x "$GB_BIN" ]]; then
    echo "[!] geekbench6 not found at $GB_BIN"
    echo "    Run setup.sh first."
    exit 1
fi

cd "$GB_DIR"

echo "[*] Running Geekbench 6 (run 1 of 2)..."
echo "[*] Date: $(date)"
echo ""

./geekbench6 2>&1 | tee -a "$RESULTS_FILE"
CLAIM1=$(grep -o 'https://browser.geekbench.com/v6/cpu/[0-9]*' "$RESULTS_FILE" | head -1)

echo ""
echo "[*] Running Geekbench 6 (run 2 of 2)..."
echo ""

./geekbench6 2>&1 | tee -a "$RESULTS_FILE"
CLAIM2=$(grep -o 'https://browser.geekbench.com/v6/cpu/[0-9]*' "$RESULTS_FILE" | tail -1)

echo ""
echo "================================"
echo "Run 1: ${CLAIM1:-not found}"
echo "Run 2: ${CLAIM2:-not found}"
echo "================================" | tee -a "$RESULTS_FILE"

echo "[✓] Results saved to $RESULTS_FILE"

mv "$SCRIPT_PATH" "$COMPLETED_DIR/"
echo "[✓] Moved run-geekbench6.sh to $COMPLETED_DIR/"
