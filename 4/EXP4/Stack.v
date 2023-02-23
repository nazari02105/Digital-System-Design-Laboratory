module stack (Clk, RstN, Data_In, Push, Pop, Data_Out, Full, Empty);
    input Clk, RstN, Push, Pop;
    input [3:0] Data_In;
    output reg Full, Empty; 
    output reg [3:0] Data_Out;
    
    reg[3:0] memory[7:0];
    integer index = 0;
    integer i;
    always @(posedge Clk) begin
        if(RstN) begin
            for (i = 0; i < 8 ; i = i + 1) begin
                memory[i] <= 0;
            end
            index = 0;
            Empty = 0;
            Full = 0;
        end
        else begin
            if(Push && Pop) begin
            //do nothing
            end
            else if(Push) begin
                if(index <= 7) begin
                    index = index + 1;
                    memory[index - 1] = Data_In;
                end
            end
            else if(Pop) begin
                if(index > 0) begin
                    Data_Out = memory[index - 1];
                    index = index - 1;
                end
            end
        end
    Full = (index == 8);
    Empty = !(index == 0);
    end
endmodule