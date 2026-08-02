module LUT_exp (
    input  wire [2:0]  addr,
    output reg  [15:0] data
);

    always @(*) begin
        case (addr)
            3'd0: data = 16'hFFFF; // approximately 1
            3'd1: data = 16'h8000; // 1/2
            3'd2: data = 16'h5555; // approximately 1/3
            3'd3: data = 16'h4000; // 1/4
            3'd4: data = 16'h3333; // approximately 1/5
            3'd5: data = 16'h2AAA; // approximately 1/6
            3'd6: data = 16'h2492; // approximately 1/7
            3'd7: data = 16'h2000; // 1/8
            default: data = 16'h0000;
        endcase
    end

endmodule