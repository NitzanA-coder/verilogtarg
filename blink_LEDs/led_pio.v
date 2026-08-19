module led_pio (
	input wire	clk,          // Avalon clock
	input wire reset,        // Avalon reset (active high)

	// Avalon-MM slave interface
	input wire chipselect,   // high when the HPS addresses this component
	input wire write,        // high on a write transaction
	input wire read,			  // high on a read transaction
	input wire [31:0] writedata,    // data from the HPS
	output reg [31:0] readdata,     // data back to the HPS

	// Non-Avalon signal
	output wire [7:0]  led
);

	reg [7:0] led_reg;

	always @(posedge clk or posedge reset) begin
		if (reset)
			led_reg <= 8'b0;
		else if (chipselect && write)
			led_reg <= writedata[7:0];
	end

	always @(*) begin
		if (chipselect && read)
			readdata = {24'b0, led_reg};
		else
			readdata = 32'b0;
	end
	 
	assign led = led_reg;

endmodule
