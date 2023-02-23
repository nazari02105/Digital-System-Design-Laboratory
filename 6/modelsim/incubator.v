module Incubator (
    input clk,
    input reset,
    input signed [7:0] T,
    output heater_on,
    output cooler_on,
    output [3:0] cooler_rps
);
    reg [1:0] main_state;
    reg [1:0] cooler_rps_state;
    reg [1:0] next_main_state;
    reg [1:0] next_cooler_rps_state;
    // Just like the chart in lab page
    assign cooler_on = (main_state == 2);
    assign heater_on = (main_state == 3);
    assign cooler_rps = cooler_rps_state == 0 ? 4'd0 : (cooler_rps_state == 1 ? 4'd4 : (cooler_rps_state == 2 ? 4'd6 : 4'd8));
    // Watch for temp change
    always @(T or main_state or cooler_rps_state) begin
        next_main_state <= main_state;
        // Check main state to decide the next state
        if (main_state == 1) begin
            if (T < 15)
                next_main_state <= 2'd3;
            else if (T > 35)
                next_main_state <= 2'd2;
        end else if (main_state == 2) begin
            if (T < 25)
                next_main_state <= 2'd1;
        end else if (main_state == 3) begin
            if (T > 30)
                next_main_state <= 2'd1;
        end
        // Check the fan state
        next_cooler_rps_state <= cooler_rps_state;
        // Nothing to do if cooler is not on
        if (next_main_state != 2) begin
            next_cooler_rps_state <= 0; // zero is out
        end else begin
            if (cooler_rps_state == 0) begin
                if (T > 35) // this looks unnecessary but whatever
                    next_cooler_rps_state <= 2'd1;
            end else if (cooler_rps_state == 1) begin
                if (T > 40)
                    next_cooler_rps_state <= 2'd2;
                else if (T < 25) // this looks unnecessary too
                    next_cooler_rps_state <= 2'd0;
            end else if (cooler_rps_state == 2) begin
                if (T > 45)
                    next_cooler_rps_state <= 2'd3;
                else if (T < 35)
                    next_cooler_rps_state <= 2'd1;
            end else if (cooler_rps_state == 3) begin
                if (T < 40)
                    next_cooler_rps_state <= 2'd2;
            end
        end
    end
    // Wait for clock
    always @(posedge clk) begin
        if (reset) begin
            main_state <= 2'b1;
            cooler_rps_state <= 2'b0;
        end else begin
            main_state <= next_main_state;
            cooler_rps_state <= next_cooler_rps_state;
        end
    end
endmodule
