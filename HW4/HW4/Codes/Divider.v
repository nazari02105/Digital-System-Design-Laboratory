module Divider #(parameter WIDTH = 8) (
    input wire signed [WIDTH-1:0] a,
    input wire signed [WIDTH-1:0] b,
    output wire signed [WIDTH-1:0] out
);
    assign out = a / b;
endmodule