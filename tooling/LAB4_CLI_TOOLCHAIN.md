# Lab4 CLI Toolchain (Windows)

This file records the command-line tools required to reproduce Lab4 quickly on a new PC.

## 1) Required tools

| Tool | Command(s) | Purpose | Install source |
|---|---|---|---|
| Intel Quartus Prime Lite 25.1 | `quartus_sh`, `quartus_map`, `quartus_fit`, `quartus_asm`, `quartus_sta` | Compile and generate FPGA programming file | Manual installer from Intel |
| Git | `git` | Version control and rollback | `winget` (`Git.Git`) |
| GitHub CLI | `gh` | Push/pull and auth from terminal | `winget` (`GitHub.cli`) |
| Python 3.12+ | `python`, `pip` | Utility scripts and checks | `winget` (`Python.Python.3.12`) |
| Icarus Verilog | `iverilog`, `vvp` | Stage-1 simulation evidence | `winget` (`Icarus.Verilog`) |
| Ripgrep | `rg` | Fast file/text search | `winget` (`BurntSushi.ripgrep.MSVC`) |
| Poppler tools | `pdftotext` | Extract lab spec text from PDF | `winget` (`oschwartz10612.Poppler`) |

## 2) Optional tools

| Tool | Command | Purpose |
|---|---|---|
| GTKWave | `gtkwave` | Open VCD waveforms locally |

## 3) Standard Quartus path baseline

Expected Quartus CLI folder:

- `D:\altera_lite\25.1std\quartus\bin64`

If Quartus is installed but command is not found, add that folder to user PATH and reopen terminal.

## 4) Quick setup sequence (new machine)

```powershell
# 1) Install non-Quartus tools
powershell -ExecutionPolicy Bypass -File .\tooling\install_lab4_cli.ps1

# 2) Verify all tools
powershell -ExecutionPolicy Bypass -File .\tooling\check_lab4_cli.ps1
```

If Quartus is missing, install Quartus manually, then run:

```powershell
powershell -ExecutionPolicy Bypass -File .\tooling\check_lab4_cli.ps1
```

## 5) Validation checklist

1. `quartus_sh --version` works.
2. `iverilog -V` and `vvp -V` work.
3. `gh auth status` returns your account.
4. `pdftotext -v` works.
5. `rg --version` works.
