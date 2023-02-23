module InstructionMemory (
    input [7:0] i_address,
    output reg [11:0] i_data
);	
    reg [11:0] i_storage [255:0];
    
    always @(*)
        i_data = i_storage[i_address];
endmodule