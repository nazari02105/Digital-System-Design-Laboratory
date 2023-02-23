`timescale 1ns/1ns
module control_unit(input clk, input start, output valid, input [7:0] Q, output load, output sum_or_diff, output shift, output [3:0] shmnt);
	reg[3:0] current, next, counter;
	assign load = current[0];
	assign sum_or_diff = current[1];
	assign shift = current[2];
	assign valid = current[3];
	always @(current, counter)
	begin
		next <= 0;
		if(current[0]) next[1] <= 1'b1;
		if(current[1]) next[2] <= 1'b1;
		if(current[2])
			if (counter > shmnt) next[1] <= 1'b1;
			else next[3] <= 1'b1;
		if(current[3]) next[3] <= 1'b1;
	end
	always @(posedge clk)
		if (start)
		begin
			current <= 1;
			counter <= 8;
		end
		else
		begin
			current <= next;
			if (current[2]) counter <= counter - shmnt;
		end
	wire [7:0] diff_pairs = ( Q ^ (Q >> 1) ) | (8'b10000000);
	reg [3:0] lsb_one;
	integer i;
	always @(*)
	begin
		lsb_one = 0;
		for (i = 0; i <= 7; i = i+1)
			if (diff_pairs[i] && lsb_one == 0) lsb_one = i + 1;
	end
	assign shmnt = (counter>lsb_one) ? lsb_one : counter;
endmodule