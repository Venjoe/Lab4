# Lab4 Final Submission Checklist

Date: 2026-03-05

Use this checklist before Canvas submission and in-lab demo.

## Section 1: ALU

- [ ] `Lab4_ALU` project archive is generated and opens correctly.
- [ ] ALU schematic/block diagram is included in report.
- [ ] Simulation evidence covers all four ALU functions (`NOT`, `SUM`, `AND`, `OR`).
- [ ] `Cout` behavior is clearly shown (active only for sum mode when carry occurs).
- [ ] Annotated simulation screenshots are included.

## Section 2: RALU Design

- [ ] Complete functional block diagram is included (REGA/REGB, MUX A/B/C, logic block, buses).
- [ ] Quartus project name is `Lab4_RALU`.
- [ ] Required outputs are present: `REGA`, `REGB`, `OUTPUT`, `Cout`.
- [ ] Simple function evidence for all Table-3 operations is included.

## Control-Word Sequences

- [ ] Table for sequences `a` through `g` is included with columns (MSA, MSB, MSC, Input, Cin, ... Description).
- [ ] Step-by-step descriptions are provided for every row.
- [ ] Sequence `g` is verified and consistent across table, simulation, and hardware behavior.

## Hardware / DAD / DE10-Lite

- [ ] FPGA programming file is generated from latest source.
- [ ] DAD input mapping is wired according to mapping guide.
- [ ] HEX displays show `REGA`, `REGB`, and `OUTPUT` correctly.
- [ ] Output display decimal point indicates `Cout`.
- [ ] `Lab4_4g.dwf3work` is saved and verified.
- [ ] Demo for sequence `g` is reproducible at slow clock.

## Files to Include

- [ ] Quartus archive(s) for ALU and RALU.
- [ ] Lab report PDF (English-only).
- [ ] Annotated simulation results.
- [ ] Table-4 sequence table and explanations.
- [ ] `Lab4_4g.dwf3work`.

## Quality Gate

- [ ] All submitted text is English-only.
- [ ] No broken paths or missing referenced files.
- [ ] Final compile status checked for both projects (no errors).
