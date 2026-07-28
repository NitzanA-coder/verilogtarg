module ARP(
	input wire clk,
	input wire rst, // Active-low reset
	input wire [1:0] data, // 2-bit serialized input stream
	input wire CRS_DV, // Indicates active frame reception
	output reg packet_ready = 1'b0 // Asserted when full ARP packet has been assembled
);

	// FSM states for each ARP header field
	localparam [3:0] IDLE = 4'd0;
	localparam [3:0] PREAMBLE = 4'd1;
	localparam [3:0] D_MAC = 4'd2;
	localparam [3:0] S_MAC = 4'd3;
	localparam [3:0] TYPE = 4'd4;
	localparam [3:0] HW_TYPE = 4'd5;
	localparam [3:0] PROTO_TYPE = 4'd6;
	localparam [3:0] HW_LEN = 4'd7;
	localparam [3:0] PROTO_LEN = 4'd8;
	localparam [3:0] OPCODE = 4'd9;
	localparam [3:0] SENDER_MAC = 4'd10;
	localparam [3:0] SENDER_IP = 4'd11;
	localparam [3:0] TARGET_MAC = 4'd12;
	localparam [3:0] TARGET_IP = 4'd13;

	// ARP fields (shift registers)
	reg [47:0] destination_MAC = 48'd0;
	reg [47:0] source_MAC = 48'd0;
	reg [15:0] type = 16'd0;
	reg [15:0] hardware_type = 16'd0;
	reg [15:0] protocol_type = 16'd0;
	reg [7:0] HW_len = 8'd0;
	reg [7:0] proto_len = 8'd0;
	reg [15:0] opcode = 16'd0;
	reg [47:0] sender_MAC = 48'd0;
	reg [31:0] sender_IP = 32'd0;
	reg [47:0] target_MAC = 48'd0;
	reg [31:0] target_IP = 32'd0;

	reg [4:0] preamble_cnt = 5'd0; // Counts number of 2-bit preamble symbols
	reg [3:0] state = IDLE; // Current FSM state
	reg [4:0] cnt_clk = 5'd0; // Counts how many 2-bit chunks were shifted

	always @(posedge clk or negedge rst) begin
		if (!rst) begin
			// Reset all fields and state
			state <= IDLE;
			packet_ready <= 1'b0;
			cnt_clk <= 5'd0;
			preamble_cnt <= 5'd0;
			destination_MAC <= 48'd0;
			source_MAC <= 48'd0;
			type <= 16'd0;
			hardware_type <= 16'd0;
			protocol_type <= 16'd0;
			HW_len <= 8'd0;
			proto_len <= 8'd0;
			opcode <= 16'd0;
			sender_MAC <= 48'd0;
			sender_IP <= 32'd0;
			target_MAC <= 48'd0;
			target_IP <= 32'd0;
		end else begin
			case(state)
				
				// Waiting for start of frame, clear all fields
				IDLE: begin
					packet_ready <= 1'b0;
					preamble_cnt <= 5'd0;
					cnt_clk <= 5'd0;
					destination_MAC <= 48'd0;
					source_MAC <= 48'd0;
					type <= 16'd0;
					hardware_type <= 16'd0;
					protocol_type <= 16'd0;
					HW_len <= 8'd0;
					proto_len <= 8'd0;
					opcode <= 16'd0;
					sender_MAC <= 48'd0;
					sender_IP <= 32'd0;
					target_MAC <= 48'd0;
					target_IP <= 32'd0;
					
					if(CRS_DV) begin // Detect custom preamble start symbol
						state <= PREAMBLE;
					end
				end
				
				// Count preamble symbols until SFD is detected.
				PREAMBLE: begin
					if(data != 2'b10) begin // If symbol is not part of preamble, check for SFD
						if(preamble_cnt == 5'd30 && data == 2'b11) begin
							preamble_cnt <= 5'd0;
							state <= D_MAC;
						end else begin
							state <= IDLE;
						end
					end else begin
						preamble_cnt <= preamble_cnt + 1;
					end
				end
					
				// Each field shifts in 2 bits per clock until full width is reached
				D_MAC: begin
					destination_MAC <= {destination_MAC[45:0], data};
					if(cnt_clk == 5'd23) begin // 23 cycles × 2 bits = 46 bits + first 2 bits = 48
						state <= S_MAC;
						cnt_clk <= 5'd0;
					end else begin
						cnt_clk <= cnt_clk + 1;
					end
				end
				S_MAC: begin
					source_MAC <= {source_MAC[45:0], data};
					if(cnt_clk == 5'd23) begin
						state <= TYPE;
						cnt_clk <= 5'd0;
					end else begin
						cnt_clk <= cnt_clk + 1;
					end
				end
				
				TYPE: begin
					type <= {type[13:0], data};
					if(cnt_clk == 5'd7) begin
						if({type[13:0], data} == 16'h0806) begin   // Validate ARP EtherType (0x0806)
							state <= HW_TYPE;
							cnt_clk <= 5'd0;
						end else begin
							state <= IDLE;
						end
					end else begin
						cnt_clk <= cnt_clk + 1;
					end
				end
				
				HW_TYPE: begin
					hardware_type <= {hardware_type[13:0], data};
					if(cnt_clk == 5'd7) begin
						state <= PROTO_TYPE;
						cnt_clk <= 5'd0;
					end else begin
						cnt_clk <= cnt_clk + 1;
					end
				end
				
				PROTO_TYPE: begin
					protocol_type <= {protocol_type[13:0], data};
					if(cnt_clk == 5'd7) begin
						state <= HW_LEN;
						cnt_clk <= 5'd0;
					end else begin
						cnt_clk <= cnt_clk + 1;
					end
				end
				
				HW_LEN: begin
					HW_len <= {HW_len[5:0], data};
					if(cnt_clk == 5'd3) begin
						state <= PROTO_LEN;
						cnt_clk <= 5'd0;
					end else begin
						cnt_clk <= cnt_clk + 1;
					end
				end
				
				PROTO_LEN: begin
					proto_len <= {proto_len[5:0], data};
					if(cnt_clk == 5'd3) begin
						state <= OPCODE;
						cnt_clk <= 5'd0;
					end else begin
						cnt_clk <= cnt_clk + 1;
					end
				end
				
				OPCODE: begin
					opcode <= {opcode[13:0], data};
					if(cnt_clk == 5'd7) begin
						state <= SENDER_MAC;
						cnt_clk <= 5'd0;
					end else begin
						cnt_clk <= cnt_clk + 1;
					end
				end
				
				SENDER_MAC: begin
					sender_MAC <= {sender_MAC[45:0], data};
					if(cnt_clk == 5'd23) begin
						state <= SENDER_IP;
						cnt_clk <= 5'd0;
					end else begin
						cnt_clk <= cnt_clk + 1;
					end
				end
				
				SENDER_IP: begin
					sender_IP <= {sender_IP[29:0], data};
					if(cnt_clk == 5'd15) begin
						state <= TARGET_MAC;
						cnt_clk <= 5'd0;
					end else begin
						cnt_clk <= cnt_clk + 1;
					end
				end
				
				TARGET_MAC: begin
					target_MAC <= {target_MAC[45:0], data};
					if(cnt_clk == 5'd23) begin
						state <= TARGET_IP;
						cnt_clk <= 5'd0;
					end else begin
						cnt_clk <= cnt_clk + 1;
					end
				end
				
				TARGET_IP: begin
					target_IP <= {target_IP[29:0], data};
					if(cnt_clk == 5'd15) begin
						state <= IDLE;
						cnt_clk <= 5'd0;
						packet_ready <= 1'b1; // Full ARP packet assembled
					end else begin
						cnt_clk <= cnt_clk + 1;
					end
				end
				
				default: state <= IDLE;
			endcase
		end
	end
endmodule
