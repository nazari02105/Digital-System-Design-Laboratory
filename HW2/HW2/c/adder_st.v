module full_adder_st(a, b, cin, s, cout);
	input a, b, cin;
	output s, cout;
	wire w1, w2, w3;

	xor #4 g1(w1, a, b);
	xor #4 g2(s, w1, cin);
	and #2 g3(w3, w1, cin);
	and #2 g4(w2, a, b);
	or #2 g5(cout, w2, w3);
endmodule
