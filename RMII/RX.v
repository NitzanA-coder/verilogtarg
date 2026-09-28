module RX (
	input wire ref_clk,
	input wire reset_n,
	input wire crs_dv,
	input wire [1:0] rx_data,
	
	output reg data_valid = 1'b0,
	output reg [1:0] data_out = 2'b00
	);
	
	localparam IDLE = 1'd0;
	localparam RECEIVING = 1'd1;
	
	reg crs_dv_old = 1'b0;
	reg state = IDLE;
	
	always @(posedge ref_clk or negedge reset_n) begin
		if(reset_n == 1'b0) begin
			state <= IDLE;
			crs_dv_old <= 1'b0;
			data_valid <= 1'b0;
			data_out <= 2'b00;
		end
		
		else begin
			crs_dv_old <= crs_dv;
			
			case(state)
				IDLE: begin
					data_out <= 2'b00;
					data_valid <= 1'b0;
					
					if(crs_dv && (rx_data == 2'b01)) begin
						state <= RECEIVING;
						data_valid <= 1'b1;
						data_out <= rx_data;
					end
				end
				
				RECEIVING: begin
					data_out <= rx_data;
					if (!(crs_dv || crs_dv_old)) begin
						data_valid <= 1'b0;
						state <= IDLE;
					end
				end
				
				default: state <= IDLE;
			endcase
		end
	end
endmodule
