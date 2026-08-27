module top_level_calculator(
	input wire FPGA_CLK1_50,
	output wire [14:0]	HPS_DDR3_address,
	output wire [ 2:0]	HPS_DDR3_bank,
	output wire				HPS_DDR3_ck_p,
	output wire				HPS_DDR3_ck_n,
	output wire				HPS_DDR3_cke,
	output wire				HPS_DDR3_chipselect_n,
	output wire				HPS_DDR3_ras_n,
	output wire				HPS_DDR3_cas_n,
	output wire				HPS_DDR3_we_n,
	output wire				HPS_DDR3_reset_n,
	inout  wire [31:0]	HPS_DDR3_dq,
	inout  wire [ 3:0]	HPS_DDR3_dqs_p,
	inout  wire [ 3:0]	HPS_DDR3_dqs_n,
	output wire				HPS_DDR3_odt,
	output wire [ 3:0]	HPS_DDR3_dm,
	input  wire				HPS_DDR3_rzq
	);
	
	
    calculator u0 (
		.clk_clk            (FPGA_CLK1_50),
		.memory_mem_a       (HPS_DDR3_address),
		.memory_mem_ba      (HPS_DDR3_bank),
		.memory_mem_ck      (HPS_DDR3_ck_p),
		.memory_mem_ck_n    (HPS_DDR3_ck_n),
		.memory_mem_cke     (HPS_DDR3_cke),
      .memory_mem_cs_n    (HPS_DDR3_chipselect_n),
      .memory_mem_ras_n   (HPS_DDR3_ras_n),
      .memory_mem_cas_n   (HPS_DDR3_cas_n),
      .memory_mem_we_n    (HPS_DDR3_we_n),
      .memory_mem_reset_n (HPS_DDR3_reset_n),
      .memory_mem_dq      (HPS_DDR3_dq),
      .memory_mem_dqs     (HPS_DDR3_dqs_p),
      .memory_mem_dqs_n   (HPS_DDR3_dqs_n),
      .memory_mem_odt     (HPS_DDR3_odt),
      .memory_mem_dm      (HPS_DDR3_dm),
      .memory_oct_rzqin   (HPS_DDR3_rzq)
    );

endmodule