# AD3 to DE10-Lite Wiring for Lab4_4g.dwf3work

Date: 2026-03-05

This wiring matches the current Quartus assignments in `Lab4_RALU.qsf`.

## 1) Required Signals

`DAD_CLK, DAD_CIN, DAD_INPUT[3:0], DAD_MSA[1:0], DAD_MSB[1:0], DAD_MSC[2:0]`

Total required AD3 digital outputs: 13 channels.

## 2) Exact Wire Mapping

Use AD3 DIO outputs as follows:

1. `AD3 DIO0`  -> `DE10 JP1 pin 1`  (`GPIO_0`,  FPGA `PIN_V10`)  -> `DAD_CLK`
2. `AD3 DIO1`  -> `DE10 JP1 pin 2`  (`GPIO_1`,  FPGA `PIN_W10`)  -> `DAD_CIN`
3. `AD3 DIO2`  -> `DE10 JP1 pin 3`  (`GPIO_2`,  FPGA `PIN_V9`)   -> `DAD_INPUT[0]`
4. `AD3 DIO3`  -> `DE10 JP1 pin 4`  (`GPIO_3`,  FPGA `PIN_W9`)   -> `DAD_INPUT[1]`
5. `AD3 DIO4`  -> `DE10 JP1 pin 5`  (`GPIO_4`,  FPGA `PIN_V8`)   -> `DAD_INPUT[2]`
6. `AD3 DIO5`  -> `DE10 JP1 pin 6`  (`GPIO_5`,  FPGA `PIN_W8`)   -> `DAD_INPUT[3]`
7. `AD3 DIO6`  -> `DE10 JP1 pin 7`  (`GPIO_6`,  FPGA `PIN_V7`)   -> `DAD_MSA[0]`
8. `AD3 DIO7`  -> `DE10 JP1 pin 8`  (`GPIO_7`,  FPGA `PIN_W7`)   -> `DAD_MSA[1]`
9. `AD3 DIO8`  -> `DE10 JP1 pin 9`  (`GPIO_8`,  FPGA `PIN_W6`)   -> `DAD_MSB[0]`
10. `AD3 DIO9` -> `DE10 JP1 pin 10` (`GPIO_9`,  FPGA `PIN_V5`)   -> `DAD_MSB[1]`
11. `AD3 DIO10`-> `DE10 JP1 pin 13` (`GPIO_10`, FPGA `PIN_W5`)   -> `DAD_MSC[0]`
12. `AD3 DIO11`-> `DE10 JP1 pin 14` (`GPIO_11`, FPGA `PIN_AA15`) -> `DAD_MSC[1]`
13. `AD3 DIO12`-> `DE10 JP1 pin 15` (`GPIO_12`, FPGA `PIN_AA14`) -> `DAD_MSC[2]`

## 3) Ground and Voltage Rules

- Connect at least one `AD3 GND` to one `DE10-Lite GND` (JP1 GND or any board GND).
- Do **not** feed AD3 power rails into DE10-Lite power pins.
- AD3 digital I/O is 3.3 V CMOS, matching the current DE10-Lite assignment (`3.3-V LVTTL`).

## 4) WaveForms Setup for this Lab

- Set DIO0 (`DAD_CLK`) as clock/pattern clock, slow rate (0.25 Hz to 1 Hz).
- Set DIO1..DIO12 as static or custom-pattern digital outputs.
- Load your `Lab4_4g` sequence values in the order used by your pattern file.

## 5) Display Expectation on DE10-Lite

- HEX0: `REGA`
- HEX1: `REGB`
- HEX2: `OUTPUT`
- HEX2 decimal point: `Cout`
