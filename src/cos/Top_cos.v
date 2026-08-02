module Top_cos (
    input  wire        clk,
    input  wire        rst,
    input  wire        Start,
    input  wire [15:0] XBus,

    output wire [17:0] RBus,
    output wire        Done
);

    wire ldX;
    wire ldT;
    wire ldC;

    wire InitCos;
    wire Init0;

    wire SelXR;
    wire CntUp;
    wire Cnt8;

    Datapath_cos datapath_unit (
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

    Controller_cos controller_unit (
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

endmodule