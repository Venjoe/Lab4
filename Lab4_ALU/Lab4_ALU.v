module Lab4_ALU (
    input  wire [3:0] A,
    input  wire [3:0] B,
    input  wire       Cin,
    input  wire [1:0] S,
    output reg  [3:0] F,
    output reg        Cout
);
    wire [4:0] add_full;
    assign add_full = {1'b0, A} + {1'b0, B} + Cin;

    always @(*) begin
        case (S)
            2'b00: begin
                F = ~A;
                Cout = 1'b0;
            end
            2'b01: begin
                F = add_full[3:0];
                Cout = add_full[4];
            end
            2'b10: begin
                F = A & B;
                Cout = 1'b0;
            end
            default: begin
                F = A | B;
                Cout = 1'b0;
            end
        endcase
    end
endmodule
