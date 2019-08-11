//////////////////////////////////////////////////////////////////////////////////
// Company:   
// Engineer: Ruige_Lee
// Create Date: 2019-06-27 19:06:59
// Last Modified by:   29505
// Last Modified time: 2019-07-12 11:20:04
// Email: 295054118@whut.edu.cn
// page: https://whutddk.github.io/
// Design Name: e203_soc_top.v  
// Module Name: e203_soc_top
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
// Engineer: 29505
// Create Date: 2019-06-26 09:51:22
// Last Modified by:   29505
// Last Modified time: 2019-06-27 16:55:15
// Email: 295054118@whut.edu.cn
// Design Name: e203_soc_top.v  
// Module Name: e203_soc_top
// Project Name:  
// Target Devices:  
// Tool Versions:  
// Description:  
// 
// Dependencies:   
// 
// Revision:  
// Revision  
// Additional Comments:   
// 
//////////////////////////////////////////////////////////////////////////////////
 /*                                                                      
 Copyright 2018 Nuclei System Technology, Inc.                
																																				 
 Licensed under the Apache License, Version 2.0 (the "License");         
 you may not use this file except in compliance with the License.        
 You may obtain a copy of the License at                                 
																																				 
		 http://www.apache.org/licenses/LICENSE-2.0                          
																																				 
	Unless required by applicable law or agreed to in writing, software    
 distributed under the License is distributed on an "AS IS" BASIS,       
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and     
 limitations under the License.                                          
 */                                                                      
																																				 
																																				 
																																				 
