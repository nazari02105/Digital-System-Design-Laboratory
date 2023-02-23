`timescale 1ns/1ns
module alu(input reset, input clk, output reg [3:0] real_part, output reg [3:0] imaginary_part, output ready);
	// first stage
	reg [4:0] PC;
	wire [17:0] instruction;
	reg [17:0] instruction_in_register;
	wire wait_all;
	wire wait_mult;
	wire wait_add;
	assign wait_all = wait_mult || wait_add;
	memory mem(PC, instruction);
	always @(posedge clk)
	begin
		if (reset) PC <= 0;
		else
			if (!wait_all)
			begin
				instruction_in_register <= instruction;
				PC <= PC + 1'b1;
			end
	end
	// second stage
	wire [3:0] multiplier_first_operand;
	wire [3:0] multiplier_second_operand;
	wire [3:0] multiplier_output;
	reg [1:0] stage2_counter;
	reg stage2_ready;
	reg [3:0] stage2_first, stage2_second, stage2_third, stage2_forth;
	reg [1:0] stage2_opcode;
	reg [3:0] first, second, third;
	multiplier multiplier_unit(multiplier_first_operand, multiplier_second_operand, multiplier_output);
	assign multiplier_first_operand = (stage2_counter == 0) ? instruction_in_register[15:12]: (stage2_counter == 1) ? instruction_in_register[11:8]: (stage2_counter == 2) ? instruction_in_register[11:8]: instruction_in_register[15:12];
	assign multiplier_second_operand = (stage2_counter == 0) ? instruction_in_register[7:4]: (stage2_counter == 1) ? instruction_in_register[7:4]: (stage2_counter == 2) ? instruction_in_register[3:0]: instruction_in_register[3:0];
	assign wait_mult = !stage2_ready;
	always @(posedge clk)
	begin
		if (reset || !wait_all)
		begin
			stage2_counter <= 0;
			stage2_ready <= 0;
		end
		if (stage2_ready == 0)
		begin
			if (instruction_in_register[17] == 0) // it is add or sub
			begin
				if (!wait_add)
				begin
					stage2_opcode <= instruction_in_register[17:16];
					stage2_first <= instruction_in_register[15:12];
					stage2_second <= instruction_in_register[11:8];
					stage2_third <= instruction_in_register[7:4];
					stage2_forth <= instruction_in_register[3:0];
					stage2_counter <= 0;
					stage2_ready <= 1;
				end
			end
			else // it is mult
			begin
				if (stage2_counter == 0)
				begin
					first <= multiplier_output;
					stage2_counter <= stage2_counter + 1'b1;
				end
				if (stage2_counter == 1)
				begin
					second <= multiplier_output;
					stage2_counter <= stage2_counter + 1'b1;
				end
				if (stage2_counter == 2)
				begin
					third <= multiplier_output;
					stage2_counter <= stage2_counter + 1'b1;
				end
				if (stage2_counter == 3)
				begin
					stage2_first <= first;
					stage2_second <= second;
					stage2_third <= third;
					stage2_forth <= multiplier_output;
					stage2_opcode <= instruction_in_register[17:16];
					stage2_counter <= stage2_counter + 1'b1;
					stage2_ready <= 1;
				end
			end
		end
	end
	// third stage
	wire [3:0] adder_first_operand;
	wire [3:0] adder_second_operand;
	wire add_diff_not;
	wire [3:0] adder_out;
	reg stage3_counter;
	reg stage3_ready;
	reg [3:0] stage3_first;
	adder adder_unit(add_diff_not, adder_first_operand, adder_second_operand, adder_out);
	assign adder_first_operand = (stage3_counter == 0) ? stage2_first : stage2_second;
	assign adder_second_operand = (stage3_counter == 0) ? stage2_third : stage2_forth;
	assign add_diff_not = stage2_opcode[0] || stage2_opcode[1] && stage3_counter;
	assign wait_add = !stage3_ready && (stage3_counter != 1);
	assign ready = stage3_ready;
	always @(posedge clk)
	begin
		if (reset || !wait_all)
		begin
			stage3_counter <= 0;
			stage3_ready <= 0;
		end
		if (stage3_ready == 0)
		begin
			if (stage3_counter == 0)
			begin
				stage3_first <= adder_out;
				stage3_counter <= stage3_counter + 1'b1;
			end
			if (stage3_counter == 1)
			begin
				real_part <= stage3_first;
				imaginary_part <= adder_out;
				stage3_counter <= stage3_counter + 1'b1;
				stage3_ready <= 1;
			end
		end
	end
endmodule
