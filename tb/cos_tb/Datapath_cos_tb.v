`timescale 1ns/1ps

module Datapath_cos_tb;

    reg         clk;
    reg         rst;

    reg         CntUp;
    reg         Init0;

    reg         ldX;
    reg         ldT;
    reg         ldC;

    reg         InitCos;
    reg         SelXR;

    reg  [15:0] XBus;

    wire        Cnt8;
    wire [17:0] RBus;

    Datapath_cos dut (
        .clk     (clk),
        .rst     (rst),

        .CntUp   (CntUp),
        .Init0   (Init0),

        .ldX     (ldX),
        .ldT     (ldT),
        .ldC     (ldC),

        .InitCos (InitCos),
        .SelXR   (SelXR),

        .XBus    (XBus),

        .Cnt8    (Cnt8),
        .RBus    (RBus)
    );

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst     = 1'b0;

        CntUp   = 1'b0;
        Init0   = 1'b0;

        ldX     = 1'b0;
        ldT     = 1'b0;
        ldC     = 1'b0;

        InitCos = 1'b0;
        SelXR   = 1'b0;

        XBus    = 16'h0000;

        // Reset
        #2;
        rst = 1'b1;

        #10;
        rst = 1'b0;

        // Initialize for x = 0.5
        XBus    = 16'h8000;

        ldX     = 1'b1;
        ldT     = 1'b1;
        ldC     = 1'b1;

        InitCos = 1'b1;
        Init0   = 1'b1;

        #10;

        ldX     = 1'b0;
        ldT     = 1'b0;
        ldC     = 1'b0;

        InitCos = 1'b0;
        Init0   = 1'b0;

        if (RBus !== 18'h10000)
            $display(
                "FAIL: initialization, expected 10000, actual = %h",
                RBus
            );
        else
            $display(
                "PASS: initialization, RBus = %h",
                RBus
            );

        // Iteration 1
        // T = 1 × x × x × 1/2

        SelXR = 1'b1;
        ldT   = 1'b1;
        #10;
        ldT   = 1'b0;

        SelXR = 1'b1;
        ldT   = 1'b1;
        #10;
        ldT   = 1'b0;

        SelXR = 1'b0;
        ldT   = 1'b1;
        #10;
        ldT   = 1'b0;

        ldC   = 1'b1;
        CntUp = 1'b1;
        #10;
        ldC   = 1'b0;
        CntUp = 1'b0;

        // Expected about 0.875
        if ((RBus < 18'h0DFFE) || (RBus > 18'h0E002))
            $display(
                "FAIL: iteration 1, RBus = %h",
                RBus
            );
        else
            $display(
                "PASS: iteration 1, RBus = %h",
                RBus
            );

        // Iteration 2
        // T = previous × x × x × 1/12

        SelXR = 1'b1;
        ldT   = 1'b1;
        #10;
        ldT   = 1'b0;

        SelXR = 1'b1;
        ldT   = 1'b1;
        #10;
        ldT   = 1'b0;

        SelXR = 1'b0;
        ldT   = 1'b1;
        #10;
        ldT   = 1'b0;

        ldC   = 1'b1;
        CntUp = 1'b1;
        #10;
        ldC   = 1'b0;
        CntUp = 1'b0;

        // Expected about 0.877604
        if ((RBus < 18'h0E0A0) || (RBus > 18'h0E0B5))
            $display(
                "FAIL: iteration 2, RBus = %h",
                RBus
            );
        else
            $display(
                "PASS: iteration 2, RBus = %h",
                RBus
            );

        #10;
        $stop;
    end

endmodule