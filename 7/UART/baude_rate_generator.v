`timescale 1ns/1ns
module baude_rate_generator
	(
		input reset,
		input clk,
		input [15:0] divisor,
		output tick
	);
	
	reg [15:0] counter;
	
	always @(posedge clk)
		if (reset)
			counter = 1;
		else
			if (counter == divisor)
				counter = 1;
			else
				counter = counter + 1'b1;
	
	assign tick = (counter == 1);
	
endmodule