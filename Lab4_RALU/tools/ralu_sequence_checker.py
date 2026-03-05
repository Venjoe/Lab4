from dataclasses import dataclass
from pathlib import Path
from typing import List, Dict
import csv


@dataclass
class Step:
    label: str
    msa: int
    msb: int
    msc: int
    inp: int
    cin: int


def nib(x: int) -> int:
    return x & 0xF


def calc_output(reg_a: int, reg_b: int, msc: int, cin: int):
    add_full = reg_a + reg_b + cin
    add_sum = add_full & 0xF
    add_cout = (add_full >> 4) & 1
    lut = {
        0b000: reg_a,
        0b001: reg_b,
        0b010: nib(~reg_a),
        0b011: reg_a & reg_b,
        0b100: reg_a | reg_b,
        0b101: add_sum,
        0b110: nib(reg_a << 1),
        0b111: (reg_a >> 1) & 0x7,
    }
    return lut[msc], add_cout


def mux_src(code: int, inp: int, reg_a: int, reg_b: int, out_bus: int):
    if code == 0b00:
        return inp
    if code == 0b01:
        return reg_a
    if code == 0b10:
        return reg_b
    return out_bus


def run_sequence(name: str, steps: List[Step], reg_a0=0, reg_b0=0) -> List[Dict]:
    rows: List[Dict] = []
    reg_a = nib(reg_a0)
    reg_b = nib(reg_b0)
    for idx, s in enumerate(steps, start=1):
        out_before, cout_before = calc_output(reg_a, reg_b, s.msc, s.cin)
        mux_a = mux_src(s.msa, s.inp, reg_a, reg_b, out_before)
        mux_b = mux_src(s.msb, s.inp, reg_a, reg_b, out_before)
        reg_a_plus = nib(mux_a)
        reg_b_plus = nib(mux_b)
        out_plus, cout_plus = calc_output(reg_a_plus, reg_b_plus, s.msc, s.cin)
        rows.append(
            {
                "sequence": name,
                "step": idx,
                "label": s.label,
                "MSA": f"{s.msa:02b}",
                "MSB": f"{s.msb:02b}",
                "MSC": f"{s.msc:03b}",
                "INPUT": f"{s.inp:X}",
                "Cin": s.cin,
                "RegA_before": f"{reg_a:X}",
                "RegB_before": f"{reg_b:X}",
                "Output_before": f"{out_before:X}",
                "Cout_before": cout_before,
                "RegA_plus": f"{reg_a_plus:X}",
                "RegB_plus": f"{reg_b_plus:X}",
                "Output_plus": f"{out_plus:X}",
                "Cout_plus": cout_plus,
            }
        )
        reg_a, reg_b = reg_a_plus, reg_b_plus
    return rows


def build_sequences():
    seq = {}
    seq["a"] = [
        Step("Load A", 0b00, 0b10, 0b000, 0xA, 0),
        Step("Load B", 0b01, 0b00, 0b000, 0x3, 0),
        Step("A <- A AND B", 0b11, 0b10, 0b011, 0x0, 0),
    ]
    seq["b"] = [
        Step("Load A", 0b00, 0b10, 0b000, 0xA, 0),
        Step("Load B", 0b01, 0b00, 0b000, 0x5, 0),
        Step("B <- A OR B", 0b01, 0b11, 0b100, 0x0, 0),
    ]
    seq["c"] = [
        Step("Load A", 0b00, 0b10, 0b000, 0x9, 0),
        Step("B <- NOT A", 0b01, 0b11, 0b010, 0x0, 0),
    ]
    seq["d"] = [
        Step("Load A", 0b00, 0b10, 0b000, 0x5, 1),
        Step("Load B", 0b01, 0b00, 0b000, 0x7, 1),
        Step("A <- A+B+Cin", 0b11, 0b10, 0b101, 0x0, 1),
    ]
    seq["e"] = [
        Step("Load A", 0b00, 0b10, 0b000, 0x9, 0),
        Step("B <- A>>1", 0b01, 0b11, 0b111, 0x0, 0),
    ]
    seq["f"] = [
        Step("Load A", 0b00, 0b10, 0b000, 0x6, 0),
        Step("B <- A<<1", 0b01, 0b11, 0b110, 0x0, 0),
    ]
    k = 0xA
    seq["g"] = [
        Step("Load 4 into A", 0b00, 0b10, 0b000, 0x4, 0),
        Step("Load Aconst into B", 0b01, 0b00, 0b000, k, 0),
        Step("A <- A OR B", 0b11, 0b10, 0b100, 0x0, 0),
        Step("Load 6 into B", 0b01, 0b00, 0b000, 0x6, 0),
        Step("A <- A AND B", 0b11, 0b10, 0b011, 0x0, 0),
        Step("A <- A<<1", 0b11, 0b10, 0b110, 0x0, 0),
        Step("A <- A<<1", 0b11, 0b10, 0b110, 0x0, 0),
        Step("Load 3 into B", 0b01, 0b00, 0b000, 0x3, 0),
        Step("A <- A OR B", 0b11, 0b10, 0b100, 0x0, 0),
        Step("A <- NOT A", 0b11, 0b10, 0b010, 0x0, 0),
        Step("A <- A>>1", 0b11, 0b10, 0b111, 0x0, 0),
    ]
    return seq


