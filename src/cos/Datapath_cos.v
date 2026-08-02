module Datapath_cos (
    input  wire        clk,
    input  wire        rst,

    input  wire        CntUp,
    input  wire        Init0,

    input  wire        ldX,
    input  wire        ldT,
    input  wire        ldC,

    input  wire        InitCos,
    input  wire        SelXR,

    input  wire [15:0] XBus,

    output wire        Cnt8,
    output wire [17:0] RBus
);

    wire [2:0]  CntOut;

    wire [15:0] XOut;
    wire [15:0] TOut;
    wire [17:0] COut;

    wire [15:0] LutOut;
    wire [15:0] MuxOut;

    wire [31:0] FullProduct;
    wire [15:0] MulOut;

    wire [15:0] TInput;
    wire [17:0] CInput;
    wire [17:0] AddSubOut;

    CntReg counter (
        .clk   (clk),
        .rst   (rst),
        .CntUp (CntUp),
        .Init0 (Init0),
        .cnt   (CntOut)
    );

    LUT_cos lut (
        .addr (CntOut),
        .data (LutOut)
    );

    Register16 XReg (
        .clk   (clk),
        .rst   (rst),
        .Init1 (1'b0),
        .load  (ldX),
        .in    (XBus),
        .out   (XOut)
    );

    // For cosine initialization, TReg starts at approximately 1.0
    assign TInput = InitCos ? 16'hFFFF : MulOut;

    Register16 TReg (
        .clk   (clk),
        .rst   (rst),
        .Init1 (1'b0),
        .load  (ldT),
        .in    (TInput),
        .out   (TOut)
    );

    // Cosine result starts at exactly 1.0 in Q2.16
    assign CInput = InitCos
                  ? 18'h10000
                  : AddSubOut;

    Register18 CReg (
        .clk   (clk),
        .rst   (rst),
        .Init1 (1'b0),
        .load  (ldC),
        .in    (CInput),
        .out   (COut)
    );

    assign MuxOut = SelXR ? XOut : LutOut;

    assign FullProduct = TOut * MuxOut;

    assign MulOut = FullProduct[31:16];

    assign AddSubOut =
        (CntOut[0] == 1'b0)
        ? COut - {2'b00, TOut}
        : COut + {2'b00, TOut};

    assign RBus = COut;

    assign Cnt8 = (CntOut == 3'd7);

endmodule