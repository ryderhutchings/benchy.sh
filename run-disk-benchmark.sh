#!/bin/bash
set -e

RESULTS_FILE=~/benchmarks/disk-results.txt

mkdir -p ~/benchmarks

echo "Running disk benchmark..."

sudo MOUNT_PATH=/ TEST_SIZE=1g ~/benchmarks/disk-benchmark.sh 2>&1 | tee "$RESULTS_FILE"

echo ""
echo "Results saved to $RESULTS_FILE"