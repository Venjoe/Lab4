# Lab4 RALU Pre-lab Questions Answers

Date: 2026-03-05

## 1) Single device to remember last carry output

Add one edge-triggered D flip-flop (1-bit register) driven by the same system clock.

- Input: `D = Cout`
- Clock: `CLK` (same clock used by REGA/REGB)
- Output: `Q = Cout_prev` (latched carry from previous cycle)

This stores carry history by one cycle and can be observed or reused by control logic.

## 2) Does divide-by-2 work for all 4-bit 2's complement numbers?

No, not for all values if implemented as a logical right shift.

- The current RALU right shift is logical: `0` is shifted into MSB.
- For negative 2's complement values, logical right shift does not preserve sign.
- Arithmetic right shift (sign-extension) is required to correctly divide signed values by 2 with truncation toward negative infinity.

Therefore, the current `MSC=111` operation is correct for unsigned interpretation, but not universally correct for signed 2's complement values.

## 3) How to get 2's complement of A into B

Use identity: `-A = (~A) + 1`

One practical sequence:

1. Load value into `A`.
2. Compute `~A` (use `MSC=010`) and store result into `B`.
3. Load constant `1` into the other register as needed.
4. Add with `Cin=0` or use `Cin=1` depending on where `+1` is injected.

A compact implementation is:
- `B <- ~A`
- then `B <- B + 1` using adder path and register steering.

## 4) How to subtract with this RALU

Use addition with 2's complement:

`A - B = A + (~B) + 1`

Method:

1. Form `~B`.
2. Set `Cin=1`.
3. Use adder function (`MSC=101`) and steer output into destination register.

So subtraction is implemented without a dedicated subtractor.

## 5) Clear A or B without async CLR/SET

Use synchronous clearing through existing data path:

Option A (preferred with current design):
1. Put `0000` on `INPUT_BUS`.
2. Set `MSA=00` to clear `A` on next clock edge, or `MSB=00` to clear `B`.

Option B:
- Add a MUX input tied to constant zero (`gnd`) and select it when a clear control signal is asserted.

Both methods avoid asynchronous reset pins.
