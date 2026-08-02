module Datapath_ln (
    input  wire        clk,
    input  wire        rst,

    input  wire        CntUp,
    input  wire        Init0,

    input  wire        ldX,
    input  wire        ldT,
    input  wire        ldL,

    input  wire        InitLn,
    input  wire        SelXR,

    input  wire [15:0] XBus,

    output wire        Cnt8,
    output wire [17:0] RBus
);

    wire [2:0]  CntOut;

    wire [15:0] XOut;
    wire [15:0] TOut;
    wire [17:0] LOut;

    wire [15:0] LutOut;
    wire [15:0] MuxOut;

    wire [31:0] FullProduct;
    wire [15:0] MulOut;

    wire [15:0] TInput;
    wire [17:0] LInput;
    wire [17:0] AddSubOut;

    // Iteration counter
    CntReg counter (
        .clk   (clk),
        .rst   (rst),
        .CntUp (CntUp),
        .Init0 (Init0),
        .cnt   (CntOut)
    );

    // LUT stores:
    // 1/2, 2/3, 3/4, ..., 8/9
    LUT_ln lut (
        .addr (CntOut),
        .data (LutOut)
    );

    // Store x
    Register16 XReg (
        .clk   (clk),
        .rst   (rst),
        .Init1 (1'b0),
        .load  (ldX),
        .in    (XBus),
        .out   (XOut)
    );

    // Current Taylor term
    //
    // Initialization:
    // TReg <- XBus
    //
    // Calculation:
    // TReg <- multiplication result
    assign TInput = InitLn ? XBus : MulOut;

    Register16 TReg (
        .clk   (clk),
        .rst   (rst),
        .Init1 (1'b0),
        .load  (ldT),
        .in    (TInput),
        .out   (TOut)
    );

    // Accumulated logarithm result
    //
    // Initialization:
    // LReg <- XBus
    //
    // Calculation:
    // LReg <- AddSubOut
    assign LInput = InitLn
                  ? {2'b00, XBus}
                  : AddSubOut;

    Register18 LReg (
        .clk   (clk),
        .rst   (rst),
        .Init1 (1'b0),
        .load  (ldL),
        .in    (LInput),
        .out   (LOut)
    );

    // SelXR = 1 selects x
    // SelXR = 0 selects LUT value
    assign MuxOut = SelXR ? XOut : LutOut;

    assign FullProduct = TOut * MuxOut;

    // Q0.16 multiplication result
    assign MulOut = FullProduct[31:16];

    // Alternating signs:
    //
    // counter 0: subtract x^2/2
    // counter 1: add      x^3/3
    // counter 2: subtract x^4/4
    assign AddSubOut =
        (CntOut[0] == 1'b0)
        ? LOut - {2'b00, TOut}
        : LOut + {2'b00, TOut};

    assign RBus = LOut;

    assign Cnt8 = (CntOut == 3'd7);

endmodule