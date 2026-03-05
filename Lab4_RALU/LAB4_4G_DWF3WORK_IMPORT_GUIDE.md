# Lab4_4g.dwf3work Import Guide

Date: 2026-03-05

Reference template: `Lab4_4g_custom_pattern_template.txt`

## Goal

Create a DAD custom pattern workspace for sequence `g`, save it as:

`Lab4_4g.dwf3work`

## Signal Order

Use this exact bit order per sample:

`MSA1 MSA0 MSB1 MSB0 MSC2 MSC1 MSC0 INPUT3 INPUT2 INPUT1 INPUT0 Cin CLK`

Equivalent grouped format:

`MSA[1:0], MSB[1:0], MSC[2:0], INPUT[3:0], Cin, CLK`

## Preparation

1. Wire DAD outputs to DE10-Lite GPIO pins per `LAB4_RALU_DE10_DAD_MAPPING_GUIDE.md`.
2. Configure static outputs/signals for:
   - `MSA[1:0]`
   - `MSB[1:0]`
   - `MSC[2:0]`
   - `INPUT[3:0]`
   - `Cin`
   - `CLK`
3. Set a slow clock frequency (recommended: `0.25 Hz` to `1 Hz`).

## Pattern Entry (Sequence g)

Enter the 11 steps from:

`Lab4_4g_custom_pattern_template.txt`

For each step:

1. Set control/data bits.
2. Apply one active clock edge.
3. Observe `REGA`, `REGB`, `OUTPUT` on HEX displays.

## Expected Final State

After step 11:

- `REGA = 2`
- `REGB = 3`
- `OUTPUT = 1` (with `MSC=111`)

## Save Workspace

1. In DAD Waveforms UI, save workspace as:
   - `Lab4_4g.dwf3work`
2. Reopen it once to verify the custom pattern is preserved.
3. Include this file in final Canvas submission.

## Troubleshooting

- If display values do not match, first verify pin mapping and bit order.
- If sequence drifts, reduce clock rate and step manually.
- If outputs look one cycle off, confirm values are sampled after active clock edge.
