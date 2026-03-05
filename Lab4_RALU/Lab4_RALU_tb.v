`timescale 1ns/1ps

module Lab4_RALU_tb;
    reg        CLK;
    reg        Cin;
    reg  [3:0] INPUT_BUS;
    reg  [1:0] MSA;
    reg  [1:0] MSB;
    reg  [2:0] MSC;

    wire [3:0] REGA;
    wire [3:0] REGB;
    wire [3:0] OUTPUT_BUS;
    wire       Cout;
    wire [3:0] DBG_MUXA_OUT;
    wire [3:0] DBG_MUXB_OUT;
    wire [3:0] DBG_NOT;
    wire [3:0] DBG_AND;
    wire [3:0] DBG_OR;
    wire [3:0] DBG_SUM;
    wire [3:0] DBG_SHL;
    wire [3:0] DBG_SHR;

    integer errors;

    Lab4_RALU dut (
        .CLK(CLK),
        .Cin(Cin),
        .INPUT_BUS(INPUT_BUS),
        .MSA(MSA),
        .MSB(MSB),
        .MSC(MSC),
        .REGA(REGA),
        .REGB(REGB),
        .OUTPUT_BUS(OUTPUT_BUS),
        .Cout(Cout),
        .DBG_MUXA_OUT(DBG_MUXA_OUT),
        .DBG_MUXB_OUT(DBG_MUXB_OUT),
        .DBG_NOT(DBG_NOT),
        .DBG_AND(DBG_AND),
        .DBG_OR(DBG_OR),
        .DBG_SUM(DBG_SUM),
        .DBG_SHL(DBG_SHL),
        .DBG_SHR(DBG_SHR)
    );

    always #5 CLK = ~CLK;

    task tick;
    begin
        @(posedge CLK);
        #1;
    end
    endtask

    task check4;
        input [255:0] name;
        input [3:0] got;
        input [3:0] exp;
    begin
        if (got !== exp) begin
            $display("FAIL: %0s got=%h exp=%h at t=%0t", name, got, exp, $time);
            errors = errors + 1;
        end
    end
    endtask

    task check1;
        input [255:0] name;
        input got;
        input exp;
    begin
        if (got !== exp) begin
            $display("FAIL: %0s got=%b exp=%b at t=%0t", name, got, exp, $time);
            errors = errors + 1;
        end
    end
    endtask

    initial begin
        CLK = 1'b0;
        Cin = 1'b0;
        INPUT_BUS = 4'h0;
        MSA = 2'b00;
        MSB = 2'b00;
        MSC = 3'b000;
        errors = 0;

        // Load A and B with 0xA.
        INPUT_BUS = 4'hA;
        MSA = 2'b00; // INPUT -> A
        MSB = 2'b00; // INPUT -> B
        tick();

        // Keep A, load B with 0x3.
        INPUT_BUS = 4'h3;
        MSA = 2'b01; // A -> A (hold)
        MSB = 2'b00; // INPUT -> B
        tick();

        check4("REGA load", REGA, 4'hA);
        check4("REGB load", REGB, 4'h3);

        MSC = 3'b000; #1; check4("MSC=000 REGA", OUTPUT_BUS, 4'hA);
        MSC = 3'b001; #1; check4("MSC=001 REGB", OUTPUT_BUS, 4'h3);
        MSC = 3'b010; #1; check4("MSC=010 NOT A", OUTPUT_BUS, 4'h5);
        MSC = 3'b011; #1; check4("MSC=011 A AND B", OUTPUT_BUS, 4'h2);
        MSC = 3'b100; #1; check4("MSC=100 A OR B", OUTPUT_BUS, 4'hB);
        MSC = 3'b101; #1; check4("MSC=101 A+B+Cin", OUTPUT_BUS, 4'hD);
        MSC = 3'b110; #1; check4("MSC=110 SHL A", OUTPUT_BUS, 4'h4);
        MSC = 3'b111; #1; check4("MSC=111 SHR A", OUTPUT_BUS, 4'h5);

        check1("Cout no carry", Cout, 1'b0);

        // Drive a carry-producing case: A=0xF, B=0x1, Cin=1 => SUM=1, Cout=1.
        INPUT_BUS = 4'hF;
        MSA = 2'b00; // INPUT -> A
        MSB = 2'b10; // B -> B (hold old B)
        tick();

        INPUT_BUS = 4'h1;
        MSA = 2'b01; // A -> A (hold)
        MSB = 2'b00; // INPUT -> B
        tick();

        Cin = 1'b1;
        MSC = 3'b101;
        #1;

        check4("Carry SUM", OUTPUT_BUS, 4'h1);
        check1("Carry Cout", Cout, 1'b1);

        if (errors == 0) begin
            $display("PASS: Lab4_RALU_tb completed with 0 errors.");
        end else begin
            $display("FAIL: Lab4_RALU_tb completed with %0d errors.", errors);
            $fatal(1);
        end

        #10;
        $finish;
    end
endmodule
