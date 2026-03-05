# Lab4 RALU DE10-Lite + DAD Mapping Guide

Date: 2026-03-04
Project: `D:\Eletronic\Lab4\Lab4_RALU`
Top entity: `Lab4_RALU_DE10_Top`

## 1) Implemented Board I/O Behavior

- `DAD_INPUT[3:0]` drives RALU `INPUT_BUS[3:0]`
- `DAD_CIN` drives RALU `Cin`
- `DAD_MSA[1:0]`, `DAD_MSB[1:0]`, `DAD_MSC[2:0]` drive control word bits
- `DAD_CLK` drives RALU register clock
- `HEX0` displays `REGA`
- `HEX1` displays `REGB`
- `HEX2` displays `OUTPUT_BUS`
- `HEX2_DP` displays `Cout` (lit when `Cout=1`)

## 2) FPGA Pin Assignments (already in QSF)

### DAD Inputs via GPIO

- `DAD_CLK` -> `GPIO_[0]` -> `PIN_V10`
- `DAD_CIN` -> `GPIO_[1]` -> `PIN_W10`
- `DAD_INPUT[0]` -> `GPIO_[2]` -> `PIN_V9`
- `DAD_INPUT[1]` -> `GPIO_[3]` -> `PIN_W9`
- `DAD_INPUT[2]` -> `GPIO_[4]` -> `PIN_V8`
- `DAD_INPUT[3]` -> `GPIO_[5]` -> `PIN_W8`
- `DAD_MSA[0]` -> `GPIO_[6]` -> `PIN_V7`
- `DAD_MSA[1]` -> `GPIO_[7]` -> `PIN_W7`
- `DAD_MSB[0]` -> `GPIO_[8]` -> `PIN_W6`
- `DAD_MSB[1]` -> `GPIO_[9]` -> `PIN_V5`
- `DAD_MSC[0]` -> `GPIO_[10]` -> `PIN_W5`
- `DAD_MSC[1]` -> `GPIO_[11]` -> `PIN_AA15`
- `DAD_MSC[2]` -> `GPIO_[12]` -> `PIN_AA14`

### HEX Outputs

- `HEX0[6:0]` -> REGA
- `HEX1[6:0]` -> REGB
- `HEX2[6:0]` -> OUTPUT_BUS
- `HEX2_DP` -> Cout

## 3) Control Word Bit Order (for custom pattern)

Use exactly this order for each pattern line:

`MSA1 MSA0 MSB1 MSB0 MSC2 MSC1 MSC0 INPUT3 INPUT2 INPUT1 INPUT0 Cin CLK`

If you prefer grouped format:

`MSA[1:0], MSB[1:0], MSC[2:0], INPUT[3:0], Cin, CLK`

## 4) Table 2 and Table 3 Coding

### Register input source (MSA / MSB)

- `00`: INPUT bus
- `01`: REGA bus
- `10`: REGB bus
- `11`: OUTPUT bus

### Function select (MSC)

- `000`: OUTPUT = REGA
- `001`: OUTPUT = REGB
- `010`: OUTPUT = ~REGA
- `011`: OUTPUT = REGA AND REGB
- `100`: OUTPUT = REGA OR REGB
- `101`: OUTPUT = REGA + REGB + Cin
- `110`: OUTPUT = REGA << 1
- `111`: OUTPUT = logical(REGA >> 1)

## 5) Minimal Bring-Up Procedure

1. Program FPGA with current `.sof` from `output_files`.
2. Connect DAD digital outputs to DE10 GPIO pins listed above.
3. Drive a slow clock on `DAD_CLK` (e.g., 0.25 Hz to 1 Hz).
4. Use DAD static I/O or custom pattern to set control/data bits.
5. Verify:
   - HEX0 follows REGA
   - HEX1 follows REGB
   - HEX2 follows OUTPUT
   - HEX2 decimal point indicates Cout for add cases

## 6) Notes

- Current compile result: full flow successful, 0 errors.
- The remaining warnings are non-blocking for lab demo.
- Keep all submission text in English.
