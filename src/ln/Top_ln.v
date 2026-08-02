module Top_ln (
    input  wire        clk,
    input  wire        rst,
    input  wire        Start,
    input  wire [15:0] XBus,

    output wire [17:0] RBus,
    output wire        Done
);

    wire ldX;
    wire ldT;
    wire ldL;

    wire InitLn;
    wire Init0;

    wire SelXR;
    wire CntUp;
    wire Cnt8;

    Datapath_ln datapath_unit (
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

    Controller_ln controller_unit (
        .clk    (clk),
        .rst    (rst),
        .Start  (Start),
        .Cnt8   (Cnt8),

        .Done   (Done),

        .ldX    (ldX),
        .ldT    (ldT),
        .ldL    (ldL),

        .InitLn (InitLn),
        .Init0  (Init0),

        .CntUp  (CntUp),
        .SelXR  (SelXR)
    );

endmodule