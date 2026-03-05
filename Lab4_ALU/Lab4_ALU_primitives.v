module BITWISE_NOT4 (
    input  wire [3:0] IN,
    output wire [3:0] OUT
);
    assign OUT = ~IN;
endmodule

module BITWISE_AND4 (
    input  wire [3:0] IN1,
    input  wire [3:0] IN2,
    output wire [3:0] OUT
);
    assign OUT = IN1 & IN2;
endmodule

module BITWISE_OR4 (
    input  wire [3:0] IN1,
    input  wire [3:0] IN2,
    output wire [3:0] OUT
);
    assign OUT = IN1 | IN2;
endmodule

module ADDER4_CIN (
    input  wire [3:0] A,
    input  wire [3:0] B,
    input  wire       CIN,
    output wire [3:0] SUM,
    output wire       Cout
);
    assign {Cout, SUM} = A + B + CIN;
endmodule

module ALU_MUX4 (
    input  wire [3:0] IN0,
    input  wire [3:0] IN1,
    input  wire [3:0] IN2,
    input  wire [3:0] IN3,
    input  wire [1:0] SEL,
    output reg  [3:0] Y
);
    always @(*) begin
        case (SEL)
            2'b00: Y = IN0;
            2'b01: Y = IN1;
            2'b10: Y = IN2;
            default: Y = IN3;
        endcase
    end
endmodule


module COUT_SUM_ONLY (
    input  wire [3:0] A,
    input  wire [3:0] B,
    input  wire       CIN,
    input  wire [1:0] S,
    output wire       COUT_SEL
);
    wire [4:0] add_tmp;
    assign add_tmp  = {1'b0, A} + {1'b0, B} + CIN;
    assign COUT_SEL = (~S[1]) & S[0] & add_tmp[4];
endmodule
