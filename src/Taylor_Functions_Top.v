module Taylor_Functions_Top (
    input  wire        clk,
    input  wire        rst,
    input  wire        Start,
    input  wire [15:0] XBus,
    input  wire [1:0]  Func,

    output reg  [17:0] RBus,
    output reg         Done
);

    // Latch the selected function when Start is received.
    reg [1:0] FuncReg;

    always @(posedge clk or posedge rst) begin
        if (rst)
            FuncReg <= 2'b00;
        else if (Start)
            FuncReg <= Func;
    end

    // Separate start signals for each function block.
    wire Start_exp;
    wire Start_sin;
    wire Start_cos;
    wire Start_ln;

    assign Start_exp = Start && (Func == 2'b00);
    assign Start_sin = Start && (Func == 2'b01);
    assign Start_cos = Start && (Func == 2'b10);
    assign Start_ln  = Start && (Func == 2'b11);

    // Outputs from the four function modules.
    wire [17:0] RBus_exp;
    wire [17:0] RBus_sin;
    wire [17:0] RBus_cos;
    wire [17:0] RBus_ln;

    wire Done_exp;
    wire Done_sin;
    wire Done_cos;
    wire Done_ln;

    Top_exp exp_unit (
        .clk   (clk),
        .rst   (rst),
        .Start (Start_exp),
        .XBus  (XBus),
        .RBus  (RBus_exp),
        .Done  (Done_exp)
    );

    Top_sin sin_unit (
        .clk   (clk),
        .rst   (rst),
        .Start (Start_sin),
        .XBus  (XBus),
        .RBus  (RBus_sin),
        .Done  (Done_sin)
    );

    Top_cos cos_unit (
        .clk   (clk),
        .rst   (rst),
        .Start (Start_cos),
        .XBus  (XBus),
        .RBus  (RBus_cos),
        .Done  (Done_cos)
    );

    Top_ln ln_unit (
        .clk   (clk),
        .rst   (rst),
        .Start (Start_ln),
        .XBus  (XBus),
        .RBus  (RBus_ln),
        .Done  (Done_ln)
    );

    // Select the result and Done signal from the active function.
    always @(*) begin
        case (FuncReg)

            2'b00: begin
                RBus = RBus_exp;
                Done = Done_exp;
            end

            2'b01: begin
                RBus = RBus_sin;
                Done = Done_sin;
            end

            2'b10: begin
                RBus = RBus_cos;
                Done = Done_cos;
            end

            2'b11: begin
                RBus = RBus_ln;
                Done = Done_ln;
            end

            default: begin
                RBus = 18'd0;
                Done = 1'b1;
            end

        endcase
    end

endmodule