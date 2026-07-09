module state_machine(
	input clk,
	input rst,
	input code,
	output reg code_correct = 0,
	output reg [3:0] code_temp = 4'b0000
	);
//define the states names
localparam WAIT_FOR_1 = 2'd0;
localparam WAIT_FOR_10 = 2'd1;
localparam WAIT_FOR_100 = 2'd2;
localparam WAIT_FOR_1001 = 2'd3;
localparam CODE_CORRECT = 3'd4;

reg [3:0] current_state, next_state;
//serial block with clock
always @(posedge clk or negedge rst) begin
	if(rst == 0)begin
		current_state <= WAIT_FOR_1;
	end else begin
		current_state <= next_state;
	end
end
//combinational block without clock
always @(*) begin
	next_state = current_state;
	code_correct = 0;
	case (current_state)
		WAIT_FOR_1: begin //state 1
			code_correct = 0;
			code_temp = 4'b0000;
			if(code == 1) begin
				next_state = WAIT_FOR_10;
			end else begin
				next_state = WAIT_FOR_1;
			end
		end
		WAIT_FOR_10: begin //state 2
			code_correct = 0;
			code_temp = 4'b0001;
			if(code == 0) begin
				next_state = WAIT_FOR_100;
			end else begin
				next_state = WAIT_FOR_10;
			end
		end
		WAIT_FOR_100: begin //state3
			code_correct = 0;
			code_temp = 4'b0010;
			if(code == 0) begin
				next_state = WAIT_FOR_1001;
			end else begin
				next_state = WAIT_FOR_10;
			end
		end
		WAIT_FOR_1001: begin //state 4
			code_correct = 0;
			code_temp = 4'b0100;
			if(code == 1) begin
				next_state = CODE_CORRECT;
			end else begin
				next_state = WAIT_FOR_1;
			end
		end
		CODE_CORRECT: begin //state 5
			code_correct = 1;
			code_temp = 4'b1001;
			if(code == 1) begin
				next_state = WAIT_FOR_10;
			end else begin
				next_state = WAIT_FOR_100;
			end
		end
		default: next_state = WAIT_FOR_1;
	endcase
end
endmodule
