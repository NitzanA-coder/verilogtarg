module state_machine(
	input wire clk,
	input wire rst,
	input wire code,
	output reg code_correct = 1'b0
	);
//define the states names
localparam WAIT_FOR_1 = 3'd0;
localparam WAIT_FOR_10 = 3'd1;
localparam WAIT_FOR_100 = 3'd2;
localparam WAIT_FOR_1001 = 3'd3;
localparam CODE_CORRECT = 3'd4;

reg [2:0] current_state, next_state;

//serial block with clock
always @(posedge clk or negedge rst) begin
	if(!rst)begin
		current_state <= WAIT_FOR_1;
	end else begin
		current_state <= next_state;
	end
end

//combinational block without clock
always @(*) begin
	next_state = current_state;
	code_correct = 1'b0;
	case (current_state)
		WAIT_FOR_1: begin //state 1
			code_correct = 1'b0;
			if(code == 1'b1) begin
				next_state = WAIT_FOR_10;
			end else begin
				next_state = WAIT_FOR_1;
			end
		end
		WAIT_FOR_10: begin //state 2
			code_correct = 1'b0;
			if(code == 1'b0) begin
				next_state = WAIT_FOR_100;
			end else begin
				next_state = WAIT_FOR_10;
			end
		end
		WAIT_FOR_100: begin //state3
			code_correct = 1'b0;
			if(code == 1'b0) begin
				next_state = WAIT_FOR_1001;
			end else begin
				next_state = WAIT_FOR_10;
			end
		end
		WAIT_FOR_1001: begin //state 4
			code_correct = 1'b0;
			if(code == 1'b1) begin
				next_state = CODE_CORRECT;
			end else begin
				next_state = WAIT_FOR_1;
			end
		end
		CODE_CORRECT: begin //state 5
			code_correct = 1'b1;
			if(code == 1'b1) begin
				next_state = WAIT_FOR_10;
			end else begin
				next_state = WAIT_FOR_100;
			end
		end
		default: next_state = WAIT_FOR_1;
	endcase
end
endmodule
