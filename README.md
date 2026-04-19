# benchy.sh

Prototype script setup for automating [Jeff Geerling's SBC benchmark workflow](https://github.com/geerlingguy/sbc-reviews).

---

## Setup

Run once to install everything:

```bash
bash setup.sh
```

This installs all dependencies, clones repos, pulls Ollama models, and downloads benchmark scripts. Geekbench 6 and GravityMark are installed automatically based on detected architecture (ARM or x86).

---

## Benchmark Scripts

| Script | What it runs | Output |
|---|---|---|
| `run-top500-benchmark.sh` | HPL Linpack (single node) | `~/benchmarks/top500-results.txt` |
| `run-ai-benchmark.sh` | Ollama LLM inference (llama3.2:3b, llama3.1:8b, llama2:13b) | `~/benchmarks/ai-results.txt` |
| `run-memory-benchmark.sh` | tinymembench | `~/benchmarks/memory-results.txt` |
| `run-disk-benchmark.sh` | iozone via disk-benchmark.sh | `~/benchmarks/disk-results.txt` |
| `run-sbc-bench.sh` | sbc-bench (uploads result to public URL) | `~/benchmarks/sbc-bench-results.txt` |

---

## Manual Steps

These still require a display or manual download:

- **Geekbench 6** — run `geekbench6` after install
- **GravityMark** — requires active display, run after install
- **glmark2** — `DISPLAY=:0 glmark2-es2`
- **vkmark** — `DISPLAY=:0 vkmark`
- **iperf3** — requires a server: `iperf3 -c $SERVER_IP`
- **lstopo** — `lstopo lstopo.png`
- **stress-ng** — `stress-ng --matrix 0` (monitor power draw at wall)

---

## References

- [Jeff Geerling's sbc-reviews](https://github.com/geerlingguy/sbc-reviews)
- [top500-benchmark](https://github.com/geerlingguy/top500-benchmark)
- [ai-benchmarks](https://github.com/geerlingguy/ai-benchmarks)
- [tinymembench](https://github.com/rojaster/tinymembench)
- [sbc-bench](https://github.com/ThomasKaiser/sbc-bench)
