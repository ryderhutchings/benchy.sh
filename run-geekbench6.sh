#!/bin/bash
set -euo pipefail

BASE="$HOME/Benchy"
RESULTS_FILE="$BASE/geekbench6-results.txt"
COMPLETED_DIR="$BASE/DONE"

mkdir -p "$BASE" "$COMPLETED_DIR"

if ! command -v geekbench6 >/dev/null 2>&1; then
    echo "[!] geekbench6 not found. Run setup.sh first."
    exit 1
fi

exec > >(tee -a "$RESULTS_FILE") 2>&1

echo "[*] Running Geekbench 6 (run 1 of 2)..."
echo "[*] Date: $(date)"
echo ""

OUTPUT1=$(geekbench6 2>&1)
echo "$OUTPUT1"
CLAIM1=$(echo "$OUTPUT1" | grep -o 'https://browser.geekbench.com/v6/cpu/[0-9]*' | head -1)

echo ""
echo "[*] Running Geekbench 6 (run 2 of 2)..."
echo ""

OUTPUT2=$(geekbench6 2>&1)
echo "$OUTPUT2"
CLAIM2=$(echo "$OUTPUT2" | grep -o 'https://browser.geekbench.com/v6/cpu/[0-9]*' | head -1)

echo ""
echo "================================"
echo "Run 1: ${CLAIM1:-not found}"
echo "Run 2: ${CLAIM2:-not found}"
echo "================================"
echo ""
echo "[✓] Results saved to $RESULTS_FILE"

mv "$(realpath "$0")" "$COMPLETED_DIR/"
echo "[✓] Moved run-geekbench6.sh to $COMPLETED_DIR/"
