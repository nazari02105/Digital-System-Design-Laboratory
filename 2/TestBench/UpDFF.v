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
// CREATED		"Wed Mar 16 03:25:48 2022"

module UpDFF(
	d,
	clk,
	Q,
	QNot
);


input wire	d;
input wire	clk;
output wire	Q;
output wire	QNot;

wire	SYNTHESIZED_WIRE_0;
wire	SYNTHESIZED_WIRE_1;




assign	SYNTHESIZED_WIRE_0 =  ~clk;


NoEdgeDFF	b2v_inst2(
	.D(d),
	.CLK(SYNTHESIZED_WIRE_0),
	.Q(SYNTHESIZED_WIRE_1)
	);


NoEdgeDFF	b2v_inst3(
	.D(SYNTHESIZED_WIRE_1),
	.CLK(clk),
	.Q(Q),
	.qNot(QNot));


endmodule

