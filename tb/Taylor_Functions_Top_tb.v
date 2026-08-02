`timescale 1ns/1ps

module Taylor_Functions_Top_tb;

    reg         clk;
    reg         rst;
    reg         Start;
    reg  [15:0] XBus;
    reg  [1:0]  Func;

    wire [17:0] RBus;
    wire        Done;

    integer pass_count;
    integer fail_count;

    Taylor_Functions_Top dut (
        .clk   (clk),
        .rst   (rst),
        .Start (Start),
        .XBus  (XBus),
        .Func  (Func),
        .RBus  (RBus),
        .Done  (Done)
    );

    // 10 ns clock period
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    // ----------------------------------------------------
    // Test one function/input combination
    // ----------------------------------------------------
    task test_function;

        input [1:0]   test_func;
        input [15:0]  test_x;
        input [17:0]  expected;
        input [17:0]  tolerance;
        input [127:0] function_name;
        input [127:0] x_name;

	reg [18:0] difference;

        begin
            // Wait until the currently selected block is idle
            wait (Done == 1'b1);

            Func = test_func;
            XBus = test_x;

            // Clean one-clock Start pulse
            @(negedge clk);
            Start = 1'b1;

            @(negedge clk);
            Start = 1'b0;

            // Wait for the chosen function to become busy
            wait (Done == 1'b0);

            // Wait for completion
            wait (Done == 1'b1);

            #1;

	    if (RBus >= expected)
       		difference = RBus - expected;
    	    else
        	difference = expected - RBus;

            $display("--------------------------------------------------");
            $display(
                "Function = %s, Func = %b, x = %s, XBus = %h",
                function_name,
                test_func,
                x_name,
                test_x
            );

            $display(
                "RBus = %h (%0d), expected = %h (%0d)",
                RBus,
                RBus,
                expected,
                expected
            );

            if (difference <= tolerance) begin
                $display("PASS");
                pass_count = pass_count + 1;
            end
            else begin
                $display("FAIL");
                fail_count = fail_count + 1;
            end
        end

    endtask

    initial begin
        rst        = 1'b0;
        Start      = 1'b0;
        XBus       = 16'h0000;
        Func       = 2'b00;
        pass_count = 0;
        fail_count = 0;

        // Reset
        #2;
        rst = 1'b1;

        #10;
        rst = 1'b0;

        wait (Done == 1'b1);

        $display("==================================================");
        $display("Final Taylor Functions Testbench");
        $display("==================================================");

        // =================================================
        // exp(x), Func = 00
        // =================================================
        test_function(2'b00, 16'h0000, 18'h10000, 18'd4, "exp(x)", "0");
        test_function(2'b00, 16'h1000, 18'h1107F, 18'd4, "exp(x)", "0.0625");
        test_function(2'b00, 16'h2000, 18'h12211, 18'd4, "exp(x)", "0.125");
        test_function(2'b00, 16'h4000, 18'h148B1, 18'd4, "exp(x)", "0.25");
        test_function(2'b00, 16'h6000, 18'h17474, 18'd4, "exp(x)", "0.375");
        test_function(2'b00, 16'h8000, 18'h1A60C, 18'd4, "exp(x)", "0.5");
        test_function(2'b00, 16'hA000, 18'h1DE3F, 18'd4, "exp(x)", "0.625");
        test_function(2'b00, 16'hC000, 18'h21DEC, 18'd4, "exp(x)", "0.75");
        test_function(2'b00, 16'hE000, 18'h26614, 18'd4, "exp(x)", "0.875");
        test_function(2'b00, 16'hFFFF, 18'h2B7D6, 18'd4, "exp(x)", "1.0");

        // =================================================
        // sin(x), Func = 01
        // =================================================
        test_function(2'b01, 16'h0000, 18'h00000, 18'd4, "sin(x)", "0");
        test_function(2'b01, 16'h1000, 18'h00FFE, 18'd4, "sin(x)", "0.0625");
        test_function(2'b01, 16'h2000, 18'h01FEB, 18'd4, "sin(x)", "0.125");
        test_function(2'b01, 16'h4000, 18'h03F56, 18'd4, "sin(x)", "0.25");
        test_function(2'b01, 16'h6000, 18'h05DC4, 18'd4, "sin(x)", "0.375");
        test_function(2'b01, 16'h8000, 18'h07ABC, 18'd4, "sin(x)", "0.5");
        test_function(2'b01, 16'hA000, 18'h095CA, 18'd4, "sin(x)", "0.625");
        test_function(2'b01, 16'hC000, 18'h0AE80, 18'd4, "sin(x)", "0.75");
        test_function(2'b01, 16'hE000, 18'h0C47E, 18'd4, "sin(x)", "0.875");
        test_function(2'b01, 16'hFFFF, 18'h0D76B, 18'd4, "sin(x)", "1.0");

        // =================================================
        // cos(x), Func = 10
        // =================================================
        test_function(2'b10, 16'h0000, 18'h10000, 18'd4, "cos(x)", "0");
        test_function(2'b10, 16'h1000, 18'h0FF81, 18'd4, "cos(x)", "0.0625");
        test_function(2'b10, 16'h2000, 18'h0FE01, 18'd4, "cos(x)", "0.125");
        test_function(2'b10, 16'h4000, 18'h0F80B, 18'd4, "cos(x)", "0.25");
        test_function(2'b10, 16'h6000, 18'h0EE36, 18'd4, "cos(x)", "0.375");
        test_function(2'b10, 16'h8000, 18'h0E0AA, 18'd4, "cos(x)", "0.5");
        test_function(2'b10, 16'hA000, 18'h0CF9C, 18'd4, "cos(x)", "0.625");
        test_function(2'b10, 16'hC000, 18'h0BB50, 18'd4, "cos(x)", "0.75");
        test_function(2'b10, 16'hE000, 18'h0A419, 18'd4, "cos(x)", "0.875");
        test_function(2'b10, 16'hFFFF, 18'h08A53, 18'd4, "cos(x)", "1.0");

        // =================================================
        // ln(1+x), Func = 11
        //
        // These expected values correspond to the limited
        // nine-term Maclaurin implementation.
        // =================================================
        test_function(2'b11, 16'h0000, 18'h00000, 18'd4, "ln(1+x)", "0");
        test_function(2'b11, 16'h1000, 18'h00F85, 18'd4, "ln(1+x)", "0.0625");
        test_function(2'b11, 16'h2000, 18'h01E27, 18'd4, "ln(1+x)", "0.125");
        test_function(2'b11, 16'h4000, 18'h03920, 18'd4, "ln(1+x)", "0.25");
        test_function(2'b11, 16'h6000, 18'h05185, 18'd4, "ln(1+x)", "0.375");
        test_function(2'b11, 16'h8000, 18'h067D0, 18'd4, "ln(1+x)", "0.5");
        test_function(2'b11, 16'hA000, 18'h07C6F, 18'd4, "ln(1+x)", "0.625");
        test_function(2'b11, 16'hC000, 18'h0901D, 18'd4, "ln(1+x)", "0.75");
        test_function(2'b11, 16'hE000, 18'h0A4AC, 18'd4, "ln(1+x)", "0.875");
        test_function(2'b11, 16'hFFFF, 18'h0BEDE, 18'd4, "ln(1+x)", "1.0");

        $display("==================================================");
        $display("FINAL TEST SUMMARY");
        $display("Passed tests = %0d", pass_count);
        $display("Failed tests = %0d", fail_count);
        $display("Total tests  = %0d", pass_count + fail_count);

        if (fail_count == 0)
            $display("FINAL RESULT: ALL TESTS PASSED");
        else
            $display("FINAL RESULT: SOME TESTS FAILED");

        $display("==================================================");

        #20;
        $stop;
    end

endmodule