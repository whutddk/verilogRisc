//////////////////////////////////////////////////////////////////////////////////
// Company:   
// Engineer: Ruige_Lee
// Create Date: 2019-02-17 17:25:12
// Last Modified by:   Ruige_Lee
// Last Modified time: 2019-04-23 11:54:41
// Email: 295054118@whut.edu.cn
// Design Name:   
// Module Name: e203_lsu_ctrl
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

module e203_lsu_ctrl(
	input  commit_mret,
	input  commit_trap,
	output lsu_ctrl_active,


	input [`E203_ADDR_SIZE-1:0] dtcm_region_indic,


	//////////////////////////////////////////////////////////////
	//////////////////////////////////////////////////////////////
	// The LSU Write-Back Interface
	output lsu_o_valid, // Handshake valid
	input  lsu_o_ready, // Handshake ready
	output [`E203_XLEN-1:0] lsu_o_wbck_wdat,
	output [`E203_ITAG_WIDTH -1:0] lsu_o_wbck_itag,
	output lsu_o_wbck_err , // The error no need to write back regfile
	output lsu_o_cmt_buserr, // The bus-error exception generated
	output [`E203_ADDR_SIZE -1:0] lsu_o_cmt_badaddr,
	output lsu_o_cmt_ld,
	output lsu_o_cmt_st,
	

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
	//   Indicate LSU-ctrl module to
	//     return the ICB response channel back to AGU
	//     this is only used by AMO or unaligned load/store 1st uop
	//     to return the response
	input                          agu_icb_cmd_back2agu, 
					 //   Sign extension or not
	input                          agu_icb_cmd_usign,
					 //   RD Regfile index
	input  [`E203_ITAG_WIDTH -1:0] agu_icb_cmd_itag,

	//    * Bus RSP channel
	output                         agu_icb_rsp_valid, // Response valid 
	input                          agu_icb_rsp_ready, // Response ready
	output                         agu_icb_rsp_err  , // Response error
	output                         agu_icb_rsp_excl_ok,// Response exclusive okay
	output [`E203_XLEN-1:0]        agu_icb_rsp_rdata,




	//////////////////////////////////////////////////////////////
	//////////////////////////////////////////////////////////////
	// The ICB Interface to DTCM
	//
	//    * Bus cmd channel
	output                         dtcm_icb_cmd_valid,
	input                          dtcm_icb_cmd_ready,
	output [`E203_DTCM_ADDR_WIDTH-1:0]   dtcm_icb_cmd_addr, 
	output                         dtcm_icb_cmd_read, 
	output [`E203_XLEN-1:0]        dtcm_icb_cmd_wdata,
	output [`E203_XLEN/8-1:0]      dtcm_icb_cmd_wmask,
	output                         dtcm_icb_cmd_lock,
	output                         dtcm_icb_cmd_excl,
	output [1:0]                   dtcm_icb_cmd_size,
	//
	//    * Bus RSP channel
	input                          dtcm_icb_rsp_valid,
	output                         dtcm_icb_rsp_ready,
	input                          dtcm_icb_rsp_err  ,
	input                          dtcm_icb_rsp_excl_ok,
	input  [`E203_XLEN-1:0]        dtcm_icb_rsp_rdata,

	//////////////////////////////////////////////////////////////
	//////////////////////////////////////////////////////////////
	// The ICB Interface to BIU
	//
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
	//
	//    * Bus RSP channel
	input                          biu_icb_rsp_valid,
	output                         biu_icb_rsp_ready,
	input                          biu_icb_rsp_err  ,
	input                          biu_icb_rsp_excl_ok  ,
	input  [`E203_XLEN-1:0]        biu_icb_rsp_rdata,


	input  clk,
	input  rst_n
	);

	// The EAI mem holdup signal will override other request to LSU-Ctrl
	wire agu_icb_cmd_valid_pos;
	wire agu_icb_cmd_ready_pos;
	assign agu_icb_cmd_valid_pos =  agu_icb_cmd_valid;
	assign agu_icb_cmd_ready     =  agu_icb_cmd_ready_pos;


	localparam LSU_ARBT_I_NUM   = 1;
	localparam LSU_ARBT_I_PTR_W = 1;


	
	// NOTE:
	//   * PPI is a must to have
	//   * Either DCache, ITCM, DTCM or SystemITF is must to have
	`ifndef E203_HAS_DTCM //{
			!!! ERROR: There must be something wrong, Either DCache, DTCM, ITCM or SystemITF is must to have. 
								 Otherwise where to access the data?
	`endif//}
	//
	//
	wire                  pre_agu_icb_rsp_valid;
	wire                  pre_agu_icb_rsp_ready;
	wire                  pre_agu_icb_rsp_err  ;
	wire                  pre_agu_icb_rsp_excl_ok;
	wire [`E203_XLEN-1:0] pre_agu_icb_rsp_rdata;

	wire                         pre_agu_icb_rsp_back2agu; 
	wire                         pre_agu_icb_rsp_usign;
	wire                         pre_agu_icb_rsp_read;
	wire                         pre_agu_icb_rsp_excl;
	wire [2-1:0]                 pre_agu_icb_rsp_size;
	wire [`E203_ITAG_WIDTH -1:0] pre_agu_icb_rsp_itag;
	wire [`E203_ADDR_SIZE-1:0]   pre_agu_icb_rsp_addr;

	localparam USR_W = (`E203_ITAG_WIDTH+6+`E203_ADDR_SIZE);
	localparam USR_PACK_EXCL = 0;// The cmd_excl is in the user 0 bit
	wire [USR_W-1:0] agu_icb_cmd_usr =
			{
				 agu_icb_cmd_back2agu  
				,agu_icb_cmd_usign
				,agu_icb_cmd_read
				,agu_icb_cmd_size
				,agu_icb_cmd_itag 
				,agu_icb_cmd_addr 
				,agu_icb_cmd_excl 
			};
	// wire [USR_W-1:0] eai_icb_cmd_usr = {USR_W-1{1'b0}};
	wire [USR_W-1:0] fpu_icb_cmd_usr = {USR_W-1{1'b0}};

	wire [USR_W-1:0]      pre_agu_icb_rsp_usr;
	assign {
				 pre_agu_icb_rsp_back2agu  
				,pre_agu_icb_rsp_usign
				,pre_agu_icb_rsp_read
				,pre_agu_icb_rsp_size
				,pre_agu_icb_rsp_itag 
				,pre_agu_icb_rsp_addr
				,pre_agu_icb_rsp_excl 
			} = pre_agu_icb_rsp_usr;


	wire arbt_icb_cmd_valid;
	wire arbt_icb_cmd_ready;
	wire [`E203_ADDR_SIZE-1:0] arbt_icb_cmd_addr;
	wire arbt_icb_cmd_read;
	wire [`E203_XLEN-1:0] arbt_icb_cmd_wdata;
	wire [`E203_XLEN/8-1:0] arbt_icb_cmd_wmask;
	wire arbt_icb_cmd_lock;
	wire arbt_icb_cmd_excl;
	wire [1:0] arbt_icb_cmd_size;
	wire [1:0] arbt_icb_cmd_burst;
	wire [1:0] arbt_icb_cmd_beat;
	wire [USR_W-1:0] arbt_icb_cmd_usr;

	wire arbt_icb_rsp_valid;
	wire arbt_icb_rsp_ready;
	wire arbt_icb_rsp_err;
	wire arbt_icb_rsp_excl_ok;
	wire [`E203_XLEN-1:0] arbt_icb_rsp_rdata;
	wire [USR_W-1:0] arbt_icb_rsp_usr;

	wire [1-1:0] arbt_bus_icb_cmd_valid;
	wire [1-1:0] arbt_bus_icb_cmd_ready;
	wire [`E203_ADDR_SIZE-1:0] arbt_bus_icb_cmd_addr;
	wire [1-1:0] arbt_bus_icb_cmd_read;
	wire [`E203_XLEN-1:0] arbt_bus_icb_cmd_wdata;
	wire [`E203_XLEN/8-1:0] arbt_bus_icb_cmd_wmask;
	wire [1-1:0] arbt_bus_icb_cmd_lock;
	wire [1-1:0] arbt_bus_icb_cmd_excl;
	wire [2-1:0] arbt_bus_icb_cmd_size;
	wire [USR_W-1:0] arbt_bus_icb_cmd_usr;
	wire [2-1:0] arbt_bus_icb_cmd_burst;
	wire [2-1:0] arbt_bus_icb_cmd_beat;

	wire [1-1:0] arbt_bus_icb_rsp_valid;
	wire [1-1:0] arbt_bus_icb_rsp_ready;
	wire [1-1:0] arbt_bus_icb_rsp_err;
	wire [1-1:0] arbt_bus_icb_rsp_excl_ok;
	wire [`E203_XLEN-1:0] arbt_bus_icb_rsp_rdata;
	wire [*USR_W-1:0] arbt_bus_icb_rsp_usr;

	//CMD Channel
	wire [1-1:0] arbt_bus_icb_cmd_valid_raw;
	assign arbt_bus_icb_cmd_valid_raw = agu_icb_cmd_valid;

	assign arbt_bus_icb_cmd_valid = agu_icb_cmd_valid_pos;

	assign arbt_bus_icb_cmd_addr = agu_icb_cmd_addr;

	assign arbt_bus_icb_cmd_read = agu_icb_cmd_read;

	assign arbt_bus_icb_cmd_wdata = agu_icb_cmd_wdata;

	assign arbt_bus_icb_cmd_wmask = agu_icb_cmd_wmask;
												 
	assign arbt_bus_icb_cmd_lock = agu_icb_cmd_lock;

	assign arbt_bus_icb_cmd_burst = 2'b0;

	assign arbt_bus_icb_cmd_beat = 1'b0;

	assign arbt_bus_icb_cmd_excl = agu_icb_cmd_excl;
													 
	assign arbt_bus_icb_cmd_size = agu_icb_cmd_size;

	assign arbt_bus_icb_cmd_usr = agu_icb_cmd_usr;

	assign agu_icb_cmd_ready_pos = arbt_bus_icb_cmd_ready;
													 

	//RSP Channel
	assign pre_agu_icb_rsp_valid = arbt_bus_icb_rsp_valid;

	assign pre_agu_icb_rsp_err = arbt_bus_icb_rsp_err;

	assign pre_agu_icb_rsp_excl_ok = arbt_bus_icb_rsp_excl_ok;


	assign pre_agu_icb_rsp_rdata = arbt_bus_icb_rsp_rdata;

	assign pre_agu_icb_rsp_usr = arbt_bus_icb_rsp_usr;

	assign arbt_bus_icb_rsp_ready = pre_agu_icb_rsp_ready;

	sirv_gnrl_icb_arbt # (
	.ARBT_SCHEME (0),// Priority based
	.ALLOW_0CYCL_RSP (0),// Dont allow the 0 cycle response because in BIU we always have CMD_DP larger than 0
											 //   when the response come back from the external bus, it is at least 1 cycle later
											 //   for ITCM and DTCM, Dcache, .etc, definitely they cannot reponse as 0 cycle
	.FIFO_OUTS_NUM   (`E203_LSU_OUTS_NUM),
	.FIFO_CUT_READY  (0),
	.ARBT_NUM   (LSU_ARBT_I_NUM),
	.ARBT_PTR_W (LSU_ARBT_I_PTR_W),
	.USR_W      (USR_W),
	.AW         (`E203_ADDR_SIZE),
	.DW         (`E203_XLEN) 
	) u_lsu_icb_arbt(
	.o_icb_cmd_valid        (arbt_icb_cmd_valid )     ,
	.o_icb_cmd_ready        (arbt_icb_cmd_ready )     ,
	.o_icb_cmd_read         (arbt_icb_cmd_read )      ,
	.o_icb_cmd_addr         (arbt_icb_cmd_addr )      ,
	.o_icb_cmd_wdata        (arbt_icb_cmd_wdata )     ,
	.o_icb_cmd_wmask        (arbt_icb_cmd_wmask)      ,
	.o_icb_cmd_burst        (arbt_icb_cmd_burst)     ,
	.o_icb_cmd_beat         (arbt_icb_cmd_beat )     ,
	.o_icb_cmd_excl         (arbt_icb_cmd_excl )     ,
	.o_icb_cmd_lock         (arbt_icb_cmd_lock )     ,
	.o_icb_cmd_size         (arbt_icb_cmd_size )     ,
	.o_icb_cmd_usr          (arbt_icb_cmd_usr  )     ,
																
	.o_icb_rsp_valid        (arbt_icb_rsp_valid )     ,
	.o_icb_rsp_ready        (arbt_icb_rsp_ready )     ,
	.o_icb_rsp_err          (arbt_icb_rsp_err)        ,
	.o_icb_rsp_excl_ok      (arbt_icb_rsp_excl_ok)    ,
	.o_icb_rsp_rdata        (arbt_icb_rsp_rdata )     ,
	.o_icb_rsp_usr          (arbt_icb_rsp_usr   )     ,
															 
	.i_bus_icb_cmd_ready    (arbt_bus_icb_cmd_ready ) ,
	.i_bus_icb_cmd_valid    (arbt_bus_icb_cmd_valid ) ,
	.i_bus_icb_cmd_read     (arbt_bus_icb_cmd_read )  ,
	.i_bus_icb_cmd_addr     (arbt_bus_icb_cmd_addr )  ,
	.i_bus_icb_cmd_wdata    (arbt_bus_icb_cmd_wdata ) ,
	.i_bus_icb_cmd_wmask    (arbt_bus_icb_cmd_wmask)  ,
	.i_bus_icb_cmd_burst    (arbt_bus_icb_cmd_burst)  ,
	.i_bus_icb_cmd_beat     (arbt_bus_icb_cmd_beat )  ,
	.i_bus_icb_cmd_excl     (arbt_bus_icb_cmd_excl )  ,
	.i_bus_icb_cmd_lock     (arbt_bus_icb_cmd_lock )  ,
	.i_bus_icb_cmd_size     (arbt_bus_icb_cmd_size )  ,
	.i_bus_icb_cmd_usr      (arbt_bus_icb_cmd_usr  )  ,
																
	.i_bus_icb_rsp_valid    (arbt_bus_icb_rsp_valid ) ,
	.i_bus_icb_rsp_ready    (arbt_bus_icb_rsp_ready ) ,
	.i_bus_icb_rsp_err      (arbt_bus_icb_rsp_err)    ,
	.i_bus_icb_rsp_excl_ok  (arbt_bus_icb_rsp_excl_ok),
	.i_bus_icb_rsp_rdata    (arbt_bus_icb_rsp_rdata ) ,
	.i_bus_icb_rsp_usr      (arbt_bus_icb_rsp_usr) ,
														 
	.clk                    (clk  ),
	.rst_n                  (rst_n)
	);



	/////////////////////////////////////////////////////////////////////////////////
	// Implement a FIFO to save the outstanding info
	//
	//  * The FIFO will be pushed when a ICB CMD handshaked
	//  * The FIFO will be poped  when a ICB RSP handshaked
	
	wire arbt_icb_cmd_itcm = 1'b0;
	
	wire arbt_icb_cmd_dtcm = (arbt_icb_cmd_addr[`E203_DTCM_BASE_REGION] ==  dtcm_region_indic[`E203_DTCM_BASE_REGION]);
	
	wire arbt_icb_cmd_dcache = 1'b0;

	wire arbt_icb_cmd_biu    = (~arbt_icb_cmd_itcm) & (~arbt_icb_cmd_dtcm) & (~arbt_icb_cmd_dcache);

	wire splt_fifo_wen = arbt_icb_cmd_valid & arbt_icb_cmd_ready;
	wire splt_fifo_ren = arbt_icb_rsp_valid & arbt_icb_rsp_ready;


	// In E200 single core config, we always assume the store-condition is checked by the core itself
	//    because no other core to race
			 
	wire excl_flg_r;
	wire [`E203_ADDR_SIZE-1:0] excl_addr_r;
	wire icb_cmdaddr_eq_excladdr = (arbt_icb_cmd_addr == excl_addr_r);
	// Set when the Excl-load instruction going
	wire excl_flg_set = splt_fifo_wen & arbt_icb_cmd_usr[USR_PACK_EXCL] & arbt_icb_cmd_read & arbt_icb_cmd_excl;
	// Clear when any going store hit the same address
	//   also clear if there is any trap happened
	wire excl_flg_clr = (splt_fifo_wen & (~arbt_icb_cmd_read) & icb_cmdaddr_eq_excladdr & excl_flg_r) 
										| commit_trap | commit_mret;
	wire excl_flg_ena = excl_flg_set | excl_flg_clr;
	wire excl_flg_nxt = excl_flg_set | (~excl_flg_clr);
	sirv_gnrl_dfflr #(1) excl_flg_dffl (excl_flg_ena, excl_flg_nxt, excl_flg_r, clk, rst_n);
	//
	// The address is set when excl-load instruction going
	wire excl_addr_ena = excl_flg_set;
	wire [`E203_ADDR_SIZE-1:0] excl_addr_nxt = arbt_icb_cmd_addr;
	sirv_gnrl_dfflr #(`E203_ADDR_SIZE) excl_addr_dffl (excl_addr_ena, excl_addr_nxt, excl_addr_r, clk, rst_n);

	// For excl-store (scond) instruction, it will be true if the flag is true and the address is matching
	wire arbt_icb_cmd_scond = arbt_icb_cmd_usr[USR_PACK_EXCL] & (~arbt_icb_cmd_read);
	wire arbt_icb_cmd_scond_true = arbt_icb_cmd_scond & icb_cmdaddr_eq_excladdr & excl_flg_r;

	//

	wire splt_fifo_i_ready;
	wire splt_fifo_i_valid = splt_fifo_wen;
	wire splt_fifo_full    = (~splt_fifo_i_ready);
	wire splt_fifo_o_valid;
	wire splt_fifo_o_ready = splt_fifo_ren;
	wire splt_fifo_empty   = (~splt_fifo_o_valid);

	wire arbt_icb_rsp_biu;
	wire arbt_icb_rsp_dcache;
	wire arbt_icb_rsp_dtcm;
	wire arbt_icb_rsp_itcm;
	wire arbt_icb_rsp_scond_true;


	localparam SPLT_FIFO_W = (USR_W+5);
	wire [`E203_XLEN/8-1:0] arbt_icb_cmd_wmask_pos = 
			(arbt_icb_cmd_scond & (~arbt_icb_cmd_scond_true)) ? {`E203_XLEN/8{1'b0}} : arbt_icb_cmd_wmask;


	wire [SPLT_FIFO_W-1:0] splt_fifo_wdat;
	wire [SPLT_FIFO_W-1:0] splt_fifo_rdat;

	assign splt_fifo_wdat =  {
					arbt_icb_cmd_biu,
					arbt_icb_cmd_dcache,
					arbt_icb_cmd_dtcm,
					arbt_icb_cmd_itcm,

					arbt_icb_cmd_scond_true,

					arbt_icb_cmd_usr 
					};

	assign   
			{
					arbt_icb_rsp_biu,
					arbt_icb_rsp_dcache,
					arbt_icb_rsp_dtcm,
					arbt_icb_rsp_itcm,

					arbt_icb_rsp_scond_true, 

					arbt_icb_rsp_usr 
					} = splt_fifo_rdat & {SPLT_FIFO_W{splt_fifo_o_valid}};
					// The output signals will be used as 
					//   control signals, so need to be masked

	
	sirv_gnrl_pipe_stage # (
		.CUT_READY(0),
		.DP(1),
		.DW(SPLT_FIFO_W)
	) u_e203_lsu_splt_stage (
		.i_vld  (splt_fifo_i_valid),
		.i_rdy  (splt_fifo_i_ready),
		.i_dat  (splt_fifo_wdat ),
		.o_vld  (splt_fifo_o_valid),
		.o_rdy  (splt_fifo_o_ready),  
		.o_dat  (splt_fifo_rdat ),  
	
		.clk  (clk),
		.rst_n(rst_n)
	);
	



	/////////////////////////////////////////////////////////////////////////////////
	// Implement the ICB Splitting


	wire cmd_diff_branch = 1'b0; // If the LSU outstanding is only 1, there is no chance to 
															 //   happen several outsanding ops, not to mention 
															 //   with different branches
	
	wire arbt_icb_cmd_addi_condi = (~splt_fifo_full) & (~cmd_diff_branch);
	wire arbt_icb_cmd_ready_pos;

	wire arbt_icb_cmd_valid_pos = arbt_icb_cmd_addi_condi & arbt_icb_cmd_valid;
	assign arbt_icb_cmd_ready     = arbt_icb_cmd_addi_condi & arbt_icb_cmd_ready_pos;

	wire all_icb_cmd_ready;
	wire all_icb_cmd_ready_excp_biu;
	wire all_icb_cmd_ready_excp_dcach;
	wire all_icb_cmd_ready_excp_dtcm;
	wire all_icb_cmd_ready_excp_itcm;


	assign dtcm_icb_cmd_valid = arbt_icb_cmd_valid_pos & arbt_icb_cmd_dtcm & all_icb_cmd_ready_excp_dtcm;
	assign dtcm_icb_cmd_addr  = arbt_icb_cmd_addr [`E203_DTCM_ADDR_WIDTH-1:0]; 
	assign dtcm_icb_cmd_read  = arbt_icb_cmd_read ; 
	assign dtcm_icb_cmd_wdata = arbt_icb_cmd_wdata;
	assign dtcm_icb_cmd_wmask = arbt_icb_cmd_wmask_pos;
	assign dtcm_icb_cmd_lock  = arbt_icb_cmd_lock ;
	assign dtcm_icb_cmd_excl  = arbt_icb_cmd_excl ;
	assign dtcm_icb_cmd_size  = arbt_icb_cmd_size ;


	assign biu_icb_cmd_valid = arbt_icb_cmd_valid_pos & arbt_icb_cmd_biu & all_icb_cmd_ready_excp_biu;
	assign biu_icb_cmd_addr  = arbt_icb_cmd_addr ; 
	assign biu_icb_cmd_read  = arbt_icb_cmd_read ; 
	assign biu_icb_cmd_wdata = arbt_icb_cmd_wdata;
	assign biu_icb_cmd_wmask = arbt_icb_cmd_wmask_pos;
	assign biu_icb_cmd_lock  = arbt_icb_cmd_lock ;
	assign biu_icb_cmd_excl  = arbt_icb_cmd_excl ;
	assign biu_icb_cmd_size  = arbt_icb_cmd_size ;
	

	// To cut the in2out path from addr to the cmd_ready signal
	//   we just always use the simplified logic
	//   to always ask for all of the downstream components
	//   to be ready, this may impact performance a little
	//   bit in corner case, but doesnt really hurt the common 
	//   case
	//
	assign all_icb_cmd_ready = (biu_icb_cmd_ready ) & (dtcm_icb_cmd_ready);

	assign all_icb_cmd_ready_excp_biu = (dtcm_icb_cmd_ready);

	assign all_icb_cmd_ready_excp_dcach = (biu_icb_cmd_ready ) & (dtcm_icb_cmd_ready);
	assign all_icb_cmd_ready_excp_dtcm = (biu_icb_cmd_ready );

	assign all_icb_cmd_ready_excp_itcm = (biu_icb_cmd_ready ) & (dtcm_icb_cmd_ready);

	assign arbt_icb_cmd_ready_pos = all_icb_cmd_ready;  

	assign {	arbt_icb_rsp_valid 
				, arbt_icb_rsp_err 
				, arbt_icb_rsp_excl_ok 
				, arbt_icb_rsp_rdata 
				 } =
						({`E203_XLEN+3{arbt_icb_rsp_biu}} &
												{ biu_icb_rsp_valid 
												, biu_icb_rsp_err 
												, biu_icb_rsp_excl_ok 
												, biu_icb_rsp_rdata 
												}
						) 
					| ({`E203_XLEN+3{arbt_icb_rsp_dtcm}} &
												{ dtcm_icb_rsp_valid 
												, dtcm_icb_rsp_err 
												, dtcm_icb_rsp_excl_ok 
												, dtcm_icb_rsp_rdata 
												}
						);

	assign biu_icb_rsp_ready    = arbt_icb_rsp_biu    & arbt_icb_rsp_ready;

	assign dtcm_icb_rsp_ready   = arbt_icb_rsp_dtcm   & arbt_icb_rsp_ready;

	/////////////////////////////////////////////////////////////////////////////////
	// Pass the ICB response back to AGU or LSU-Writeback if it need back2agu or not
	assign lsu_o_valid       = pre_agu_icb_rsp_valid & (~pre_agu_icb_rsp_back2agu);
	assign agu_icb_rsp_valid = pre_agu_icb_rsp_valid &   pre_agu_icb_rsp_back2agu;

	assign pre_agu_icb_rsp_ready =
			pre_agu_icb_rsp_back2agu ?  agu_icb_rsp_ready : lsu_o_ready; 

	assign agu_icb_rsp_err   = pre_agu_icb_rsp_err  ;
	assign agu_icb_rsp_excl_ok = pre_agu_icb_rsp_excl_ok  ;
	assign agu_icb_rsp_rdata = pre_agu_icb_rsp_rdata;

	assign lsu_o_wbck_itag   = pre_agu_icb_rsp_itag;

	wire [`E203_XLEN-1:0] rdata_algn = 
			(pre_agu_icb_rsp_rdata >> {pre_agu_icb_rsp_addr[1:0],3'b0});

	wire rsp_lbu = (pre_agu_icb_rsp_size == 2'b00) & (pre_agu_icb_rsp_usign == 1'b1);
	wire rsp_lb  = (pre_agu_icb_rsp_size == 2'b00) & (pre_agu_icb_rsp_usign == 1'b0);
	wire rsp_lhu = (pre_agu_icb_rsp_size == 2'b01) & (pre_agu_icb_rsp_usign == 1'b1);
	wire rsp_lh  = (pre_agu_icb_rsp_size == 2'b01) & (pre_agu_icb_rsp_usign == 1'b0);
	wire rsp_lw  = (pre_agu_icb_rsp_size == 2'b10);


			 // In E200 single core config, we always assume the store-condition is checked by the core itself
			 //    because no other core to race. So we dont use the returned excl-ok, but use the LSU tracked
			 //    scond_true
	wire [`E203_XLEN-1:0] sc_excl_wdata = arbt_icb_rsp_scond_true ? `E203_XLEN'd0 : `E203_XLEN'd1; 
								// If it is scond (excl-write), then need to update the regfile
	assign lsu_o_wbck_wdat   = ((~pre_agu_icb_rsp_read) & pre_agu_icb_rsp_excl) ? sc_excl_wdata :


					( ({`E203_XLEN{rsp_lbu}} & {{24{          1'b0}}, rdata_algn[ 7:0]})
					| ({`E203_XLEN{rsp_lb }} & {{24{rdata_algn[ 7]}}, rdata_algn[ 7:0]})
					| ({`E203_XLEN{rsp_lhu}} & {{16{          1'b0}}, rdata_algn[15:0]})
					| ({`E203_XLEN{rsp_lh }} & {{16{rdata_algn[15]}}, rdata_algn[15:0]}) 
					| ({`E203_XLEN{rsp_lw }} & rdata_algn[31:0]));
					
	assign lsu_o_wbck_err    = pre_agu_icb_rsp_err;
	assign lsu_o_cmt_buserr  = pre_agu_icb_rsp_err;// The bus-error exception generated
	assign lsu_o_cmt_badaddr = pre_agu_icb_rsp_addr;
	assign lsu_o_cmt_ld=  pre_agu_icb_rsp_read;
	assign lsu_o_cmt_st= ~pre_agu_icb_rsp_read;

	assign lsu_ctrl_active = (|arbt_bus_icb_cmd_valid_raw) | splt_fifo_o_valid;

endmodule

