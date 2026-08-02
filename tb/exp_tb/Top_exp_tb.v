`timescale 1ns/1ps

module Top_exp_tb;

    reg         clk;
    reg         rst;
    reg         Start;
    reg  [15:0] XBus;

    wire        Done;
    wire [17:0] RBus;

    Top_exp dut (
        .clk   (clk),
        .rst   (rst),
        .Start (Start),
        .XBus  (XBus),
        .Done  (Done),
        .RBus  (RBus)
    );

    //========== Clock ==========
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    //========== Test one value ==========
    task test_exp;

    input [15:0]  x;
    input [127:0] name;

    begin
        // Make sure the circuit is idle
        wait (Done == 1'b1);

        XBus = x;

        // Generate a clean Start pulse
        @(negedge clk);
        Start = 1'b1;

        @(negedge clk);
        Start = 1'b0;

        // First wait until the circuit becomes busy
        wait (Done == 1'b0);

        // Then wait until the calculation finishes
        wait (Done == 1'b1);

        // Allow combinational outputs to settle
        #1;

        $display("--------------------------------------");
        $display("x = %s", name);
        $display("XBus = %h", XBus);
        $display("RBus = %h (%0d)", RBus, RBus);
    end

endtask

    //========== Main test ==========
    initial begin

        rst   = 0;
        Start = 0;
        XBus  = 0;

        //---------------------------------------------
        // Reset
        //---------------------------------------------
        #2;
        rst = 1;
        #10;
        rst = 0;

        wait(Done);

        if (Done)
            $display("PASS: circuit is idle after reset");
        else
            $display("FAIL: reset");

        //---------------------------------------------
        // Five test values
        //---------------------------------------------

        test_exp(16'h0000,"0");
        test_exp(16'h2000,"0.125");
        test_exp(16'h4000,"0.25");
        test_exp(16'h8000,"0.5");
        test_exp(16'hFFFF,"1.0");

        //---------------------------------------------
        $display("--------------------------------------");
        $display("All exponential tests completed.");
        $display("--------------------------------------");

        #20;
        $stop;

    end

endmodule