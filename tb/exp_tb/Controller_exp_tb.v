`timescale 1ns/1ps

module Controller_exp_tb;

    reg clk;
    reg rst;
    reg Start;
    reg Cnt8;

    wire Done;
    wire ldX;
    wire IT1;
    wire IE1;
    wire ldT;
    wire ldE;
    wire Init0;
    wire CntUp;
    wire SelXR;

    Controller_exp dut (
        .clk   (clk),
        .rst   (rst),
        .Start (Start),
        .Cnt8  (Cnt8),

        .Done  (Done),
        .ldX   (ldX),
        .IT1   (IT1),
        .IE1   (IE1),
        .ldT   (ldT),
        .ldE   (ldE),
        .Init0 (Init0),
        .CntUp (CntUp),
        .SelXR (SelXR)
    );

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst   = 1'b0;
        Start = 1'b0;
        Cnt8  = 1'b0;

        // Reset
        #2;
        rst = 1'b1;
        #10;
        rst = 1'b0;

        #1;

        if (Done !== 1'b1)
            $display("FAIL: controller is not idle after reset");
        else
            $display("PASS: idle after reset");

        // Request start
        Start = 1'b1;
        #10;

        if (Done !== 1'b0)
            $display("FAIL: Done should be low while starting");
        else
            $display("PASS: entered Starting state");

        // Keep Start high for another cycle
        #10;

        if (ldX !== 1'b0)
            $display("FAIL: controller should wait for Start to go low");
        else
            $display("PASS: waits while Start is high");

        // Release Start
        Start = 1'b0;
        #10;

        // Now controller should be in GET_INPUT
        if (
            ldX   !== 1'b1 ||
            IT1   !== 1'b1 ||
            IE1   !== 1'b1 ||
            Init0 !== 1'b1
        )
            $display("FAIL: GetInput control signals incorrect");
        else
            $display("PASS: GetInput control signals");

        #10;

        // MULT1
        if (ldT !== 1'b1 || SelXR !== 1'b1)
            $display("FAIL: Mult1 control signals incorrect");
        else
            $display("PASS: Mult1 control signals");

        #10;

        // MULT2
        if (ldT !== 1'b1 || SelXR !== 1'b0)
            $display("FAIL: Mult2 control signals incorrect");
        else
            $display("PASS: Mult2 control signals");

        #10;

        // ADD, with Cnt8 = 0
        if (ldE !== 1'b1 || CntUp !== 1'b1)
            $display("FAIL: Add control signals incorrect");
        else
            $display("PASS: Add control signals");

        #10;

        // Should return to MULT1
        if (ldT !== 1'b1 || SelXR !== 1'b1)
            $display("FAIL: controller did not repeat iteration");
        else
            $display("PASS: repeated iteration");

        // Allow MULT2
        #10;

        // Before ADD state, tell controller this is final iteration
        Cnt8 = 1'b1;
        #10;

        // Controller is now in ADD
        if (ldE !== 1'b1 || CntUp !== 1'b1)
            $display("FAIL: final Add control signals incorrect");
        else
            $display("PASS: final Add control signals");

        // Next clock should return to IDLE
        #10;
        Cnt8 = 1'b0;

        if (Done !== 1'b1)
            $display("FAIL: controller did not return to Idle");
        else
            $display("PASS: returned to Idle");

        #10;
        $stop;
    end

endmodule