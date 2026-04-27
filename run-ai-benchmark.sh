#!/bin/bash
set -euo pipefail

REPO_DIR="$HOME/Benchy/ai-benchmarks"
RESULTS_FILE="$HOME/Benchy/ai-results.txt"

COMPLETED_DIR="$HOME/Benchy/DONE"
mkdir -p "$COMPLETED_DIR"

mkdir -p "$HOME/Benchy"

if [ ! -d "$REPO_DIR" ]; then
    echo "[!] ai-benchmarks not found at $REPO_DIR"
    exit 1
fi

cd "$REPO_DIR"

echo "[*] Running AI / LLM inference benchmarks..."

models=("tinyllama:1.1b" "deepseek-r1:1.5b" "llama3.2:3b")

for model in "${models[@]}"; do
    echo ""
    echo "[*] Benchmarking $model..."

    if [ -x "./obench.sh" ]; then
        ./obench.sh -m "$model" -c 3 --markdown 2>&1 | tee -a "$RESULTS_FILE"
    else
        echo "[!] obench.sh not found or not executable"
        exit 1
    fi
done

echo ""
echo "[✓] Results saved to $RESULTS_FILE"

mv "$(realpath "$0")" "$COMPLETED_DIR/"
