module Lab4_RALU_DE10_Top (
    input  wire       DAD_CLK,
    input  wire       DAD_CIN,
    input  wire [3:0] DAD_INPUT,
    input  wire [1:0] DAD_MSA,
    input  wire [1:0] DAD_MSB,
    input  wire [2:0] DAD_MSC,
    output wire [6:0] HEX0,
    output wire [6:0] HEX1,
    output wire [6:0] HEX2,
    output wire       HEX2_DP
);
    wire [3:0] reg_a;
    wire [3:0] reg_b;
    wire [3:0] out_bus;
    wire       out_cout;

    Lab4_RALU u_ralu (
        .CLK          (DAD_CLK),
        .Cin          (DAD_CIN),
        .INPUT_BUS    (DAD_INPUT),
        .MSA          (DAD_MSA),
        .MSB          (DAD_MSB),
        .MSC          (DAD_MSC),
        .REGA         (reg_a),
        .REGB         (reg_b),
        .OUTPUT_BUS   (out_bus),
        .Cout         (out_cout),
        .DBG_MUXA_OUT (),
        .DBG_MUXB_OUT (),
        .DBG_NOT      (),
        .DBG_AND      (),
        .DBG_OR       (),
        .DBG_SUM      (),
        .DBG_SHL      (),
        .DBG_SHR      ()
    );

    assign HEX0 = hex7seg(reg_a);
    assign HEX1 = hex7seg(reg_b);
    assign HEX2 = hex7seg(out_bus);
    assign HEX2_DP = ~out_cout;

    function [6:0] hex7seg;
        input [3:0] v;
        begin
            // Active-low segments on DE10-Lite.
            case (v)
                4'h0: hex7seg = 7'b1000000;
                4'h1: hex7seg = 7'b1111001;
                4'h2: hex7seg = 7'b0100100;
                4'h3: hex7seg = 7'b0110000;
                4'h4: hex7seg = 7'b0011001;
                4'h5: hex7seg = 7'b0010010;
                4'h6: hex7seg = 7'b0000010;
                4'h7: hex7seg = 7'b1111000;
                4'h8: hex7seg = 7'b0000000;
                4'h9: hex7seg = 7'b0010000;
                4'hA: hex7seg = 7'b0001000;
                4'hB: hex7seg = 7'b0000011;
                4'hC: hex7seg = 7'b1000110;
                4'hD: hex7seg = 7'b0100001;
                4'hE: hex7seg = 7'b0000110;
                default: hex7seg = 7'b0001110; // F
            endcase
        end
    endfunction
endmodule
