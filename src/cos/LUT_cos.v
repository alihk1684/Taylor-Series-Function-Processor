module LUT_cos (
    input  wire [2:0]  addr,
    output reg  [15:0] data
);

    always @(*) begin
        case (addr)
            3'd0: data = 16'h8000; // 1/2
            3'd1: data = 16'h1555; // approximately 1/12
            3'd2: data = 16'h0889; // approximately 1/30
            3'd3: data = 16'h0492; // approximately 1/56
            3'd4: data = 16'h02D8; // approximately 1/90
            3'd5: data = 16'h01F0; // approximately 1/132
            3'd6: data = 16'h0168; // approximately 1/182
            3'd7: data = 16'h0111; // approximately 1/240
            default: data = 16'h0000;
        endcase
    end

endmodule