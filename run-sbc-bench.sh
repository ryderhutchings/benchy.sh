#!/bin/bash
set -e

RESULTS_FILE=~/Benchy/sbc-bench-results.txt

mkdir -p ~/Benchy

echo "Running sbc-bench..."

sudo /bin/bash ~/Benchy/sbc-bench.sh -r 2>&1 | tee "$RESULTS_FILE"

echo ""
echo "Results saved to $RESULTS_FILE"
