module Stack_TB;
    reg Clk, RstN, Push, Pop;
    reg [3:0] Data_In;
    wire Full, Empty;
    wire [3:0] Data_Out;
    stack stack0(Clk, RstN, Data_In, Push, Pop,  Data_Out, Full, Empty);

    //clk
    initial begin
        Clk = 1'b0;
    end
    always #5 Clk = ~Clk;

    initial
	begin
		RstN <= 1'b1;
		Push <= 1'b0;
		Pop <= 1'b0;
		#10
		RstN <= 1'b0;
		Data_In <= 4'b1111;
		Push <= 1'b1;
        //push 0110
		#10
		Data_In <= 4'b1101;
		Push <= 1'b1;
        //push 1101
		#10
		Push <= 1'b0;
		Pop <= 1'b1;
        //pop 1101
		#10
        Pop <= 1'b0;
		Push <= 1'b1;
		Data_In <= 4'b0110;
        //push 0110
		#10
		Push <= 1'b1;
		Data_In <= 4'b0111;
        //push 0111
		#10
		Push <= 1'b1;
		Data_In <= 4'b1110;
        //push 1110
		#10
		Push <= 1'b1;
		Data_In <= 4'b0100;
        //push 0100
		#10
		Push <= 1'b1;
		Data_In <= 4'b0010;
        //push 0010
		#10
		Push <= 1'b1;
		Data_In <= 4'b1000;
        //push 1000
		#10
		Push <= 1'b1;
		Data_In <= 4'b0110;
        //push 0110
		#10
		Push <= 1'b1;
		Data_In <= 4'b0111;
        //push 0111
		#10
		Push <= 1'b1;
		Data_In <= 4'b1110;
        //push 1110
		#10
		Push <= 1'b1;
		Data_In <= 4'b0010;
        //push 0010
		#10
        Push <= 1'b0;
		Pop <= 1'b1;
		#10
		Pop <= 1'b1;
		#10
		Pop <= 1'b1;
		#10
		Pop <= 1'b1;
		#10
		Pop <= 1'b1;
		#10
		Pop <= 1'b1;
		#10
		Pop <= 1'b1;
		#10
		Pop <= 1'b1;
		#10
		Pop <= 1'b1;
		#10
		Data_In <= 4'b0000;
		Push <= 1'b1;
		Pop <= 1'b1;
            //nothing!
		#10
		$stop;
	end
endmodule