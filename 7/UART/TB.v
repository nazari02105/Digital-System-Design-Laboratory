`timescale 1ns/1ns
module TB;
	
	reg reset;
	reg clk1 = 1'b1;
	always @(clk1) clk1 <= #5 ~clk1;
	reg clk2 = 1'b1;
	always @(clk2) clk2 <= #7 ~clk2;
	

	reg [15:0] divisor1 = 7;
	reg [15:0] divisor2 = 5;
	
	// simplex comunication : uart1.tx_data_out -> uart2.rx_data_in
	wire simplex;
	

	reg send;
	reg [7:0] tx_data_in;
	
	UART uart1(
	
		.reset (reset),
		.sysclk (clk1),
		.divisor (divisor1),
		
		.send (send),
		.tx_data_in (tx_data_in),
		.tx_data_out (simplex)
	);
	
	wire [7:0] rx_data_out;
	wire ready;
	wire error;
	
	UART uart2 (
		.reset (reset),
		.sysclk (clk2),
		.divisor (divisor2),
		
		.rx_data_in (simplex),
		.rx_data_out (rx_data_out),
		.ready (ready),
		.error (error)
	);
	
	reg[13*8-1:0] text = "Hello, World!";
	integer i = 0;
	
	initial
	begin
	
		// set even parity bits
		for (i = 12; i >= 0; i = i-1)
			text[(i+1)*8-1] = ^ text[(i*8) +: 7];
		
		reset = 1;
		#70; // wait for 1 tick
		
		reset = 0;
		#70; // wait for 1 tick
		
		send = 1;
		for (i = 12; i >= 0; i = i-1)
		begin
			tx_data_in = text[(i*8) +: 8];
			#700; // wait for 10 ticks
		end
		send = 0;
		
		$stop;
	end
	
	always @(posedge ready)
		$display("time = %6d ns",  $time, 
					" -> rx_data_out = %b (%c)", rx_data_out[6:0], rx_data_out[6:0],
					" , parity error = ", error);
	
endmodule
