module DataMemory(
    input [7:0] d_address,
    inout [7:0] d_data,
    input write
);
    reg [7:0] d_storage [255:0];

    assign d_data = (~write && d_address < 'hF8) ? d_storage[d_address] : 8'hzz;
    
    always @(posedge write)
        d_storage[d_address] = d_data;

endmodule