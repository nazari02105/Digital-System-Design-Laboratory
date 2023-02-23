module Comparator (input wire [31:0] a,input wire [31:0] b,output wire gt);
	assign gt = a > b ? 1 : 0;
endmodule
