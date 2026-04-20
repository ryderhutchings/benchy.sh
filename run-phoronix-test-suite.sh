#!/bin/bash
set -euo pipefail

BASE="$HOME/Benchy"
PTS_DIR="$BASE/phoronix-test-suite"
PTS_BIN="$PTS_DIR/phoronix-test-suite"

RESULTS_FILE="$BASE/pts-results.txt"

mkdir -p "$BASE"

LOG="$RESULTS_FILE"
exec > >(tee -a "$LOG") 2>&1

echo "[*] Running PTS benchmarks..."

cd "$PTS_DIR"

# Ensure PTS runs from correct directory
export PTS_CORE_PATH="$PTS_DIR"

./phoronix-test-suite batch-run pts/encode-mp3
./phoronix-test-suite batch-run pts/phpbench

echo "1" | ./phoronix-test-suite batch-run pts/x264
echo "1" | ./phoronix-test-suite batch-run pts/build-linux-kernel

echo ""
echo "[✓] Results saved to $RESULTS_FILE"
