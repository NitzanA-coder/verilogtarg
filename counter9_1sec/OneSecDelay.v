module OneSecDelay #(
	parameter count_max = 50000000 // Number of clock cycles required to generate a 1‑second delay
	)(
	input wire clk,
	input wire rst,
	output reg one_sec
	);
	
	reg [25:0] counter = 26'd0; // 26‑bit counter used to count clock cycles
	
	// Sequential logic: counts clock cycles and generates a 1‑second pulse
	always @(posedge clk or negedge rst) begin
		if(rst == 0) begin
			counter <= 0;
			one_sec <= 0;
		end else if(counter == count_max - 1) begin
			counter <= 0; // When maximum count is reached, reset counter
			one_sec <= 1; // Generate a single‑cycle pulse
		end else begin
			counter = counter + 1; // Increment counter each clock cycle
			one_sec <= 0; // Pulse stays low except at rollover
		end
	end
endmodule