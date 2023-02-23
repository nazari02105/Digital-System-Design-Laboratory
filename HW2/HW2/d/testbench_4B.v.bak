module testbench_4B;
	reg[3:0] a, b;
	reg cin;
	wire[3:0] s;
	wire cout, r;
	integer i, j;

	fullAdder4B adder(s, cout, r, a, b, cin);

	initial
	begin
		for (i=0; i<16; i=i+1)
		begin
			for (j=0; j<16; j=j+1)
			begin
				#32 a = i; b = j; cin = 1'b0;
			end
		end

		for (i=0; i<16; i=i+1)
		begin
			for (j=0; j<16; j=j+1)
			begin
				#32 a = i; b = j; cin = 1'b1;
			end
		end
	end

	initial
		$monitor($time, " a=%b, b=%b, cin=%b, s=%b, cout=%b", a, b, cin, s, cout);
endmodule
