module Controller_sin (
    input  wire clk,
    input  wire rst,
    input  wire Start,
    input  wire Cnt8,

    output reg  Done,
    output reg  ldX,
    output reg  ldT,
    output reg  ldS,
    output reg  InitSin,
    output reg  Init0,
    output reg  CntUp,
    output reg  SelXR
);

    localparam IDLE       = 3'd0;
    localparam STARTING   = 3'd1;
    localparam GET_INPUT  = 3'd2;
    localparam MULT_X1    = 3'd3;
    localparam MULT_X2    = 3'd4;
    localparam MULT_LUT   = 3'd5;
    localparam ACCUMULATE = 3'd6;

    reg [2:0] current_state;
    reg [2:0] next_state;

    // State register
    always @(posedge clk or posedge rst) begin
        if (rst)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end

    // Next-state and output logic
    always @(*) begin
        next_state = IDLE;

        Done    = 1'b0;
        ldX     = 1'b0;
        ldT     = 1'b0;
        ldS     = 1'b0;
        InitSin = 1'b0;
        Init0   = 1'b0;
        CntUp   = 1'b0;
        SelXR   = 1'b0;

        case (current_state)

            IDLE: begin
                Done = 1'b1;

                if (Start)
                    next_state = STARTING;
                else
                    next_state = IDLE;
            end

            STARTING: begin
                if (!Start)
                    next_state = GET_INPUT;
                else
                    next_state = STARTING;
            end

            GET_INPUT: begin
                ldX     = 1'b1;
                ldT     = 1'b1;
                ldS     = 1'b1;
                InitSin = 1'b1;
                Init0   = 1'b1;

                next_state = MULT_X1;
            end

            MULT_X1: begin
                SelXR = 1'b1;
                ldT   = 1'b1;

                next_state = MULT_X2;
            end

            MULT_X2: begin
                SelXR = 1'b1;
                ldT   = 1'b1;

                next_state = MULT_LUT;
            end

            MULT_LUT: begin
                SelXR = 1'b0;
                ldT   = 1'b1;

                next_state = ACCUMULATE;
            end

            ACCUMULATE: begin
                ldS   = 1'b1;
                CntUp = 1'b1;

                if (Cnt8)
                    next_state = IDLE;
                else
                    next_state = MULT_X1;
            end

            default: begin
                next_state = IDLE;
            end

        endcase
    end

endmodule