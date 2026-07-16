`timescale 1 ns/ 1 ps
module ARP_tb();

reg clk;
reg [1:0] data = 2'd0; // 2‑bit serialized input stream
reg rst;
reg start_send = 1'b0;
                                              
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
	.start_send(start_send)
);
initial                                                
begin                                                  
// code that executes only once                        
// insert code here --> begin                          
clk = 1'b0;
rst = 1'b0;
data = 2'd0;
start_send = 1'b0;
// Apply reset
#40
rst = 1'b1;
#20

// Start packet transmission (first 2-bit chunk)
@(posedge clk);
start_send = 1'b1;
data = data_in[335:334]; 
data_in = {data_in[333:0], 2'b00};
 
@(posedge clk);
start_send = 1'b0;

// Send remaining 167 chunks (2 bits per clock)
repeat (167) begin
	data = data_in[335:334]; 
	data_in = {data_in[333:0], 2'b00}; 
	@(posedge clk);
end
data = 2'd0;
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

