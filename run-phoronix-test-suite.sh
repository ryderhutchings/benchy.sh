#!/bin/bash
set -euo pipefail

BASE="$HOME/Benchy"
RESULTS_FILE="$BASE/sbc-general-benchmark-results.txt"

mkdir -p "$BASE"

if [ ! -f "$BASE/sbc-bench.sh" ]; then
    echo "[!] sbc-bench.sh not found in $BASE"
    exit 1
fi

echo "[*] Running sbc-general-benchmark (PTS wrapper)..."

sudo bash "$BASE/sbc-bench.sh" -r 2>&1 | tee "$RESULTS_FILE"

echo ""
echo "[✓] Results saved to $RESULTS_FILE"
