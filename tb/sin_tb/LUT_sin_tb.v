`timescale 1ns/1ps

module LUT_sin_tb;

    reg  [2:0]  addr;
    wire [15:0] data;

    LUT_sin dut (
        .addr (addr),
        .data (data)
    );

    task check_value;
        input [2:0]  test_addr;
        input [15:0] expected;

        begin
            addr = test_addr;
            #1;

            if (data !== expected)
                $display(
                    "FAIL: addr = %0d, expected = %h, actual = %h",
                    test_addr,
                    expected,
                    data
                );
            else
                $display(
                    "PASS: addr = %0d, data = %h",
                    test_addr,
                    data
                );
        end
    endtask

    initial begin
        check_value(3'd0, 16'h2AAB);
        check_value(3'd1, 16'h0CCD);
        check_value(3'd2, 16'h0618);
        check_value(3'd3, 16'h038E);
        check_value(3'd4, 16'h0254);
        check_value(3'd5, 16'h01A4);
        check_value(3'd6, 16'h0138);
        check_value(3'd7, 16'h00F1);

        #10;
        $stop;
    end

endmodule