module e203_soc_top(

    //driver pin
    output SRAM_OEn,
    output SRAM_WEn,
    output SRAM_CEn,
    output [3:0] SRAM_BEn,

    output [21:0] SRAM_ADDR,
    output [31:0] SRAM_DATA_IN,
    input [31:0] SRAM_DATA_OUT,
    output [31:0] SRAM_DATA_t,

		// This clock should comes from the crystal pad generated high speed clock (16MHz)
	input  hfextclk,
	output hfxoscen,// The signal to enable the crystal pad generated clock

	// This clock should comes from the crystal pad generated low speed clock (32.768KHz)
	input  lfextclk,
	output lfxoscen,// The signal to enable the crystal pad generated clock


	// The JTAG TCK is input, need to be pull-up
	input   io_pads_jtag_TCK_i_ival,

	// The JTAG TMS is input, need to be pull-up
	input   io_pads_jtag_TMS_i_ival,

	// The JTAG TDI is input, need to be pull-up
	input   io_pads_jtag_TDI_i_ival,

	// The JTAG TDO is output have enable
	output  io_pads_jtag_TDO_o_oval,
	output  io_pads_jtag_TDO_o_oe,

	// The GPIO are all bidir pad have enables
	input   io_pads_gpio_0_i_ival,
	output  io_pads_gpio_0_o_oval,
	output  io_pads_gpio_0_o_oe,
	output  io_pads_gpio_0_o_ie,
	output  io_pads_gpio_0_o_pue,
	output  io_pads_gpio_0_o_ds,
	input   io_pads_gpio_1_i_ival,
	output  io_pads_gpio_1_o_oval,
	output  io_pads_gpio_1_o_oe,
	output  io_pads_gpio_1_o_ie,
	output  io_pads_gpio_1_o_pue,
	output  io_pads_gpio_1_o_ds,
	input   io_pads_gpio_2_i_ival,
	output  io_pads_gpio_2_o_oval,
	output  io_pads_gpio_2_o_oe,
	output  io_pads_gpio_2_o_ie,
	output  io_pads_gpio_2_o_pue,
	output  io_pads_gpio_2_o_ds,
	input   io_pads_gpio_3_i_ival,
	output  io_pads_gpio_3_o_oval,
	output  io_pads_gpio_3_o_oe,
	output  io_pads_gpio_3_o_ie,
	output  io_pads_gpio_3_o_pue,
	output  io_pads_gpio_3_o_ds,
	input   io_pads_gpio_4_i_ival,
	output  io_pads_gpio_4_o_oval,
	output  io_pads_gpio_4_o_oe,
	output  io_pads_gpio_4_o_ie,
	output  io_pads_gpio_4_o_pue,
	output  io_pads_gpio_4_o_ds,
	input   io_pads_gpio_5_i_ival,
	output  io_pads_gpio_5_o_oval,
	output  io_pads_gpio_5_o_oe,
	output  io_pads_gpio_5_o_ie,
	output  io_pads_gpio_5_o_pue,
	output  io_pads_gpio_5_o_ds,
	input   io_pads_gpio_6_i_ival,
	output  io_pads_gpio_6_o_oval,
	output  io_pads_gpio_6_o_oe,
	output  io_pads_gpio_6_o_ie,
	output  io_pads_gpio_6_o_pue,
	output  io_pads_gpio_6_o_ds,
	input   io_pads_gpio_7_i_ival,
	output  io_pads_gpio_7_o_oval,
	output  io_pads_gpio_7_o_oe,
	output  io_pads_gpio_7_o_ie,
	output  io_pads_gpio_7_o_pue,
	output  io_pads_gpio_7_o_ds,
	input   io_pads_gpio_8_i_ival,
	output  io_pads_gpio_8_o_oval,
	output  io_pads_gpio_8_o_oe,
	output  io_pads_gpio_8_o_ie,
	output  io_pads_gpio_8_o_pue,
	output  io_pads_gpio_8_o_ds,
	input   io_pads_gpio_9_i_ival,
	output  io_pads_gpio_9_o_oval,
	output  io_pads_gpio_9_o_oe,
	output  io_pads_gpio_9_o_ie,
	output  io_pads_gpio_9_o_pue,
	output  io_pads_gpio_9_o_ds,
	input   io_pads_gpio_10_i_ival,
	output  io_pads_gpio_10_o_oval,
	output  io_pads_gpio_10_o_oe,
	output  io_pads_gpio_10_o_ie,
	output  io_pads_gpio_10_o_pue,
	output  io_pads_gpio_10_o_ds,
	input   io_pads_gpio_11_i_ival,
	output  io_pads_gpio_11_o_oval,
	output  io_pads_gpio_11_o_oe,
	output  io_pads_gpio_11_o_ie,
	output  io_pads_gpio_11_o_pue,
	output  io_pads_gpio_11_o_ds,
	input   io_pads_gpio_12_i_ival,
	output  io_pads_gpio_12_o_oval,
	output  io_pads_gpio_12_o_oe,
	output  io_pads_gpio_12_o_ie,
	output  io_pads_gpio_12_o_pue,
	output  io_pads_gpio_12_o_ds,
	input   io_pads_gpio_13_i_ival,
	output  io_pads_gpio_13_o_oval,
	output  io_pads_gpio_13_o_oe,
	output  io_pads_gpio_13_o_ie,
	output  io_pads_gpio_13_o_pue,
	output  io_pads_gpio_13_o_ds,
	input   io_pads_gpio_14_i_ival,
	output  io_pads_gpio_14_o_oval,
	output  io_pads_gpio_14_o_oe,
	output  io_pads_gpio_14_o_ie,
	output  io_pads_gpio_14_o_pue,
	output  io_pads_gpio_14_o_ds,
	input   io_pads_gpio_15_i_ival,
	output  io_pads_gpio_15_o_oval,
	output  io_pads_gpio_15_o_oe,
	output  io_pads_gpio_15_o_ie,
	output  io_pads_gpio_15_o_pue,
	output  io_pads_gpio_15_o_ds,
	input   io_pads_gpio_16_i_ival,
	output  io_pads_gpio_16_o_oval,
	output  io_pads_gpio_16_o_oe,
	output  io_pads_gpio_16_o_ie,
	output  io_pads_gpio_16_o_pue,
	output  io_pads_gpio_16_o_ds,
	input   io_pads_gpio_17_i_ival,
	output  io_pads_gpio_17_o_oval,
	output  io_pads_gpio_17_o_oe,
	output  io_pads_gpio_17_o_ie,
	output  io_pads_gpio_17_o_pue,
	output  io_pads_gpio_17_o_ds,
	input   io_pads_gpio_18_i_ival,
	output  io_pads_gpio_18_o_oval,
	output  io_pads_gpio_18_o_oe,
	output  io_pads_gpio_18_o_ie,
	output  io_pads_gpio_18_o_pue,
	output  io_pads_gpio_18_o_ds,
	input   io_pads_gpio_19_i_ival,
	output  io_pads_gpio_19_o_oval,
	output  io_pads_gpio_19_o_oe,
	output  io_pads_gpio_19_o_ie,
	output  io_pads_gpio_19_o_pue,
	output  io_pads_gpio_19_o_ds,
	input   io_pads_gpio_20_i_ival,
	output  io_pads_gpio_20_o_oval,
	output  io_pads_gpio_20_o_oe,
	output  io_pads_gpio_20_o_ie,
	output  io_pads_gpio_20_o_pue,
	output  io_pads_gpio_20_o_ds,
	input   io_pads_gpio_21_i_ival,
	output  io_pads_gpio_21_o_oval,
	output  io_pads_gpio_21_o_oe,
	output  io_pads_gpio_21_o_ie,
	output  io_pads_gpio_21_o_pue,
	output  io_pads_gpio_21_o_ds,
	input   io_pads_gpio_22_i_ival,
	output  io_pads_gpio_22_o_oval,
	output  io_pads_gpio_22_o_oe,
	output  io_pads_gpio_22_o_ie,
	output  io_pads_gpio_22_o_pue,
	output  io_pads_gpio_22_o_ds,
	input   io_pads_gpio_23_i_ival,
	output  io_pads_gpio_23_o_oval,
	output  io_pads_gpio_23_o_oe,
	output  io_pads_gpio_23_o_ie,
	output  io_pads_gpio_23_o_pue,
	output  io_pads_gpio_23_o_ds,
	input   io_pads_gpio_24_i_ival,
	output  io_pads_gpio_24_o_oval,
	output  io_pads_gpio_24_o_oe,
	output  io_pads_gpio_24_o_ie,
	output  io_pads_gpio_24_o_pue,
	output  io_pads_gpio_24_o_ds,
	input   io_pads_gpio_25_i_ival,
	output  io_pads_gpio_25_o_oval,
	output  io_pads_gpio_25_o_oe,
	output  io_pads_gpio_25_o_ie,
	output  io_pads_gpio_25_o_pue,
	output  io_pads_gpio_25_o_ds,
	input   io_pads_gpio_26_i_ival,
	output  io_pads_gpio_26_o_oval,
	output  io_pads_gpio_26_o_oe,
	output  io_pads_gpio_26_o_ie,
	output  io_pads_gpio_26_o_pue,
	output  io_pads_gpio_26_o_ds,
	input   io_pads_gpio_27_i_ival,
	output  io_pads_gpio_27_o_oval,
	output  io_pads_gpio_27_o_oe,
	output  io_pads_gpio_27_o_ie,
	output  io_pads_gpio_27_o_pue,
	output  io_pads_gpio_27_o_ds,
	input   io_pads_gpio_28_i_ival,
	output  io_pads_gpio_28_o_oval,
	output  io_pads_gpio_28_o_oe,
	output  io_pads_gpio_28_o_ie,
	output  io_pads_gpio_28_o_pue,
	output  io_pads_gpio_28_o_ds,
	input   io_pads_gpio_29_i_ival,
	output  io_pads_gpio_29_o_oval,
	output  io_pads_gpio_29_o_oe,
	output  io_pads_gpio_29_o_ie,
	output  io_pads_gpio_29_o_pue,
	output  io_pads_gpio_29_o_ds,
	input   io_pads_gpio_30_i_ival,
	output  io_pads_gpio_30_o_oval,
	output  io_pads_gpio_30_o_oe,
	output  io_pads_gpio_30_o_ie,
	output  io_pads_gpio_30_o_pue,
	output  io_pads_gpio_30_o_ds,
	input   io_pads_gpio_31_i_ival,
	output  io_pads_gpio_31_o_oval,
	output  io_pads_gpio_31_o_oe,
	output  io_pads_gpio_31_o_ie,
	output  io_pads_gpio_31_o_pue,
	output  io_pads_gpio_31_o_ds,

	// Erst is input need to be pull-up by default
	input   io_pads_aon_erst_n_i_ival,

	// dbgmode are inputs need to be pull-up by default
	input  io_pads_dbgmode0_n_i_ival,
	input  io_pads_dbgmode1_n_i_ival,
	input  io_pads_dbgmode2_n_i_ival,

	// BootRom is input need to be pull-up by default
	input  io_pads_bootrom_n_i_ival,


	// dwakeup is input need to be pull-up by default
	input  io_pads_aon_pmu_dwakeup_n_i_ival,

			// PMU output is just output without enable
	output io_pads_aon_pmu_padrst_o_oval,
	output io_pads_aon_pmu_vddpaden_o_oval 
);


 
 wire sysper_icb_cmd_valid;
 wire sysper_icb_cmd_ready;

