// Produces a single-cycle 'baud' pulse at: baud_freq = BAUD_RATE * OVERSAMPLING
module baud_rate#(
	parameter CLK_FREQ = 26'd50000000, // System clock frequency
	parameter OVERSAMPLING = 5'd16, // UART oversampling factor
	parameter BAUD_RATE = 14'd9600 // UART baud rate
	)(
	input wire clk, rst,
	output reg baud
	);
	
	// Number of clock cycles per oversampled baud tick
	localparam PRESCALER = CLK_FREQ / (OVERSAMPLING * BAUD_RATE);
   
	// Counter sized automatically using clog2
	reg [$clog2(PRESCALER):0] cnt = 9'd0;
	
   // Generate baud pulse every PRESCALER cycles
	always @(posedge clk or negedge rst) begin
		if(!rst) begin
			baud <= 1'b0;
			cnt <= 9'd0;
		end else begin
			if(cnt == PRESCALER) begin
				cnt <= 9'd0;
				baud <= 1'b1;
			end else begin
				cnt <= cnt + 1;
				baud <= 1'b0;
			end
		end
	end
endmodule
