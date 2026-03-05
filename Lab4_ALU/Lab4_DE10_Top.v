module Lab4_DE10_Top (
    input  wire [9:0] SW,
    input  wire [1:0] KEY,
    output wire [9:0] LEDR
);
    wire [3:0] alu_f;
    wire       alu_cout;
    wire [1:0] alu_s;

    wire [3:0] dbg_fnot;
    wire [3:0] dbg_fsum;
    wire [3:0] dbg_fand;
    wire [3:0] dbg_for;

    assign alu_s = {~KEY[1], ~KEY[0]};

    Lab4_ALU u_lab4_alu (
        .A    (SW[3:0]),
        .B    (SW[7:4]),
        .Cin  (SW[8]),
        .S    (alu_s),
        .F    (alu_f),
        .Cout (alu_cout),
        .Fnot (dbg_fnot),
        .Fsum (dbg_fsum),
        .Fand (dbg_fand),
        .For  (dbg_for)
    );

    assign LEDR[3:0] = alu_f;
    assign LEDR[4]   = alu_cout;

    // Board has limited LEDs. Show 1 debug bit per functional block.
    assign LEDR[5]   = dbg_fnot[0];
    assign LEDR[6]   = dbg_fsum[0];
    assign LEDR[7]   = dbg_fand[0];
    assign LEDR[8]   = dbg_for[0];

    // Keep SW[9] observable to avoid unused input warning.
    assign LEDR[9]   = SW[9];
endmodule