// `ifdef E203_HAS_MEM_ITF
//  wire sysmem_icb_cmd_valid;
//  wire sysmem_icb_cmd_ready;
// `endif

 e203_subsys_top u_e203_subsys_top(


    //driver pin
    .SRAM_OEn(SRAM_OEn),
    .SRAM_WEn(SRAM_WEn),
    .SRAM_CEn(SRAM_CEn),
    .SRAM_BEn(SRAM_BEn),

    .SRAM_ADDR(SRAM_ADDR),
    .SRAM_DATA_IN(SRAM_DATA_IN),
    .SRAM_DATA_OUT(SRAM_DATA_OUT),
    .SRAM_DATA_t(SRAM_DATA_t),

		.core_mhartid      (1'b0),
	
	.sysper_icb_cmd_valid (sysper_icb_cmd_valid),
	.sysper_icb_cmd_ready (sysper_icb_cmd_ready),
	.sysper_icb_cmd_read  (), 
	.sysper_icb_cmd_addr  (), 
	.sysper_icb_cmd_wdata (), 
	.sysper_icb_cmd_wmask (), 
	
	.sysper_icb_rsp_valid (sysper_icb_cmd_valid),
	.sysper_icb_rsp_ready (sysper_icb_cmd_ready),
	.sysper_icb_rsp_err   (1'b0  ),
	.sysper_icb_rsp_rdata (32'b0),

// `ifdef E203_HAS_MEM_ITF
// 	.sysmem_icb_cmd_valid(sysmem_icb_cmd_valid),
// 	.sysmem_icb_cmd_ready(sysmem_icb_cmd_ready),
// 	.sysmem_icb_cmd_read (), 
// 	.sysmem_icb_cmd_addr (), 
// 	.sysmem_icb_cmd_wdata(), 
// 	.sysmem_icb_cmd_wmask(), 

// 	.sysmem_icb_rsp_valid(sysmem_icb_cmd_valid),
// 	.sysmem_icb_rsp_ready(sysmem_icb_cmd_ready),
// 	.sysmem_icb_rsp_err  (1'b0  ),
// 	.sysmem_icb_rsp_rdata(32'b0),
// `endif

	.io_pads_jtag_TCK_i_ival    (io_pads_jtag_TCK_i_ival    ),
	.io_pads_jtag_TCK_o_oval    (),
	.io_pads_jtag_TCK_o_oe      (),
	.io_pads_jtag_TCK_o_ie      (),
	.io_pads_jtag_TCK_o_pue     (),
	.io_pads_jtag_TCK_o_ds      (),

	.io_pads_jtag_TMS_i_ival    (io_pads_jtag_TMS_i_ival    ),
	.io_pads_jtag_TMS_o_oval    (),
	.io_pads_jtag_TMS_o_oe      (),
	.io_pads_jtag_TMS_o_ie      (),
	.io_pads_jtag_TMS_o_pue     (),
	.io_pads_jtag_TMS_o_ds      (),

	.io_pads_jtag_TDI_i_ival    (io_pads_jtag_TDI_i_ival    ),
	.io_pads_jtag_TDI_o_oval    (),
	.io_pads_jtag_TDI_o_oe      (),
	.io_pads_jtag_TDI_o_ie      (),
	.io_pads_jtag_TDI_o_pue     (),
	.io_pads_jtag_TDI_o_ds      (),

	.io_pads_jtag_TDO_i_ival    (1'b1    ),
	.io_pads_jtag_TDO_o_oval    (io_pads_jtag_TDO_o_oval    ),
	.io_pads_jtag_TDO_o_oe      (io_pads_jtag_TDO_o_oe      ),
	.io_pads_jtag_TDO_o_ie      (),
	.io_pads_jtag_TDO_o_pue     (),
	.io_pads_jtag_TDO_o_ds      (),

	.io_pads_jtag_TRST_n_i_ival (1'b1 ),
	.io_pads_jtag_TRST_n_o_oval (),
	.io_pads_jtag_TRST_n_o_oe   (),
	.io_pads_jtag_TRST_n_o_ie   (),
	.io_pads_jtag_TRST_n_o_pue  (),
	.io_pads_jtag_TRST_n_o_ds   (),

	.test_mode(1'b0),
	.test_iso_override(1'b0),

	.io_pads_gpio_0_i_ival           (io_pads_gpio_0_i_ival & io_pads_gpio_0_o_ie),
	.io_pads_gpio_0_o_oval           (io_pads_gpio_0_o_oval),
	.io_pads_gpio_0_o_oe             (io_pads_gpio_0_o_oe),
	.io_pads_gpio_0_o_ie             (io_pads_gpio_0_o_ie),
	.io_pads_gpio_0_o_pue            (io_pads_gpio_0_o_pue),
	.io_pads_gpio_0_o_ds             (io_pads_gpio_0_o_ds),

	.io_pads_gpio_1_i_ival           (io_pads_gpio_1_i_ival & io_pads_gpio_1_o_ie),
	.io_pads_gpio_1_o_oval           (io_pads_gpio_1_o_oval),
	.io_pads_gpio_1_o_oe             (io_pads_gpio_1_o_oe),
	.io_pads_gpio_1_o_ie             (io_pads_gpio_1_o_ie),
	.io_pads_gpio_1_o_pue            (io_pads_gpio_1_o_pue),
	.io_pads_gpio_1_o_ds             (io_pads_gpio_1_o_ds),

	.io_pads_gpio_2_i_ival           (io_pads_gpio_2_i_ival & io_pads_gpio_2_o_ie),
	.io_pads_gpio_2_o_oval           (io_pads_gpio_2_o_oval),
	.io_pads_gpio_2_o_oe             (io_pads_gpio_2_o_oe),
	.io_pads_gpio_2_o_ie             (io_pads_gpio_2_o_ie),
	.io_pads_gpio_2_o_pue            (io_pads_gpio_2_o_pue),
	.io_pads_gpio_2_o_ds             (io_pads_gpio_2_o_ds),

	.io_pads_gpio_3_i_ival           (io_pads_gpio_3_i_ival & io_pads_gpio_3_o_ie),
	.io_pads_gpio_3_o_oval           (io_pads_gpio_3_o_oval),
	.io_pads_gpio_3_o_oe             (io_pads_gpio_3_o_oe),
	.io_pads_gpio_3_o_ie             (io_pads_gpio_3_o_ie),
	.io_pads_gpio_3_o_pue            (io_pads_gpio_3_o_pue),
	.io_pads_gpio_3_o_ds             (io_pads_gpio_3_o_ds),

	.io_pads_gpio_4_i_ival           (io_pads_gpio_4_i_ival & io_pads_gpio_4_o_ie),
	.io_pads_gpio_4_o_oval           (io_pads_gpio_4_o_oval),
	.io_pads_gpio_4_o_oe             (io_pads_gpio_4_o_oe),
	.io_pads_gpio_4_o_ie             (io_pads_gpio_4_o_ie),
	.io_pads_gpio_4_o_pue            (io_pads_gpio_4_o_pue),
	.io_pads_gpio_4_o_ds             (io_pads_gpio_4_o_ds),

	.io_pads_gpio_5_i_ival           (io_pads_gpio_5_i_ival & io_pads_gpio_5_o_ie),
	.io_pads_gpio_5_o_oval           (io_pads_gpio_5_o_oval),
	.io_pads_gpio_5_o_oe             (io_pads_gpio_5_o_oe),
	.io_pads_gpio_5_o_ie             (io_pads_gpio_5_o_ie),
	.io_pads_gpio_5_o_pue            (io_pads_gpio_5_o_pue),
	.io_pads_gpio_5_o_ds             (io_pads_gpio_5_o_ds),

	.io_pads_gpio_6_i_ival           (io_pads_gpio_6_i_ival & io_pads_gpio_6_o_ie),
	.io_pads_gpio_6_o_oval           (io_pads_gpio_6_o_oval),
	.io_pads_gpio_6_o_oe             (io_pads_gpio_6_o_oe),
	.io_pads_gpio_6_o_ie             (io_pads_gpio_6_o_ie),
	.io_pads_gpio_6_o_pue            (io_pads_gpio_6_o_pue),
	.io_pads_gpio_6_o_ds             (io_pads_gpio_6_o_ds),

	.io_pads_gpio_7_i_ival           (io_pads_gpio_7_i_ival & io_pads_gpio_7_o_ie),
	.io_pads_gpio_7_o_oval           (io_pads_gpio_7_o_oval),
	.io_pads_gpio_7_o_oe             (io_pads_gpio_7_o_oe),
	.io_pads_gpio_7_o_ie             (io_pads_gpio_7_o_ie),
	.io_pads_gpio_7_o_pue            (io_pads_gpio_7_o_pue),
	.io_pads_gpio_7_o_ds             (io_pads_gpio_7_o_ds),

	.io_pads_gpio_8_i_ival           (io_pads_gpio_8_i_ival & io_pads_gpio_8_o_ie),
	.io_pads_gpio_8_o_oval           (io_pads_gpio_8_o_oval),
	.io_pads_gpio_8_o_oe             (io_pads_gpio_8_o_oe),
	.io_pads_gpio_8_o_ie             (io_pads_gpio_8_o_ie),
	.io_pads_gpio_8_o_pue            (io_pads_gpio_8_o_pue),
	.io_pads_gpio_8_o_ds             (io_pads_gpio_8_o_ds),

	.io_pads_gpio_9_i_ival           (io_pads_gpio_9_i_ival & io_pads_gpio_9_o_ie),
	.io_pads_gpio_9_o_oval           (io_pads_gpio_9_o_oval),
	.io_pads_gpio_9_o_oe             (io_pads_gpio_9_o_oe),
	.io_pads_gpio_9_o_ie             (io_pads_gpio_9_o_ie),
	.io_pads_gpio_9_o_pue            (io_pads_gpio_9_o_pue),
	.io_pads_gpio_9_o_ds             (io_pads_gpio_9_o_ds),

	.io_pads_gpio_10_i_ival          (io_pads_gpio_10_i_ival & io_pads_gpio_10_o_ie),
	.io_pads_gpio_10_o_oval          (io_pads_gpio_10_o_oval),
	.io_pads_gpio_10_o_oe            (io_pads_gpio_10_o_oe),
	.io_pads_gpio_10_o_ie            (io_pads_gpio_10_o_ie),
	.io_pads_gpio_10_o_pue           (io_pads_gpio_10_o_pue),
	.io_pads_gpio_10_o_ds            (io_pads_gpio_10_o_ds),

	.io_pads_gpio_11_i_ival          (io_pads_gpio_11_i_ival & io_pads_gpio_11_o_ie),
	.io_pads_gpio_11_o_oval          (io_pads_gpio_11_o_oval),
	.io_pads_gpio_11_o_oe            (io_pads_gpio_11_o_oe),
	.io_pads_gpio_11_o_ie            (io_pads_gpio_11_o_ie),
	.io_pads_gpio_11_o_pue           (io_pads_gpio_11_o_pue),
	.io_pads_gpio_11_o_ds            (io_pads_gpio_11_o_ds),

	.io_pads_gpio_12_i_ival          (io_pads_gpio_12_i_ival & io_pads_gpio_12_o_ie),
	.io_pads_gpio_12_o_oval          (io_pads_gpio_12_o_oval),
	.io_pads_gpio_12_o_oe            (io_pads_gpio_12_o_oe),
	.io_pads_gpio_12_o_ie            (io_pads_gpio_12_o_ie),
	.io_pads_gpio_12_o_pue           (io_pads_gpio_12_o_pue),
	.io_pads_gpio_12_o_ds            (io_pads_gpio_12_o_ds),

	.io_pads_gpio_13_i_ival          (io_pads_gpio_13_i_ival & io_pads_gpio_13_o_ie),
	.io_pads_gpio_13_o_oval          (io_pads_gpio_13_o_oval),
	.io_pads_gpio_13_o_oe            (io_pads_gpio_13_o_oe),
	.io_pads_gpio_13_o_ie            (io_pads_gpio_13_o_ie),
	.io_pads_gpio_13_o_pue           (io_pads_gpio_13_o_pue),
	.io_pads_gpio_13_o_ds            (io_pads_gpio_13_o_ds),

	.io_pads_gpio_14_i_ival          (io_pads_gpio_14_i_ival & io_pads_gpio_14_o_ie),
	.io_pads_gpio_14_o_oval          (io_pads_gpio_14_o_oval),
	.io_pads_gpio_14_o_oe            (io_pads_gpio_14_o_oe),
	.io_pads_gpio_14_o_ie            (io_pads_gpio_14_o_ie),
	.io_pads_gpio_14_o_pue           (io_pads_gpio_14_o_pue),
	.io_pads_gpio_14_o_ds            (io_pads_gpio_14_o_ds),

	.io_pads_gpio_15_i_ival          (io_pads_gpio_15_i_ival & io_pads_gpio_15_o_ie),
	.io_pads_gpio_15_o_oval          (io_pads_gpio_15_o_oval),
	.io_pads_gpio_15_o_oe            (io_pads_gpio_15_o_oe),
	.io_pads_gpio_15_o_ie            (io_pads_gpio_15_o_ie),
	.io_pads_gpio_15_o_pue           (io_pads_gpio_15_o_pue),
	.io_pads_gpio_15_o_ds            (io_pads_gpio_15_o_ds),

	.io_pads_gpio_16_i_ival          (io_pads_gpio_16_i_ival & io_pads_gpio_16_o_ie),
	.io_pads_gpio_16_o_oval          (io_pads_gpio_16_o_oval),
	.io_pads_gpio_16_o_oe            (io_pads_gpio_16_o_oe),
	.io_pads_gpio_16_o_ie            (io_pads_gpio_16_o_ie),
	.io_pads_gpio_16_o_pue           (io_pads_gpio_16_o_pue),
	.io_pads_gpio_16_o_ds            (io_pads_gpio_16_o_ds),

	.io_pads_gpio_17_i_ival          (io_pads_gpio_17_i_ival & io_pads_gpio_17_o_ie),
	.io_pads_gpio_17_o_oval          (io_pads_gpio_17_o_oval),
	.io_pads_gpio_17_o_oe            (io_pads_gpio_17_o_oe),
	.io_pads_gpio_17_o_ie            (io_pads_gpio_17_o_ie),
	.io_pads_gpio_17_o_pue           (io_pads_gpio_17_o_pue),
	.io_pads_gpio_17_o_ds            (io_pads_gpio_17_o_ds),

	.io_pads_gpio_18_i_ival          (io_pads_gpio_18_i_ival & io_pads_gpio_18_o_ie),
	.io_pads_gpio_18_o_oval          (io_pads_gpio_18_o_oval),
	.io_pads_gpio_18_o_oe            (io_pads_gpio_18_o_oe),
	.io_pads_gpio_18_o_ie            (io_pads_gpio_18_o_ie),
	.io_pads_gpio_18_o_pue           (io_pads_gpio_18_o_pue),
	.io_pads_gpio_18_o_ds            (io_pads_gpio_18_o_ds),

	.io_pads_gpio_19_i_ival          (io_pads_gpio_19_i_ival & io_pads_gpio_19_o_ie),
	.io_pads_gpio_19_o_oval          (io_pads_gpio_19_o_oval),
	.io_pads_gpio_19_o_oe            (io_pads_gpio_19_o_oe),
	.io_pads_gpio_19_o_ie            (io_pads_gpio_19_o_ie),
	.io_pads_gpio_19_o_pue           (io_pads_gpio_19_o_pue),
	.io_pads_gpio_19_o_ds            (io_pads_gpio_19_o_ds),

	.io_pads_gpio_20_i_ival          (io_pads_gpio_20_i_ival & io_pads_gpio_20_o_ie),
	.io_pads_gpio_20_o_oval          (io_pads_gpio_20_o_oval),
	.io_pads_gpio_20_o_oe            (io_pads_gpio_20_o_oe),
	.io_pads_gpio_20_o_ie            (io_pads_gpio_20_o_ie),
	.io_pads_gpio_20_o_pue           (io_pads_gpio_20_o_pue),
	.io_pads_gpio_20_o_ds            (io_pads_gpio_20_o_ds),

	.io_pads_gpio_21_i_ival          (io_pads_gpio_21_i_ival & io_pads_gpio_21_o_ie),
	.io_pads_gpio_21_o_oval          (io_pads_gpio_21_o_oval),
	.io_pads_gpio_21_o_oe            (io_pads_gpio_21_o_oe),
	.io_pads_gpio_21_o_ie            (io_pads_gpio_21_o_ie),
	.io_pads_gpio_21_o_pue           (io_pads_gpio_21_o_pue),
	.io_pads_gpio_21_o_ds            (io_pads_gpio_21_o_ds),

	.io_pads_gpio_22_i_ival          (io_pads_gpio_22_i_ival & io_pads_gpio_22_o_ie),
	.io_pads_gpio_22_o_oval          (io_pads_gpio_22_o_oval),
	.io_pads_gpio_22_o_oe            (io_pads_gpio_22_o_oe),
	.io_pads_gpio_22_o_ie            (io_pads_gpio_22_o_ie),
	.io_pads_gpio_22_o_pue           (io_pads_gpio_22_o_pue),
	.io_pads_gpio_22_o_ds            (io_pads_gpio_22_o_ds),

	.io_pads_gpio_23_i_ival          (io_pads_gpio_23_i_ival & io_pads_gpio_23_o_ie),
	.io_pads_gpio_23_o_oval          (io_pads_gpio_23_o_oval),
	.io_pads_gpio_23_o_oe            (io_pads_gpio_23_o_oe),
	.io_pads_gpio_23_o_ie            (io_pads_gpio_23_o_ie),
	.io_pads_gpio_23_o_pue           (io_pads_gpio_23_o_pue),
	.io_pads_gpio_23_o_ds            (io_pads_gpio_23_o_ds),

	.io_pads_gpio_24_i_ival          (io_pads_gpio_24_i_ival & io_pads_gpio_24_o_ie),
	.io_pads_gpio_24_o_oval          (io_pads_gpio_24_o_oval),
	.io_pads_gpio_24_o_oe            (io_pads_gpio_24_o_oe),
	.io_pads_gpio_24_o_ie            (io_pads_gpio_24_o_ie),
	.io_pads_gpio_24_o_pue           (io_pads_gpio_24_o_pue),
	.io_pads_gpio_24_o_ds            (io_pads_gpio_24_o_ds),

	.io_pads_gpio_25_i_ival          (io_pads_gpio_25_i_ival & io_pads_gpio_25_o_ie),
	.io_pads_gpio_25_o_oval          (io_pads_gpio_25_o_oval),
	.io_pads_gpio_25_o_oe            (io_pads_gpio_25_o_oe),
	.io_pads_gpio_25_o_ie            (io_pads_gpio_25_o_ie),
	.io_pads_gpio_25_o_pue           (io_pads_gpio_25_o_pue),
	.io_pads_gpio_25_o_ds            (io_pads_gpio_25_o_ds),

	.io_pads_gpio_26_i_ival          (io_pads_gpio_26_i_ival & io_pads_gpio_26_o_ie),
	.io_pads_gpio_26_o_oval          (io_pads_gpio_26_o_oval),
	.io_pads_gpio_26_o_oe            (io_pads_gpio_26_o_oe),
	.io_pads_gpio_26_o_ie            (io_pads_gpio_26_o_ie),
	.io_pads_gpio_26_o_pue           (io_pads_gpio_26_o_pue),
	.io_pads_gpio_26_o_ds            (io_pads_gpio_26_o_ds),

	.io_pads_gpio_27_i_ival          (io_pads_gpio_27_i_ival & io_pads_gpio_27_o_ie),
	.io_pads_gpio_27_o_oval          (io_pads_gpio_27_o_oval),
	.io_pads_gpio_27_o_oe            (io_pads_gpio_27_o_oe),
	.io_pads_gpio_27_o_ie            (io_pads_gpio_27_o_ie),
	.io_pads_gpio_27_o_pue           (io_pads_gpio_27_o_pue),
	.io_pads_gpio_27_o_ds            (io_pads_gpio_27_o_ds),

	.io_pads_gpio_28_i_ival          (io_pads_gpio_28_i_ival & io_pads_gpio_28_o_ie),
	.io_pads_gpio_28_o_oval          (io_pads_gpio_28_o_oval),
	.io_pads_gpio_28_o_oe            (io_pads_gpio_28_o_oe),
	.io_pads_gpio_28_o_ie            (io_pads_gpio_28_o_ie),
	.io_pads_gpio_28_o_pue           (io_pads_gpio_28_o_pue),
	.io_pads_gpio_28_o_ds            (io_pads_gpio_28_o_ds),

	.io_pads_gpio_29_i_ival          (io_pads_gpio_29_i_ival & io_pads_gpio_29_o_ie),
	.io_pads_gpio_29_o_oval          (io_pads_gpio_29_o_oval),
	.io_pads_gpio_29_o_oe            (io_pads_gpio_29_o_oe),
	.io_pads_gpio_29_o_ie            (io_pads_gpio_29_o_ie),
	.io_pads_gpio_29_o_pue           (io_pads_gpio_29_o_pue),
	.io_pads_gpio_29_o_ds            (io_pads_gpio_29_o_ds),

	.io_pads_gpio_30_i_ival          (io_pads_gpio_30_i_ival & io_pads_gpio_30_o_ie),
	.io_pads_gpio_30_o_oval          (io_pads_gpio_30_o_oval),
	.io_pads_gpio_30_o_oe            (io_pads_gpio_30_o_oe),
	.io_pads_gpio_30_o_ie            (io_pads_gpio_30_o_ie),
	.io_pads_gpio_30_o_pue           (io_pads_gpio_30_o_pue),
	.io_pads_gpio_30_o_ds            (io_pads_gpio_30_o_ds),

	.io_pads_gpio_31_i_ival          (io_pads_gpio_31_i_ival & io_pads_gpio_31_o_ie),
	.io_pads_gpio_31_o_oval          (io_pads_gpio_31_o_oval),
	.io_pads_gpio_31_o_oe            (io_pads_gpio_31_o_oe),
	.io_pads_gpio_31_o_ie            (io_pads_gpio_31_o_ie),
	.io_pads_gpio_31_o_pue           (io_pads_gpio_31_o_pue),
	.io_pads_gpio_31_o_ds            (io_pads_gpio_31_o_ds),


		.hfextclk        (hfextclk),
		.hfxoscen        (hfxoscen),
		.lfextclk        (lfextclk),
		.lfxoscen        (lfxoscen),

	.io_pads_aon_erst_n_i_ival        (io_pads_aon_erst_n_i_ival       ), 
	.io_pads_aon_erst_n_o_oval        (),
	.io_pads_aon_erst_n_o_oe          (),
	.io_pads_aon_erst_n_o_ie          (),
	.io_pads_aon_erst_n_o_pue         (),
	.io_pads_aon_erst_n_o_ds          (),
	.io_pads_aon_pmu_dwakeup_n_i_ival (io_pads_aon_pmu_dwakeup_n_i_ival),
	.io_pads_aon_pmu_dwakeup_n_o_oval (),
	.io_pads_aon_pmu_dwakeup_n_o_oe   (),
	.io_pads_aon_pmu_dwakeup_n_o_ie   (),
	.io_pads_aon_pmu_dwakeup_n_o_pue  (),
	.io_pads_aon_pmu_dwakeup_n_o_ds   (),
	.io_pads_aon_pmu_vddpaden_i_ival  (1'b1 ),
	.io_pads_aon_pmu_vddpaden_o_oval  (io_pads_aon_pmu_vddpaden_o_oval ),
	.io_pads_aon_pmu_vddpaden_o_oe    (),
	.io_pads_aon_pmu_vddpaden_o_ie    (),
	.io_pads_aon_pmu_vddpaden_o_pue   (),
	.io_pads_aon_pmu_vddpaden_o_ds    (),

	
		.io_pads_aon_pmu_padrst_i_ival    (1'b1 ),
		.io_pads_aon_pmu_padrst_o_oval    (io_pads_aon_pmu_padrst_o_oval ),
		.io_pads_aon_pmu_padrst_o_oe      (),
		.io_pads_aon_pmu_padrst_o_ie      (),
		.io_pads_aon_pmu_padrst_o_pue     (),
		.io_pads_aon_pmu_padrst_o_ds      (),

		.io_pads_bootrom_n_i_ival       (io_pads_bootrom_n_i_ival),
		.io_pads_bootrom_n_o_oval       (),
		.io_pads_bootrom_n_o_oe         (),
		.io_pads_bootrom_n_o_ie         (),
		.io_pads_bootrom_n_o_pue        (),
		.io_pads_bootrom_n_o_ds         (),

		.io_pads_dbgmode0_n_i_ival       (io_pads_dbgmode0_n_i_ival),

		.io_pads_dbgmode1_n_i_ival       (io_pads_dbgmode1_n_i_ival),

		.io_pads_dbgmode2_n_i_ival       (io_pads_dbgmode2_n_i_ival) 


	);

endmodule
