module ControlUnit (input wire clk,reset ,start ,greater_than_max, main_or, is_greater,output reg ready ,in_1_l, result_r, in_2_l , final_s, multiplicand_d , ,in_2_s, max_l ,result_l, in_1_s ,final_l);
	reg [1:0] p_state , n_state;
	reg is_ready = 0;
	localparam [1:0] init=2'b00, cmp=2'b01, mul=2'b10, max=2';
	always @(*) begin
		n_state = init;
		case (p_state)
			init: begin
				if (start) begin
					{in_1_l, in_2_l, in_1_s, in_2_s, max_l, result_r, final_l, is_ready, final_s} = 9'b110011000;
					n_state = cmp;
				end
			end
			cmp: begin
				result_r = 0;
				if (is_greater) begin
					{in_1_s, in_2_s, in_1_l, in_2_l} = 4'b1111;
					n_state = mul;
				end else begin
					{in_1_l, in_2_l} = 2'b00;
					n_state = mul;
				end
			end
			mul: begin
				in_1_l = 0;
				in_2_l = 0;
				if (main_or) begin
					result_l = 1;
					multiplicand_d = 1;
					n_state = max;
				end else begin
					{result_l, multiplicand_d, final_l, is_ready} = 4'b0011;
					n_state = init;
				end
			end
			max: begin
				result_l = 0;
				multiplicand_d = 0;
				if (greater_than_max) begin
					is_ready = 1;
					final_s = 1;
					final_l = 1;
					n_state = init;
				end else begin
					n_state = mul;
				end
			end
		endcase
	end
	always @(posedge clk) begin
		if (reset)
			p_state <= init;
		else
			p_state <= n_state;
		ready <= is_ready;
	end
endmodule
