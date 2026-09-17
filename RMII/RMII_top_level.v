module RMII_top_level (
	input wire ref_clk,
	input wire reset,
	input wire send1,
	input wire send2,
	output wire tx_en1,
	output wire tx_en2,
	input wire [1:0] data_in1,
	input wire [1:0] data_in2,
	input wire crs_dv1,
	input wire crs_dv2,
	output wire data_valid1,
	output wire data_valid2,
	output wire [1:0] data_out1,
	output wire [1:0] data_out2
	);
	
	wire [1:0] tx_data1;
	wire [1:0] tx_data2;
	
	RMII_module RMII_module1 (
		.ref_clk (ref_clk),
		.reset (reset),
		.send (send1),
		.data_in (data_in1),
		.tx_data (tx_data1),
		.tx_en (tx_en1),
		.crs_dv (crs_dv1),
		.rx_data (tx_data2),
		.data_valid (data_valid1),
		.data_out (data_out1)
	);
	
	RMII_module RMII_module2 (
		.ref_clk (ref_clk),
		.reset (reset),
		.send (send2),
		.data_in (data_in2),
		.tx_data (tx_data2),
		.tx_en (tx_en2),
		.crs_dv (crs_dv2),
		.rx_data (tx_data1),
		.data_valid (data_valid2),
		.data_out (data_out2)
	);
	
endmodule
