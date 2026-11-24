`timescale 1 ps/ 1 ps
module RMII_top_level_tb();
// test vector input registers
reg crs_dv1;
reg crs_dv2;
reg [1:0] data_in1;
reg [1:0] data_in2;
reg ref_clk;
reg reset_n;
reg send1;
reg send2;
// wires
wire [1:0]  data_out1;
wire [1:0]  data_out2;
wire data_valid1;
wire data_valid2;
wire tx_en1;
wire tx_en2;

localparam [55:0] PREAMBLE = 56'h55555555555555;
localparam [7:0]  SFD = 8'hD5;
localparam [47:0] BROADCAST_MAC = 48'hFFFFFFFFFFFF;
localparam [15:0] ETHERTYPE = 16'h0806;
localparam [15:0] H_TYPE = 16'h0001;
localparam [15:0] P_TYPE = 16'h0800;
localparam [7:0]  H_LEN = 8'h06;
localparam [7:0]  P_LEN = 8'h04;
localparam [15:0] OPER = 16'h0001;
localparam [143:0] PADDING = 144'h0;

localparam [47:0] S_MAC1 = 48'h98DED0C357D7;
localparam [31:0] S_IP1  = 32'h0A09001A;
localparam [47:0] T_MAC1 = 48'hFFFFFFFFFFFF;
localparam [31:0] T_IP1  = 32'h0A09001A;

localparam [47:0] S_MAC2    = 48'h106838CCD4B6;
localparam [31:0] S_IP2  = 32'h0A09083F;
localparam [47:0] T_MAC2 = 48'h000000000000;
localparam [31:0] T_IP2  = 32'h0A09083F;

reg [543:0] data1 = {
    PREAMBLE,
	 SFD,
    BROADCAST_MAC,
    S_MAC1,
    ETHERTYPE,
    H_TYPE,
	 P_TYPE,
	 H_LEN,
	 P_LEN,
	 OPER,
    S_MAC1,
    S_IP1,
    T_MAC1,
    T_IP1,
    PADDING
};

reg [543:0] data2 = {
    PREAMBLE,
	 SFD,
    BROADCAST_MAC,
    S_MAC2,
    ETHERTYPE,
    H_TYPE,
	 P_TYPE,
	 H_LEN,
	 P_LEN,
	 OPER,
    S_MAC2,
    S_IP2,
    T_MAC2,
    T_IP2,
    PADDING
};
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
	.reset_n(reset_n),
	.send1(send1),
	.send2(send2),
	.tx_en1(tx_en1),
	.tx_en2(tx_en2)
);

task automatic sending;
  input [543:0] data;
  input target;
  integer i;
  begin
		for (i = 0; i < $bits(data)/2; i = i + 1) begin
			if (target) begin
				data_in1 <= data[$bits(data)-1 - i*2 -: 2];
				crs_dv1  <= 1'b1;
				send1    <= 1'b1;
			end
			else begin
				data_in2 <= data[$bits(data)-1 - i*2 -: 2];
				crs_dv2  <= 1'b1;
				send2    <= 1'b1;
			end
			 
			if (i >= $bits(data)/2 - 2) begin
            if (target)
					crs_dv1 <= ~crs_dv1;				
				else 
					crs_dv2 <= ~crs_dv2;
         end
			 
			@(posedge ref_clk);
		end

		if (target) begin
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
reset_n = 1'b0;
crs_dv1 = 1'b0;
crs_dv2 = 1'b0;
data_in1 = 2'b00;
data_in2 = 2'b00;
send1 = 1'b0;
send2 = 1'b0;
#30
reset_n = 1'b1;
#20

$display("Running testbench");

fork
	sending(data1, 1'b1);
	sending(data2, 1'b0);
join

#100

$display("Testbench finished");
$stop;
end

always #10 ref_clk = ~ref_clk;

endmodule