def assert_expected(results: Dict[str, List[Dict]]):
    def last(seq_name):
        return results[seq_name][-1]

    assert last("a")["RegA_plus"] == "2" and last("a")["RegB_plus"] == "3"
    assert last("b")["RegA_plus"] == "A" and last("b")["RegB_plus"] == "F"
    assert last("c")["RegA_plus"] == "9" and last("c")["RegB_plus"] == "6"
    assert last("d")["RegA_plus"] == "D" and last("d")["RegB_plus"] == "7" and last("d")["Cout_plus"] == 1
    assert last("e")["RegA_plus"] == "9" and last("e")["RegB_plus"] == "4"
    assert last("f")["RegA_plus"] == "6" and last("f")["RegB_plus"] == "C"
    assert last("g")["RegA_plus"] == "2"


def write_outputs(results: Dict[str, List[Dict]], out_dir: Path):
    out_dir.mkdir(parents=True, exist_ok=True)
    all_rows = []
    for name in ["a", "b", "c", "d", "e", "f", "g"]:
        path = out_dir / f"sequence_{name}.csv"
        rows = results[name]
        with path.open("w", newline="", encoding="ascii") as f:
            w = csv.DictWriter(f, fieldnames=list(rows[0].keys()))
            w.writeheader()
            w.writerows(rows)
        all_rows.extend(rows)

    with (out_dir / "all_sequences.csv").open("w", newline="", encoding="ascii") as f:
        w = csv.DictWriter(f, fieldnames=list(all_rows[0].keys()))
        w.writeheader()
        w.writerows(all_rows)

    report = out_dir / "sequence_validation_report.md"
    with report.open("w", encoding="ascii") as f:
        f.write("# RALU Sequence Validation Report\n\n")
        f.write("Generated by `tools/ralu_sequence_checker.py`.\n\n")
        f.write("## Scope\n")
        f.write("- Validates control-word sequences for tasks a~g.\n")
        f.write("- Uses cycle-accurate register update model consistent with Lab4 RALU datapath.\n")
        f.write("- Confirms final register states for each task.\n\n")
        f.write("## Final State Summary\n")
        for k in ["a", "b", "c", "d", "e", "f", "g"]:
            row = results[k][-1]
            f.write(
                f"- {k}: RegA={row['RegA_plus']} RegB={row['RegB_plus']} Output={row['Output_plus']} Cout={row['Cout_plus']}\n"
            )
        f.write("\n## Output Files\n")
        f.write("- `sequence_a.csv`\n")
        f.write("- `sequence_b.csv`\n")
        f.write("- `sequence_c.csv`\n")
        f.write("- `sequence_d.csv`\n")
        f.write("- `sequence_e.csv`\n")
        f.write("- `sequence_f.csv`\n")
        f.write("- `sequence_g.csv`\n")
        f.write("- `all_sequences.csv`\n")


def main():
    sequences = build_sequences()
    results = {}
    for k, steps in sequences.items():
        results[k] = run_sequence(k, steps)
    assert_expected(results)
    out = Path(__file__).resolve().parents[1] / "verification"
    write_outputs(results, out)
    print("OK: generated verification artifacts in", out)


if __name__ == "__main__":
    main()
