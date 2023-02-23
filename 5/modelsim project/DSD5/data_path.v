`timescale 1ns/1ns
module data_path(input clk, input [7:0] input_1, input [7:0] input_2, output reg [7:0] dxb_input_1, output reg [7:0] dxb_input_2, input load, input sum_or_diff, input shift, input [3:0] shmnt);
	reg [7:0] M;
	reg LSB;
	always @(posedge clk)
	begin
		if (load)
		begin
			 M <= input_1;
			 dxb_input_1 <= 0;
			 dxb_input_2 <= input_2;
			 LSB <= 0;
		end
		else if (sum_or_diff)
		begin
			if (dxb_input_2[0] == 1 && LSB == 0)
				dxb_input_1 <= dxb_input_1 - M;
			else if (dxb_input_2[0] == 0 && LSB == 1)
				dxb_input_1 <= dxb_input_1 + M;
		end
		else if (shift)
			{dxb_input_1, dxb_input_2, LSB} <= $signed({dxb_input_1, dxb_input_2, LSB}) >>> shmnt;
	end
endmodule


