`timescale 1ns/1ns
module adder(input add_diff_not, input [3:0] a, input [3:0] b, output [3:0] out);
	assign out = add_diff_not ? (a + b) : (a - b);
endmodule
