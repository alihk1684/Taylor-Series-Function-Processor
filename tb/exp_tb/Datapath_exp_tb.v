`timescale 1ns/1ps

module Datapath_exp_tb;

    reg         clk;
    reg         rst;
    reg         CntUp;
    reg         Init0;
    reg         ldX;
    reg         ldT;
    reg         IT1;
    reg         ldE;
    reg         IE1;
    reg         SelXR;
    reg  [15:0] XBus;

    wire        Cnt8;
    wire [17:0] RBus;

    Datapath_exp dut (
        .clk   (clk),
        .rst   (rst),
        .CntUp (CntUp),
        .Init0 (Init0),
        .ldX   (ldX),
        .ldT   (ldT),
        .IT1   (IT1),
        .ldE   (ldE),
        .IE1   (IE1),
        .SelXR (SelXR),
        .XBus  (XBus),
        .Cnt8  (Cnt8),
        .RBus  (RBus)
    );

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst   = 1'b0;
        CntUp = 1'b0;
        Init0 = 1'b0;
        ldX   = 1'b0;
        ldT   = 1'b0;
        IT1   = 1'b0;
        ldE   = 1'b0;
        IE1   = 1'b0;
        SelXR = 1'b0;
        XBus  = 16'h0000;

        // Reset
        #2;
        rst = 1'b1;
        #10;
        rst = 1'b0;

        // Initialize datapath and load x = 0.5
        XBus  = 16'h8000;
        ldX   = 1'b1;
        IT1   = 1'b1;
        IE1   = 1'b1;
        Init0 = 1'b1;

        #10;

        ldX   = 1'b0;
        IT1   = 1'b0;
        IE1   = 1'b0;
        Init0 = 1'b0;

        if (RBus !== 18'h10000)
            $display("FAIL: initialization, RBus = %h", RBus);
        else
            $display("PASS: initialization");

        // Iteration 1, Mult1: T = T * X
        SelXR = 1'b1;
        ldT   = 1'b1;
        #10;
        ldT   = 1'b0;

        // Iteration 1, Mult2: T = T * 1
        SelXR = 1'b0;
        ldT   = 1'b1;
        #10;
        ldT   = 1'b0;

        // Iteration 1, Add: E = E + T, counter++
        ldE   = 1'b1;
        CntUp = 1'b1;
        #10;
        ldE   = 1'b0;
        CntUp = 1'b0;

        // Due to using FFFF as approximately 1.0,
        // result may be slightly below exact 1.5.
        if ((RBus < 18'h17FFD) || (RBus > 18'h18000))
            $display("FAIL: iteration 1, RBus = %h", RBus);
        else
            $display("PASS: iteration 1, RBus = %h", RBus);

        // Iteration 2, Mult1: T = previous T * X
        SelXR = 1'b1;
        ldT   = 1'b1;
        #10;
        ldT   = 1'b0;

        // Iteration 2, Mult2: multiply by 1/2
        SelXR = 1'b0;
        ldT   = 1'b1;
        #10;
        ldT   = 1'b0;

        // Iteration 2, Add
        ldE   = 1'b1;
        CntUp = 1'b1;
        #10;
        ldE   = 1'b0;
        CntUp = 1'b0;

        // Expected approximately 1.625
        if ((RBus < 18'h19FFA) || (RBus > 18'h1A000))
            $display("FAIL: iteration 2, RBus = %h", RBus);
        else
            $display("PASS: iteration 2, RBus = %h", RBus);

        #10;
        $stop;
    end

endmodule