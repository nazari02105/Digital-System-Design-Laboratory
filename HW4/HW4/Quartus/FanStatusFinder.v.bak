`include "Abs.v"
`include "BetweenChecker.v"

module FanStatusResultFinder (
    input wire signed [7:0] sensor1_60_average,
    input wire signed [7:0] sensor2_60_average,
    input wire signed [7:0] set_point,
    output reg [1:0] result
);
    // Get the abs of diffrence
    wire [7:0] abs_diff;
    Abs #(8) abs(sensor2_60_average - sensor1_60_average, abs_diff);

    // Check if set point is in between
    wire set_point_between_averages;
    BetweenChecker #(8) between_checker(sensor1_60_average, sensor2_60_average, set_point, set_point_between_averages);

    always @(*) begin
        if (sensor2_60_average < set_point)
            result = 0;
        else if (sensor2_60_average > set_point & sensor1_60_average > set_point)
            result = 1;
        else if (set_point_between_averages) begin
            if (abs_diff <= 3)
                result = 2;
            else
                result = 3;
        end
    end
endmodule