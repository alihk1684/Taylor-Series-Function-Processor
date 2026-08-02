module Top_exp (
    input  wire        clk,
    input  wire        rst,
    input  wire        Start,
    input  wire [15:0] XBus,

    output wire [17:0] RBus,
    output wire        Done
);

    // Control signals between controller and datapath
    wire CntUp;
    wire Init0;
    wire ldX;
    wire ldT;
    wire IT1;
    wire ldE;
    wire IE1;
    wire SelXR;

    // Status signal from datapath to controller
    wire Cnt8;

    // Datapath instance
    Datapath_exp datapath_unit (
        .clk   (clk),
        .rst   (rst),
        .CntUp (CntUp),
        .Init0 (Init0),
        .ldX   (ldX),
        .ldT   (ldT),
        .IT1   (IT1),
        .ldE   (ldE),
        .IE1   (IE1),
        .SelXR (SelXR),
        .XBus  (XBus),

        .Cnt8  (Cnt8),
        .RBus  (RBus)
    );

    // Controller instance
    Controller_exp controller_unit (
        .clk   (clk),
        .rst   (rst),
        .Start (Start),
        .Cnt8  (Cnt8),

        .Done  (Done),
        .ldX   (ldX),
        .IT1   (IT1),
        .IE1   (IE1),
        .ldT   (ldT),
        .ldE   (ldE),
        .Init0 (Init0),
        .CntUp (CntUp),
        .SelXR (SelXR)
    );

endmodule