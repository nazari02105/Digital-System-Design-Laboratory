`timescale 1ns/1ns
module test_bench;
	reg clk, start;
	reg [7:0] in1, in2;
	wire valid;
	wire [15:0] out;
	booth exe_test(.clk(clk), .start(start), .in1(in1), .in2(in2), .valid(valid), .out(out));
	initial clk = 1;
	always #5 clk = ~clk;
	initial
	begin
		start <= 1;
		in1 <= 4;
		in2 <= 5;
		#10;
		start <= 0;

		#400;
		start <= 1;
		in1 <= 6;
		in2 <= 10;
		#10;
		start <= 0;

		#400;
		start <= 1;
		in1 <= -10;
		in2 <= 20;
		#10;
		start <= 0;
	end
endmodule
