module BetweenChecker #(parameter WIDTH = 8) (
    input wire signed [WIDTH-1:0] a,
    input wire signed [WIDTH-1:0] b,
    input wire signed [WIDTH-1:0] target,
    output wire result
);
    wire signed [WIDTH-1:0] lower = a > b ? b : a;
    wire signed [WIDTH-1:0] upper = a > b ? a : b;
    assign result = target > lower & target < upper;
endmodule