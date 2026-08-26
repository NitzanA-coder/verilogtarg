module ALU (
	input wire [31:0] operation,
	input wire signed [31:0] num1,
	input wire signed [31:0] num2,
	output reg error = 1'b0,
	output reg signed [31:0] result = 32'b0
);
	localparam ADDITION = 3'd1;
	localparam SUBTRACTION = 3'd2;
	localparam MULTIPLICATION = 3'd3;
	localparam DIVISION = 3'd4;
	localparam MODULU = 3'd5;
		
	always @(*) begin
	
		error = 1'b0;
		
		case(operation)
			ADDITION: result = num1 + num2;
			
			SUBTRACTION: result = num1 - num2;
			
			MULTIPLICATION: result = num1 * num2;
			
			DIVISION: begin
				if(num2 != 32'b0)
					result = num1 / num2;
				else
					error = 1'd1;
			end
			
			MODULU: result = num1 % num2;
			
			default: result = 32'b0;
			
		endcase
	end
endmodule
