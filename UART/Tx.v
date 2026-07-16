module Tx(
	input wire start_bit, clk, rst, baud,
	input wire [7:0] data_in,
	output reg tx
	);
	
   // FSM states
	localparam IDLE = 3'd0;
	localparam START = 3'd1;
	localparam DATA_WRITE = 3'd2;
	localparam PARITY_BIT = 3'd3;
	localparam STOP = 3'd4;
	
	reg [2:0] index_send = 3'd0;
	reg [2:0] state;

   // TX updates only on baud pulses	
	always @(posedge baud or negedge rst) begin
		if(!rst) begin
         // Reset transmitter
			state <= IDLE;
			tx <= 1'b1;
			index_send <= 3'd0;
		end else begin
			case(state)
				// Wait for start trigger (active-low)
				IDLE: begin
					tx <= 1'b1;
					if(!start_bit) begin
						state <= START;
					end
				end
				// Send start bit (always 0)
				START: begin
					tx <= 1'b0;
					state <= DATA_WRITE;
				end
				// Send 8 data bits (MSB-first)
				DATA_WRITE: begin
					tx <= data_in[7 - index_send];
					if(index_send == 3'd7) begin
						index_send <= 3'd0;
						state <= PARITY_BIT;
					end else begin
						index_send <= index_send + 1;
					end
				end
				// Send even parity bit
				PARITY_BIT: begin
					tx <= ^data_in;
					state <= STOP;
				end
				// Send stop bit (always 1)
				STOP: begin
					tx <= 1'b1;
					state <= IDLE;
				end
			endcase
		end
	end
endmodule	