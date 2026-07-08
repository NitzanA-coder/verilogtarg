module top_level_counter #(
    parameter count_max = 50000000
)(
	input wire clk,
	input wire rst,
	output wire [3:0] count);
	
	wire one_sec;
	
	OneSecDelay #(.count_max(count_max)) sec(
	.clk(clk),
	.rst(rst),
	.one_sec(one_sec));
	
	counter counter(
	.one_sec(one_sec),
	.rst(rst),
	.count(count));
endmodule
