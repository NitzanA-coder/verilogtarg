`timescale 1 ns/ 1 ps
module ARP_tb();

reg clk;
reg CRS_DV = 1'b0;
reg [1:0] data = 2'd0; // 2‑bit serialized input stream
reg rst;
                                              
wire packet_ready;

// Full ARP packet serialized into 2‑bit chunks (MSB-first)
reg [335:0] data_in = 336'h_6225fd0180c5_808489a8b759_0806_0001_0800_06_04_0002_808489a8b759_c0a8dd45_6225fd0180c5_c0a8dd70;

// assign statements (if any)                          
ARP i1 (
// port map - connection between master ports and signals/registers   
	.clk(clk),
	.data(data),
	.packet_ready(packet_ready),
	.rst(rst),
	.CRS_DV(CRS_DV)
);

task send_packet;
	input [335:0] packet_data;
	begin
		@(posedge clk);
		CRS_DV = 1'b1;
		repeat (31) begin
			data = 2'b10;
			@(posedge clk);
		end
		data = 2'b11;
		@(posedge clk);

		// Send remaining 168 chunks (2 bits per clock)
		repeat (168) begin
			data = data_in[335:334]; 
			data_in = {data_in[333:0], 2'b00}; 
			@(posedge clk);
		end
		data = 2'd0;
		CRS_DV = 1'b0;
	end
endtask
	
initial                                                
begin                                                  
// code that executes only once                        
// insert code here --> begin                          
clk = 1'b0;
rst = 1'b0;
data = 2'd0;
CRS_DV = 1'b0;
// Apply reset
#40
rst = 1'b1;
#20

send_packet(data_in);
#100;
// --> end                                             
$display("Running testbench");                       
end                                                    
always                                                 
// optional sensitivity list                           
// @(event1 or event2 or .... eventn)                  
begin                                                  
// code executes for every event on sensitivity list   
// insert code here --> begin                          

#10 clk = ~clk;    // Clock generation (50 MHz)                                                   
// --> end                                             
end                                                    
endmodule

