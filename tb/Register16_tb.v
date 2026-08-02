`timescale 1ns/1ps

module Register16_tb;

    reg         clk;
    reg         rst;
    reg         Init1;
    reg         load;
    reg  [15:0] in;

    wire [15:0] out;

    Register16 dut (
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
        in    = 16'h0000;

        // Test reset
        #2;
        rst = 1'b1;
        #10;
        rst = 1'b0;

        if (out !== 16'h0000)
            $display("FAIL: reset test, out = %h", out);
        else
            $display("PASS: reset test");

        // Test initialization to approximately 1
        Init1 = 1'b1;
        #10;
        Init1 = 1'b0;

        if (out !== 16'hFFFF)
            $display("FAIL: Init1 test, out = %h", out);
        else
            $display("PASS: Init1 test");

        // Test loading 0.5
        in   = 16'h8000;
        load = 1'b1;
        #10;
        load = 1'b0;

        if (out !== 16'h8000)
            $display("FAIL: load test, out = %h", out);
        else
            $display("PASS: load test");

        // Test hold behaviour
        in = 16'h4000;
        #20;

        if (out !== 16'h8000)
            $display("FAIL: hold test, out = %h", out);
        else
            $display("PASS: hold test");

        #10;
        $stop;
    end

endmodule