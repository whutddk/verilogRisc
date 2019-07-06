//////////////////////////////////////////////////////////////////////////////////
// Company:   
// Engineer: Ruige_Lee
// Create Date: 2019-06-27 19:06:55
// Last Modified by:   Ruige_Lee
// Last Modified time: 2019-07-06 19:14:16
// Email: 295054118@whut.edu.cn
// page: https://whutddk.github.io/
// Design Name: system.v  
// Module Name: system
// Project Name:   
// Target Devices:   
// Tool Versions:   
// Description:   
// 
// Dependencies:   
// 
// Revision:  
// Revision:    -   
// Additional Comments:  
// 
//
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////
// Company:   
// Engineer: Ruige_Lee
// Create Date: 2019-01-24 08:57:00
// Last Modified by:   29505
// Last Modified time: 2019-06-27 15:34:18
// Email: 295054118@whut.edu.cn
// Design Name: system.v  
// Module Name: system
// Project Name:   
// Target Devices:   
// Tool Versions:   
// Description:   
// 
// Dependencies:   
// 
// Revision:  
// Revision 0.01 - File Created
// Additional Comments:  
// 
//////////////////////////////////////////////////////////////////////////////////
`timescale 1ns/1ps

module system
(
    output SRAM_OEn_io,
    output SRAM_WRn_io,
    output SRAM_CSn_io,

    output [19:0] SRAM_ADDR_io,
    inout [15:0] SRAM_DATA,


	input wire CLK100MHZ,//GCLK-W19

	input wire mcu_rst,//MCU_RESET-P20


	//gpio
	inout wire [1:0] gpio,//GPIO00~GPIO031

	// JD (used for JTAG connection)
	inout wire mcu_TDO,//MCU_TDO-N17
	inout wire mcu_TCK,//MCU_TCK-P15 
	inout wire mcu_TDI,//MCU_TDI-T18
	inout wire mcu_TMS//MCU_TMS-P17

);

	wire clk_out1;
	wire mmcm_locked;

	wire reset_periph;

	wire ck_rst;

	// All wires connected to the chip top
	wire dut_clock;
	wire dut_reset;
	wire dut_io_pads_jtag_TCK_i_ival;
	wire dut_io_pads_jtag_TMS_i_ival;
	wire dut_io_pads_jtag_TMS_o_oval;
	wire dut_io_pads_jtag_TMS_o_oe;
	wire dut_io_pads_jtag_TMS_o_ie;
	wire dut_io_pads_jtag_TMS_o_pue;
	wire dut_io_pads_jtag_TMS_o_ds;
	wire dut_io_pads_jtag_TDI_i_ival;
	wire dut_io_pads_jtag_TDO_o_oval;
	wire dut_io_pads_jtag_TDO_o_oe;
	wire dut_io_pads_gpio_0_i_ival;
	wire dut_io_pads_gpio_0_o_oval;
	wire dut_io_pads_gpio_0_o_oe;
	wire dut_io_pads_gpio_0_o_ie;
	wire dut_io_pads_gpio_0_o_pue;
	wire dut_io_pads_gpio_0_o_ds;
	wire dut_io_pads_gpio_1_i_ival;
	wire dut_io_pads_gpio_1_o_oval;
	wire dut_io_pads_gpio_1_o_oe;
	wire dut_io_pads_gpio_1_o_ie;
	wire dut_io_pads_gpio_1_o_pue;
	wire dut_io_pads_gpio_1_o_ds;

	wire dut_io_pads_bootrom_n_i_ival;
	wire dut_io_pads_dbgmode0_n_i_ival;
	wire dut_io_pads_dbgmode1_n_i_ival;
	wire dut_io_pads_dbgmode2_n_i_ival;

	//=================================================
	// Clock & Reset
	wire clk_8388;
	wire clk_16M;
	


	mmcm ip_mmcm
	(
		.resetn(ck_rst),
		.clk_in1(CLK100MHZ),
		.clk_out1(clk_8388),
		.clk_out2(clk_16M), // 16 MHz, this clock we set to 16MHz 
		.locked(mmcm_locked)
	);

	assign ck_rst = mcu_rst;

	reg [7:0] rtcCLK_cnt;
always @(posedge clk_8388 or negedge ck_rst) begin
		if (!ck_rst) begin
			rtcCLK_cnt <= 8'b0;
			
		end
		else begin
			rtcCLK_cnt <= rtcCLK_cnt + 8'b1;
		end
end




	reset_sys ip_reset_sys
	(
		.slowest_sync_clk(clk_16M),
		.ext_reset_in(ck_rst), // Active-low
		.aux_reset_in(1'b1),
		.mb_debug_sys_rst(1'b0),
		.dcm_locked(mmcm_locked),
		.mb_reset(),
		.bus_struct_reset(),
		.peripheral_reset(reset_periph),
		.interconnect_aresetn(),
		.peripheral_aresetn()
	);


	//=================================================
	// IOBUF instantiation for GPIOs

	wire iobuf_gpio_0_o;
	IOBUF
	#(
		.DRIVE(12),
		.IBUF_LOW_PWR("TRUE"),
		.IOSTANDARD("DEFAULT"),
		.SLEW("SLOW")
	)
	IOBUF_gpio_0
	(
		.O(iobuf_gpio_0_o),
		.IO(gpio[0]),
		.I(dut_io_pads_gpio_0_o_oval),
		.T(~dut_io_pads_gpio_0_o_oe)
	);
	assign dut_io_pads_gpio_0_i_ival = iobuf_gpio_0_o & dut_io_pads_gpio_0_o_ie;

	wire iobuf_gpio_1_o;
	IOBUF
	#(
		.DRIVE(12),
		.IBUF_LOW_PWR("TRUE"),
		.IOSTANDARD("DEFAULT"),
		.SLEW("SLOW")
	)
	IOBUF_gpio_1
	(
		.O(iobuf_gpio_1_o),
		.IO(gpio[1]),
		.I(dut_io_pads_gpio_1_o_oval),
		.T(~dut_io_pads_gpio_1_o_oe)
	);
	assign dut_io_pads_gpio_1_i_ival = iobuf_gpio_1_o & dut_io_pads_gpio_1_o_ie;

	
	//=================================================
	// JTAG IOBUFs

	wire iobuf_jtag_TCK_o;
	IOBUF
	#(
		.DRIVE(12),
		.IBUF_LOW_PWR("TRUE"),
		.IOSTANDARD("DEFAULT"),
		.SLEW("SLOW")
	)
	IOBUF_jtag_TCK
	(
		.O(iobuf_jtag_TCK_o),
		.IO(mcu_TCK),
		.I(1'b0),
		.T(1'b1)
	);
	assign dut_io_pads_jtag_TCK_i_ival = iobuf_jtag_TCK_o ;
	PULLUP pullup_TCK (.O(mcu_TCK));

	wire iobuf_jtag_TMS_o;
	IOBUF
	#(
		.DRIVE(12),
		.IBUF_LOW_PWR("TRUE"),
		.IOSTANDARD("DEFAULT"),
		.SLEW("SLOW")
	)
	IOBUF_jtag_TMS
	(
		.O(iobuf_jtag_TMS_o),
		.IO(mcu_TMS),
		.I(1'b0),
		.T(1'b1)
	);
	assign dut_io_pads_jtag_TMS_i_ival = iobuf_jtag_TMS_o;
	PULLUP pullup_TMS (.O(mcu_TMS));

	wire iobuf_jtag_TDI_o;
	IOBUF
	#(
		.DRIVE(12),
		.IBUF_LOW_PWR("TRUE"),
		.IOSTANDARD("DEFAULT"),
		.SLEW("SLOW")
	)
	IOBUF_jtag_TDI
	(
		.O(iobuf_jtag_TDI_o),
		.IO(mcu_TDI),
		.I(1'b0),
		.T(1'b1)
	);
	assign dut_io_pads_jtag_TDI_i_ival = iobuf_jtag_TDI_o;
	PULLUP pullup_TDI (.O(mcu_TDI));

	wire iobuf_jtag_TDO_o;
	IOBUF
	#(
		.DRIVE(12),
		.IBUF_LOW_PWR("TRUE"),
		.IOSTANDARD("DEFAULT"),
		.SLEW("SLOW")
	)
	IOBUF_jtag_TDO
	(
		.O(iobuf_jtag_TDO_o),
		.IO(mcu_TDO),
		.I(dut_io_pads_jtag_TDO_o_oval),
		.T(~dut_io_pads_jtag_TDO_o_oe)
	);
	
wire [15:0] SRAM_DATA_IN_io;
wire [15:0] SRAM_DATA_OUT_io;
wire [15:0] SRAM_DATA_t;


genvar i;
generate
	for ( i = 0 ; i < 16 ; i = i+1 ) begin
		IOBUF
	#(
		.DRIVE(12),
		.IBUF_LOW_PWR("TRUE"),
		.IOSTANDARD("DEFAULT"),
		.SLEW("SLOW")
	)
	IOBUF_SRAM_DATA
	(
		.O(SRAM_DATA_OUT_io[i]),
		.IO(SRAM_DATA[i]),
		.I(SRAM_DATA_IN_io[i]),
		.T(SRAM_DATA_t[i])
	);
	end
 	
 endgenerate 

	//=================================================
	// Assignment of IOBUF "IO" pins to package pins

	// Pins IO0-IO13
	// Shield header row 0: PD0-PD7

	// Use the LEDs for some more useful debugging things.
	// assign pmu_paden  = dut_io_pads_aon_pmu_vddpaden_o_oval;  
	// assign pmu_padrst = dut_io_pads_aon_pmu_padrst_o_oval;		

	// model select
	assign dut_io_pads_bootrom_n_i_ival  = 1'b0;   //
	assign dut_io_pads_dbgmode0_n_i_ival = 1'b1;
	assign dut_io_pads_dbgmode1_n_i_ival = 1'b1;
	assign dut_io_pads_dbgmode2_n_i_ival = 1'b1;
	//



	e203_soc_top dut
	(



  //driver pin
  .SRAM_OEn_io(SRAM_OEn_io),
  .SRAM_WRn_io(SRAM_WRn_io),
  .SRAM_CSn_io(SRAM_CSn_io),

  .SRAM_ADDR_io(SRAM_ADDR_io),
  .SRAM_DATA_IN_io(SRAM_DATA_IN_io),
  .SRAM_DATA_OUT_io(SRAM_DATA_OUT_io),
  .SRAM_DATA_t(SRAM_DATA_t), 



		.hfextclk(clk_16M),
		.hfxoscen(),

		.lfextclk(rtcCLK_cnt[7]), 
		.lfxoscen(),

			 // Note: this is the real SoC top AON domain slow clock
		.io_pads_jtag_TCK_i_ival(dut_io_pads_jtag_TCK_i_ival),
		.io_pads_jtag_TMS_i_ival(dut_io_pads_jtag_TMS_i_ival),
		.io_pads_jtag_TDI_i_ival(dut_io_pads_jtag_TDI_i_ival),
		.io_pads_jtag_TDO_o_oval(dut_io_pads_jtag_TDO_o_oval),
		.io_pads_jtag_TDO_o_oe(dut_io_pads_jtag_TDO_o_oe),

		.io_pads_gpio_0_i_ival(1'b0),
		.io_pads_gpio_0_o_oval(),
		.io_pads_gpio_0_o_oe(),
		.io_pads_gpio_0_o_ie(),
		.io_pads_gpio_0_o_pue(),
		.io_pads_gpio_0_o_ds(),
		.io_pads_gpio_1_i_ival(1'b0),
		.io_pads_gpio_1_o_oval(),
		.io_pads_gpio_1_o_oe(),
		.io_pads_gpio_1_o_ie(),
		.io_pads_gpio_1_o_pue(),
		.io_pads_gpio_1_o_ds(),
		.io_pads_gpio_2_i_ival(1'b0),
		.io_pads_gpio_2_o_oval(),
		.io_pads_gpio_2_o_oe(),
		.io_pads_gpio_2_o_ie(),
		.io_pads_gpio_2_o_pue(),
		.io_pads_gpio_2_o_ds(),
		.io_pads_gpio_3_i_ival(1'b0),
		.io_pads_gpio_3_o_oval(),
		.io_pads_gpio_3_o_oe(),
		.io_pads_gpio_3_o_ie(),
		.io_pads_gpio_3_o_pue(),
		.io_pads_gpio_3_o_ds(),
		.io_pads_gpio_4_i_ival(1'b0),
		.io_pads_gpio_4_o_oval(),
		.io_pads_gpio_4_o_oe(),
		.io_pads_gpio_4_o_ie(),
		.io_pads_gpio_4_o_pue(),
		.io_pads_gpio_4_o_ds(),
		.io_pads_gpio_5_i_ival(1'b0),
		.io_pads_gpio_5_o_oval(),
		.io_pads_gpio_5_o_oe(),
		.io_pads_gpio_5_o_ie(),
		.io_pads_gpio_5_o_pue(),
		.io_pads_gpio_5_o_ds(),
		.io_pads_gpio_6_i_ival(1'b0),
		.io_pads_gpio_6_o_oval(),
		.io_pads_gpio_6_o_oe(),
		.io_pads_gpio_6_o_ie(),
		.io_pads_gpio_6_o_pue(),
		.io_pads_gpio_6_o_ds(),
		.io_pads_gpio_7_i_ival(1'b0),
		.io_pads_gpio_7_o_oval(),
		.io_pads_gpio_7_o_oe(),
		.io_pads_gpio_7_o_ie(),
		.io_pads_gpio_7_o_pue(),
		.io_pads_gpio_7_o_ds(),
		.io_pads_gpio_8_i_ival(1'b0),
		.io_pads_gpio_8_o_oval(),
		.io_pads_gpio_8_o_oe(),
		.io_pads_gpio_8_o_ie(),
		.io_pads_gpio_8_o_pue(),
		.io_pads_gpio_8_o_ds(),
		.io_pads_gpio_9_i_ival(1'b0),
		.io_pads_gpio_9_o_oval(),
		.io_pads_gpio_9_o_oe(),
		.io_pads_gpio_9_o_ie(),
		.io_pads_gpio_9_o_pue(),
		.io_pads_gpio_9_o_ds(),
		.io_pads_gpio_10_i_ival(1'b0),
		.io_pads_gpio_10_o_oval(),
		.io_pads_gpio_10_o_oe(),
		.io_pads_gpio_10_o_ie(),
		.io_pads_gpio_10_o_pue(),
		.io_pads_gpio_10_o_ds(),
		.io_pads_gpio_11_i_ival(1'b0),
		.io_pads_gpio_11_o_oval(),
		.io_pads_gpio_11_o_oe(),
		.io_pads_gpio_11_o_ie(),
		.io_pads_gpio_11_o_pue(),
		.io_pads_gpio_11_o_ds(),
		.io_pads_gpio_12_i_ival(1'b0),
		.io_pads_gpio_12_o_oval(),
		.io_pads_gpio_12_o_oe(),
		.io_pads_gpio_12_o_ie(),
		.io_pads_gpio_12_o_pue(),
		.io_pads_gpio_12_o_ds(),
		.io_pads_gpio_13_i_ival(1'b0),
		.io_pads_gpio_13_o_oval(),
		.io_pads_gpio_13_o_oe(),
		.io_pads_gpio_13_o_ie(),
		.io_pads_gpio_13_o_pue(),
		.io_pads_gpio_13_o_ds(),
		.io_pads_gpio_14_i_ival(1'b0),
		.io_pads_gpio_14_o_oval(),
		.io_pads_gpio_14_o_oe(),
		.io_pads_gpio_14_o_ie(),
		.io_pads_gpio_14_o_pue(),
		.io_pads_gpio_14_o_ds(),
		.io_pads_gpio_15_i_ival(1'b0),
		.io_pads_gpio_15_o_oval(),
		.io_pads_gpio_15_o_oe(),
		.io_pads_gpio_15_o_ie(),
		.io_pads_gpio_15_o_pue(),
		.io_pads_gpio_15_o_ds(),
		.io_pads_gpio_16_i_ival(dut_io_pads_gpio_0_i_ival),
		.io_pads_gpio_16_o_oval(dut_io_pads_gpio_0_o_oval),
		.io_pads_gpio_16_o_oe(dut_io_pads_gpio_0_o_oe),
		.io_pads_gpio_16_o_ie(dut_io_pads_gpio_0_o_ie),
		.io_pads_gpio_16_o_pue(dut_io_pads_gpio_0_o_pue),
		.io_pads_gpio_16_o_ds(dut_io_pads_gpio_0_o_ds),
		.io_pads_gpio_17_i_ival(dut_io_pads_gpio_1_i_ival),
		.io_pads_gpio_17_o_oval(dut_io_pads_gpio_1_o_oval),
		.io_pads_gpio_17_o_oe(dut_io_pads_gpio_1_o_oe),
		.io_pads_gpio_17_o_ie(dut_io_pads_gpio_1_o_ie),
		.io_pads_gpio_17_o_pue(dut_io_pads_gpio_1_o_pue),
		.io_pads_gpio_17_o_ds(dut_io_pads_gpio_1_o_ds),
		.io_pads_gpio_18_i_ival(1'b0),
		.io_pads_gpio_18_o_oval(),
		.io_pads_gpio_18_o_oe(),
		.io_pads_gpio_18_o_ie(),
		.io_pads_gpio_18_o_pue(),
		.io_pads_gpio_18_o_ds(),
		.io_pads_gpio_19_i_ival(1'b0),
		.io_pads_gpio_19_o_oval(),
		.io_pads_gpio_19_o_oe(),
		.io_pads_gpio_19_o_ie(),
		.io_pads_gpio_19_o_pue(),
		.io_pads_gpio_19_o_ds(),

	.io_pads_gpio_20_i_ival(1'b0),
		.io_pads_gpio_20_o_oval(),
		.io_pads_gpio_20_o_oe(),
		.io_pads_gpio_20_o_ie(),
		.io_pads_gpio_20_o_pue(),
		.io_pads_gpio_20_o_ds(),

	.io_pads_gpio_21_i_ival(1'b0),
		.io_pads_gpio_21_o_oval(),
		.io_pads_gpio_21_o_oe(),
		.io_pads_gpio_21_o_ie(),
		.io_pads_gpio_21_o_pue(),
		.io_pads_gpio_21_o_ds(),

		.io_pads_gpio_22_i_ival(1'b0),
		.io_pads_gpio_22_o_oval(),
		.io_pads_gpio_22_o_oe(),
		.io_pads_gpio_22_o_ie(),
		.io_pads_gpio_22_o_pue(),
		.io_pads_gpio_22_o_ds(),

		.io_pads_gpio_23_i_ival(1'b0),
		.io_pads_gpio_23_o_oval(),
		.io_pads_gpio_23_o_oe(),
		.io_pads_gpio_23_o_ie(),
		.io_pads_gpio_23_o_pue(),
		.io_pads_gpio_23_o_ds(),
		.io_pads_gpio_24_i_ival(1'b0),
		.io_pads_gpio_24_o_oval(),
		.io_pads_gpio_24_o_oe(),
		.io_pads_gpio_24_o_ie(),
		.io_pads_gpio_24_o_pue(),
		.io_pads_gpio_24_o_ds(),
		.io_pads_gpio_25_i_ival(1'b0),
		.io_pads_gpio_25_o_oval(),
		.io_pads_gpio_25_o_oe(),
		.io_pads_gpio_25_o_ie(),
		.io_pads_gpio_25_o_pue(),
		.io_pads_gpio_25_o_ds(),
		.io_pads_gpio_26_i_ival(1'b0),
		.io_pads_gpio_26_o_oval(),
		.io_pads_gpio_26_o_oe(),
		.io_pads_gpio_26_o_ie(),
		.io_pads_gpio_26_o_pue(),
		.io_pads_gpio_26_o_ds(),
		.io_pads_gpio_27_i_ival(1'b0),
		.io_pads_gpio_27_o_oval(),
		.io_pads_gpio_27_o_oe(),
		.io_pads_gpio_27_o_ie(),
		.io_pads_gpio_27_o_pue(),
		.io_pads_gpio_27_o_ds(),
		.io_pads_gpio_28_i_ival(1'b0),
		.io_pads_gpio_28_o_oval(),
		.io_pads_gpio_28_o_oe(),
		.io_pads_gpio_28_o_ie(),
		.io_pads_gpio_28_o_pue(),
		.io_pads_gpio_28_o_ds(),
		.io_pads_gpio_29_i_ival(1'b0),
		.io_pads_gpio_29_o_oval(),
		.io_pads_gpio_29_o_oe(),
		.io_pads_gpio_29_o_ie(),
		.io_pads_gpio_29_o_pue(),
		.io_pads_gpio_29_o_ds(),
		.io_pads_gpio_30_i_ival(1'b0),
		.io_pads_gpio_30_o_oval(),
		.io_pads_gpio_30_o_oe(),
		.io_pads_gpio_30_o_ie(),
		.io_pads_gpio_30_o_pue(),
		.io_pads_gpio_30_o_ds(),
		.io_pads_gpio_31_i_ival(1'b0),
		.io_pads_gpio_31_o_oval(),
		.io_pads_gpio_31_o_oe(),
		.io_pads_gpio_31_o_ie(),
		.io_pads_gpio_31_o_pue(),
		.io_pads_gpio_31_o_ds(),
		
			 // Note: this is the real SoC top level reset signal
		.io_pads_aon_erst_n_i_ival(ck_rst),
		.io_pads_aon_pmu_dwakeup_n_i_ival(1'b0),
		.io_pads_aon_pmu_vddpaden_o_oval(),

		.io_pads_aon_pmu_padrst_o_oval    (),

		.io_pads_bootrom_n_i_ival       (dut_io_pads_bootrom_n_i_ival),

		.io_pads_dbgmode0_n_i_ival       (dut_io_pads_dbgmode0_n_i_ival),
		.io_pads_dbgmode1_n_i_ival       (dut_io_pads_dbgmode1_n_i_ival),
		.io_pads_dbgmode2_n_i_ival       (dut_io_pads_dbgmode2_n_i_ival) 
	);

	// Assign reasonable values to otherwise unconnected inputs to chip top




endmodule


