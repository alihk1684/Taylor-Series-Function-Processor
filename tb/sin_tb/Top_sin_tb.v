`timescale 1ns/1ps

module Top_sin_tb;

    reg         clk;
    reg         rst;
    reg         Start;
    reg  [15:0] XBus;

    wire        Done;
    wire [17:0] RBus;

    Top_sin dut (

        .clk   (clk),
        .rst   (rst),
        .Start (Start),
        .XBus  (XBus),

        .Done  (Done),
        .RBus  (RBus)

    );

    //---------------------------------------------------
    // Clock
    //---------------------------------------------------
    initial begin

        clk = 0;

        forever #5 clk = ~clk;

    end

    //---------------------------------------------------
    // Test Task
    //---------------------------------------------------
    task test_sin;

        input [15:0] x;
        input [127:0] name;

        begin

            wait(Done == 1);

            XBus = x;

            @(negedge clk);
            Start = 1;

            @(negedge clk);
            Start = 0;

            wait(Done == 0);
            wait(Done == 1);

            #1;

            $display("--------------------------------");
            $display("x    = %s",name);
            $display("XBus = %h",XBus);
            $display("RBus = %h (%0d)",RBus,RBus);

        end

    endtask

    //---------------------------------------------------
    // Main
    //---------------------------------------------------
    initial begin

        rst   = 0;
        Start = 0;
        XBus  = 0;

        #2;
        rst = 1;

        #10;
        rst = 0;

        wait(Done);

        $display("PASS: idle after reset");

        //--------------------------------

        test_sin(16'h0000,"0");
        test_sin(16'h2000,"0.125");
        test_sin(16'h4000,"0.25");
        test_sin(16'h8000,"0.5");
        test_sin(16'hFFFF,"1.0");

        //--------------------------------

        $display("--------------------------------");
        $display("All sine tests completed.");
        $display("--------------------------------");

        #20;
        $stop;

    end

endmodule