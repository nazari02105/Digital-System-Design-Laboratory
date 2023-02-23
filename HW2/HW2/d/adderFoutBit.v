module fullAdder4B(s, c_out, ready, a, b, c_in);
	output[3:0] s;
	output c_out;
	output reg ready;
	input[3:0] a, b;
	input c_in;

	wire[2:0] c;

	full_adder_st add1(a[0], b[0], c_in, s[0], c[0]);
	full_adder_st add2(a[1], b[1], c[0], s[1], c[1]);
	full_adder_st add3(a[2], b[2], c[1], s[2], c[2]);
	full_adder_st add4(a[3], b[3], c[2], s[3], c_out);

	always @(a or b or c_in)
	begin
		ready = 1'b0;
		#16 ready = 1'b1;
	end

	initial
		ready = 1'b0;
endmodule
