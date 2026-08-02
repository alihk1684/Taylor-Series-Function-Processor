`timescale 1ns/1ps

module Datapath_ln_tb;

    reg         clk;
    reg         rst;

    reg         CntUp;
    reg         Init0;

    reg         ldX;
    reg         ldT;
    reg         ldL;

    reg         InitLn;
    reg         SelXR;

    reg  [15:0] XBus;

    wire        Cnt8;
    wire [17:0] RBus;

    Datapath_ln dut (
        .clk    (clk),
        .rst    (rst),

        .CntUp  (CntUp),
        .Init0  (Init0),

        .ldX    (ldX),
        .ldT    (ldT),
        .ldL    (ldL),

        .InitLn (InitLn),
        .SelXR  (SelXR),

        .XBus   (XBus),

        .Cnt8   (Cnt8),
        .RBus   (RBus)
    );

    // 10 ns clock
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst    = 1'b0;

        CntUp  = 1'b0;
        Init0  = 1'b0;

        ldX    = 1'b0;
        ldT    = 1'b0;
        ldL    = 1'b0;

        InitLn = 1'b0;
        SelXR  = 1'b0;

        XBus   = 16'h0000;

        // Reset
        #2;
        rst = 1'b1;

        #10;
        rst = 1'b0;

        // Initialize x = 0.5
        XBus   = 16'h8000;

        ldX    = 1'b1;
        ldT    = 1'b1;
        ldL    = 1'b1;

        InitLn = 1'b1;
        Init0  = 1'b1;

        #10;

        ldX    = 1'b0;
        ldT    = 1'b0;
        ldL    = 1'b0;

        InitLn = 1'b0;
        Init0  = 1'b0;

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
        // T = x^2 / 2
        // L = x - T
        // =================================================

        // T <- T × X
        SelXR = 1'b1;
        ldT   = 1'b1;
        #10;
        ldT   = 1'b0;

        // T <- T × 1/2
        SelXR = 1'b0;
        ldT   = 1'b1;
        #10;
        ldT   = 1'b0;

        // L <- L - T
        ldL   = 1'b1;
        CntUp = 1'b1;
        #10;
        ldL   = 1'b0;
        CntUp = 1'b0;

        // Expected exactly about 0.375 = 0x06000
        if ((RBus < 18'h05FFE) || (RBus > 18'h06002))
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
        // T = previous × x × 2/3 = x^3/3
        // L = previous + T
        // =================================================

        // T <- T × X
        SelXR = 1'b1;
        ldT   = 1'b1;
        #10;
        ldT   = 1'b0;

        // T <- T × 2/3
        SelXR = 1'b0;
        ldT   = 1'b1;
        #10;
        ldT   = 1'b0;

        // L <- L + T
        ldL   = 1'b1;
        CntUp = 1'b1;
        #10;
        ldL   = 1'b0;
        CntUp = 1'b0;

        // Expected approximately 0.416667
        // 0.416667 × 65536 ? 27307 ? 0x06AAB
        if ((RBus < 18'h06AA5) || (RBus > 18'h06AB0))
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