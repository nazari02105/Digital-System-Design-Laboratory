//`include "four_bit_comparator.v"

module four_bit_comparator_test;
    reg[3:0] x;
    reg[3:0] y;
    integer i;
    wire o_gt, o_eq;
    four_bit_comparator c(x, y, o_gt, o_eq);

    initial begin
        // Simple tests
        x = 4'b0000;
        y = 4'b0000;
        #10 x = 4'b1000;
        y = 4'b0111;
        #10 x = 4'b0110;
        y = 4'b0111;
        #10 x = 4'b0110;
        y = 4'b0111;
        #10 x = 4'b0010;
        y = 4'b0010;
        // Fuzzing
        for (i = 0; i < 10 ; i = i + 1) begin
            #10 x = $random;
            y = $random;
        end
        $stop;
    end

    initial begin
        $monitor("x=%d y=%d o_gt=%d o_eq=%d", x, y, o_gt, o_eq);
    end
endmodule