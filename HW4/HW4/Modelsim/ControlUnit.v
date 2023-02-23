module ControlUnit(
    input wire clk,
    input wire reset,
    /////////////////////
    // Main Controller //
    /////////////////////
    input wire [3:0] microupcode,
    input wire signed [7:0] sensor1_temp,
    input wire signed [7:0] sensor2_temp,
    output reg [1:0] fan_status,
    output reg cooler_status,
    //////////////
    // Datapath //
    //////////////
    output reg reset_clock_counter,
    output reg reset_sum_registers,
    input wire new_temp_ready,
    // Sum saver registers
    output reg [7:0] sensor1_in,
    output reg [7:0] sensor2_in,
    output reg sensor1_last_load,
    output reg sensor2_last_load,
    // Each bit of these inputs will enable one of the chips (so sevral chips can be enabled together)
    output reg [2:0] sensor1_average_enable,
    output reg [2:0] sensor2_average_enable,
    output reg [2:0] sensor1_average_mode,
    output reg [2:0] sensor2_average_mode,
    // We need the raw ouput of these 
    output reg [2:0] average_select,
    // Memory stuff
    output reg datapath_memory_address_count_up,
    output reg datapath_memory_select,
    output reg [1:0] memory_old_select,
    // Fan controller stuff
    input wire [1:0] fan_status_result,
    /////////
    // RAM //
    /////////
    output reg ram_write_enable,
    inout [7:0] ram_inout,
    output reg ram_reset
);
    // State stuff
    localparam [3:0] STATE_START = 0, STATE_STORE_SENSOR1 = 1, STATE_STORE_SENSOR2 = 2,
        STATE_UPDATE_SENSOR1_REG20 = 3, STATE_UPDATE_SENSOR2_REG20 = 4,
        STATE_UPDATE_SENSOR1_REG40 = 5, STATE_UPDATE_SENSOR2_REG40 = 6,
        STATE_UPDATE_SENSOR1_REG60 = 7, STATE_UPDATE_SENSOR2_REG60 = 8,
        STATE_CHECK_UPCODE = 9, STATE_UPDATE_COOLER = 10, STATE_AFTER_SENSOR_UPDATE = 11;
    reg [3:0] state, next_state;

    // Ram
    reg [7:0] ram_output;
    assign ram_inout = ram_write_enable ? ram_output : 8'bz;
    
    // Combinational part
    always @(*) begin
        // Reset status registers
        reset_clock_counter = 0;
        reset_sum_registers = 0;
        ram_write_enable = 0;
        ram_reset = 0;
        sensor1_last_load = 0;
        sensor2_last_load = 0;
        sensor1_average_enable = 0;
        sensor2_average_enable = 0;
        datapath_memory_address_count_up = 0;
        // Check state
        case(state)
            STATE_START: begin
                if (new_temp_ready) begin
                    next_state = STATE_STORE_SENSOR1;
                    reset_clock_counter = 1;
                end else begin
                    next_state = STATE_CHECK_UPCODE;
                end
            end
            STATE_STORE_SENSOR1: begin
                datapath_memory_select = 0; // first sensor
                memory_old_select = 0; // current index
                ram_output = sensor1_temp; // save temp 1
                sensor1_in = sensor1_temp;
                ram_write_enable = 1; // write to ram
                sensor1_last_load = 1;
                sensor1_average_enable = 3'b111; // add to all
                sensor1_average_mode = 3'b000; // mode add
                next_state = STATE_STORE_SENSOR2;
            end
            STATE_STORE_SENSOR2: begin
                datapath_memory_select = 1; // second sensor
                memory_old_select = 0; // current index
                ram_output = sensor2_temp; // save temp 2
                sensor2_in = sensor2_temp;
                ram_write_enable = 1; // write to ram
                sensor2_last_load = 1;
                sensor2_average_enable = 3'b111; // add to all
                sensor2_average_mode = 3'b000; // mode add
                next_state = STATE_UPDATE_SENSOR1_REG20;
            end
            STATE_UPDATE_SENSOR1_REG20: begin
                datapath_memory_select = 0; // first sensor
                memory_old_select = 1; // -20
                // We edit the reg in next state
                next_state = STATE_UPDATE_SENSOR2_REG20;
            end
            STATE_UPDATE_SENSOR2_REG20: begin
                // Update the sensor from previous state
                sensor1_average_enable = 3'b001; // sub from first
                sensor1_average_mode = 3'b001; // mode sub
                sensor1_in = ram_inout;
                // Update ram
                datapath_memory_select = 1; // second sensor
                memory_old_select = 1; // -20
                next_state = STATE_UPDATE_SENSOR1_REG40;
            end
            STATE_UPDATE_SENSOR1_REG40: begin
                // Update the sensor
                sensor2_average_enable = 3'b001; // sub from first
                sensor2_average_mode = 3'b001; // mode sub
                sensor2_in = ram_inout;
                // Update ram
                datapath_memory_select = 0; // first sensor
                memory_old_select = 2; // -40
                next_state = STATE_UPDATE_SENSOR2_REG40;
            end
            STATE_UPDATE_SENSOR2_REG40: begin
                // Update the sensor
                sensor1_average_enable = 3'b010;
                sensor1_average_mode = 3'b010; // mode sub
                sensor1_in = ram_inout;
                // Update ram
                datapath_memory_select = 1; // second sensor
                memory_old_select = 2; // -40
                next_state = STATE_UPDATE_SENSOR1_REG60;
            end
            STATE_UPDATE_SENSOR1_REG60: begin
                // Update the sensor
                sensor2_average_enable = 3'b010;
                sensor2_average_mode = 3'b010; // mode sub
                sensor2_in = ram_inout;
                // Update ram
                datapath_memory_select = 0; // first sensor
                memory_old_select = 3; // -60
                next_state = STATE_UPDATE_SENSOR2_REG60;
            end
            STATE_UPDATE_SENSOR2_REG60: begin
                // Update the sensor
                sensor1_average_enable = 3'b100;
                sensor1_average_mode = 3'b100; // mode sub
                sensor1_in = ram_inout;
                // Update ram
                datapath_memory_select = 1; // second sensor
                memory_old_select = 3; // -60
                next_state = STATE_AFTER_SENSOR_UPDATE;
            end
            STATE_AFTER_SENSOR_UPDATE: begin
                // Update the sensor
                sensor2_average_enable = 3'b100;
                sensor2_average_mode = 3'b100; // mode sub
                sensor2_in = ram_inout;
                datapath_memory_address_count_up = 1; // increase memory address
                // Done
                next_state = STATE_CHECK_UPCODE;
            end
            STATE_CHECK_UPCODE: begin
                case (microupcode)
                4'b0000: begin
                    reset_sum_registers = 1;
                    ram_reset = 1;
                end
                4'b1000: average_select = 0;
                4'b1100: average_select = 1;
                4'b1001: average_select = 2;
                4'b1010: average_select = 4;
                4'b1011: average_select = 6;
                4'b1101: average_select = 3;
                4'b1110: average_select = 5;
                4'b1111: average_select = 7;
                endcase
                next_state = microupcode == 0 ? STATE_START : STATE_UPDATE_COOLER;
            end
            STATE_UPDATE_COOLER: begin
                // This is combinational so we can do this
                case (fan_status_result)
                2'b00: begin
                    fan_status = 0;
                    cooler_status = 0;
                end
                2'b01: begin
                    fan_status = 2;
                    cooler_status = 1;
                end
                2'b10: begin
                    fan_status = 1;
                    cooler_status = 0;
                end
                2'b11: begin
                    fan_status = 2;
                    cooler_status = 0;
                end
                endcase
                next_state = STATE_START;
            end
        endcase
    end

    // Sequential part
    always @(posedge clk or posedge reset) begin
        if (reset)
            state <= STATE_START;
        else
            state <= next_state;
    end
endmodule