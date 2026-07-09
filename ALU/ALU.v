module ALU(
input [3:0] a,b,
input [2:0] operation,
output reg [4:0] out
);
always @(*) begin
	case(operation) 
		4'd1: out = a + b;
		4'd2: out = a - b;
		4'd3: out = ~b;
		4'd4: out = a & b;
		4'd5: out = a | b;
		4'd6: out = ~a;
		4'd7: out = a ^ b;
		default: out = 0;
	endcase
end
endmodule
