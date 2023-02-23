module CounterWithMod #(parameter WIDTH = 8, parameter MOD = 100) (
    input wire clk,
    input wire clear,
    input wire enable,
    input wire mod_enable,
    output reg [WIDTH-1:0] out
);
    always @(posedge clk or posedge clear) begin
        if (clear)
            out <= 0;
        else if (enable) begin
            if (mod_enable)
                out <= (out + 1) % MOD;
            else
                out <= out + 1;
        end
    end
endmodule