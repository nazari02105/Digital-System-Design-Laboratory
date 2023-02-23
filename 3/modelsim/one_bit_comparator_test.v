//`include "one_bit_comparator.v"

module one_bit_comparator_test;
    reg i_gt, i_eq, x, y;
    wire o_gt, o_eq;
    one_bit_comparator c(i_gt, i_eq, x, y, o_gt, o_eq);

    initial begin
        // Simple even tests
        i_gt = 1'b0;
        i_eq = 1'b1;
        x = 1'b0;
        y = 1'b0;
        while ({y, x} != 2'b11) begin
            #10 {y, x} = {y, x} + 1;
        end
        // Before was greater
        #20
        i_gt = 1'b1;
        i_eq = 1'b0;
        x = 1'b0;
        y = 1'b0;
        while ({y, x} != 2'b11) begin
            #10 {y, x} = {y, x} + 1;
        end
        // Before was smaller
        #20
        i_gt = 1'b0;
        i_eq = 1'b0;
        x = 1'b0;
        y = 1'b0;
        while ({y, x} != 2'b11) begin
            #10 {y, x} = {y, x} + 1;
        end
        $stop;
    end

    initial begin
        $monitor("i_gt=%d i_eq=%d x=%d y=%d o_gt=%d o_eq=%d\n", i_gt, i_eq, x, y, o_gt, o_eq);
    end
endmodule