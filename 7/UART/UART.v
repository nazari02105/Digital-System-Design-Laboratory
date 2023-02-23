`timescale 1ns/1ns
module UART
	(
		input reset,                 // reset module
		input sysclk,                // system clock
		input [15:0] divisor,        // to set baud rate
		
		input send,                  // start transmission
		input [7:0] tx_data_in,      // parallel transmit data <- proccessor
		output tx_data_out,          // serial transmit output
		
		input rx_data_in,            // serial receiver input
		output reg [7:0] rx_data_out,// parallel receiver data -> proccessor
		output reg ready,            // received byte is ready
		output error                 // check even parity
	);
	
	// generate tick
	wire tick;
	baude_rate_generator brg(
		.reset(reset),
		.clk(sysclk),
		.divisor(divisor), 
		.tick(tick)
	);
	
	//RECEIVER 
	reg rx_cs;
	reg rx_ns;
	reg [2:0] rx_counter;
	localparam IDLE = 1'b0;
	localparam DATA = 1'b1;
	
	// detect rx next state
	always @(*)
	begin
		if (rx_cs == IDLE)
			if (rx_data_in == 0)	// start bit
				rx_ns = DATA;
			else						
				rx_ns = IDLE;
		
		else
			if (rx_counter == 7)	// last data bit
				rx_ns = IDLE;
			else						
				rx_ns = DATA;
	end
	
	// at tick, go to next state
	always @(posedge tick)
	begin
		if (reset)
		begin
			rx_cs <= IDLE;
			rx_counter <= 0;
		end
		else
			rx_cs <= rx_ns;
		
		
		if (rx_cs == DATA)
		begin
			rx_data_out[rx_counter] <= rx_data_in;
			rx_counter <= rx_counter + 1'b1;
		end
		
		
		if (rx_cs != rx_ns)
			ready <= (rx_ns == IDLE);
	end
	
	// even parity
	assign error = ^ rx_data_out;
	
	//TRANSMITTER
	
	reg [1:0] tx_cs;
	reg [1:0] tx_ns;
	reg [2:0] tx_counter;
	localparam START = 2'b10;
	
	//detect tx next state
	always @(*)
	begin
		if (tx_cs == IDLE)
			if (send == 1)
				tx_ns = START;
			else
				tx_ns = IDLE;
		
		else if (tx_cs == START)
			tx_ns = DATA;
			
		else 
		begin
			if (tx_counter == 7)
				tx_ns = IDLE;
			else
				tx_ns = DATA;
		end
		
	end
	
	// at tick, go to tx next state
	always @(posedge tick)
	begin
		if (reset)
		begin
			tx_cs <= IDLE;
			tx_counter <= 0;
		end
		else
			tx_cs <= tx_ns;
		
		
		if (tx_cs == DATA)
			tx_counter <= tx_counter + 1'b1;
	end
	
	assign tx_data_out =
			(tx_cs == IDLE) ? 1'b1 :
			(tx_cs == START) ? 1'b0 : tx_data_in[tx_counter];
	
endmodule
