#!/bin/bash
set -e

REPO_DIR=~/top500-benchmark
RESULTS_FILE=~/Benchy/top500-results.txt

# Ensure pip and ansible are available
pip3 install ansible --break-system-packages 2>/dev/null || pip3 install ansible

cd "$REPO_DIR"

# Copy example config files if not already present
[ ! -f hosts.ini ] && cp example.hosts.ini hosts.ini
[ ! -f config.yml ] && cp example.config.yml config.yml

# Single node: make sure hosts.ini points to localhost only
cat > hosts.ini << 'EOF'
[cluster]
127.0.0.1

[cluster:vars]
ansible_user=root
ansible_connection=local
EOF

# Run benchmark (setup + benchmark only, skip SSH cluster config)
echo "Running top500 HPL benchmark (single node)..."
mkdir -p ~/Benchy

ansible-playbook main.yml --tags "setup,benchmark" 2>&1 | tee "$RESULTS_FILE"

echo ""
echo "Results saved to $RESULTS_FILE"
