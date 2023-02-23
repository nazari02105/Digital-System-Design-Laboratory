module IO(
    input [7:0] d_address,
    inout [7:0] d_data,
    input write,
    input [7:0] X,
    output reg [7:0] Y
);
    
    assign d_data = (~write && d_address == 'hF8) ? X : 8'hzz;
    
    always @(posedge write)
        if (d_address == 8'hFF)
            Y = d_data;
    
endmodule