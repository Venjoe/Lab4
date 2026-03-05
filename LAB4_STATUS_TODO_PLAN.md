# Lab4 Status and Execution Plan

Last Updated: 2026-03-04

## Current Status
- [x] Section 1 (ALU) implemented in Quartus project `Lab4_ALU`.
- [x] `Cout` behavior fixed to match section-1 requirement: valid only for SUM mode (`S=01`).
- [x] Full compile passes for ALU (`0 errors`).
- [x] Phase-1 simulation proof pack completed (`2048/2048` pass).
- [x] English-only submission folder created: `Lab4_ALU_SUBMISSION_EN_20260304`.

## Remaining Work (Whole Lab4)

### Section 2: RALU Design (Main Remaining Scope)
- [x] P0. Create `Lab4_RALU` Quartus project skeleton.
- [x] P1. Implement RALU datapath blocks:
  - [x] REGA (4-bit register)
  - [x] REGB (4-bit register)
  - [x] MUX A (source select for REGA)
  - [x] MUX B (source select for REGB)
  - [x] Combinational logic block (NOT/AND/OR/ADD/SHL/SHR paths)
  - [x] MUX C (output function select per Table 3)
- [x] P2. Expose required outputs: `REGA`, `REGB`, `OUTPUT`, `Cout`.
- [ ] P3. Simulate each simple Table-3 function and annotate waveforms.
  - [x] Created `Lab4_RALU_tb.v` self-checking testbench for all 8 Table-3 functions.
  - [x] Added `Lab4_RALU_tb_evidence.v` with simple functions + 4g sequence checks.
  - [x] Ran Icarus simulation and saved evidence in `Lab4_RALU/verification/iverilog/`.
  - [ ] Optional: rerun same evidence in Questa once license env is fixed.
- [ ] P4. Build control-word sequences (`MSA1:0, MSB1:0, MSC2:0`) for complex operations a~g.
  - [x] Draft sequence file created: `Lab4_RALU/LAB4_RALU_CONTROL_WORDS_DRAFT.md`
  - [x] Logic-level sequence checker added: `Lab4_RALU/tools/ralu_sequence_checker.py`
  - [x] Auto-generated cycle tables in `Lab4_RALU/verification/*.csv`
  - [ ] Validate each sequence against Quartus/Questa simulation waveforms.
- [ ] P5. Simulate and document complex sequence 4g with step-by-step descriptions (Table 4 style).
  - [x] Draft table created: `Lab4_RALU/Lab4_RALU_4g_TABLE4_DRAFT.csv`
  - [x] Generated validation summary: `Lab4_RALU/verification/sequence_validation_report.md`
  - [ ] Validate draft values against actual waveform capture.
- [ ] P6. Hardware mapping and in-lab demo preparation:
  - [x] DAD input mapping (including clock)
  - [x] HEX display mapping for REGA/REGB/OUTPUT and `Cout`
  - [x] Added board top file: `Lab4_RALU/Lab4_RALU_DE10_Top.v`
  - [x] Added mapping guide: `Lab4_RALU/LAB4_RALU_DE10_DAD_MAPPING_GUIDE.md`
  - [x] Added custom pattern template: `Lab4_RALU/Lab4_4g_custom_pattern_template.txt`
  - [ ] Physical wiring + on-board behavioral check with DAD
  - [ ] Save and verify `Lab4_4g.dwf3work`
- [ ] P7. Final submission package cleanup (English-only, archive-ready).
  - [x] Added execution checklist: `Lab4_RALU/NEXT_EXECUTION_STEPS.md`

## Execution Started
- [x] This status/plan file has been recorded.
- [x] Completed P0 (project skeleton).
- [x] Completed P1/P2 (RALU datapath + required outputs in RTL).
- [x] Full Quartus compile passes for `Lab4_RALU` (`0 errors`).
- [ ] Currently executing: P3 (simple-function simulation evidence).

## Active Blockers
- Questa command-line simulation currently fails due to missing license environment setup:
  - Error: `Invalid license environment`
  - Required variable appears unset: `SALT_LICENSE_SERVER`
  - Workaround in place: Icarus Verilog CLI evidence flow is operational.
