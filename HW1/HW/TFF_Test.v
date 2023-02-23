
module TFF_Test;
	reg t;
	reg clk; reg reset; wire q;

	//instantiate the design block
	TFF tff0(q, reset, clk, t);

	//control the clk signal that drives the design block
	initial begin
		reset = 1'b1;
		t = 1'b0;
		clk = 1'b0;
	end
	always #5 clk = ~clk;
	
	//control the reset signal that drives the design block
	initial
		begin
			reset = 1'b1;
			#10 reset = 1'b0;
			#25 t = 1'b1;
			#35 t = 1'b0;
			#50 $stop;
		end

	initial //monitor the output
		$monitor($time, " Output q = %d", q);
endmodule
