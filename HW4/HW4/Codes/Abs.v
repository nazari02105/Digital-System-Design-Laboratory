module Abs #(parameter WIDTH = 8) (
    input wire [WIDTH-1:0] in,
    output wire [WIDTH-1:0] out
);
    assign out = in[WIDTH-1] ? -in : in;
endmodule