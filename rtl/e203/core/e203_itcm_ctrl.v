//////////////////////////////////////////////////////////////////////////////////
// Company:   
// Engineer: Ruige_Lee
// Create Date: 2019-02-17 17:25:12
// Last Modified by:   Ruige_Lee
// Last Modified time: 2019-04-09 11:47:15
// Email: 295054118@whut.edu.cn
// Design Name:   
// Module Name: e203_itcm_ctrl
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
																																				 
																																				 
																																				 
//=====================================================================
//
// Designer   : Bob Hu
//
// Description:
//  The itcm_ctrl module control the ITCM access requests 
//
// ====================================================================
`include "e203_defines.v"

	`ifdef E203_HAS_ITCM //{

module e203_itcm_ctrl(
	// The cgstop is coming from CSR (0xBFE mcgstop)'s filed 1
	// // This register is our self-defined CSR register to disable the 
	// ITCM SRAM clock gating for debugging purpose
	input tcm_cgstop,
	input core_cgstop,
	// Note: the ITCM ICB interface only support the single-transaction
	

	input  ifu2itcm_icb_cmd_valid,
	output ifu2itcm_icb_cmd_ready,
	input  [`E203_ITCM_ADDR_WIDTH-1:0] ifu2itcm_icb_cmd_addr,
	input  ifu2itcm_icb_cmd_read,
// input  [`E203_ITCM_DATA_WIDTH-1:0] ifu2itcm_icb_cmd_wdata, 
// input  [`E203_ITCM_WMSK_WIDTH-1:0] ifu2itcm_icb_cmd_wmask, 
	output ifu2itcm_icb_rsp_valid,
	input  ifu2itcm_icb_rsp_ready,
	output ifu2itcm_icb_rsp_err,
	output [`E203_ITCM_DATA_WIDTH-1:0] ifu2itcm_icb_rsp_rdata, 	
	output ifu2itcm_holdup,


	input  clk,
	input  rst_n
	);

	wire clk_itcm;




	wire itcm_ram_cs;  
	wire itcm_ram_we;  
	wire [`E203_ITCM_RAM_AW-1:0] itcm_ram_addr; 
	wire [`E203_ITCM_RAM_MW-1:0] itcm_ram_wem;
	wire [`E203_ITCM_RAM_DW-1:0] itcm_ram_din;          
	wire [`E203_ITCM_RAM_DW-1:0] itcm_ram_dout;
	wire clk_itcm_ram;




		 //The EXT and load/store have higher priotry than the ifetch


	// wire sram_icb_cmd_ready;


	// assign ifu2itcm_icb_cmd_ready = sram_icb_cmd_ready;


// wire [`E203_ITCM_ADDR_WIDTH-1:0] sram_icb_cmd_addr;
// wire sram_icb_cmd_read;
	// wire [`E203_ITCM_DATA_WIDTH-1:0] sram_icb_cmd_wdata;
	// wire [`E203_ITCM_WMSK_WIDTH-1:0] sram_icb_cmd_wmask;

// wire sram_icb_cmd_valid =  ifu2itcm_icb_cmd_valid;

	// assign sram_icb_cmd_addr  =  ifu2itcm_icb_cmd_addr;
	// assign sram_icb_cmd_read  =  ifu2itcm_icb_cmd_read;
	// assign sram_icb_cmd_wdata =  ifu2itcm_icb_cmd_wdata;
	// assign sram_icb_cmd_wmask =  ifu2itcm_icb_cmd_wmask;

												
	// wire sram_icb_cmd_ifu = ifu2itcm_icb_cmd_valid;


	wire  [1:0] sram_icb_rsp_usr;
	wire  [1:0] sram_icb_cmd_usr =  {ifu2itcm_icb_cmd_valid,ifu2itcm_icb_cmd_read};
	wire sram_icb_rsp_ifu ;
	wire sram_icb_rsp_read; 
	assign {sram_icb_rsp_ifu, sram_icb_rsp_read} = sram_icb_rsp_usr;
	
	wire itcm_sram_ctrl_active;

	wire sram_icb_rsp_valid;
	// wire sram_icb_rsp_ready;
	// wire [`E203_ITCM_DATA_WIDTH-1:0] sram_icb_rsp_rdata;
	// wire sram_icb_rsp_err;

	sirv_sram_icb_ctrl #(
			.DW     (`E203_ITCM_DATA_WIDTH),
			.AW     (`E203_ITCM_ADDR_WIDTH),
			.MW     (`E203_ITCM_WMSK_WIDTH),
			.AW_LSB (3),// ITCM is 64bits wide, so the LSB is 3
			.USR_W  (2) 
	) u_sram_icb_ctrl(
			.sram_ctrl_active (itcm_sram_ctrl_active),
			.tcm_cgstop       (tcm_cgstop),
		 
			.i_icb_cmd_valid (ifu2itcm_icb_cmd_valid),
			.i_icb_cmd_ready (ifu2itcm_icb_cmd_ready),
			.i_icb_cmd_read  (ifu2itcm_icb_cmd_read),
			.i_icb_cmd_addr  (ifu2itcm_icb_cmd_addr), 
			// .i_icb_cmd_wdata ({`E203_ITCM_DATA_WIDTH{1'b0}}), 
			// .i_icb_cmd_wmask ({`E203_ITCM_DATA_WIDTH/8{1'b0}}), 
			.i_icb_cmd_usr   (sram_icb_cmd_usr  ),
	
			.i_icb_rsp_valid (sram_icb_rsp_valid),
			.i_icb_rsp_ready (ifu2itcm_icb_rsp_ready),
			.i_icb_rsp_rdata (ifu2itcm_icb_rsp_rdata),
			.i_icb_rsp_usr   (sram_icb_rsp_usr  ),
	
			.ram_cs   (itcm_ram_cs  ),  
			.ram_we   (itcm_ram_we  ),  
			.ram_addr (itcm_ram_addr), 
			.ram_wem  (itcm_ram_wem ),
			.ram_din  (itcm_ram_din ),          
			.ram_dout (itcm_ram_dout),
			.clk_ram  (clk_itcm_ram ),
	
			.test_mode(1'b0),
			.clk  (clk_itcm),
			.rst_n(rst_n)  
		);

		// assign sram_icb_rsp_err = 1'b0;


	



	// The E2 pass to IFU RSP channel only when it is IFU access 
	// The E2 pass to ARBT RSP channel only when it is not IFU access
	// assign sram_icb_rsp_ready = ifu2itcm_icb_rsp_ready ;

	assign ifu2itcm_icb_rsp_valid = sram_icb_rsp_valid & sram_icb_rsp_ifu;
	assign ifu2itcm_icb_rsp_err   = 1'b0;
	// assign ifu2itcm_icb_rsp_rdata = sram_icb_rsp_rdata;

	// The holdup indicating the target is not accessed by other agents 
	// since last accessed by IFU, and the output of it is holding up
	// last value. Hence,
	//   * The holdup flag it set when there is a succuess (no-error) ifetch
	//       accessed this target
	//   * The holdup flag it clear when when 
	//         ** other agent (non-IFU) accessed this target
	//         ** other agent (non-IFU) accessed this target
	//for example:
	//   *** The external agent accessed the ITCM
	//   *** I$ updated by cache maintaineice operation
	wire ifu_holdup_r;
	// The IFU holdup will be set after last time accessed by a IFU access
	wire ifu_holdup_set =   ifu2itcm_icb_cmd_valid & itcm_ram_cs;
	// The IFU holdup will be cleared after last time accessed by a non-IFU access
	wire ifu_holdup_clr = (~ifu2itcm_icb_cmd_valid) & itcm_ram_cs;
	wire ifu_holdup_ena = ifu_holdup_set | ifu_holdup_clr;
	wire ifu_holdup_nxt = ifu_holdup_set & (~ifu_holdup_clr);
	sirv_gnrl_dfflr #(1)ifu_holdup_dffl(ifu_holdup_ena, ifu_holdup_nxt, ifu_holdup_r, clk_itcm, rst_n);
	assign ifu2itcm_holdup = ifu_holdup_r ;
	  

	wire itcm_active = ifu2itcm_icb_cmd_valid | itcm_sram_ctrl_active;

	e203_itcm_ram u_e203_itcm_ram (
		.cs   (itcm_ram_cs),
		.we   (itcm_ram_we),
		.addr (itcm_ram_addr),
		.wem  (itcm_ram_wem),
		.din  (itcm_ram_din),
		.dout (itcm_ram_dout),
		.rst_n(rst_n),
		.clk  (clk_itcm_ram )
	);






// The ITCM and DTCM Ctrl module's clock gating does not need to check
//  WFI because it may have request from external agent
//  and also, it actually will automactically become inactive regardess
//  currently is WFI or not, hence we dont need WFI here
	wire itcm_active_r;
	sirv_gnrl_dffr #(1)itcm_active_dffr(itcm_active, itcm_active_r, clk_itcm, rst_n);
	wire itcm_clk_en = core_cgstop | itcm_active | itcm_active_r;


	e203_clkgate u_itcm_clkgate(
		.clk_in   (clk),
		.test_mode(1'b0),
		.clock_en (itcm_clk_en),
		.clk_out  (clk_itcm)
	);







endmodule

	`endif//}


	

