#!/bin/bash
set -e

BASE="$HOME/Benchy"
RESULTS_FILE="$BASE/sbc-bench-results.txt"

mkdir -p "$BASE"

echo "[*] Running sbc-bench..."

sudo /bin/bash "$BASE/sbc-bench.sh" -r 2>&1 | tee "$RESULTS_FILE"

echo ""
echo "[*] Results saved to $RESULTS_FILE"
