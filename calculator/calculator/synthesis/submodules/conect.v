module conect(
	input wire clk,
	input wire reset_n,
	input wire chipselect,
	input wire write,
	input wire read,
	input wire [31:0] writedata,
	output reg [31:0] readdata = 32'b0
	);
	
	wire error;
	wire [31:0] result;
	wire [31:0] operation;
	wire [31:0] num1;
	wire [31:0] num2;
	
	ALU u1 (
		.operation (operation),
      .num1      (num1),
      .num2      (num2),
      .error     (error),
      .result    (result)
	);
	
	localparam WAIT_FOR_O = 3'd0;
	localparam WAIT_FOR_N1 = 3'd1;
	localparam WAIT_FOR_N2 = 3'd2;
	localparam WAIT_FOR_READ = 3'd3;
	localparam READ = 3'd4;
	
	reg [2:0] state = WAIT_FOR_O;
	reg [31:0] OPERATION = 32'b0;
	reg [31:0] NUM1 = 32'b0;
	reg [31:0] NUM2 = 32'b0;
	
	always @(posedge clk or negedge reset_n) begin
		if(reset_n == 0) begin
			state <= WAIT_FOR_O;
			readdata <= 32'b0;
			OPERATION <= 32'b0;
			NUM1 <= 32'b0;
			NUM2 <= 32'b0;
		end else begin
			case(state)
				WAIT_FOR_O: begin
					readdata <= 32'b0;
					OPERATION <= 32'b0;
					NUM1 <= 32'b0;
					NUM2 <= 32'b0;
					if (write && chipselect) begin
						state <= WAIT_FOR_N1;
						OPERATION <= writedata;
					end
				end
				
				WAIT_FOR_N1: begin
					if (write && chipselect) begin
						state <= WAIT_FOR_N2;
						NUM1 <= writedata;
					end
				end
				
				WAIT_FOR_N2: begin
					if (write && chipselect) begin
						state <= WAIT_FOR_READ;
						NUM2 <= writedata;
					end
				end
				
				WAIT_FOR_READ: begin
					if (read && chipselect)
						state <= READ;
				end
				
				READ: begin
					if (error)
						readdata <= 32'hFFFFFFFF;
					else
						readdata <= result;
					state <= WAIT_FOR_O;
				end
			endcase
		end
	end
	
	assign operation = OPERATION;
	assign num1 = NUM1;
	assign num2 = NUM2;
	
endmodule