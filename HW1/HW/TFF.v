module TFF (q, reset, clk, t);
	output q;
	input reset, clk, t;
	JK jk0(q, reset, clk, t, t);
endmodule
