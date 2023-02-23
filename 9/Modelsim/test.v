`include "TCAM.v"
module Test;
    reg clk, reset, write_enable;
    reg [15:0] input_data, input_unknown_bits;
    wire [15:0] htis;
    wire write_success;
    TCAM tcam(clk, reset, write_enable, input_data, input_unknown_bits, htis, write_success);

    initial clk = 0;
    always #5 clk = ~clk;

    integer i;

    initial begin
        reset = 1;
        #10;
        reset = 0;
        write_enable = 1;
        input_data = 16'b01100000;
        input_unknown_bits = 16'b1111;
        #10;
        input_data = 16'b01111110;
        input_unknown_bits = 16'b01010010;
        #10;
        input_data = 16'b11101001;
        input_unknown_bits = 0;
        #10;
        input_data = 16'b11101001;
        input_unknown_bits = 16'b10000111;
        #10;
        input_data = 0;
        input_unknown_bits = {16{1'b1}};
        #10;
        write_enable = 0;
        input_data = 16'b01101110;
        #10;
        write_enable = 1;
        input_data = 0;
        input_unknown_bits = {16{1'b1}};
        for (i = 0; i < 14; i = i + 1)
            #10;
        write_enable = 0;
        input_data = 1234;
        #10;
        $finish;
    end
endmodule