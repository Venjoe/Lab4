# Lab4 RALU Next Execution Steps

## A. Simulation Evidence (when Questa license is ready)

1. Open terminal in `D:\Eletronic\Lab4\Lab4_RALU`.
2. Compile TB:
   - `vlib work`
   - `vlog Lab4_RALU.v Lab4_RALU_tb.v`
3. Run TB:
   - `vsim -c Lab4_RALU_tb -do "run -all; quit -f"`
4. Save transcript as proof in report appendix.

## B. Hardware Demo (DE10 + DAD)

1. Program FPGA with latest `Lab4_RALU.sof`.
2. Wire DAD to GPIO pins per `LAB4_RALU_DE10_DAD_MAPPING_GUIDE.md`.
3. Set DAD clock to slow rate (0.25 Hz to 1 Hz).
4. Execute control words for sequence g line-by-line.
5. Save DAD workspace as `Lab4_4g.dwf3work`.

## C. Documentation Pack

1. Include:
   - Block diagram (RALU complete datapath)
   - Table-3 simple function evidence
   - Table-4 sequence table and explanation
   - Sequence validation CSV/MD from `verification/`
2. Ensure all captions and notes are English-only.
