# Benchy
Prototype script setup for automating [Jeff Geerling's SBC benchmark workflow](https://github.com/geerlingguy/sbc-reviews).

![License](https://img.shields.io/github/license/ryderhutchings/Benchy)
![Repo size](https://img.shields.io/github/repo-size/ryderhutchings/Benchy)
![Last commit](https://img.shields.io/github/last-commit/ryderhutchings/Benchy)
![Stars](https://img.shields.io/github/stars/ryderhutchings/Benchy?style=flat)
![Contributors](https://img.shields.io/github/contributors/ryderhutchings/Benchy)

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
| `run-top500-benchmark.sh` | HPL Linpack (single node) | `~/benchmarks/top500-results.txt` |
| `run-ai-benchmark.sh` | Ollama LLM inference (llama3.2:3b, llama3.1:8b, llama2:13b) | `~/benchmarks/ai-results.txt` |
| `run-tinymembench.sh` | tinymembench | `~/benchmarks/memory-results.txt` |
| `run-disk-benchmark.sh` | iozone via disk-benchmark.sh | `~/benchmarks/disk-results.txt` |
| `run-sbc-bench.sh` | sbc-bench (uploads result to public URL) | `~/benchmarks/sbc-bench-results.txt` |
| `run-phoronix-test-suite.sh` | Phoronix Test Suite | `~/benchmarks/phoronix-results.txt` |

## Manual Steps
These still require a display or manual download:
- **Geekbench 6** — run `geekbench6` after install
- **GravityMark** — requires active display, run after install
- **glmark2** — `DISPLAY=:0 glmark2-es2`
- **vkmark** — `DISPLAY=:0 vkmark`
- **iperf3** — requires a server: `iperf3 -c $SERVER_IP`
- **lstopo** — `lstopo lstopo.png`
- **stress-ng** — `stress-ng --matrix 0` (monitor power draw at wall)

## References
- [Jeff Geerling's sbc-reviews](https://github.com/geerlingguy/sbc-reviews)
- [top500-benchmark](https://github.com/geerlingguy/top500-benchmark)
- [ai-benchmarks](https://github.com/geerlingguy/ai-benchmarks)
- [tinymembench](https://github.com/rojaster/tinymembench)
- [sbc-bench](https://github.com/ThomasKaiser/sbc-bench)
- [Phoronix Test Suite](https://github.com/phoronix-test-suite/phoronix-test-suite)
