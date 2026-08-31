module RMII_top_level (
	input wire ref_clk,
	input wire reset,
	input wire send,
	input wire [1:0] data_in,
	input wire crs_dv,
	output wire [1:0] data_out
	);
	
	wire [1:0] tx_data;
	wire [1:0] tx_data2;
	wire tx_en;
	wire tx_en2;
	wire second_send;
	wire [1:0] data_in2;
	
	
	TX TX1(
		.ref_clk (ref_clk),
		.reset (reset),
		.send (send),
		.data_in (data_in),
		.tx_data (tx_data),
		.tx_en (tx_en)
	);
	
	TX TX2(
		.ref_clk (ref_clk),
		.reset (reset),
		.send (second_send),
		.data_in (data_in2),
		.tx_data (tx_data2),
		.tx_en (tx_en2)
	);
	
	RX RX1(
		.ref_clk (ref_clk),
		.reset (reset),
		.crs_dv (tx_en2),
		.rx_data (tx_data2),
		.data_out (data_out)
	);
	
	RX RX2(
		.ref_clk (ref_clk),
		.reset (reset),
		.crs_dv (crs_dv),
		.rx_data (tx_data),
		.second_send (second_send),
		.data_out (data_in2)
	);
	
endmodule
