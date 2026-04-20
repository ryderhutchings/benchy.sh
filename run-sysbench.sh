#!/bin/bash
set -euo pipefail

BASE="$HOME/Benchy"
RESULTS_FILE="$BASE/sysbench-results.txt"
COMPLETED_DIR="$BASE/DONE"

mkdir -p "$BASE" "$COMPLETED_DIR"

if ! command -v sysbench >/dev/null 2>&1; then
    echo "[!] sysbench not found. Installing..."
    sudo apt install -y sysbench
fi

THREADS=$(nproc)

exec > >(tee -a "$RESULTS_FILE") 2>&1

echo "[*] Running sysbench CPU benchmark..."
echo "[*] Date: $(date)"
echo "[*] Threads: $THREADS"
echo ""

sysbench cpu --cpu-max-prime=20000 --threads=$THREADS run

echo ""
echo "[✓] Results saved to $RESULTS_FILE"

mv "$(realpath "$0")" "$COMPLETED_DIR/"
echo "[✓] Moved run-sysbench.sh to $COMPLETED_DIR/"
