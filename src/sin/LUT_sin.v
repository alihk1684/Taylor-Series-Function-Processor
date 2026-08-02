module LUT_sin (
    input  wire [2:0]  addr,
    output reg  [15:0] data
);

    always @(*) begin
        case (addr)
            3'd0: data = 16'h2AAB; // approximately 1/6
            3'd1: data = 16'h0CCD; // approximately 1/20
            3'd2: data = 16'h0618; // approximately 1/42
            3'd3: data = 16'h038E; // approximately 1/72
            3'd4: data = 16'h0254; // approximately 1/110
            3'd5: data = 16'h01A4; // approximately 1/156
            3'd6: data = 16'h0138; // approximately 1/210
            3'd7: data = 16'h00F1; // approximately 1/272
            default: data = 16'h0000;
        endcase
    end

endmodule