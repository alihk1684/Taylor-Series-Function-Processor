`timescale 1ns/1ps

module Controller_cos_tb;

    reg clk;
    reg rst;
    reg Start;
    reg Cnt8;

    wire Done;
    wire ldX;
    wire ldT;
    wire ldC;
    wire InitCos;
    wire Init0;
    wire CntUp;
    wire SelXR;

    Controller_cos dut (
        .clk     (clk),
        .rst     (rst),
        .Start   (Start),
        .Cnt8    (Cnt8),

        .Done    (Done),
        .ldX     (ldX),
        .ldT     (ldT),
        .ldC     (ldC),
        .InitCos (InitCos),
        .Init0   (Init0),
        .CntUp   (CntUp),
        .SelXR   (SelXR)
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

        // Enter STARTING
        Start = 1'b1;
        #10;

        if (Done !== 1'b0)
            $display("FAIL: Done should be low in Starting");
        else
            $display("PASS: entered Starting state");

        // Hold Start high
        #10;

        if (ldX !== 1'b0)
            $display("FAIL: controller should wait for Start to go low");
        else
            $display("PASS: waits while Start is high");

        // Release Start
        Start = 1'b0;
        #10;

        // GET_INPUT
        if (
            ldX     !== 1'b1 ||
            ldT     !== 1'b1 ||
            ldC     !== 1'b1 ||
            InitCos !== 1'b1 ||
            Init0   !== 1'b1
        )
            $display("FAIL: GetInput control signals incorrect");
        else
            $display("PASS: GetInput control signals");

        #10;

        // MULT_X1
        if (ldT !== 1'b1 || SelXR !== 1'b1)
            $display("FAIL: MultX1 control signals incorrect");
        else
            $display("PASS: MultX1 control signals");

        #10;

        // MULT_X2
        if (ldT !== 1'b1 || SelXR !== 1'b1)
            $display("FAIL: MultX2 control signals incorrect");
        else
            $display("PASS: MultX2 control signals");

        #10;

        // MULT_LUT
        if (ldT !== 1'b1 || SelXR !== 1'b0)
            $display("FAIL: MultLUT control signals incorrect");
        else
            $display("PASS: MultLUT control signals");

        #10;

        // ACCUMULATE
        if (ldC !== 1'b1 || CntUp !== 1'b1)
            $display("FAIL: Accumulate control signals incorrect");
        else
            $display("PASS: Accumulate control signals");

        #10;

        // Repeat iteration
        if (ldT !== 1'b1 || SelXR !== 1'b1)
            $display("FAIL: controller did not repeat iteration");
        else
            $display("PASS: repeated iteration");

        // MULT_X2
        #10;

        // MULT_LUT
        #10;

        // Mark final iteration before ACCUMULATE
        Cnt8 = 1'b1;
        #10;

        if (ldC !== 1'b1 || CntUp !== 1'b1)
            $display("FAIL: final Accumulate signals incorrect");
        else
            $display("PASS: final Accumulate signals");

        // Return to IDLE
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