module alu #(parameter N = 4)(input wire clock, input wire reset, input wire data_in, output wire data_out);
	reg [N-1:0] a, b;
    reg [2*N-1:0] result;
    reg [1:0] state, opcode;
    integer counter;
    reg exception, ready;
    assign data_out = (state == 2'b01 ? (~|result) : state == 2'b00 ? (^result) : result[2*N-1-counter]) | exception;
    always @(posedge clock) 
    begin
    	if (ready)
    	begin
    		state = 2'b00;
    		ready = 0;
    	end
        if (reset) 
		begin
			a = 0;
            b = 0;
            result = 0;
            state = 2'b00;
            opcode = 2'b00;
            counter = 0;
            exception = 0;
            ready = 0;
        end 
		else 
		begin
			if (state == 2'b00)
			begin
				counter = 0;
				opcode[1] = data_in;
                state = 2'b01;
			end
			else if (state == 2'b01)
			begin
				opcode[0] = data_in;
                state = 2'b10;
			end
			else if (state == 2'b10)
			begin
				a[N-1-counter] = data_in;
                counter = counter + 1;
                if (counter == N)
                    state = 2'b11;
			end
			else if (state == 2'b11)
			begin
				b[2*N-1-counter] = data_in;
                counter = counter + 1;
                if (counter == 2 * N) 
				begin
                    exception = 0;
                    if (opcode == 2'b00)
                    begin
                    	if (b == 0) 
						begin
                           result = 0;
                           exception = 1;
                        end 
						else
                            result = a / b;
                    end
                    else
                    begin
                    	result = opcode == 2'b01 ? a - b : opcode == 2'b11 ? a * b : a + b;
                    end
                    ready = 1;
                end
			end
        end
    end
endmodule