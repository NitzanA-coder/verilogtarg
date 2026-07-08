module counter(
	input wire rst,
	input wire one_sec,
	output reg [3:0] count = 4'd0
	);
	
	always @(*) begin	
		if(count == 4'd10 | rst == 0) begin
			count = 0;
		end else if(one_sec) begin
			count = count + 1;
		end else begin
			count = count;
		end
	end
endmodule
