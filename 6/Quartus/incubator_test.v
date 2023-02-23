module IncubatorTest;
    reg clk;
    reg reset;
    reg signed [7:0] temperature;
    wire heater_on;
    wire cooler_on;
    wire [3:0] fan_speed;
    integer i;

    Incubator incubator(clk, reset, temperature, heater_on, cooler_on, fan_speed);
    initial clk = 1'b1;
    always #5 clk= ~clk;

    initial begin
        reset = 1'b1;
        temperature = 0;
        #10;
        // Simple tests
        reset = 1'b0;
        temperature = 0;
        #60;
        temperature = 10;
        #60;
        temperature = 20;
        #60;
        temperature = 50;
        #60;
        temperature = 30;
        #60;
        for (i = 0; i < 10; i = i + 1) begin
            temperature = ($urandom % 70) - 10;
            #60;
        end
        $stop;
    end
endmodule
