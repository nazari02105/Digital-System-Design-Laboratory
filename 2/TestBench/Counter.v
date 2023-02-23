// Copyright (C) 2021  Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions 
// and other software and tools, and any partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License 
// Subscription Agreement, the Intel Quartus Prime License Agreement,
// the Intel FPGA IP License Agreement, or other applicable license
// agreement, including, without limitation, that your use is for
// the sole purpose of programming logic devices manufactured by
// Intel and sold by Intel or its authorized distributors.  Please
// refer to the applicable agreement for further details, at
// https://fpgasoftware.intel.com/eula.

// PROGRAM		"Quartus Prime"
// VERSION		"Version 21.1.0 Build 842 10/21/2021 SJ Lite Edition"
// CREATED		"Wed Mar 16 03:26:30 2022"

module Counter(
	up_down_not,
	enable,
	clock,
	clear,
	out0,
	out1,
	out2,
	out3,
	full,
	not_zero
);


input wire	up_down_not;
input wire	enable;
input wire	clock;
input wire	clear;
output wire	out0;
output wire	out1;
output wire	out2;
output wire	out3;
output wire	full;
output wire	not_zero;

wire	SYNTHESIZED_WIRE_20;
wire	SYNTHESIZED_WIRE_21;
wire	SYNTHESIZED_WIRE_2;
wire	SYNTHESIZED_WIRE_22;
wire	SYNTHESIZED_WIRE_23;
wire	SYNTHESIZED_WIRE_6;
reg	SYNTHESIZED_WIRE_24;
wire	SYNTHESIZED_WIRE_8;
wire	SYNTHESIZED_WIRE_10;
wire	SYNTHESIZED_WIRE_11;
wire	SYNTHESIZED_WIRE_12;
reg	SYNTHESIZED_WIRE_25;
reg	SYNTHESIZED_WIRE_26;
reg	SYNTHESIZED_WIRE_27;
wire	SYNTHESIZED_WIRE_13;
wire	SYNTHESIZED_WIRE_14;
wire	SYNTHESIZED_WIRE_15;
wire	SYNTHESIZED_WIRE_16;
wire	SYNTHESIZED_WIRE_17;
wire	SYNTHESIZED_WIRE_18;

assign	out0 = SYNTHESIZED_WIRE_25;
assign	out1 = SYNTHESIZED_WIRE_26;
assign	out2 = SYNTHESIZED_WIRE_24;
assign	out3 = SYNTHESIZED_WIRE_27;



assign	SYNTHESIZED_WIRE_18 = SYNTHESIZED_WIRE_20 | SYNTHESIZED_WIRE_21;

assign	SYNTHESIZED_WIRE_22 = SYNTHESIZED_WIRE_2 & SYNTHESIZED_WIRE_20;

assign	SYNTHESIZED_WIRE_6 = SYNTHESIZED_WIRE_22 | SYNTHESIZED_WIRE_23;

assign	SYNTHESIZED_WIRE_14 = SYNTHESIZED_WIRE_6 & enable;

assign	SYNTHESIZED_WIRE_11 = SYNTHESIZED_WIRE_23 & SYNTHESIZED_WIRE_24;

assign	SYNTHESIZED_WIRE_10 = SYNTHESIZED_WIRE_8 & SYNTHESIZED_WIRE_22;

assign	SYNTHESIZED_WIRE_12 = SYNTHESIZED_WIRE_10 | SYNTHESIZED_WIRE_11;

assign	SYNTHESIZED_WIRE_15 = SYNTHESIZED_WIRE_12 & enable;


always@(posedge clock or negedge clear)
begin
if (!clear)
	begin
	SYNTHESIZED_WIRE_25 <= 0;
	end
else
	SYNTHESIZED_WIRE_25 <= SYNTHESIZED_WIRE_25 ^ enable;
end

assign	full = SYNTHESIZED_WIRE_25 & SYNTHESIZED_WIRE_26 & SYNTHESIZED_WIRE_24 & SYNTHESIZED_WIRE_27;

assign	SYNTHESIZED_WIRE_16 =  ~SYNTHESIZED_WIRE_25;


always@(posedge clock or negedge clear)
begin
if (!clear)
	begin
	SYNTHESIZED_WIRE_26 <= 0;
	end
else
	SYNTHESIZED_WIRE_26 <= SYNTHESIZED_WIRE_26 ^ SYNTHESIZED_WIRE_13;
end


always@(posedge clock or negedge clear)
begin
if (!clear)
	begin
	SYNTHESIZED_WIRE_24 <= 0;
	end
else
	SYNTHESIZED_WIRE_24 <= SYNTHESIZED_WIRE_24 ^ SYNTHESIZED_WIRE_14;
end


always@(posedge clock or negedge clear)
begin
if (!clear)
	begin
	SYNTHESIZED_WIRE_27 <= 0;
	end
else
	SYNTHESIZED_WIRE_27 <= SYNTHESIZED_WIRE_27 ^ SYNTHESIZED_WIRE_15;
end

assign	SYNTHESIZED_WIRE_8 =  ~SYNTHESIZED_WIRE_24;

assign	SYNTHESIZED_WIRE_2 =  ~SYNTHESIZED_WIRE_26;

assign	not_zero = SYNTHESIZED_WIRE_25 | SYNTHESIZED_WIRE_24 | SYNTHESIZED_WIRE_27 | SYNTHESIZED_WIRE_26;

assign	SYNTHESIZED_WIRE_21 = up_down_not & SYNTHESIZED_WIRE_25;

assign	SYNTHESIZED_WIRE_20 = SYNTHESIZED_WIRE_16 & SYNTHESIZED_WIRE_17;

assign	SYNTHESIZED_WIRE_17 =  ~up_down_not;

assign	SYNTHESIZED_WIRE_13 = SYNTHESIZED_WIRE_18 & enable;

assign	SYNTHESIZED_WIRE_23 = SYNTHESIZED_WIRE_21 & SYNTHESIZED_WIRE_26;


endmodule

