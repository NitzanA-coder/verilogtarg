module RX (
	input wire ref_clk,
	input wire reset,
	input wire crs_dv,
	input wire [1:0] rx_data,
	
	output reg second_send = 1'b0,
	output reg [1:0] data_out = 2'b00
	);
	
	reg crs_dv_old = 1'b0;
	
	always @(posedge ref_clk or negedge reset) begin
		if(reset == 1'b0) begin
			data_out <= 2'b00;
			second_send <= 1'b0;
		end
		
		else begin
			if(crs_dv | crs_dv_old != 0) begin
				data_out <= rx_data;
				second_send <= 1'b1;
			end else
				second_send <= 1'b0;
		end
		
		crs_dv_old <= crs_dv;
	end
endmodule
