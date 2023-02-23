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
// CREATED		"Wed Mar 16 03:26:45 2022"

module Exp2(
	T,
	in,
	ent,
	out,
	clock,
	clear,
	Close,
	Open,
	Out0,
	Out1,
	Out2,
	Out3
);


input wire	T;
input wire	in;
input wire	ent;
input wire	out;
input wire	clock;
input wire	clear;
output wire	Close;
output wire	Open;
output wire	Out0;
output wire	Out1;
output wire	Out2;
output wire	Out3;

wire	SYNTHESIZED_WIRE_13;
wire	SYNTHESIZED_WIRE_1;
wire	SYNTHESIZED_WIRE_14;
wire	SYNTHESIZED_WIRE_3;
wire	SYNTHESIZED_WIRE_5;
wire	SYNTHESIZED_WIRE_15;
wire	SYNTHESIZED_WIRE_7;
wire	SYNTHESIZED_WIRE_8;
wire	SYNTHESIZED_WIRE_10;
wire	SYNTHESIZED_WIRE_11;





Counter	b2v_inst0(
	.up_down_not(SYNTHESIZED_WIRE_13),
	.clear(clear),
	.clock(clock),
	.enable(SYNTHESIZED_WIRE_1),
	.out0(Out0),
	.out1(Out1),
	.out2(Out2),
	.out3(Out3),
	.full(SYNTHESIZED_WIRE_15),
	.not_zero(SYNTHESIZED_WIRE_14));

assign	Close =  ~SYNTHESIZED_WIRE_14;

assign	SYNTHESIZED_WIRE_1 = SYNTHESIZED_WIRE_3 | SYNTHESIZED_WIRE_13;

assign	Open = T & in & ent & SYNTHESIZED_WIRE_5;

assign	SYNTHESIZED_WIRE_5 =  ~SYNTHESIZED_WIRE_15;

assign	SYNTHESIZED_WIRE_13 = SYNTHESIZED_WIRE_7 & SYNTHESIZED_WIRE_8;

assign	SYNTHESIZED_WIRE_8 =  ~SYNTHESIZED_WIRE_15;

assign	SYNTHESIZED_WIRE_7 = T & in & ent & SYNTHESIZED_WIRE_10;

assign	SYNTHESIZED_WIRE_3 = SYNTHESIZED_WIRE_11 & out & SYNTHESIZED_WIRE_14;

assign	SYNTHESIZED_WIRE_10 =  ~out;

assign	SYNTHESIZED_WIRE_11 =  ~in;


endmodule

