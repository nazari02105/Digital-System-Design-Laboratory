`include "one_bit_comparator.v"

module four_bit_comparator (
    input[3:0] x,
    input[3:0] y,
    output o_gt,
    output o_eq
);
    wire c1_gt, c1_eq, c2_gt, c2_eq, c3_gt, c3_eq;
    one_bit_comparator c1(1'b0, 1'b1, x[3], y[3], c1_gt, c1_eq);
    one_bit_comparator c2(c1_gt, c1_eq, x[2], y[2], c2_gt, c2_eq);
    one_bit_comparator c3(c2_gt, c2_eq, x[1], y[1], c3_gt, c3_eq);
    one_bit_comparator c4(c3_gt, c3_eq, x[0], y[0], o_gt, o_eq);
endmodule