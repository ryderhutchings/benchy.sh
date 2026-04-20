#!/bin/bash
set -e

BASE="$HOME/Benchy"
REPO_DIR="$BASE/top500-benchmark"
RESULTS_FILE="$BASE/top500-results.txt"

mkdir -p "$BASE"

# Ensure pip and ansible are available
pip3 install ansible --break-system-packages 2>/dev/null || pip3 install ansible

cd "$REPO_DIR"

# Copy example config files if not already present
[ ! -f hosts.ini ] && cp example.hosts.ini hosts.ini
[ ! -f config.yml ] && cp example.config.yml config.yml

# Single node config
cat > hosts.ini << 'EOF'
[cluster]
127.0.0.1

[cluster:vars]
ansible_user=root
ansible_connection=local
EOF

echo "[*] Running top500 HPL benchmark (single node)..."

sudo ansible-playbook main.yml --tags "setup,benchmark" -K | tee "$RESULTS_FILE"

echo ""
echo "[*] Results saved to $RESULTS_FILE"
