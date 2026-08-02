`timescale 1ns/1ps

module Top_ln_tb;

    reg         clk;
    reg         rst;
    reg         Start;
    reg  [15:0] XBus;

    wire        Done;
    wire [17:0] RBus;

    Top_ln dut (
        .clk   (clk),
        .rst   (rst),
        .Start (Start),
        .XBus  (XBus),
        .Done  (Done),
        .RBus  (RBus)
    );

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    task test_ln;
        input [15:0]  x;
        input [127:0] name;

        begin
            wait (Done == 1'b1);

            XBus = x;

            @(negedge clk);
            Start = 1'b1;

            @(negedge clk);
            Start = 1'b0;

            wait (Done == 1'b0);
            wait (Done == 1'b1);

            #1;

            $display("--------------------------------");
            $display("x       = %s", name);
            $display("XBus    = %h", XBus);
            $display("ln(1+x) = %h (%0d)", RBus, RBus);
        end
    endtask

    initial begin
        rst   = 1'b0;
        Start = 1'b0;
        XBus  = 16'h0000;

        #2;
        rst = 1'b1;

        #10;
        rst = 1'b0;

        wait (Done == 1'b1);

        if (Done)
            $display("PASS: idle after reset");
        else
            $display("FAIL: reset");

        test_ln(16'h0000, "0");
        test_ln(16'h2000, "0.125");
        test_ln(16'h4000, "0.25");
        test_ln(16'h8000, "0.5");
        test_ln(16'hFFFF, "1.0");

        $display("--------------------------------");
        $display("All logarithm tests completed.");
        $display("--------------------------------");

        #20;
        $stop;
    end

endmodule