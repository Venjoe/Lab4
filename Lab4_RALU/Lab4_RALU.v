module Lab4_RALU (
    input  wire       CLK,
    input  wire       Cin,
    input  wire [3:0] INPUT_BUS,
    input  wire [1:0] MSA,
    input  wire [1:0] MSB,
    input  wire [2:0] MSC,
    output wire [3:0] REGA,
    output wire [3:0] REGB,
    output wire [3:0] OUTPUT_BUS,
    output wire       Cout,
    output wire [3:0] DBG_MUXA_OUT,
    output wire [3:0] DBG_MUXB_OUT,
    output wire [3:0] DBG_NOT,
    output wire [3:0] DBG_AND,
    output wire [3:0] DBG_OR,
    output wire [3:0] DBG_SUM,
    output wire [3:0] DBG_SHL,
    output wire [3:0] DBG_SHR
);
    reg [3:0] reg_a;
    reg [3:0] reg_b;

    reg [3:0] mux_a_out;
    reg [3:0] mux_b_out;
    reg [3:0] mux_c_out;

    wire [3:0] fn_not;
    wire [3:0] fn_and;
    wire [3:0] fn_or;
    wire [3:0] fn_sum;
    wire [3:0] fn_shl;
    wire [3:0] fn_shr;
    wire       add_cout;

    // MUX A selects source for register A input (Table 2).
    always @(*) begin
        case (MSA)
            2'b00: mux_a_out = INPUT_BUS;
            2'b01: mux_a_out = reg_a;
            2'b10: mux_a_out = reg_b;
            default: mux_a_out = mux_c_out;
        endcase
    end

    // MUX B selects source for register B input (Table 2).
    always @(*) begin
        case (MSB)
            2'b00: mux_b_out = INPUT_BUS;
            2'b01: mux_b_out = reg_a;
            2'b10: mux_b_out = reg_b;
            default: mux_b_out = mux_c_out;
        endcase
    end

    // Registers update on active clock edge.
    always @(posedge CLK) begin
        reg_a <= mux_a_out;
        reg_b <= mux_b_out;
    end

    assign fn_not = ~reg_a;
    assign fn_and = reg_a & reg_b;
    assign fn_or  = reg_a | reg_b;
    assign {add_cout, fn_sum} = reg_a + reg_b + Cin;
    assign fn_shl = {reg_a[2:0], 1'b0};
    assign fn_shr = {1'b0, reg_a[3:1]};

    // MUX C selects output function (Table 3).
    always @(*) begin
        case (MSC)
            3'b000: mux_c_out = reg_a;
            3'b001: mux_c_out = reg_b;
            3'b010: mux_c_out = fn_not;
            3'b011: mux_c_out = fn_and;
            3'b100: mux_c_out = fn_or;
            3'b101: mux_c_out = fn_sum;
            3'b110: mux_c_out = fn_shl;
            default: mux_c_out = fn_shr;
        endcase
    end

    assign REGA       = reg_a;
    assign REGB       = reg_b;
    assign OUTPUT_BUS = mux_c_out;
    assign Cout       = add_cout;

    // Optional debug taps for simulation and hardware visibility.
    assign DBG_MUXA_OUT = mux_a_out;
    assign DBG_MUXB_OUT = mux_b_out;
    assign DBG_NOT      = fn_not;
    assign DBG_AND      = fn_and;
    assign DBG_OR       = fn_or;
    assign DBG_SUM      = fn_sum;
    assign DBG_SHL      = fn_shl;
    assign DBG_SHR      = fn_shr;
endmodule
