// Copyright (C) 2017  Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions 
// and other software and tools, and its AMPP partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License 
// Subscription Agreement, the Intel Quartus Prime License Agreement,
// the Intel MegaCore Function License Agreement, or other 
// applicable license agreement, including, without limitation, 
// that your use is for the sole purpose of programming logic 
// devices manufactured by Intel and sold by Intel or its 
// authorized distributors.  Please refer to the applicable 
// agreement for further details.

// *****************************************************************************
// This file contains a Verilog test bench template that is freely editable to  
// suit user's needs .Comments are provided in each section to help the user    
// fill out necessary details.                                                  
// *****************************************************************************
// Generated on "07/14/2026 11:19:08"
                                                                                
// Verilog Test Bench template for design : UART_top_level
// 
// Simulation tool : ModelSim-Altera (Verilog)
// 

`timescale 1 ns/ 1 ps
module UART_top_level_tb #(
	parameter CLK_FREQ = 21'd1536000,
	parameter OVERSAMPLING = 5'd16,
	parameter BAUD_RATE = 14'd9600
	)();
// constants                                           
// general purpose registers
// test vector input registers
reg clk;
reg [7:0] data_in1 = 8'b11010101;
reg [7:0] data_in2 = 8'b01001100;
reg rst;
reg start_bit;
// wires                                               
wire [7:0]  data_out1;
wire [7:0]  data_out2;
wire parity_error1;
wire parity_error2;
wire tx1;
wire tx2;

// assign statements (if any)                          
UART_top_level #(
	.CLK_FREQ(CLK_FREQ),
	.OVERSAMPLING(OVERSAMPLING),
	.BAUD_RATE(BAUD_RATE))
	i1 (
// port map - connection between master ports and signals/registers   
	.clk(clk),
	.data_in1(data_in1),
	.data_in2(data_in2),
	.data_out1(data_out1),
	.data_out2(data_out2),
	.parity_error1(parity_error1),
	.parity_error2(parity_error2),
	.rst(rst),
	.start_bit(start_bit),
	.tx1(tx1),
	.tx2(tx2)
);
initial                                                
begin                                                  
// code that executes only once                        
// insert code here --> begin                          
clk = 1'b0;
rst = 1'b0;
start_bit = 1'b1;
#10
rst = 1'b1;
#200
start_bit = 1'b0;
#20
start_bit = 1'b1;
#3000
start_bit = 1'b0;
#110
start_bit = 1'b1;
#3000
start_bit = 1'b0;
#110
start_bit = 1'b1;                                                       
// --> end                                             
$display("Running testbench");                       
end                                                    
always                                                 
// optional sensitivity list                           
// @(event1 or event2 or .... eventn)                  
begin                                                  
// code executes for every event on sensitivity list   
// insert code here --> begin                          
#5
clk = ~clk;                                                       
// --> end                                             
end                                                    
endmodule

