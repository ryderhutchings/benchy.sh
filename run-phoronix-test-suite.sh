#!/bin/bash
set -euo pipefail

BASE="$HOME/Benchy"
PTS_DIR="$BASE/phoronix-test-suite"
PTS_BIN="$PTS_DIR/phoronix-test-suite"
RESULTS_FILE="$BASE/pts-results.txt"

mkdir -p "$BASE"

if [[ ! -x "$PTS_BIN" ]]; then
    echo "[!] Phoronix Test Suite not found at $PTS_BIN"
    echo "    Run setup.sh first."
    exit 1
fi

LOG="$RESULTS_FILE"
exec > >(tee -a "$LOG") 2>&1

echo "[*] Running PTS benchmarks..."
cd "$PTS_DIR"

"$PTS_BIN" batch-run pts/encode-mp3
"$PTS_BIN" batch-run pts/phpbench
echo "1" | "$PTS_BIN" batch-run pts/x264
echo "1" | "$PTS_BIN" batch-run pts/build-linux-kernel

echo ""
echo "[✓] Results saved to $RESULTS_FILE"
