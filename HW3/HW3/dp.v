module Datapath (
input wire clk,input wire [31:0] first_operand , , load_controller , multiplicand_controller , decrement_controller, [31:0] max_controller, select_controller , multiplicand_select , reset_result, [31:0] second_operand, load_result, load_controller, load_final , final_select ,output wire multipicant_or , result_gt_max, multiplier_gt_multiplicand, [31:0] final);
	wire [31:0] the_result_1 , main_input_1 , main_result_1, main_input_2, max, result_data, adder_result, final_register_input;
	register multipicant(clk, multiplicand_controller ,decrement_controller , main_input_1 , the_result_1);
	register max_reg(clk, load_controller , max_controller , max);
	register multiplier(clk, load_controller , main_input_2 ,main_result_1);
	register final_register(clk, load_final , final_register_input ,final);
	register result(clk, load_result , reset_result ,adder_result , result_data);
	Mux mux_1(first_operand, main_result_1 , multiplicand_select ,main_input_1);
	Mux mux_2(second_operand, the_result_1 , select_controller ,main_input_2);
	Mux mux_3(result_data , max, final_select ,final_register_input);
	Adder adder(result_data , main_result_1 , adder_result);
	Comparator comtor(main_result_1 , the_result_1 , multiplier_gt_multiplicand);
	Comparator maxComprator(result_data , max,result_gt_max);
	DO_OR or1(the_result_1 , multipicant_or);
endmodule
