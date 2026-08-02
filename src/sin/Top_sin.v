module Top_sin (

    input  wire        clk,
    input  wire        rst,
    input  wire        Start,
    input  wire [15:0] XBus,

    output wire [17:0] RBus,
    output wire        Done

);

    // Control signals
    wire ldX;
    wire ldT;
    wire ldS;

    wire InitSin;
    wire Init0;

    wire SelXR;
    wire CntUp;

    // Status signal
    wire Cnt8;

    //-------------------------------------------------------
    // Datapath
    //-------------------------------------------------------
    Datapath_sin datapath_unit (

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

    //-------------------------------------------------------
    // Controller
    //-------------------------------------------------------
    Controller_sin controller_unit (

        .clk     (clk),
        .rst     (rst),

        .Start   (Start),
        .Cnt8    (Cnt8),

        .Done    (Done),

        .ldX     (ldX),
        .ldT     (ldT),
        .ldS     (ldS),

        .InitSin (InitSin),
        .Init0   (Init0),

        .CntUp   (CntUp),
        .SelXR   (SelXR)

    );

endmodule