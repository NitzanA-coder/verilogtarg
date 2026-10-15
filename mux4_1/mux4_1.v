module mux4_1(
	input wire [1:0] s,
	input wire [3:0] d,
	output wire y
	);
assign y = d[s];
endmodule
