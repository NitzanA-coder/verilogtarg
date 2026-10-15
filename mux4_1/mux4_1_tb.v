`timescale 1ns / 1ps
module mux4_1_tb;
reg [1:0] t_s;
reg [3:0] t_d;
wire t_y;
mux4_1 uut(
	.s(t_s),
	.d(t_d),
	.y(t_y)
	);
initial begin
t_d = 4'b1010;

t_s = 2'd0;
#10;
t_s = 2'd1;
#10;
t_s = 2'd2;
#10;
t_s = 2'd3;
#10;

t_d = 4'b0101;

t_s = 2'd0;
#10;
t_s = 2'd1;
#10;
t_s = 2'd2;
#10;
t_s = 2'd3;
#10;

$finish;
end
endmodule
