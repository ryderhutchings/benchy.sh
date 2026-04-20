# Benchy
Prototype script setup for automating [Jeff Geerling's SBC benchmark workflow](https://github.com/geerlingguy/sbc-reviews).

![License](https://img.shields.io/github/license/ryderhutchings/Benchy)
![Repo size](https://img.shields.io/github/repo-size/ryderhutchings/Benchy)
![Last commit](https://img.shields.io/github/last-commit/ryderhutchings/Benchy)
![Arch](https://img.shields.io/badge/arch-x86__64%20%7C%20aarch64-lightgrey)
![Debian](https://img.shields.io/badge/tested%20on-Debian%2013-red)
![Shell](https://img.shields.io/badge/shell-bash-green)
[![YouTube](https://img.shields.io/youtube/channel/subscribers/UCfYoumlckdDcox4TtxZiKtA?label=YouTube&style=flat&color=red&logo=youtube)](https://www.youtube.com/@ryderhutchings?sub_confirmation=1)

## Setup
Run once to install everything:
```bash
bash setup.sh
```
This installs all dependencies, clones repos, pulls Ollama models, and downloads benchmark scripts. Geekbench 6 and GravityMark are installed automatically based on detected architecture (ARM or x86).

## Benchmark Scripts
| Script | What it runs | Output |
|---|---|---|
| `run-top500-benchmark.sh` | HPL Linpack (single node) | `~/Benchy/top500-results.txt` |
| `run-ai-benchmark.sh` | Ollama LLM inference (tinyllama:1.1b, deepseek-r1:1.5b, llama3.2:3b) | `~/Benchy/ai-results.txt` |
| `run-tinymembench.sh` | tinymembench | `~/Benchy/memory-results.txt` |
| `run-disk-benchmark.sh` | iozone via disk-benchmark.sh | `~/Benchy/disk-results.txt` |
| `run-sbc-bench.sh` | sbc-bench (uploads result to public URL) | `~/Benchy/sbc-bench-results.txt` |
| `run-phoronix-test-suite.sh` | Phoronix Test Suite (encode-mp3, x264, phpbench, build-linux-kernel) | `~/Benchy/pts-results.txt` |
| `run-geekbench6.sh` | Geekbench 6 (2 runs) | `~/Benchy/geekbench6-results.txt` |
| `run-glmark2.sh` | glmark2-es2 (requires display) | `~/Benchy/glmark2-results.txt` |
| `run-vkmark.sh` | vkmark (requires display) | `~/Benchy/vkmark-results.txt` |
| `run-sysbench.sh` | sysbench CPU | `~/Benchy/sysbench-results.txt` |

## Manual Steps
These still require a display or manual intervention:

- **GravityMark** — requires active display: `bash ~/Benchy/GravityMark.run`
- **iperf3** — requires a server: `iperf3 -c $SERVER_IP`
- **nuttcp** — requires a server: `nuttcp -t $SERVER_IP`
- **lstopo** — `lstopo lstopo.png`
- **stress-ng** — `stress-ng --matrix 0` (monitor power draw at wall)
- **Thermals** — record temps manually.
- **Power draw** — measure at wall with a meter during each benchmark.

## References
- [Jeff Geerling's sbc-reviews](https://github.com/geerlingguy/sbc-reviews)
- [top500-benchmark](https://github.com/geerlingguy/top500-benchmark)
- [ai-benchmarks](https://github.com/geerlingguy/ai-benchmarks)
- [tinymembench](https://github.com/rojaster/tinymembench)
- [sbc-bench](https://github.com/ThomasKaiser/sbc-bench)
- [Phoronix Test Suite](https://github.com/phoronix-test-suite/phoronix-test-suite)
