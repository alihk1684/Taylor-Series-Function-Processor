module LUT_ln (
    input  wire [2:0]  addr,
    output reg  [15:0] data
);

    always @(*) begin
        case (addr)
            3'd0: data = 16'h8000; // 1/2
            3'd1: data = 16'hAAAB; // approximately 2/3
            3'd2: data = 16'hC000; // 3/4
            3'd3: data = 16'hCCCD; // approximately 4/5
            3'd4: data = 16'hD555; // approximately 5/6
            3'd5: data = 16'hDB6E; // approximately 6/7
            3'd6: data = 16'hE000; // 7/8
            3'd7: data = 16'hE38E; // approximately 8/9
            default: data = 16'h0000;
        endcase
    end

endmodule