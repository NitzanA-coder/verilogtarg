module OneSecDelay #(
	parameter count_max = 50000000
	)(
	input wire clk,
	input wire rst,
	output reg one_sec
	);
	
	reg [25:0] counter = 26'd0;
	
	always @(posedge clk or negedge rst) begin
		if(rst == 0) begin
			counter <= 0;
			one_sec <= 0;
		end else if(counter == count_max - 1) begin
			counter <= 0;
			one_sec <= 1;
		end else begin
			counter = counter + 1;
			one_sec <= 0;
		end
	end
endmodule
