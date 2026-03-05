# Phase-1 Simulation Proof Pack (Lab4_ALU)

This package proves the Phase-1 ALU behavior required in `lab4_s26_alu_ralu.pdf` section 1.

## Files
- `tb_Lab4_ALU_phase1.v`: self-checking exhaustive testbench
- `run_phase1_questa.do`: batch script for ModelSim/Questa
- `phase1_simulation.log`: captured simulator transcript

## Requirement coverage
- Inputs/outputs: `A[3:0], B[3:0], Cin, S[1:0] -> F[3:0], Cout`
- Function select behavior:
  - `S=00`: `F=~A`
  - `S=01`: `F=A+B+Cin`
  - `S=10`: `F=A&B`
  - `S=11`: `F=A|B`
- Carry rule (critical):
  - `Cout` is valid only for SUM (`S=01`)
  - `Cout=0` for NOT/AND/OR modes

## Test scope
Exhaustive sweep of all combinations:
- `S`: 4 values
- `A`: 16 values
- `B`: 16 values
- `Cin`: 2 values
- Total: `4 * 16 * 16 * 2 = 2048` checks

## Result
From `phase1_simulation.log`:
- `PASS: 2048/2048 tests passed.`
- Compile/sim warnings: 0
- Compile/sim errors: 0

## Re-run command
From `proof_phase1` folder:

```powershell
D:\intelFPGA\19.1\modelsim_ase\win32aloem\vsim.exe -c -do run_phase1_questa.do
```
