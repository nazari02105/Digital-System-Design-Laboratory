module Counter_Test;
	reg clk; reg reset;
	wire[4:0] q;
	Counter counter0(q, clk, reset);
	initial clk=0;
	always #1 clk=~clk;
	initial begin
		reset = 1'b1;
		// I assume every clock is about 2 ns
		#2 reset = 1'b0;
		#66 reset = 1'b1;
		#2 reset = 1'b0;
		#30 reset = 1'b1;
		#2 reset = 1'b0;
		#20 $stop;
	end
endmodule
