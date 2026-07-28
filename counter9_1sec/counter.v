module counter(
	input wire rst,
	input wire one_sec,
	output reg [3:0] count = 4'd0
	);
	
	// Combinational logic describing counter behavior.
	always @(*) begin
		count = count; // Default assignment to avoid latch inference
		if(count == 4'd10 | rst == 0) begin
			count = 0; //// Reset the counter or start over after reaching 9
		end else if(one_sec) begin
			count = count + 1; // Increment counter only when one‑second pulse is high
		end
	end
endmodule