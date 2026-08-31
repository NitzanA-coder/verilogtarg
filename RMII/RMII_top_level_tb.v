`timescale 1 ps/ 1 ps
module RMII_top_level_tb();
// constants                                           
// test vector input registers
reg crs_dv;
reg [1:0] data_in;
reg ref_clk;
reg reset;
reg send;
// wires                                               
wire [1:0]  data_out;

reg [7:0] data = 8'b10011101;

// assign statements (if any)                          
RMII_top_level i1 (
// port map - connection between master ports and signals/registers   
	.crs_dv(crs_dv),
	.data_in(data_in),
	.data_out(data_out),
	.ref_clk(ref_clk),
	.reset(reset),
	.send(send)
);
initial                                                
begin                                                  
// code that executes only once                        
// insert code here --> begin                          
ref_clk = 1'b0;
reset = 1'b1;
crs_dv = 1'b0;
send = 1'b1;
data_in = 2'b00;

#20
@(posedge ref_clk);
send = 1'b1;
crs_dv = 1'b1;
repeat(4) begin
	data_in = data[7:6];
	data = {data[5:0], 2'b00};
	@(posedge ref_clk);
end

data_in = 2'b00;
send = 1'b0;
crs_dv = 1'b0;
#200

// --> end                                             
$display("Running testbench");                       
end                                                    
always                                                 
// optional sensitivity list                           
// @(event1 or event2 or .... eventn)                  
begin                                                  
// code executes for every event on sensitivity list   
// insert code here --> begin                          
#10 ref_clk = ~ref_clk;
// --> end                                             
end                                                    
endmodule

