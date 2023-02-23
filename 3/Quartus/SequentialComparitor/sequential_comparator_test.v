//`include "sequential_comparator.v"

module sequential_comparator_test;
    reg x, y, clk, reset;
    wire gt, lt;
    integer i, j, temp_x, temp_y;

    sequential_comparator sc(x, y, reset, clk, gt, lt);

    initial clk = 1'b1;
    always #5 clk = ~clk;

    initial begin
        // Hardcoded test
        reset = 1'b1;
        x = 1'b0;
        y = 1'b0;
        #10
        reset = 1'b0;
        x = 1'b0;
        y = 1'b0;
        #10
        x = 1'b1;
        y = 1'b0;
        #10
        x = 1'b0;
        y = 1'b1;
        #10
        x = 1'b0;
        y = 1'b0;
        // Fuzzy test
        for (i = 0; i < 10; i=i+1) begin
            // Reset numbers
            #20 reset = 1'b1;
            temp_x = 0;
            temp_y = 0;
            #10
            reset = 1'b0;
            // Create a 4 bit number
            for (j = 0; j < 4; j=j+1) begin 
                x = $random % 2;
                y = $random % 2;
                temp_x = (temp_x << 1) + x;
                temp_y = (temp_y << 1) + y;
                #1
                $display("x=%d y=%d gt=%d lt=%d", temp_x, temp_y, gt, lt);
                #9
                temp_x = temp_x; // no op
            end
        end
        $stop;
    end
endmodule