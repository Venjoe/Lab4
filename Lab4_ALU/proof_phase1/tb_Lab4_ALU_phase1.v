`timescale 1ns/1ps

module tb_Lab4_ALU_phase1;
    reg  [3:0] A;
    reg  [3:0] B;
    reg        Cin;
    reg  [1:0] S;
    wire [3:0] F;
    wire       Cout;

    integer tests;
    integer fails;
    integer a_i, b_i, c_i, s_i;
    reg [4:0] add_tmp;
    reg [3:0] expF;
    reg       expCout;

    Lab4_ALU dut (
        .A(A),
        .B(B),
        .Cin(Cin),
        .S(S),
        .F(F),
        .Cout(Cout)
    );

    initial begin
        tests = 0;
        fails = 0;

        $display("================ Phase-1 ALU Verification ================");
        $display("Requirement: Cout is valid only when S=01 (SUM)");

        for (s_i = 0; s_i < 4; s_i = s_i + 1) begin
            for (a_i = 0; a_i < 16; a_i = a_i + 1) begin
                for (b_i = 0; b_i < 16; b_i = b_i + 1) begin
                    for (c_i = 0; c_i < 2; c_i = c_i + 1) begin
                        A   = a_i[3:0];
                        B   = b_i[3:0];
                        Cin = c_i[0];
                        S   = s_i[1:0];
                        #1;

                        add_tmp = {1'b0, A} + {1'b0, B} + Cin;

                        case (S)
                            2'b00: begin
                                expF    = ~A;
                                expCout = 1'b0;
                            end
                            2'b01: begin
                                expF    = add_tmp[3:0];
                                expCout = add_tmp[4];
                            end
                            2'b10: begin
                                expF    = A & B;
                                expCout = 1'b0;
                            end
                            default: begin
                                expF    = A | B;
                                expCout = 1'b0;
                            end
                        endcase

                        tests = tests + 1;
                        if ((F !== expF) || (Cout !== expCout)) begin
                            fails = fails + 1;
                            $display("FAIL S=%b A=%h B=%h Cin=%b -> F=%h Cout=%b | expF=%h expCout=%b",
                                     S, A, B, Cin, F, Cout, expF, expCout);
                        end
                    end
                end
            end
        end

        if (fails == 0) begin
            $display("PASS: %0d/%0d tests passed.", tests, tests);
        end else begin
            $display("FAIL: %0d failures out of %0d tests.", fails, tests);
        end

        $display("==========================================================");
        $finish;
    end
endmodule
