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
// Generated on "07/09/2026 11:40:19"
                                                                                
// Verilog Test Bench template for design : state_machine
// 
// Simulation tool : ModelSim-Altera (Verilog)
// 

`timescale 1 ns/ 1 ps
module state_machine_tb();
// constants                                           
// general purpose registers
// test vector input registers
reg clk;
reg code;
reg rst;
// wires                                               
wire code_correct;

// assign statements (if any)                          
state_machine i1 (
// port map - connection between master ports and signals/registers   
	.clk(clk),
	.code(code),
	.code_correct(code_correct),
	.rst(rst)
);
initial                                                
begin                                                  
// code that executes only once                        
// insert code here --> begin                          
clk = 0;
rst = 1;
code = 0;
#10
code = 1;
#10
code = 0;
#10
code = 0;
#10
rst = 0;
#10
rst = 1;
code = 0;
#10
code = 1;
#10
code = 0;
#10
code = 1;
#10
code = 0;
#10
code = 0;
#10
code = 1;
#10
code = 0;
#10
code = 0;
#10
code = 1;
#10                                                       
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

