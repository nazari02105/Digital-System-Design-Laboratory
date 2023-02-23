module JK (q, reset, clk, j, k);
	output q;
	input reset, clk, j, k;
	reg q;
	always @(posedge reset or negedge clk) begin
		if (reset == 1) begin
			q = 0;
		end
		else begin
			if (j == 1 && k == 0) begin
				q = 1;
			end
			if (j == 1 && k == 1) begin
				q = ~q;
			end
			if (j == 0 && k == 1) begin
				q = 0;
			end
		end
	end
endmodule
