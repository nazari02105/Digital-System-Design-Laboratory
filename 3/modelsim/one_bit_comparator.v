module one_bit_comparator (
    input i_gt,
    input i_eq,
    input x,
    input y,
    output o_gt,
    output o_eq
);
    assign o_gt = i_gt | (i_eq & (x > y));
    assign o_eq = i_eq & (x == y);
endmodule