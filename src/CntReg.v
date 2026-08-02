module CntReg (
    input  wire       clk,
    input  wire       rst,
    input  wire       CntUp,
    input  wire       Init0,
    output reg  [2:0] cnt
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            cnt <= 3'd0;
        end
        else if (Init0) begin
            cnt <= 3'd0;
        end
        else if (CntUp) begin
            cnt <= cnt + 3'd1;
        end
    end

endmodule