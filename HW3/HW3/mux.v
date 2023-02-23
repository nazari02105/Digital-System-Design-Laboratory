module Mux (input wire [31:0] a,input wire [31:0] b,input wire select ,output wire [31:0] out);
	assign out = select ? b : a;
endmodule