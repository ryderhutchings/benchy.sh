#!/bin/bash
#
# Based on Jeff Geerling's sbc-reviews workflow + custom extensions
# by Ryder Hutchings: https://github.com/ryderhutchings
#
set -euo pipefail

mkdir -p ~/Benchy
echo "[*] Benchy directory ready at ~/Benchy"

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
    gnuplot

sudo apt install -y vkmark || echo "[!] vkmark not available via 'apt' compile from source: https://github.com/geerlingguy/sbc-reviews/issues/76"

# Ollama
curl -fsSL https://ollama.com/install.sh | sh

sudo systemctl start ollama

echo "[*] Waiting for Ollama API..."
until curl -s http://127.0.0.1:11434 > /dev/null; do
    sleep 1
done

ollama pull tinyllama:1.1b
ollama pull deepseek-r1:1.5b
ollama pull llama3.2:3b

cd ~
[ ! -d ~/top500-benchmark ] && git clone https://github.com/geerlingguy/top500-benchmark.git
[ ! -d ~/ai-benchmarks ] && git clone https://github.com/geerlingguy/ai-benchmarks.git
[ ! -d ~/tinymembench ] && git clone https://github.com/rojaster/tinymembench.git
cd ~/tinymembench && make && cd ~

# c2clat
git clone https://github.com/rigtorp/c2clat.git || true

if [ -d ~/c2clat ]; then
    cd ~/c2clat

    echo "[*] Inspecting c2clat contents..."
    ls

    # Case 1: Makefile exists
    if [ -f Makefile ]; then
        make || echo "[!] make failed for c2clat"

    # Case 2: CMake project
    elif [ -f CMakeLists.txt ]; then
        mkdir -p build
        cd build
        cmake ..
        make || echo "[!] cmake build failed for c2clat"
        cd ..

    else
        echo "[!] No Makefile or CMake found. Attempting manual compile..."

        SRC=$(find . -maxdepth 2 -name "*.c" | head -n 1)

        if [ -n "$SRC" ]; then
            gcc -O2 -pthread "$SRC" -o c2clat || echo "[!] manual gcc build failed"
        else
            echo "[!] No C source found cannot build c2clat"
        fi
    fi

    cd ~
fi


wget -q -O ~/Benchy/disk-benchmark.sh https://raw.githubusercontent.com/geerlingguy/pi-cluster/master/benchmarks/disk-benchmark.sh
wget -q -O ~/Benchy/sbc-bench.sh https://raw.githubusercontent.com/ThomasKaiser/sbc-bench/master/sbc-bench.sh
chmod +x ~/Benchy/disk-benchmark.sh ~/Benchy/sbc-bench.sh

# Geekbench
mkdir -p ~/geekbench6
ARCH=$(uname -m)
if [[ "$ARCH" == "aarch64" || "$ARCH" == "arm64" ]]; then
    GB_URL="https://cdn.geekbench.com/Geekbench-6.4.0-LinuxARMPreview.tar.gz"
    GB_DIR="Geekbench-6.4.0-LinuxARMPreview"
elif [[ "$ARCH" == "x86_64" ]]; then
    GB_URL="https://cdn.geekbench.com/Geekbench-6.7.0-Linux.tar.gz"
    GB_DIR="Geekbench-6.7.0-Linux"
else
    echo "[!] Unknown architecture $ARCH skipping Geekbench 6. Download manually: https://www.geekbench.com/download/"
    GB_URL=""
fi

if [[ -n "$GB_URL" ]]; then
    wget "$GB_URL" -O ~/geekbench6/geekbench.tar.gz
    tar -xzf ~/geekbench6/geekbench.tar.gz -C ~/geekbench6
    rm ~/geekbench6/geekbench.tar.gz
    sudo ln -sf ~/geekbench6/$GB_DIR/geekbench6 /usr/local/bin/geekbench6
    echo "Geekbench 6 installed: $(geekbench6 --version 2>/dev/null || echo 'run geekbench6 to verify')"
fi

# GravityMark
if [[ "$ARCH" == "aarch64" || "$ARCH" == "arm64" ]]; then
    GM_URL="https://tellusim.com/download/GravityMark_1.89_arm64.run"
elif [[ "$ARCH" == "x86_64" ]]; then
    GM_URL="https://tellusim.com/download/GravityMark_1.89.run"
else
    echo "[!] Unknown architecture $ARCH skipping GravityMark. Download manually: https://gravitymark.tellusim.com"
    GM_URL=""
fi

if [[ -n "$GM_URL" ]]; then
    wget "$GM_URL" -O ~/GravityMark.run
    chmod +x ~/GravityMark.run
fi

echo ""
echo "Done. All benchmarks installed."
