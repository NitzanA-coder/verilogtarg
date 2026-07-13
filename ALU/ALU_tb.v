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
// Generated on "07/09/2026 09:15:01"
                                                                                
// Verilog Test Bench template for design : ALU
// 
// Simulation tool : ModelSim-Altera (Verilog)
// 

`timescale 1 ns/ 1 ps
module ALU_tb();
// constants                                           
// general purpose registers
// test vector input registers
reg [3:0] a = 4'd10;
reg [3:0] b = 4'd5;
reg [3:0] operation;
// wires                                               
wire [4:0]  out;

// assign statements (if any)                          
ALU i1 (
// port map - connection between master ports and signals/registers   
	.a(a),
	.b(b),
	.operation(operation),
	.out(out)
);
initial                                                
begin                                                  
// code that executes only once                        
// insert code here --> begin                          
operation = 0;
#100                                                       
// --> end                                             
$display("Running testbench");                       
end                                                    
always                                                 
// optional sensitivity list                           
// @(event1 or event2 or .... eventn)                  
begin                                                  
// code executes for every event on sensitivity list   
// insert code here --> begin                          
#10                                                       
operation = operation + 1;                                             
// --> end                                             
end                                                    
endmodule

