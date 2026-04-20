#!/bin/bash
set -euo pipefail

BASE="$HOME/Benchy"
RESULTS_FILE="$BASE/disk-results.txt"

COMPLETED_DIR="$BASE/DONE"
mkdir -p "$COMPLETED_DIR"

mkdir -p "$BASE"

echo "[*] Running disk benchmark..."

sudo MOUNT_PATH=/ TEST_SIZE=1g "$BASE/disk-benchmark.sh" 2>&1 | tee "$RESULTS_FILE"

echo "[✓] Results saved to $RESULTS_FILE"

mv "$(realpath "$0")" "$COMPLETED_DIR/"
