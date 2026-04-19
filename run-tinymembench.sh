#!/bin/bash
set -e

REPO_DIR=~/tinymembench
RESULTS_FILE=~/benchmarks/memory-results.txt

cd "$REPO_DIR"

echo "Running tinymembench memory benchmark..."
mkdir -p ~/benchmarks

./tinymembench 2>&1 | tee "$RESULTS_FILE"

echo ""
echo "Results saved to $RESULTS_FILE"