module mux4_1(
	input [1:0] s,
	input [3:0] d,
	output y
	);
assign y = ((~s[0])&(~s[1])&d[0]) | (s[0]&(~s[1])&d[1]) | ((~s[0])&s[1]&d[2]) | (s[0]&s[1]&d[3]);
endmodule
