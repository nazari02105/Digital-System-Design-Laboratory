`include "FanController.v"

module FanControllerTest;
    reg clk, reset;
    reg [3:0] microupcode;
    reg signed [7:0] set_point, sensor1_temp, sensor2_temp;
    wire signed [7:0] user_output;
    wire [1:0] fan_status;
    wire cooler_status;

    initial clk = 0;
    always #5 clk = ~clk;

    FanController #(100) fn(clk, reset, microupcode, set_point, sensor1_temp, sensor2_temp, fan_status, cooler_status, user_output);

    initial begin
        microupcode = 4'b1000;
        reset = 1;
        #8;
        reset = 0;
        sensor1_temp = 100;
        sensor2_temp = 50;
        set_point = 10;
        #(100 * 11 * 80);
        $display("user output: %d fan status: %d cooler status: %d", user_output, fan_status, cooler_status);
        $finish;
    end
endmodule