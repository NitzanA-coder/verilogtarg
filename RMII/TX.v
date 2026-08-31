module TX (
	input wire ref_clk,
	input wire reset,
	input wire send,
	input wire [1:0] data_in,
	
	output reg [1:0] tx_data = 2'b00,
	output reg tx_en = 1'b0
	);
	
	always @(posedge ref_clk or negedge reset) begin
		if (reset == 1'b0) begin
			tx_data <= 2'b00;
			tx_en <= 1'b0;
		end
		
		else begin
			if (send) begin
				tx_en <= 1'b1;
				tx_data <= data_in;
			end
			else
				tx_en <= 1'b0;
		end
	end
endmodule
