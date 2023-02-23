module Memory (
    input wire clk,
    input wire reset,
    input wire [7:0] addr, // 8 bit address to access at last 256
    input wire write_enable,    
    inout [7:0] data
);
    reg [7:0] mem[0:199];
    reg [7:0] read_data;
    integer i;
    
    assign data = write_enable ? 8'bz : read_data;
    
    always @(posedge clk or posedge reset) begin
        if (reset)
            for (i = 0; i < 200; i = i + 1)
                mem[i] <= 0;
        else if (write_enable)
            mem[addr] <= data;
        else
            read_data <= mem[addr];
    end
endmodule