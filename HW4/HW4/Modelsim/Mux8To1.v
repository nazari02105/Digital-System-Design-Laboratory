module Mux8To1 #(parameter WIDTH = 8) (
    input wire [WIDTH-1:0] a,
    input wire [WIDTH-1:0] b,
    input wire [WIDTH-1:0] c,
    input wire [WIDTH-1:0] d,
    input wire [WIDTH-1:0] e,
    input wire [WIDTH-1:0] f,
    input wire [WIDTH-1:0] g,
    input wire [WIDTH-1:0] h,
    input wire [2:0] select,
    output reg [WIDTH-1:0] out
);
    always @(*) begin
        case(select)
            3'b000: out = a;
            3'b001: out = b;
            3'b010: out = c;
            3'b011: out = d;
            3'b100: out = e;
            3'b101: out = f;
            3'b110: out = g;
            3'b111: out = h;
        endcase
    end
endmodule