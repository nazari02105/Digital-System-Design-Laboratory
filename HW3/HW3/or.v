module DO_OR (input wire [31:0] in,output wire result);
	assign result = |in;
endmodule
