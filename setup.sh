#!/bin/bash
#
# Based on Jeff Geerling's sbc-reviews workflow + custom extensions
# by Ryder Hutchings: https://github.com/ryderhutchings
#

set -euo pipefail

BASE="$HOME/Benchy"
mkdir -p "$BASE"
echo "[*] Benchy directory ready at $BASE"

# APT packages
sudo apt update
sudo apt install -y \
    hwloc \
    glmark2-es2 \
    stress-ng \
    iperf3 \
    git \
    wget \
    curl \
    build-essential \
    fastfetch \
    screenfetch \
    gnuplot \
    stress-ng \
    nuttcp

sudo apt install -y vkmark || echo "[!] vkmark not available via apt"

# Ollama
# Ollama
if command -v ollama >/dev/null 2>&1; then
    echo "[*] Ollama OK"
else
    echo "[*] Installing Ollama..."
    curl -fsSL https://ollama.com/install.sh | sh
fi

sudo systemctl start ollama

echo "[*] Waiting for Ollama API..."
until curl -s http://127.0.0.1:11434 > /dev/null; do
    sleep 1
done

ollama pull tinyllama:1.1b
ollama pull deepseek-r1:1.5b
ollama pull llama3.2:3b

[ ! -d "$BASE/top500-benchmark" ] && git clone https://github.com/geerlingguy/top500-benchmark.git "$BASE/top500-benchmark"
[ ! -d "$BASE/ai-benchmarks" ] && git clone https://github.com/geerlingguy/ai-benchmarks.git "$BASE/ai-benchmarks"
[ ! -d "$BASE/tinymembench" ] && git clone https://github.com/rojaster/tinymembench.git "$BASE/tinymembench"
[ ! -d "$BASE/sbc-general-benchmark" ] && git clone https://gist.github.com/bef7542d2d392ae10acaad34fa38fcfe.git "$BASE/sbc-general-benchmark"

echo "[*] PTS ready in $BASE"

cd "$BASE/tinymembench"
make || true
cd "$HOME"

# c2clat
[ ! -d "$BASE/c2clat" ] && git clone https://github.com/rigtorp/c2clat.git "$BASE/c2clat"

g++ -O2 "$BASE/c2clat/c2clat.cpp" -o "$BASE/c2clat/c2clat" || true

wget -q -O "$BASE/disk-benchmark.sh" https://raw.githubusercontent.com/geerlingguy/pi-cluster/master/benchmarks/disk-benchmark.sh
wget -q -O "$BASE/sbc-bench.sh" https://raw.githubusercontent.com/ThomasKaiser/sbc-bench/master/sbc-bench.sh
chmod +x "$BASE/disk-benchmark.sh" "$BASE/sbc-bench.sh"

# Geekbench
mkdir -p "$BASE/geekbench6"
ARCH=$(uname -m)

if [[ "$ARCH" == "aarch64" ]]; then
    GB_URL="https://cdn.geekbench.com/Geekbench-6.4.0-LinuxARMPreview.tar.gz"
    GB_DIR="Geekbench-6.4.0-LinuxARMPreview"
elif [[ "$ARCH" == "x86_64" ]]; then
    GB_URL="https://cdn.geekbench.com/Geekbench-6.7.0-Linux.tar.gz"
    GB_DIR="Geekbench-6.7.0-Linux"
else
    echo "[!] Unknown architecture $ARCH skipping Geekbench"
    GB_URL=""
fi

if [[ -n "$GB_URL" ]]; then
    wget "$GB_URL" -O "$BASE/geekbench6/geekbench.tar.gz"
    tar -xzf "$BASE/geekbench6/geekbench.tar.gz" -C "$BASE/geekbench6"
    rm "$BASE/geekbench6/geekbench.tar.gz"
    sudo ln -sf "$BASE/geekbench6/$GB_DIR/geekbench6" /usr/local/bin/geekbench6
    echo "Geekbench installed: $(geekbench6 --version 2>/dev/null || echo 'run geekbench6')"
fi

# GravityMark
if [[ "$ARCH" == "aarch64" ]]; then
    GM_URL="https://tellusim.com/download/GravityMark_1.89_arm64.run"
elif [[ "$ARCH" == "x86_64" ]]; then
    GM_URL="https://tellusim.com/download/GravityMark_1.89.run"
else
    echo "[!] Unknown architecture $ARCH skipping GravityMark"
    GM_URL=""
fi

if [[ -n "$GM_URL" ]]; then
    wget "$GM_URL" -O "$BASE/GravityMark.run"
    chmod +x "$BASE/GravityMark.run"
fi

# Phoronix Test Suite
PTS_VERSION="10.8.4"
PTS_TAR="phoronix-test-suite-${PTS_VERSION}.tar.gz"
PTS_URL="https://github.com/phoronix-test-suite/phoronix-test-suite/releases/download/v${PTS_VERSION}/${PTS_TAR}"

echo "[*] Downloading Phoronix Test Suite..."
wget -O "$BASE/$PTS_TAR" "$PTS_URL"

echo "[*] Extracting PTS..."
tar -xzf "$BASE/$PTS_TAR" -C "$BASE"

echo "[*] Removing archive..."
rm -f "$BASE/$PTS_TAR"

PTS_DIR="$BASE/phoronix-test-suite"
cd "$PTS_DIR"

chmod +x phoronix-test-suite

echo "[*] Running system info..."
printf "y\nn\nn\n" | ./phoronix-test-suite system-info || true

echo "[*] Batch setup..."
printf "y\nn\nn\nn\nn\nn\nn\n" | ./phoronix-test-suite batch-setup || true

echo "[*] Installing benchmarks..."
./phoronix-test-suite install pts/encode-mp3
./phoronix-test-suite install pts/x264
./phoronix-test-suite install pts/phpbench
./phoronix-test-suite install pts/build-linux-kernel

echo ""
echo "[*] Setup complete. Benchmarks ready in $BASE"
