module Datapath_exp (
    input  wire        clk,
    input  wire        rst,
    input  wire        CntUp,
    input  wire        Init0,
    input  wire        ldX,
    input  wire        ldT,
    input  wire        IT1,
    input  wire        ldE,
    input  wire        IE1,
    input  wire        SelXR,
    input  wire [15:0] XBus,

    output wire        Cnt8,
    output wire [17:0] RBus
);

    wire [2:0]  CntOut;

    wire [15:0] LutOut;
    wire [15:0] XOut;
    wire [15:0] TOut;
    wire [15:0] MuxOut;
    wire [15:0] MulOut;

    wire [17:0] EOut;
    wire [17:0] AddOut;

    wire [31:0] FullProduct;

    CntReg counter (
        .clk   (clk),
        .rst   (rst),
        .CntUp (CntUp),
        .Init0 (Init0),
        .cnt   (CntOut)
    );

    LUT_exp lut (
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

    Register16 TReg (
        .clk   (clk),
        .rst   (rst),
        .Init1 (IT1),
        .load  (ldT),
        .in    (MulOut),
        .out   (TOut)
    );

    Register18 EReg (
        .clk   (clk),
        .rst   (rst),
        .Init1 (IE1),
        .load  (ldE),
        .in    (AddOut),
        .out   (EOut)
    );

    assign MuxOut = (SelXR == 1'b1) ? XOut : LutOut;

    assign FullProduct = MuxOut * TOut;

    assign MulOut = FullProduct[31:16];

    assign AddOut = EOut + {2'b00, TOut};

    assign RBus = EOut;

    assign Cnt8 = (CntOut == 3'b111);

endmodule