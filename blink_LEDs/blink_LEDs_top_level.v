module blink_LEDs_top_level (

    //CLOCK
    input               FPGA_CLK1_50,	// Main 50 MHz system clock

    //HPS DDR3
    output [14: 0]      HPS_DDR3_ADDR,	// DDR3 memory address bus
    output [ 2: 0]      HPS_DDR3_BA,	// DDR3 bank address
    output              HPS_DDR3_CAS_N,	// Column address strobe
    output              HPS_DDR3_CK_N,	// DDR3 clock negative
    output              HPS_DDR3_CK_P,	// DDR3 clock positive
    output              HPS_DDR3_CKE,	// Clock enable
    output              HPS_DDR3_CS_N,	// Chip select
    output [ 3: 0]      HPS_DDR3_DM,	// Data mask
    inout  [31: 0]      HPS_DDR3_DQ,	// Data bus
    inout  [ 3: 0]      HPS_DDR3_DQS_N,	// Data strobe negative
    inout  [ 3: 0]      HPS_DDR3_DQS_P,	// Data strobe positive
    output              HPS_DDR3_ODT,	// On‑die termination control
    output              HPS_DDR3_RAS_N,	// Row address strobe
    output              HPS_DDR3_RESET_N,	// DDR3 reset signal
    input               HPS_DDR3_RZQ,	// Calibration reference
    output              HPS_DDR3_WE_N,	// Write enable

    //LED
    output [ 7: 0]      LED	// LED output pins
);

    blink_led u0 (
        .clk_clk                            (FPGA_CLK1_50),
        .memory_mem_a                       (HPS_DDR3_ADDR),
        .memory_mem_ba                      (HPS_DDR3_BA),
        .memory_mem_ck                      (HPS_DDR3_CK_P),
        .memory_mem_ck_n                    (HPS_DDR3_CK_N),
        .memory_mem_cke                     (HPS_DDR3_CKE),
        .memory_mem_cs_n                    (HPS_DDR3_CS_N),
        .memory_mem_ras_n                   (HPS_DDR3_RAS_N),
        .memory_mem_cas_n                   (HPS_DDR3_CAS_N),
        .memory_mem_we_n                    (HPS_DDR3_WE_N),
        .memory_mem_reset_n                 (HPS_DDR3_RESET_N),
        .memory_mem_dq                      (HPS_DDR3_DQ),
        .memory_mem_dqs                     (HPS_DDR3_DQS_P),
        .memory_mem_dqs_n                   (HPS_DDR3_DQS_N),
        .memory_mem_odt                     (HPS_DDR3_ODT),
        .memory_mem_dm                      (HPS_DDR3_DM),
        .memory_oct_rzqin                   (HPS_DDR3_RZQ),
        .led_pio_component_0_conduit_end_export (LED)
    );

endmodule