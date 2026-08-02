`timescale 1ns/1ps

module Datapath_sin_tb;

    reg         clk;
    reg         rst;

    reg         CntUp;
    reg         Init0;

    reg         ldX;
    reg         ldT;
    reg         ldS;

    reg         InitSin;
    reg         SelXR;

    reg  [15:0] XBus;

    wire        Cnt8;
    wire [17:0] RBus;

    Datapath_sin dut (
        .clk     (clk),
        .rst     (rst),

        .CntUp   (CntUp),
        .Init0   (Init0),

        .ldX     (ldX),
        .ldT     (ldT),
        .ldS     (ldS),

        .InitSin (InitSin),
        .SelXR   (SelXR),

        .XBus    (XBus),

        .Cnt8    (Cnt8),
        .RBus    (RBus)
    );

    // 10 ns clock period
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
        ldS     = 1'b0;

        InitSin = 1'b0;
        SelXR   = 1'b0;

        XBus    = 16'h0000;

        // ------------------------------------------------
        // Reset
        // ------------------------------------------------
        #2;
        rst = 1'b1;

        #10;
        rst = 1'b0;

        // ------------------------------------------------
        // Initialize for x = 0.5
        //
        // XReg <- 0.5
        // TReg <- 0.5
        // SReg <- 0.5
        // Counter <- 0
        // ------------------------------------------------
        XBus    = 16'h8000;

        ldX     = 1'b1;
        ldT     = 1'b1;
        ldS     = 1'b1;

        InitSin = 1'b1;
        Init0   = 1'b1;

        #10;

        ldX     = 1'b0;
        ldT     = 1'b0;
        ldS     = 1'b0;

        InitSin = 1'b0;
        Init0   = 1'b0;

        if (RBus !== 18'h08000)
            $display(
                "FAIL: initialization, expected 08000, actual = %h",
                RBus
            );
        else
            $display(
                "PASS: initialization, RBus = %h",
                RBus
            );

        // =================================================
        // ITERATION 1
        // T = x^3 / 6
        // S = x - T
        // =================================================

        // T <- T × X
        SelXR = 1'b1;
        ldT   = 1'b1;
        #10;
        ldT   = 1'b0;

        // T <- T × X again
        SelXR = 1'b1;
        ldT   = 1'b1;
        #10;
        ldT   = 1'b0;

        // T <- T × LUT[0] = T × 1/6
        SelXR = 1'b0;
        ldT   = 1'b1;
        #10;
        ldT   = 1'b0;

        // S <- S - T, counter++
        ldS   = 1'b1;
        CntUp = 1'b1;
        #10;
        ldS   = 1'b0;
        CntUp = 1'b0;

        // Expected approximately 0.47917
        // Expected fixed-point result is around 18'h07AAB.
        if ((RBus < 18'h07AA5) || (RBus > 18'h07AB0))
            $display(
                "FAIL: iteration 1, RBus = %h",
                RBus
            );
        else
            $display(
                "PASS: iteration 1, RBus = %h",
                RBus
            );

        // =================================================
        // ITERATION 2
        // T = x^5 / 120
        // S = previous S + T
        // =================================================

        // T <- T × X
        SelXR = 1'b1;
        ldT   = 1'b1;
        #10;
        ldT   = 1'b0;

        // T <- T × X again
        SelXR = 1'b1;
        ldT   = 1'b1;
        #10;
        ldT   = 1'b0;

        // T <- T × LUT[1] = T × 1/20
        SelXR = 1'b0;
        ldT   = 1'b1;
        #10;
        ldT   = 1'b0;

        // Counter is now odd, so datapath adds the term.
        ldS   = 1'b1;
        CntUp = 1'b1;
        #10;
        ldS   = 1'b0;
        CntUp = 1'b0;

        // Expected approximately 0.47943.
        if ((RBus < 18'h07AB5) || (RBus > 18'h07AC5))
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