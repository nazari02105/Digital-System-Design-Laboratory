module SensorSumHolder #(parameter WIDTH = 16) (
    input wire clk,
    input wire reset,
    input wire enable, // if enable is zero nothing will be changed
    input wire sub_sum_not, // if 0 out will be in + out otherwise out = out - in
    input wire signed [WIDTH-1:0] in,
    output reg signed [WIDTH-1:0] out
);
    always @(posedge clk or posedge reset) begin
        if (reset)
            out <= 0;
        else if (enable) begin
            if (sub_sum_not) begin
                out <= out - in;
            end else begin
                out <= out + in;
            end
        end
    end
endmodule