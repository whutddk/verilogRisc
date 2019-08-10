//////////////////////////////////////////////////////////////////////////////////
// Company:   
// Engineer: Ruige_Lee
// Create Date: 2019-06-25 19:07:21
// Last Modified by:   Ruige_Lee
// Last Modified time: 2019-06-29 16:27:40
// Email: 295054118@whut.edu.cn
// page: https://whutddk.github.io/
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


	input [`E203_ADDR_SIZE-1:0] itcm_region_indic,

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
	// The ICB Interface to ITCM
	//
	//    * Bus cmd channel
	output                         itcm_icb_cmd_valid,
	input                          itcm_icb_cmd_ready,
	output [`E203_ITCM_ADDR_WIDTH-1:0]   itcm_icb_cmd_addr, 
	output                         itcm_icb_cmd_read, 
	output [`E203_XLEN-1:0]        itcm_icb_cmd_wdata,
	output [`E203_XLEN/8-1:0]      itcm_icb_cmd_wmask,
	output                         itcm_icb_cmd_lock,
	output                         itcm_icb_cmd_excl,
	output [1:0]                   itcm_icb_cmd_size,
	//    * Bus RSP channel
	input                          itcm_icb_rsp_valid,
	output                         itcm_icb_rsp_ready,
	input                          itcm_icb_rsp_err  ,
	input                          itcm_icb_rsp_excl_ok  ,
	input  [`E203_XLEN-1:0]        itcm_icb_rsp_rdata,


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
	//    * Bus RSP channel
	input                          biu_icb_rsp_valid,
	output                         biu_icb_rsp_ready,
	input                          biu_icb_rsp_err  ,
	input                          biu_icb_rsp_excl_ok  ,
	input  [`E203_XLEN-1:0]        biu_icb_rsp_rdata,


	input  clk,
	input  rst_n
	);





	
	// NOTE:
	//   * PPI is a must to have
	//   * Either DCache, ITCM, DTCM or SystemITF is must to have
	`ifndef E203_HAS_DTCM //{
		`ifndef E203_HAS_DCACHE //{
			`ifndef E203_HAS_MEM_ITF //{
				`ifndef E203_HAS_ITCM //{
			!!! ERROR: There must be something wrong, Either DCache, DTCM, ITCM or SystemITF is must to have. 
								 Otherwise where to access the data?
				`endif//}
			`endif//}
		`endif//}
	`endif//}


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

	wire [USR_W-1:0] pre_agu_icb_rsp_usr;
	assign 
			{
				 pre_agu_icb_rsp_back2agu  
				,pre_agu_icb_rsp_usign
				,pre_agu_icb_rsp_read
				,pre_agu_icb_rsp_size
				,pre_agu_icb_rsp_itag 
				,pre_agu_icb_rsp_addr
				,pre_agu_icb_rsp_excl 
			} = pre_agu_icb_rsp_usr;


	/////////////////////////////////////////////////////////////////////////////////
	// Implement a FIFO to save the outstanding info
	//
	//  * The FIFO will be pushed when a ICB CMD handshaked
	//  * The FIFO will be poped  when a ICB RSP handshaked

	wire arbt_icb_cmd_itcm = (agu_icb_cmd_addr[`E203_ITCM_BASE_REGION] ==  itcm_region_indic[`E203_ITCM_BASE_REGION]);
	wire arbt_icb_cmd_dtcm = (agu_icb_cmd_addr[`E203_DTCM_BASE_REGION] ==  dtcm_region_indic[`E203_DTCM_BASE_REGION]);
	wire arbt_icb_cmd_biu    = (~arbt_icb_cmd_itcm) & (~arbt_icb_cmd_dtcm);

	wire splt_fifo_wen = agu_icb_cmd_valid & agu_icb_cmd_ready;
	wire splt_fifo_ren = pre_agu_icb_rsp_valid & pre_agu_icb_rsp_ready;

	wire splt_fifo_i_ready;
	wire splt_fifo_i_valid = splt_fifo_wen;
	wire splt_fifo_full    = (~splt_fifo_i_ready);
	wire splt_fifo_o_valid;
	wire splt_fifo_o_ready = splt_fifo_ren;
	wire splt_fifo_empty   = (~splt_fifo_o_valid);

	wire arbt_icb_rsp_biu;
	wire arbt_icb_rsp_dtcm;
	wire arbt_icb_rsp_itcm;
	wire arbt_icb_rsp_scond_true;



	localparam SPLT_FIFO_W = (USR_W+3);
	wire [`E203_XLEN/8-1:0] arbt_icb_cmd_wmask_pos = agu_icb_cmd_wmask;


	wire [SPLT_FIFO_W-1:0] splt_fifo_wdat;
	wire [SPLT_FIFO_W-1:0] splt_fifo_rdat;

	assign splt_fifo_wdat =  {
			arbt_icb_cmd_biu,
			arbt_icb_cmd_dtcm,
			arbt_icb_cmd_itcm,
			agu_icb_cmd_usr 
		};

	assign  {
				arbt_icb_rsp_biu,
				arbt_icb_rsp_dtcm,
				arbt_icb_rsp_itcm,
				pre_agu_icb_rsp_usr 
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






	wire arbt_icb_cmd_addi_condi = (~splt_fifo_full);
	wire arbt_icb_cmd_ready_pos;

	wire arbt_icb_cmd_valid_pos = arbt_icb_cmd_addi_condi & agu_icb_cmd_valid;
	assign agu_icb_cmd_ready = arbt_icb_cmd_addi_condi & arbt_icb_cmd_ready_pos;

	wire all_icb_cmd_ready;
	wire all_icb_cmd_ready_excp_biu;
	wire all_icb_cmd_ready_excp_dtcm;
	wire all_icb_cmd_ready_excp_itcm;


	assign dtcm_icb_cmd_valid = arbt_icb_cmd_valid_pos & arbt_icb_cmd_dtcm & all_icb_cmd_ready_excp_dtcm;
	assign dtcm_icb_cmd_addr  = agu_icb_cmd_addr [`E203_DTCM_ADDR_WIDTH-1:0]; 
	assign dtcm_icb_cmd_read  = agu_icb_cmd_read ; 
	assign dtcm_icb_cmd_wdata = agu_icb_cmd_wdata;
	assign dtcm_icb_cmd_wmask = arbt_icb_cmd_wmask_pos;
	assign dtcm_icb_cmd_lock  = agu_icb_cmd_lock ;
	assign dtcm_icb_cmd_excl  = agu_icb_cmd_excl ;
	assign dtcm_icb_cmd_size  = agu_icb_cmd_size ;

	assign itcm_icb_cmd_valid = arbt_icb_cmd_valid_pos & arbt_icb_cmd_itcm & all_icb_cmd_ready_excp_itcm;
	assign itcm_icb_cmd_addr  = agu_icb_cmd_addr [`E203_ITCM_ADDR_WIDTH-1:0]; 
	assign itcm_icb_cmd_read  = agu_icb_cmd_read ; 
	assign itcm_icb_cmd_wdata = agu_icb_cmd_wdata;
	assign itcm_icb_cmd_wmask = arbt_icb_cmd_wmask_pos;
	assign itcm_icb_cmd_lock  = agu_icb_cmd_lock ;
	assign itcm_icb_cmd_excl  = agu_icb_cmd_excl ;
	assign itcm_icb_cmd_size  = agu_icb_cmd_size ;

	assign biu_icb_cmd_valid = arbt_icb_cmd_valid_pos & arbt_icb_cmd_biu & all_icb_cmd_ready_excp_biu;
	assign biu_icb_cmd_addr  = agu_icb_cmd_addr ; 
	assign biu_icb_cmd_read  = agu_icb_cmd_read ; 
	assign biu_icb_cmd_wdata = agu_icb_cmd_wdata;
	assign biu_icb_cmd_wmask = arbt_icb_cmd_wmask_pos;
	assign biu_icb_cmd_lock  = agu_icb_cmd_lock ;
	assign biu_icb_cmd_excl  = agu_icb_cmd_excl ;
	assign biu_icb_cmd_size  = agu_icb_cmd_size ;
	

	assign all_icb_cmd_ready =  
			(biu_icb_cmd_ready )& (dtcm_icb_cmd_ready)& (itcm_icb_cmd_ready);

	assign all_icb_cmd_ready_excp_biu =  
			1'b1 & (dtcm_icb_cmd_ready) & (itcm_icb_cmd_ready) ;
	
	assign all_icb_cmd_ready_excp_dtcm =  
			(biu_icb_cmd_ready ) & 1'b1 & (itcm_icb_cmd_ready) ;

	assign all_icb_cmd_ready_excp_itcm =  
			(biu_icb_cmd_ready ) & (dtcm_icb_cmd_ready) & 1'b1;

	assign arbt_icb_cmd_ready_pos = all_icb_cmd_ready;  

	assign {
					pre_agu_icb_rsp_valid 
				, pre_agu_icb_rsp_err 
				, pre_agu_icb_rsp_excl_ok 
				, pre_agu_icb_rsp_rdata 
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
						) 

					| ({`E203_XLEN+3{arbt_icb_rsp_itcm}} &
												{ itcm_icb_rsp_valid 
												, itcm_icb_rsp_err 
												, itcm_icb_rsp_excl_ok 
												, itcm_icb_rsp_rdata 
												}
						) 

						 ;

	assign biu_icb_rsp_ready    = arbt_icb_rsp_biu    & pre_agu_icb_rsp_ready;
	assign dtcm_icb_rsp_ready   = arbt_icb_rsp_dtcm   & pre_agu_icb_rsp_ready;
	assign itcm_icb_rsp_ready   = arbt_icb_rsp_itcm   & pre_agu_icb_rsp_ready;



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

	

			 // If not support the store-condition instructions, then we have no chance to issue excl transaction
					 // no need to consider the store-condition result write-back
	assign lsu_o_wbck_wdat   = 
					( ({`E203_XLEN{rsp_lbu}} & {{24{          1'b0}}, rdata_algn[ 7:0]})
					| ({`E203_XLEN{rsp_lb }} & {{24{rdata_algn[ 7]}}, rdata_algn[ 7:0]})
					| ({`E203_XLEN{rsp_lhu}} & {{16{          1'b0}}, rdata_algn[15:0]})
					| ({`E203_XLEN{rsp_lh }} & {{16{rdata_algn[15]}}, rdata_algn[15:0]}) 
					| ({`E203_XLEN{rsp_lw }} & rdata_algn[31:0]));
					
	assign lsu_o_wbck_err    = pre_agu_icb_rsp_err;
	assign lsu_o_cmt_buserr  = pre_agu_icb_rsp_err;// The bus-error exception generated
	assign lsu_o_cmt_badaddr = pre_agu_icb_rsp_addr;
	assign lsu_o_cmt_ld =  pre_agu_icb_rsp_read;
	assign lsu_o_cmt_st = ~pre_agu_icb_rsp_read;

	assign lsu_ctrl_active = (|agu_icb_cmd_valid) | splt_fifo_o_valid;

endmodule

