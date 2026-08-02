`timescale 1ns/1ps

module Register18_tb;

    reg         clk;
    reg         rst;
    reg         Init1;
    reg         load;
    reg  [17:0] in;

    wire [17:0] out;

    Register18 dut (
        .clk   (clk),
        .rst   (rst),
        .Init1 (Init1),
        .load  (load),
        .in    (in),
        .out   (out)
    );

    // 10 ns clock period
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst   = 1'b0;
        Init1 = 1'b0;
        load  = 1'b0;
        in    = 18'h00000;

        // Test reset
        #2;
        rst = 1'b1;
        #10;
        rst = 1'b0;

        if (out !== 18'h00000)
            $display("FAIL: reset test, out = %h", out);
        else
            $display("PASS: reset test");

        // Test initialization to exact 1.0
        Init1 = 1'b1;
        #10;
        Init1 = 1'b0;

        if (out !== 18'h10000)
            $display("FAIL: Init1 test, out = %h", out);
        else
            $display("PASS: Init1 test");

        // Test loading 1.5
        in   = 18'h18000;
        load = 1'b1;
        #10;
        load = 1'b0;

        if (out !== 18'h18000)
            $display("FAIL: load test, out = %h", out);
        else
            $display("PASS: load test");

        // Test hold behaviour
        in = 18'h20000;
        #20;

        if (out !== 18'h18000)
            $display("FAIL: hold test, out = %h", out);
        else
            $display("PASS: hold test");

        #10;
        $stop;
    end

endmodule