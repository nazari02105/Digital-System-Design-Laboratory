module FanController #(parameter CLOCK_FREQUENCY = 10000) (
    input wire clk,
    input wire reset,
    input wire [3:0] microupcode,
    input wire signed [7:0] set_point,
    input wire signed [7:0] sensor1_temp,
    input wire signed [7:0] sensor2_temp,
    output wire [1:0] fan_status,
    output wire cooler_status,
    output wire [7:0] user_output
);
    wire [7:0] mem_address, mem_inout;
    wire mem_wire_enable, mem_reset;
    Memory ram (.clk(clk), .reset(reset | mem_reset), .addr(mem_address), .write_enable(mem_wire_enable), .data(mem_inout));

    wire reset_clock_counter, reset_sum_registers, new_temp_ready, sensor1_last_load, sensor2_last_load, memory_address_count_up, memory_select;
    wire [7:0] sensor1_in, sensor2_in;
    wire [2:0] sensor1_average_enable, sensor2_average_enable, sensor1_average_mode, sensor2_average_mode, average_select;
    wire [1:0] fan_status_result, memory_old_select;
    Datapath #(CLOCK_FREQUENCY) datapath(
        .clk(clk),
        .reset(reset),
        .reset_clock_counter(reset_clock_counter),
        .reset_sum_registers(reset_sum_registers),
        .new_temp_ready(new_temp_ready),
        .sensor1_in(sensor1_in),
        .sensor2_in(sensor2_in),
        .sensor1_last_load(sensor1_last_load),
        .sensor2_last_load(sensor2_last_load),
        .sensor1_average_enable(sensor1_average_enable),
        .sensor2_average_enable(sensor2_average_enable),
        .sensor1_average_mode(sensor1_average_mode),
        .sensor2_average_mode(sensor2_average_mode),
        .average_select(average_select),
        .average_output(user_output),
        .memory_address_count_up(memory_address_count_up),
        .memory_select(memory_select),
        .memory_old_select(memory_old_select),
        .memory_address(mem_address),
        .set_point(set_point),
        .fan_status_result(fan_status_result)
    );
    ControlUnit cu(
        .clk(clk),
        .reset(reset),
        .microupcode(microupcode),
        .sensor1_temp(sensor1_temp),
        .sensor2_temp(sensor2_temp),
        .fan_status(fan_status),
        .cooler_status(cooler_status),
        .reset_clock_counter(reset_clock_counter),
        .reset_sum_registers(reset_sum_registers),
        .new_temp_ready(new_temp_ready),
        .sensor1_in(sensor1_in),
        .sensor2_in(sensor2_in),
        .sensor1_last_load(sensor1_last_load),
        .sensor2_last_load(sensor2_last_load),
        .sensor1_average_enable(sensor1_average_enable),
        .sensor2_average_enable(sensor2_average_enable),
        .sensor1_average_mode(sensor1_average_mode),
        .sensor2_average_mode(sensor2_average_mode),
        .average_select(average_select),
        .datapath_memory_address_count_up(memory_address_count_up),
        .datapath_memory_select(memory_select),
        .memory_old_select(memory_old_select),
        .fan_status_result(fan_status_result),
        .ram_write_enable(mem_wire_enable),
        .ram_inout(mem_inout),
        .ram_reset(mem_reset)
    );
endmodule