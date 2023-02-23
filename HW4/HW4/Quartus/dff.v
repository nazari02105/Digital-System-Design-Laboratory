module DFF #(parameter WIDTH = 8) (
    input wire clk,
    input wire clear,
    input wire [WIDTH-1:0] in,
    output reg [WIDTH-1:0] out
);
    always @(posedge clk or posedge clear) begin
        if (clear)
            out <= 0;
        else
            out <= in;
    end
endmodule