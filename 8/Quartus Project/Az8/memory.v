`timescale 1ns/1ns
module memory(input [4:0] address, output reg [17:0] instruction);
	always @(address)
	begin
		if (address == 0) instruction = 18'b01_1111_0001_0001_0010;
		if (address == 1) instruction = 18'b00_0111_0001_0001_0011;
		if (address == 2) instruction = 18'b00_0001_0001_0001_0010;
		if (address == 3) instruction = 18'b10_0011_0001_0001_0010;
		if (address == 4) instruction = 18'b01_0011_0011_0011_0000;
		if (address == 5) instruction = 18'b00_0011_0001_0001_0000;
		if (address == 6) instruction = 18'b00_0011_0001_0001_0010;
		if (address == 7) instruction = 18'b10_0011_0001_0001_0010;
		if (address == 8) instruction = 18'b01_0011_0001_0001_0011;
		if (address == 9) instruction = 18'b10_0011_0001_0001_0011;
		if (address == 10) instruction = 18'b10_0011_0001_0011_0010;
		if (address == 11) instruction = 18'b10_0011_0011_0001_0010;
		if (address == 12) instruction = 18'b10_0011_0011_0001_0010;
		if (address == 13) instruction = 18'b10_0001_0001_0001_0010;
		if (address == 14) instruction = 18'b01_0101_0011_0001_0011;
		if (address == 15) instruction = 18'b01_1000_0001_0001_0110;
		if (address == 16) instruction = 18'b10_0011_0011_0001_0010;
		if (address == 17) instruction = 18'b00_0011_0001_0001_0011;
		if (address == 18) instruction = 18'b00_1000_0001_0001_0110;
		if (address == 19) instruction = 18'b01_0011_0001_0001_0011;
		if (address == 20) instruction = 18'b10_0011_0001_0001_0011;
		if (address == 21) instruction = 18'b10_0001_0001_0001_0010;
		if (address == 22) instruction = 18'b10_0011_0010_0010_0011;
		if (address == 23) instruction = 18'b00_0011_0001_0001_0010;
		if (address == 24) instruction = 18'b01_0011_1101_0001_0000;
		if (address == 25) instruction = 18'b00_0011_0010_0001_0111;
		if (address == 26) instruction = 18'b10_0011_0001_0011_0001;
		if (address == 27) instruction = 18'b01_0011_0001_0001_0010;
		if (address == 28) instruction = 18'b01_0011_0111_0001_0001;
		if (address == 29) instruction = 18'b01_0011_0111_0001_0010;
		if (address == 30) instruction = 18'b00_0011_0111_0001_0010;
		if (address == 31) instruction = 18'b01_1111_1111_0001_0010;
	end
endmodule