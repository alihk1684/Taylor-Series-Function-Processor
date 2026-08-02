module Register18 (
    input  wire        clk,
    input  wire        rst,
    input  wire        Init1,
    input  wire        load,
    input  wire [17:0] in,
    output reg  [17:0] out
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            out <= 18'd0;
        end
        else if (Init1) begin
            // Exact 1.0 in Q2.16
            out <= {2'b01, 16'h0000};
        end
        else if (load) begin
            out <= in;
        end
    end

endmodule