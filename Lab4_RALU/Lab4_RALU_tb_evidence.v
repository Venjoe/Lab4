`timescale 1ns/1ps

module Lab4_RALU_tb_evidence;
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
    integer fd;

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

    task expect4;
        input [255:0] name;
        input [3:0] got;
        input [3:0] exp;
    begin
        if (got !== exp) begin
            $display("FAIL %0s got=%h exp=%h t=%0t", name, got, exp, $time);
            $fdisplay(fd, "FAIL %0s got=%h exp=%h t=%0t", name, got, exp, $time);
            errors = errors + 1;
        end
    end
    endtask

    task expect1;
        input [255:0] name;
        input got;
        input exp;
    begin
        if (got !== exp) begin
            $display("FAIL %0s got=%b exp=%b t=%0t", name, got, exp, $time);
            $fdisplay(fd, "FAIL %0s got=%b exp=%b t=%0t", name, got, exp, $time);
            errors = errors + 1;
        end
    end
    endtask

    task log_state;
        input [255:0] tag;
    begin
        $display("%0s | A=%h B=%h OUT=%h Cout=%b", tag, REGA, REGB, OUTPUT_BUS, Cout);
        $fdisplay(fd, "%0s | A=%h B=%h OUT=%h Cout=%b", tag, REGA, REGB, OUTPUT_BUS, Cout);
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

        fd = $fopen("tb_evidence.log", "w");
        $dumpfile("tb_evidence.vcd");
        $dumpvars(0, Lab4_RALU_tb_evidence);

        $display("=== Part A: Table-3 simple function checks ===");
        $fdisplay(fd, "=== Part A: Table-3 simple function checks ===");

        // Load A=0xA, B=0x3
        INPUT_BUS = 4'hA; MSA = 2'b00; MSB = 2'b10; MSC = 3'b000; tick();
        INPUT_BUS = 4'h3; MSA = 2'b01; MSB = 2'b00; MSC = 3'b000; tick();
        log_state("After load A=0xA B=0x3");

        MSC = 3'b000; #1; expect4("MSC000 REGA", OUTPUT_BUS, 4'hA);
        MSC = 3'b001; #1; expect4("MSC001 REGB", OUTPUT_BUS, 4'h3);
        MSC = 3'b010; #1; expect4("MSC010 NOT", OUTPUT_BUS, 4'h5);
        MSC = 3'b011; #1; expect4("MSC011 AND", OUTPUT_BUS, 4'h2);
        MSC = 3'b100; #1; expect4("MSC100 OR", OUTPUT_BUS, 4'hB);
        MSC = 3'b101; #1; expect4("MSC101 SUM", OUTPUT_BUS, 4'hD);
        MSC = 3'b110; #1; expect4("MSC110 SHL", OUTPUT_BUS, 4'h4);
        MSC = 3'b111; #1; expect4("MSC111 SHR", OUTPUT_BUS, 4'h5);
        expect1("No-carry case", Cout, 1'b0);

        $display("=== Part B: Sequence 4g check ===");
        $fdisplay(fd, "=== Part B: Sequence 4g check ===");

        // 4g: OR 4 and A, AND 6, *4, OR 3, complement, /2
        // Use Aconst = 0xA
        Cin = 1'b0;
        INPUT_BUS = 4'h4; MSA = 2'b00; MSB = 2'b10; MSC = 3'b000; tick(); log_state("g1 load 4->A");
        INPUT_BUS = 4'hA; MSA = 2'b01; MSB = 2'b00; MSC = 3'b000; tick(); log_state("g2 load Aconst->B");
        INPUT_BUS = 4'h0; MSA = 2'b11; MSB = 2'b10; MSC = 3'b100; tick(); log_state("g3 A<-A|B");
        INPUT_BUS = 4'h6; MSA = 2'b01; MSB = 2'b00; MSC = 3'b000; tick(); log_state("g4 load 6->B");
        INPUT_BUS = 4'h0; MSA = 2'b11; MSB = 2'b10; MSC = 3'b011; tick(); log_state("g5 A<-A&B");
        INPUT_BUS = 4'h0; MSA = 2'b11; MSB = 2'b10; MSC = 3'b110; tick(); log_state("g6 A<-A<<1");
        INPUT_BUS = 4'h0; MSA = 2'b11; MSB = 2'b10; MSC = 3'b110; tick(); log_state("g7 A<-A<<1");
        INPUT_BUS = 4'h3; MSA = 2'b01; MSB = 2'b00; MSC = 3'b000; tick(); log_state("g8 load 3->B");
        INPUT_BUS = 4'h0; MSA = 2'b11; MSB = 2'b10; MSC = 3'b100; tick(); log_state("g9 A<-A|B");
        INPUT_BUS = 4'h0; MSA = 2'b11; MSB = 2'b10; MSC = 3'b010; tick(); log_state("g10 A<-~A");
        INPUT_BUS = 4'h0; MSA = 2'b11; MSB = 2'b10; MSC = 3'b111; tick(); log_state("g11 A<-A>>1");

        expect4("Final g RegA", REGA, 4'h2);
        expect4("Final g RegB", REGB, 4'h3);

        if (errors == 0) begin
            $display("PASS: Lab4_RALU_tb_evidence completed with 0 errors.");
            $fdisplay(fd, "PASS: Lab4_RALU_tb_evidence completed with 0 errors.");
        end else begin
            $display("FAIL: Lab4_RALU_tb_evidence completed with %0d errors.", errors);
            $fdisplay(fd, "FAIL: Lab4_RALU_tb_evidence completed with %0d errors.", errors);
            $fatal(1);
        end

        $fclose(fd);
        #10;
        $finish;
    end
endmodule
