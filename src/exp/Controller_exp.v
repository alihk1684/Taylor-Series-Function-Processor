module Controller_exp (
    input  wire clk,
    input  wire rst,
    input  wire Start,
    input  wire Cnt8,

    output reg  Done,
    output reg  ldX,
    output reg  IT1,
    output reg  IE1,
    output reg  ldT,
    output reg  ldE,
    output reg  Init0,
    output reg  CntUp,
    output reg  SelXR
);

    localparam IDLE      = 3'd0;
    localparam STARTING  = 3'd1;
    localparam GET_INPUT = 3'd2;
    localparam MULT1     = 3'd3;
    localparam MULT2     = 3'd4;
    localparam ADD       = 3'd5;

    reg [2:0] current_state;
    reg [2:0] next_state;

    // State register
    always @(posedge clk or posedge rst) begin
        if (rst)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end

    // Next-state logic and output logic
    always @(*) begin
        // Default values
        next_state = IDLE;

        Done  = 1'b0;
        ldX   = 1'b0;
        IT1   = 1'b0;
        IE1   = 1'b0;
        ldT   = 1'b0;
        ldE   = 1'b0;
        Init0 = 1'b0;
        CntUp = 1'b0;
        SelXR = 1'b0;

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
                ldX   = 1'b1;
                IT1   = 1'b1;
                IE1   = 1'b1;
                Init0 = 1'b1;

                next_state = MULT1;
            end

            MULT1: begin
                SelXR = 1'b1;
                ldT   = 1'b1;

                next_state = MULT2;
            end

            MULT2: begin
                SelXR = 1'b0;
                ldT   = 1'b1;

                next_state = ADD;
            end

            ADD: begin
                ldE   = 1'b1;
                CntUp = 1'b1;

                if (Cnt8)
                    next_state = IDLE;
                else
                    next_state = MULT1;
            end

            default: begin
                next_state = IDLE;
            end

        endcase
    end

endmodule