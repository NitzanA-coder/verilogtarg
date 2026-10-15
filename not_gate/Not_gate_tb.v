`timescale 1ns / 1ps

module Not_gate_tb;

	reg t_a_in;
	wire t_a_out;

	Not_gate uut(
		.a_in(t_a_in),
		.a_out(t_a_out)
	);
	
	initial begin
		//מצב אחד: הכניסה ב0
		t_a_in = 0;
		#10;
		//מצב שני: הכניסה ב1
		t_a_in = 1;
		#10;
		$finish;
	end
endmodule
