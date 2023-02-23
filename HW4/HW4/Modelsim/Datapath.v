`include "CounterWithMod.v"
`include "dff_load.v"
`include "SensorSumHolder.v"
`include "Mux8To1.v"
`include "FanStatusFinder.v"

module Datapath #(parameter CLOCK_FREQUENCY = 10000) (
    input wire clk,
    input wire reset,
    input wire reset_clock_counter,
    input wire reset_sum_registers,
    output wire new_temp_ready,
    // Sum saver registers
    input wire [7:0] sensor1_in,
    input wire [7:0] sensor2_in,
    input wire sensor1_last_load,
    input wire sensor2_last_load,
    // Each bit of these inputs will enable one of the chips (so sevral chips can be enabled together)
    input wire [2:0] sensor1_average_enable,
    input wire [2:0] sensor2_average_enable,
    input wire [2:0] sensor1_average_mode,
    input wire [2:0] sensor2_average_mode,
    // We need the raw ouput of these 
    input wire [2:0] average_select,
    output wire signed [7:0] average_output,
    // Memory stuff
    input wire memory_address_count_up,
    input wire memory_select,
    input wire [1:0] memory_old_select, // 0: 0 / 1: -20 / 2: -40 / 3: -60
    output wire [7:0] memory_address,
    // Fan controller stuff
    input wire signed [7:0] set_point,
    output wire [1:0] fan_status_result
);
    // Sign extend inputs
    wire [15:0] sensor1_in_sign_extend = {{8{sensor1_in[7]}}, sensor1_in[7:0]};
    wire [15:0] sensor2_in_sign_extend = {{8{sensor2_in[7]}}, sensor2_in[7:0]};

    // Sum saver registers
    wire signed [7:0] sensor1_last_out, sensor2_last_out;
    DFFWithLoad #(.WIDTH(8)) sensor1_last(clk, reset | reset_sum_registers, sensor1_last_load, sensor1_in, sensor1_last_out);
    DFFWithLoad #(.WIDTH(8)) sensor2_last(clk, reset | reset_sum_registers, sensor2_last_load, sensor2_in, sensor2_last_out);
    wire signed [15:0] sensor1_20_out, sensor2_20_out, sensor1_40_out, sensor2_40_out, sensor1_60_out, sensor2_60_out;
    SensorSumHolder #(.WIDTH(16)) sensor1_20(.clk(clk), .reset(reset | reset_sum_registers), .enable(sensor1_average_enable[0]), .sub_sum_not(sensor1_average_mode[0]), .in(sensor1_in_sign_extend), .out(sensor1_20_out));
    SensorSumHolder #(.WIDTH(16)) sensor2_20(.clk(clk), .reset(reset | reset_sum_registers), .enable(sensor2_average_enable[0]), .sub_sum_not(sensor2_average_mode[0]), .in(sensor2_in_sign_extend), .out(sensor2_20_out));
    SensorSumHolder #(.WIDTH(16)) sensor1_40(.clk(clk), .reset(reset | reset_sum_registers), .enable(sensor1_average_enable[1]), .sub_sum_not(sensor1_average_mode[1]), .in(sensor1_in_sign_extend), .out(sensor1_40_out));
    SensorSumHolder #(.WIDTH(16)) sensor2_40(.clk(clk), .reset(reset | reset_sum_registers), .enable(sensor2_average_enable[1]), .sub_sum_not(sensor2_average_mode[1]), .in(sensor2_in_sign_extend), .out(sensor2_40_out));
    SensorSumHolder #(.WIDTH(16)) sensor1_60(.clk(clk), .reset(reset | reset_sum_registers), .enable(sensor1_average_enable[2]), .sub_sum_not(sensor1_average_mode[2]), .in(sensor1_in_sign_extend), .out(sensor1_60_out));
    SensorSumHolder #(.WIDTH(16)) sensor2_60(.clk(clk), .reset(reset | reset_sum_registers), .enable(sensor2_average_enable[2]), .sub_sum_not(sensor2_average_mode[2]), .in(sensor2_in_sign_extend), .out(sensor2_60_out));

    // Averages
    wire signed [7:0] sensor1_20_average = sensor1_20_out / 20;
    wire signed [7:0] sensor2_20_average = sensor2_20_out / 20;
    wire signed [7:0] sensor1_40_average = sensor1_40_out / 40;
    wire signed [7:0] sensor2_40_average = sensor2_40_out / 40;
    wire signed [7:0] sensor1_60_average = sensor1_60_out / 60;
    wire signed [7:0] sensor2_60_average = sensor2_60_out / 60;
    Mux8To1 average_result_mux(
        .a(sensor1_last_out),
        .b(sensor2_last_out),
        .c(sensor1_20_average),
        .d(sensor2_20_average),
        .e(sensor1_40_average),
        .f(sensor2_40_average),
        .g(sensor1_60_average),
        .h(sensor2_60_average),
        .select(average_select),
        .out(average_output)
    );

    // Cloak counter
    wire [31:0] clock_counter;
    CounterWithMod #(.WIDTH(32), .MOD(CLOCK_FREQUENCY)) clock_counter_part(.clk(clk), .clear(reset), .enable(1'b1), .mod_enable(reset_clock_counter), .out(clock_counter));
    assign new_temp_ready = clock_counter >= CLOCK_FREQUENCY;

    // Mem address
    wire [7:0] mem_address;
    CounterWithMod #(.WIDTH(8), .MOD(100)) mem_address_counter(.clk(clk), .clear(reset), .enable(memory_address_count_up), .mod_enable(1'b1), .out(mem_address));
    wire [31:0] offset_memory_address = (mem_address + memory_old_select * 80) % 100;
    assign memory_address = memory_select ? offset_memory_address + 100 : offset_memory_address;

    // Fan result
    FanStatusResultFinder fan_result_finder(.sensor1_60_average(sensor1_60_average), .sensor2_60_average(sensor2_60_average), .set_point(set_point), .result(fan_status_result));
endmodule