module RMII_module(
	input wire ref_clk,
	input wire reset,
	input wire crs_dv,
	input wire send,
	input wire tx_en,
	input wire [1:0] rx_data,
	input wire [1:0] data_in,
	output wire data_valid,
	output wire [1:0] tx_data,
	output wire [1:0] data_out

);

	TX TX(
		.ref_clk (ref_clk),
		.reset (reset),
		.send (send),
		.data_in (data_in),
		.tx_data (tx_data),
		.tx_en (tx_en)
	);
	
	RX RX(
		.ref_clk (ref_clk),
		.reset (reset),
		.crs_dv (crs_dv),
		.rx_data (rx_data),
		.data_valid (data_valid),
		.data_out (data_out)
	);
endmodule