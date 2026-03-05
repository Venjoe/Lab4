# Lab4 RALU Control-Word Draft (P4)

Date: 2026-03-04
Control word format: `MSA1:0, MSB1:0, MSC2:0`

MUX source codes (Table 2):
- `00`: INPUT bus
- `01`: REGA bus
- `10`: REGB bus
- `11`: OUTPUT bus

MUX C function codes (Table 3):
- `000`: OUTPUT = REGA
- `001`: OUTPUT = REGB
- `010`: OUTPUT = ~REGA
- `011`: OUTPUT = REGA & REGB
- `100`: OUTPUT = REGA | REGB
- `101`: OUTPUT = REGA + REGB + Cin
- `110`: OUTPUT = REGA << 1
- `111`: OUTPUT = logical(REGA >> 1)

## a) Load A, B, then AND and store into A (preserve B)

1. Load A from INPUT(A_in): `00,10,000`
2. Load B from INPUT(B_in), hold A: `01,00,000`
3. Compute AND and store to A, hold B: `11,10,011`

## b) Load A, B, then OR and store into B (preserve A)

1. Load A from INPUT(A_in): `00,10,000`
2. Load B from INPUT(B_in), hold A: `01,00,000`
3. Compute OR and store to B, hold A: `01,11,100`

## c) Load A, complement A, store into B (preserve A)

1. Load A from INPUT(A_in): `00,10,000`
2. Compute NOT A and store to B, hold A: `01,11,010`

## d) Load A, B, sum and store into A (preserve B)

1. Load A from INPUT(A_in): `00,10,000`
2. Load B from INPUT(B_in), hold A: `01,00,000`
3. Compute SUM and store to A, hold B: `11,10,101`

## e) Load A, shift right, store into B

1. Load A from INPUT(A_in): `00,10,000`
2. Compute SHR and store to B, hold A: `01,11,111`

## f) Load A, shift left, store into B

1. Load A from INPUT(A_in): `00,10,000`
2. Compute SHL and store to B, hold A: `01,11,110`

## g) Program sequence
Goal: OR 4 and A, AND 6, multiply by 4, OR 3, complement, divide by 2.

1. Load A = 4: `00,10,000` (INPUT=4)
2. Load B = A_const: `01,00,000` (INPUT=A_const)
3. A <- A OR B: `11,10,100`
4. Load B = 6: `01,00,000` (INPUT=6)
5. A <- A AND B: `11,10,011`
6. A <- A << 1: `11,10,110`
7. A <- A << 1: `11,10,110`
8. Load B = 3: `01,00,000` (INPUT=3)
9. A <- A OR B: `11,10,100`
10. A <- ~A: `11,10,010`
11. A <- A >> 1: `11,10,111`

Notes:
- Keep `Cin=0` for this program unless an add step is intentionally used.
- For each step, set control/data before the active clock edge; read register updates immediately after the edge.
- This is a draft pending waveform confirmation in P5.
