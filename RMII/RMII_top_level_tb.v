`timescale 1 ps/ 1 ps
module RMII_top_level_tb();
// test vector input registers
reg crs_dv1;
reg crs_dv2;
reg [1:0] data_in1;
reg [1:0] data_in2;
reg ref_clk;
reg reset;
reg send1;
reg send2;
// wires
wire [1:0]  data_out1;
wire [1:0]  data_out2;
wire data_valid1;
wire data_valid2;
wire tx_en1;
wire tx_en2;

reg [543:0] data1 = 544'h55555555555555d5ffffffffffff98ded0c357d70806000108000604000198ded0c357d70a09001affffffffffff0a09001a000000000000000000000000000000000001;
reg [543:0] data2 = 544'h55555555555555d5ffffffffffff106838ccd4b608060001080006040001106838ccd4b60a09083f0000000000000a09083f000000000000000000000000000000000001;

// assign statements (if any)
RMII_top_level i1 (
// port map - connection between master ports and signals/registers
	.crs_dv1(crs_dv1),
	.crs_dv2(crs_dv2),
	.data_in1(data_in1),
	.data_in2(data_in2),
	.data_out1(data_out1),
	.data_out2(data_out2),
	.data_valid1(data_valid1),
	.data_valid2(data_valid2),
	.ref_clk(ref_clk),
	.reset(reset),
	.send1(send1),
	.send2(send2),
	.tx_en1(tx_en1),
	.tx_en2(tx_en2)
);

task automatic sending;
  input [543:0] data;
  input integer target;
  integer i;
  begin
		for (i = 0; i < 272; i = i + 1) begin
			if (target == 1) begin
				data_in1 <= data[543:542];
				crs_dv1  <= 1'b1;
				send1    <= 1'b1;
			end
			else begin
				data_in2 <= data[543:542];
				crs_dv2  <= 1'b1;
				send2    <= 1'b1;
			end
			data = {data[541:0], 2'b00};
			 
			if (i >= 270) begin
            if (target == 1)
					crs_dv1 <= ~crs_dv1;				
				else 
					crs_dv2 <= ~crs_dv2;
         end
			 
			 @(posedge ref_clk);
		end

		if (target == 1) begin
			crs_dv1 <= 1'b0;
			data_in1 <= 2'b00;
			@(posedge ref_clk);
			send1 <= 1'b0;
		end
		else begin
			crs_dv2 <= 1'b0;
			data_in2 <= 2'b00;
			@(posedge ref_clk);
			send2 <= 1'b0;
		end
  end
endtask

initial
begin
// code that executes only once
ref_clk = 1'b0;
reset = 1'b0;
crs_dv1 = 1'b0;
crs_dv2 = 1'b0;
data_in1 = 2'b00;
data_in2 = 2'b00;
send1 = 1'b0;
send2 = 1'b0;
#30
reset = 1'b1;
#20

$display("Running testbench");

crs_dv1 = 1'b1;
#40

fork
	sending(data1, 1);
	sending(data2, 2);
join

#100

$display("Testbench finished");
$stop;
end
always
// optional sensitivity list
// @(event1 or event2 or .... eventn)
begin
// code executes for every event on sensitivity list
// insert code here --> begin
#10
ref_clk = ~ref_clk;
// --> end
end
endmodule

