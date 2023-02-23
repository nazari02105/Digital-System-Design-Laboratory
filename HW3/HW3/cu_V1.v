module CU(input S, OR_R1, CMP_L_R1, output reg L_R1, L_R2, L_R3, L_R4, R_R3, Dec_R1, Sel_R1, Sel_R2, S_R, R_R);
	reg[1:0] p_state, n_state;
	localparam[1:0] init=1'b00, cmp=2'b01, mul=2'b10;
	always @(p_state or S or OR_R1 or CMP_L_R1)
	begin
		n_state = init;
		case (p_state):
			init:
				begin
				end
			cmp:
				begin
				end
		endcase
	end

	always @(posedge clk)
	begin
		if (rst) p_state = init;
		else p_state = n_state;
	end
endmodule