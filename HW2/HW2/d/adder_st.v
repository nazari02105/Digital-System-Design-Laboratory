module full_adder_st(a, b, cin, s, cout);
	input a, b, cin;
	output s, cout;
	wire w1, w2, w3;

	and #2 g1(w1, a, b);
	and #2 g2(w2, b, cin);
	and #2 g3(w3, a, cin);
	xor #4 g4(s, a, b, cin);
	or #2 g5(cout, w1, w2, w3);
endmodule
