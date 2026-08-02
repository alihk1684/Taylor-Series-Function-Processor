`timescale 1ns/1ps

module CntReg_tb;

    reg        clk;
    reg        rst;
    reg        CntUp;
    reg        Init0;

    wire [2:0] cnt;

    CntReg dut (
        .clk   (clk),
        .rst   (rst),
        .CntUp (CntUp),
        .Init0 (Init0),
        .cnt   (cnt)
    );

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst   = 1'b0;
        CntUp = 1'b0;
        Init0 = 1'b0;

        // Reset test
        #2;
        rst = 1'b1;
        #10;
        rst = 1'b0;

        if (cnt !== 3'd0)
            $display("FAIL: reset test, cnt = %d", cnt);
        else
            $display("PASS: reset test");

        // Count up once
        CntUp = 1'b1;
        #10;
        CntUp = 1'b0;

        if (cnt !== 3'd1)
            $display("FAIL: first count test, cnt = %d", cnt);
        else
            $display("PASS: first count test");

        // Count up three more times
        CntUp = 1'b1;
        #30;
        CntUp = 1'b0;

        if (cnt !== 3'd4)
            $display("FAIL: multiple count test, cnt = %d", cnt);
        else
            $display("PASS: multiple count test");

        // Hold test
        #20;

        if (cnt !== 3'd4)
            $display("FAIL: hold test, cnt = %d", cnt);
        else
            $display("PASS: hold test");

        // Initialize to zero
        Init0 = 1'b1;
        #10;
        Init0 = 1'b0;

        if (cnt !== 3'd0)
            $display("FAIL: Init0 test, cnt = %d", cnt);
        else
            $display("PASS: Init0 test");

        #10;
        $stop;
    end

endmodule