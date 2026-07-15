module Rx(
	input wire clk, rst, baud,
	input wire rx,
	output reg parity_error, rx_finish,
	output reg [7:0] data_out
	);
	
   // FSM states
	localparam IDLE = 3'd0;
	localparam START = 3'd1;
	localparam DATA_WRITE = 3'd2;
	localparam PARITY_BIT = 3'd3;
	localparam STOP = 3'd4;
	
	reg parity_recv = 1'b0; 
	reg [2:0] index_send = 3'd0;
	reg [2:0] state;
	
   // Receiver samples data on each baud pulse
	always @(posedge baud or negedge rst) begin
		if(!rst) begin
			// Reset all internal registers
			state <= IDLE;
			parity_recv <= 1'b0;
			parity_error <= 1'b0;
			rx_finish <= 1'b1;
			index_send <= 3'd0;
			data_out <= 8'b0;
		end else begin
			rx_finish <= 1'b1;
			case(state)
				// Wait for start bit (rx = 0)
				IDLE: begin
					parity_error <= 1'b0;
					if(!rx) begin
						state <= DATA_WRITE;
					end
				end
				// Sample 8 data bits (MSB-first)
				DATA_WRITE: begin
					data_out[7-index_send] <= rx;
					if(index_send == 3'd7) begin
						index_send <= 3'd0;
						state <= PARITY_BIT;
					end else begin
						index_send <= index_send + 1;
					end
				end
				// Capture parity bit and compare with computed parity
				PARITY_BIT: begin
					parity_recv <= rx;
					if(rx != ^data_out) begin
						parity_error <= 1'b1;
					end
					state <= STOP;
				end
				// Stop bit must be high (rx = 1)
				STOP: begin
					if(rx) begin
						rx_finish <= 1'b0;
						state <= IDLE;
					end else begin
						state <= DATA_WRITE;
					end
				end
			endcase
		end
	end
endmodule
