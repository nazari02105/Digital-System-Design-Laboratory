module register (input wire clk,input wire load,input wire [31:0] data,output reg [31:0] out,input wire dec, input wire reset);

	always @(posedge clk) 
	begin
		if (load)
			out <= data;
		else if (dec)
			out <= out - 1;
		else if (reset)
			out <= 0;
	end

endmodule
