module JK_Test;
	reg j; reg k;
	reg clk; reg reset; wire q;

	//instantiate the design block
	JK jk0(q, reset, clk, j, k);

	//control the clk signal that drives the design block
	initial begin
		reset = 1'b1;
		j = 1'b0;
		k = 1'b0;
		clk = 0'b0;
	end
	always #5 clk = ~clk;
	
	//control the reset signal that drives the design block
	initial
		begin
			reset = 1'b1;
			#10 reset = 1'b0;
			#25 j = 1'b1;
			#25 k = 1'b1;
			#35 j = 1'b0;
			#40 k = 1'b0;
			#50 $stop;
		end

	initial //monitor the output
		$monitor($time, " Output q = %d", q);
endmodule

