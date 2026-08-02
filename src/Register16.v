module Register16 (
    input  wire        clk,
    input  wire        rst,
    input  wire        Init1,
    input  wire        load,
    input  wire [15:0] in,
    output reg  [15:0] out
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            out <= 16'd0;
        end
        else if (Init1) begin
            // Closest Q0.16 representation to 1.0
            out <= 16'hFFFF;
        end
        else if (load) begin
            out <= in;
        end
    end

endmodule