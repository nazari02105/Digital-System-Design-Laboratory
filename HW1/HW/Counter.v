module Counter (q, clk, reset);
	output[4:0] q;
	input clk, reset;
	TFF tff0(q[0], reset, clk, 1);
	TFF tff1(q[1], reset, q[0], 1);
	TFF tff2(q[2], reset, q[1], 1);
	TFF tff3(q[3], reset, q[2], 1);
	TFF tff4(q[4], reset, q[3], 1);
endmodule
