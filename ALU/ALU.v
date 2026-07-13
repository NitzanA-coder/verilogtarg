module ALU(
input [3:0] a,b,
input [3:0] operation,
output reg [4:0] out
);

//local parameters for each operation
localparam ADDITION = 4'd1;
localparam SUBTRACTION = 4'd2;
localparam MULTIPLICATION = 4'd3;
localparam DIVISION = 4'd4;
localparam AND = 4'd5;
localparam OR = 4'd6;
localparam NOT = 4'd7;
localparam XOR = 4'd8;

always @(*) begin
	case(operation)
		ADDITION: out = a + b;
		SUBTRACTION: out = a - b;
		MULTIPLICATION: out = a * b;
		DIVISION: out = a / b;
		AND: out = a & b;
		OR: out = a | b;
		NOT: out = ~a;
		XOR: out = a ^ b;
		default: out = 0;
	endcase
end
endmodule
