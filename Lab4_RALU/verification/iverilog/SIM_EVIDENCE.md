# Icarus Simulation Evidence

Date: 2026-03-04
Project: `Lab4_RALU`

## Toolchain
- `iverilog` v12
- `vvp` runtime

## Command
`iverilog -g2012 -o verification/iverilog/ralu_evidence.out Lab4_RALU.v Lab4_RALU_tb_evidence.v`
`vvp verification/iverilog/ralu_evidence.out`

## Result
- PASS: `Lab4_RALU_tb_evidence` completed with 0 errors.
- Verified all simple Table-3 functions and sequence 4g final states.

## Artifacts
- `verification/iverilog/ralu_evidence.out`
- `verification/iverilog/tb_evidence.log`
- `verification/iverilog/tb_evidence.vcd`
