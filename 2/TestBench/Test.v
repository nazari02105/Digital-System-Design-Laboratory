module Test;
	reg T, in, ent, out, clock, clear;
	wire open, close, out0, out1, out2, out3;
	Exp2 main_instance(T, in, ent, out, clock, clear, open, close, out0, out1, out2, out3);

	initial begin
	T = 1'b1;
	in = 1'b0;
	ent = 1'b1;
	out = 1'b0;
	clock = 1'b0;
	clear = 1'b1;
	end
	always begin
	#5 clock = ~clock;
	end

	initial begin
	#5 in = 1'b1;
	#15 in = 1'b0;
	#10 in = 1'b1;
	#10 in = 1'b0;
	#20 out = 1'b1;
	#10 out = 1'b0;
	#10 ent = 1'b0;
	#5 in = 1'b1;
	#10 in = 1'b0;
	#5 ent = 1'b1;
	#5 T = 1'b0;
	#5 in = 1'b1;
	#10 in = 1'b0;
	#5 T = 1'b1;
	#5 in = 1'b1;
	#60 in = 1'b1;
	#10 $stop;
	end

endmodule
