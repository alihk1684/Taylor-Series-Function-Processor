`timescale 1ns/1ps

module LUT_exp_tb;

    reg  [2:0]  addr;
    wire [15:0] data;

    LUT_exp dut (
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
                    "FAIL: addr = %d, expected = %h, actual = %h",
                    test_addr,
                    expected,
                    data
                );
            else
                $display(
                    "PASS: addr = %d, data = %h",
                    test_addr,
                    data
                );
        end
    endtask

    initial begin
        check_value(3'd0, 16'hFFFF);
        check_value(3'd1, 16'h8000);
        check_value(3'd2, 16'h5555);
        check_value(3'd3, 16'h4000);
        check_value(3'd4, 16'h3333);
        check_value(3'd5, 16'h2AAA);
        check_value(3'd6, 16'h2492);
        check_value(3'd7, 16'h2000);

        #10;
        $stop;
    end

endmodule