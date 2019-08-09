//////////////////////////////////////////////////////////////////////////////////
// Company:   
// Engineer: Ruige_Lee
// Create Date: 2019-02-17 17:25:12
// Last Modified by:   Ruige_Lee
// Last Modified time: 2019-04-23 16:04:28
// Email: 295054118@whut.edu.cn
// Design Name:   
// Module Name: e203_lsu
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
// Designer   : Bob Hu
//
// Description:
//  The lsu_ctrl module control the LSU access requests 
//
// ====================================================================
`include "e203_defines.v"

module e203_lsu(
		input commit_mret,
		input commit_trap,
		input excp_active,
		output lsu_active,

		//////////////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////////
		// The LSU Write-Back Interface
		output lsu_o_valid, // Handshake valid
		input  lsu_o_ready, // Handshake ready
		output [`E203_XLEN-1:0] lsu_o_wbck_wdat,
		output [`E203_ITAG_WIDTH -1:0] lsu_o_wbck_itag,
		output lsu_o_wbck_err , 
		output lsu_o_cmt_ld,
		output lsu_o_cmt_st,
		output [`E203_ADDR_SIZE -1:0] lsu_o_cmt_badaddr,
		output lsu_o_cmt_buserr , // The bus-error exception generated
		

		//////////////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////////
		// The AGU ICB Interface to LSU-ctrl
		//    * Bus cmd channel
		input                          agu_icb_cmd_valid, // Handshake valid
		output                         agu_icb_cmd_ready, // Handshake ready
		input  [`E203_ADDR_SIZE-1:0]   agu_icb_cmd_addr, // Bus transaction start addr 
		input                          agu_icb_cmd_read,   // Read or write
		input  [`E203_XLEN-1:0]        agu_icb_cmd_wdata, 
		input  [`E203_XLEN/8-1:0]      agu_icb_cmd_wmask, 
		input                          agu_icb_cmd_lock,
		input                          agu_icb_cmd_excl,
		input  [1:0]                   agu_icb_cmd_size,
		// Several additional side channel signals
		// Indicate LSU-ctrl module to
		// return the ICB response channel back to AGU
		// this is only used by AMO or unaligned load/store 1st uop
		// to return the response
		input                          agu_icb_cmd_back2agu, 
		//   Sign extension or not
		input                          agu_icb_cmd_usign,
		input  [`E203_ITAG_WIDTH -1:0] agu_icb_cmd_itag,

		// * Bus RSP channel
		output                         agu_icb_rsp_valid, // Response valid 
		input                          agu_icb_rsp_ready, // Response ready
		output                         agu_icb_rsp_err  , // Response error
		output                         agu_icb_rsp_excl_ok, // Response error
		output [`E203_XLEN-1:0]        agu_icb_rsp_rdata,

		//////////////////////////////////////////////////////////////
		//////////////////////////////////////////////////////////////
		// The ICB Interface to BIU

		//    * Bus cmd channel
		output                         biu_icb_cmd_valid,
		input                          biu_icb_cmd_ready,
		output [`E203_ADDR_SIZE-1:0]   biu_icb_cmd_addr, 
		output                         biu_icb_cmd_read, 
		output [`E203_XLEN-1:0]        biu_icb_cmd_wdata,
		output [`E203_XLEN/8-1:0]      biu_icb_cmd_wmask,
		output                         biu_icb_cmd_lock,
		output                         biu_icb_cmd_excl,
		output [1:0]                   biu_icb_cmd_size,

		//    * Bus RSP channel
		input                          biu_icb_rsp_valid,
		output                         biu_icb_rsp_ready,
		input                          biu_icb_rsp_err  ,
		input                          biu_icb_rsp_excl_ok  ,
		input  [`E203_XLEN-1:0]        biu_icb_rsp_rdata,


		input  clk,
		input  rst_n
	);

	wire lsu_ctrl_active;

(* DONT_TOUCH = "TRUE" *)
	e203_lsu_ctrl u_e203_lsu_ctrl(
		.commit_mret           (commit_mret),
		.commit_trap           (commit_trap),
		.lsu_ctrl_active       (lsu_ctrl_active),


		.lsu_o_valid           (lsu_o_valid ),
		.lsu_o_ready           (lsu_o_ready ),
		.lsu_o_wbck_wdat       (lsu_o_wbck_wdat),
		.lsu_o_wbck_itag       (lsu_o_wbck_itag),
		.lsu_o_wbck_err        (lsu_o_wbck_err  ),
		.lsu_o_cmt_buserr      (lsu_o_cmt_buserr  ),
		.lsu_o_cmt_badaddr     (lsu_o_cmt_badaddr ),
		.lsu_o_cmt_ld          (lsu_o_cmt_ld ),
		.lsu_o_cmt_st          (lsu_o_cmt_st ),
		
		.agu_icb_cmd_valid     (agu_icb_cmd_valid ),
		.agu_icb_cmd_ready     (agu_icb_cmd_ready ),
		.agu_icb_cmd_addr      (agu_icb_cmd_addr ),
		.agu_icb_cmd_read      (agu_icb_cmd_read   ),
		.agu_icb_cmd_wdata     (agu_icb_cmd_wdata ),
		.agu_icb_cmd_wmask     (agu_icb_cmd_wmask ),
		.agu_icb_cmd_lock      (agu_icb_cmd_lock),
		.agu_icb_cmd_excl      (agu_icb_cmd_excl),
		.agu_icb_cmd_size      (agu_icb_cmd_size),
	 
		.agu_icb_cmd_back2agu  (agu_icb_cmd_back2agu ),
		.agu_icb_cmd_usign     (agu_icb_cmd_usign),
		.agu_icb_cmd_itag      (agu_icb_cmd_itag),
	
		.agu_icb_rsp_valid     (agu_icb_rsp_valid ),
		.agu_icb_rsp_ready     (agu_icb_rsp_ready ),
		.agu_icb_rsp_err       (agu_icb_rsp_err   ),
		.agu_icb_rsp_excl_ok   (agu_icb_rsp_excl_ok),
		.agu_icb_rsp_rdata     (agu_icb_rsp_rdata),
		
		.biu_icb_cmd_valid     (biu_icb_cmd_valid),
		.biu_icb_cmd_ready     (biu_icb_cmd_ready),
		.biu_icb_cmd_addr      (biu_icb_cmd_addr ),
		.biu_icb_cmd_read      (biu_icb_cmd_read ),
		.biu_icb_cmd_wdata     (biu_icb_cmd_wdata),
		.biu_icb_cmd_wmask     (biu_icb_cmd_wmask),
		.biu_icb_cmd_lock      (biu_icb_cmd_lock),
		.biu_icb_cmd_excl      (biu_icb_cmd_excl),
		.biu_icb_cmd_size      (biu_icb_cmd_size),
	 
		.biu_icb_rsp_valid     (biu_icb_rsp_valid),
		.biu_icb_rsp_ready     (biu_icb_rsp_ready),
		.biu_icb_rsp_err       (biu_icb_rsp_err  ),
		.biu_icb_rsp_excl_ok   (biu_icb_rsp_excl_ok  ),
		.biu_icb_rsp_rdata     (biu_icb_rsp_rdata),
	
		.clk                   (clk),
		.rst_n                 (rst_n)
	);

	assign lsu_active = lsu_ctrl_active 
										// When interrupts comes, need to update the exclusive monitor
										// so also need to turn on the clock
										| excp_active;
endmodule

