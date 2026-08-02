module Datapath_sin (
    input  wire        clk,
    input  wire        rst,

    input  wire        CntUp,
    input  wire        Init0,

    input  wire        ldX,
    input  wire        ldT,
    input  wire        ldS,

    // When InitSin = 1:
    // TReg and SReg load XBus instead of calculation results.
    input  wire        InitSin,

    // SelXR = 1 selects XReg.
    // SelXR = 0 selects the sine LUT.
    input  wire        SelXR,

    input  wire [15:0] XBus,

    output wire        Cnt8,
    output wire [17:0] RBus
);

    wire [2:0] CntOut;

    wire [15:0] XOut;
    wire [15:0] TOut;
    wire [17:0] SOut;

    wire [15:0] LutOut;
    wire [15:0] MuxOut;

    wire [31:0] FullProduct;
    wire [15:0] MulOut;

    wire [15:0] TInput;
    wire [17:0] SInput;
    wire [17:0] AddSubOut;

    // ----------------------------------------------------
    // Counter
    // ----------------------------------------------------
    CntReg counter (
        .clk   (clk),
        .rst   (rst),
        .CntUp (CntUp),
        .Init0 (Init0),
        .cnt   (CntOut)
    );

    // ----------------------------------------------------
    // Sine reciprocal LUT
    // ----------------------------------------------------
    LUT_sin lut (
        .addr (CntOut),
        .data (LutOut)
    );

    // ----------------------------------------------------
    // Input register: stores x
    // ----------------------------------------------------
    Register16 XReg (
        .clk   (clk),
        .rst   (rst),
        .Init1 (1'b0),
        .load  (ldX),
        .in    (XBus),
        .out   (XOut)
    );

    // ----------------------------------------------------
    // Taylor-term register
    //
    // Initialization: TReg <- XBus
    // Calculation:    TReg <- MulOut
    // ----------------------------------------------------
    assign TInput = InitSin ? XBus : MulOut;

    Register16 TReg (
        .clk   (clk),
        .rst   (rst),
        .Init1 (1'b0),
        .load  (ldT),
        .in    (TInput),
        .out   (TOut)
    );

    // ----------------------------------------------------
    // Sine-result register
    //
    // Initialization: SReg <- XBus
    // Calculation:    SReg <- AddSubOut
    // ----------------------------------------------------
    assign SInput = InitSin
                  ? {2'b00, XBus}
                  : AddSubOut;

    Register18 SReg (
        .clk   (clk),
        .rst   (rst),
        .Init1 (1'b0),
        .load  (ldS),
        .in    (SInput),
        .out   (SOut)
    );

    // ----------------------------------------------------
    // Shared multiplier
    // ----------------------------------------------------
    assign MuxOut = SelXR ? XOut : LutOut;

    assign FullProduct = TOut * MuxOut;

    // Q0.16 × Q0.16 gives Q0.32.
    // Keep the middle/high 16 fractional-result bits.
    assign MulOut = FullProduct[31:16];

    // ----------------------------------------------------
    // Alternating subtraction and addition
    //
    // Counter 0: subtract x^3 / 3!
    // Counter 1: add      x^5 / 5!
    // Counter 2: subtract x^7 / 7!
    // ----------------------------------------------------
    assign AddSubOut =
        (CntOut[0] == 1'b0)
        ? SOut - {2'b00, TOut}
        : SOut + {2'b00, TOut};

    assign RBus = SOut;

    // Eight calculated correction terms: counter 0 through 7
    assign Cnt8 = (CntOut == 3'd7);

endmodule