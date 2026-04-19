#!/bin/bash
set -e

REPO_DIR=~/ai-benchmarks
RESULTS_FILE=~/benchmarks/ai-results.txt

cd "$REPO_DIR"

echo "Running AI / LLM inference benchmarks..."
mkdir -p ~/benchmarks

declare -a models=("llama3.2:3b" "llama3.1:8b" "llama2:13b")

for model in "${models[@]}"; do
    echo ""
    echo "Benchmarking $model..."
    ./obench.sh -m "$model" -c 3 --markdown 2>&1 | tee -a "$RESULTS_FILE"
done

echo ""
echo "Results saved to $RESULTS_FILE"