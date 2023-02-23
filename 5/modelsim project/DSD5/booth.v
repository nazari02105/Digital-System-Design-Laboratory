`timescale 1ns/1ns
module booth(input clk, input start, input [7:0] in1, input [7:0] in2, output valid, output [15:0] out);
	wire [3:0] shmnt;
	wire load, sum_or_diff, shift;
	data_path dp(.clk(clk), .input_1(in1), .input_2(in2), .dxb_input_1(out[15:8]), .dxb_input_2(out[7:0]), .load(load), .sum_or_diff(sum_or_diff), .shift(shift), .shmnt(shmnt));
	control_unit cu(.clk(clk), .start(start), .valid(valid), .Q(out[7:0]), .load(load), .sum_or_diff(sum_or_diff), .shift(shift), .shmnt(shmnt));
endmodule
