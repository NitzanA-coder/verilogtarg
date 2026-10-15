module UART_top_level#(
	parameter CLK_FREQ = 26'd50000000, // System clock frequency
	parameter OVERSAMPLING = 5'd16, // UART oversampling factor
	parameter BAUD_RATE = 14'd9600 // UART baud rate
	)(
	input wire start_bit, clk, rst,
	input wire [7:0] data_in1,
	input wire [7:0] data_in2,
	output wire tx1,
	output wire tx2,
	output wire parity_error1,
	output wire parity_error2,
	output wire [7:0] data_out1,
		output wire [7:0] data_out2
	);
	wire rx2_finish;
	wire baud;
	
   // Baud-rate generator with oversampling
	baud_rate #(
	.CLK_FREQ(CLK_FREQ),
	.OVERSAMPLING(OVERSAMPLING),
	.BAUD_RATE(BAUD_RATE))
	baud_rate(
	.rst(rst), 
	.baud(baud), 
	.clk(clk)
	);
	
   // RX1 receives data from TX2
	Rx Rx1(
	.rst(rst), 
	.baud(baud), 
	.clk(clk), 
	.rx(tx2), 
	.parity_error(parity_error1), 
	.data_out(data_out1),
	.rx_finish()
	);
	
   // TX1 sends data_in1 when start_bit is asserted (active-low)
	Tx Tx1(
	.start_bit(start_bit), 
	.rst(rst), 
	.baud(baud), 
	.data_in(data_in1), 
	.clk(clk), 
	.tx(tx1)
	);
	
   // RX2 receives data from TX1
	Rx Rx2(
	.rst(rst), 
	.baud(baud), 
	.clk(clk), 
	.rx(tx1), 
	.parity_error(parity_error2), 
	.data_out(data_out2),
	.rx_finish(rx2_finish)
	);
	
   // TX2 sends data_in2 when RX2 finishes receiving a frame
	Tx Tx2(
	.start_bit(rx2_finish), 
	.rst(rst), 
	.baud(baud), 
	.data_in(data_in2), 
	.clk(clk), 
	.tx(tx2)
	);
	
endmodule
