module top_level_counter #(
    parameter count_max = 50000000 // Maximum count value used to generate a 1‑second delay
)(
	input wire clk,
	input wire rst,
	output wire [3:0] count);
	
	wire one_sec; // Pulse that goes high once every second
	
	// Module that generates a 1‑second enable pulse based on the system clock
	OneSecDelay #(.count_max(count_max)) sec(
	.clk(clk),
	.rst(rst),
	.one_sec(one_sec));
	
	// A 4-bit counter that counts up to 9 that increments only when 'one_sec' is asserted
	counter counter(
	.one_sec(one_sec),
	.rst(rst),
	.count(count));
endmodule