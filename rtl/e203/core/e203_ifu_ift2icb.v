//////////////////////////////////////////////////////////////////////////////////
// Company:   
// Engineer: Ruige_Lee
// Create Date: 2019-02-17 17:25:12
// Last Modified by:   Ruige_Lee
// Last Modified time: 2019-04-10 16:20:13
// Email: 295054118@whut.edu.cn
// Design Name:   
// Module Name: e203_ifu_ift2icb
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
//  The ift2icb module convert the fetch request to ICB (Internal Chip bus) 
//  and dispatch to different targets including ITCM, ICache or Sys-MEM.
//
// ====================================================================
`include "e203_defines.v"

module e203_ifu_ift2icb(
	input  clk,
	input  rst_n,

	input  itcm_nohold,

	input  ifu_req_valid, // Handshake valid
	output ifu_req_ready, // Handshake ready
	input  [`E203_PC_SIZE-1:0] ifu_req_pc, // Fetch PC
	input  ifu_req_seq, // This request is a sequential instruction fetch
	input  ifu_req_seq_rv32, // This request is incremented 32bits fetch
	input  [`E203_PC_SIZE-1:0] ifu_req_last_pc, // The last accessed
	output ifu_rsp_valid, // Response valid 
	input  ifu_rsp_ready, // Response ready
	output ifu_rsp_err = 1'b0,   // Response error
	// Note: the RSP channel always return a valid instruction fetched from the fetching start PC address. The targetd (ITCM, ICache or Sys-MEM) ctrl modules  will handle the unalign cases and split-and-merge works
	output [32-1:0] ifu_rsp_instr, // Response instruction



`ifdef E203_HAS_ITCM

output ifu2itcm_icb_cmd_valid,
input  ifu2itcm_icb_cmd_ready,
output [`E203_ITCM_ADDR_WIDTH-1:0]   ifu2itcm_icb_cmd_addr,
input  ifu2itcm_icb_rsp_valid,
output ifu2itcm_icb_rsp_ready,
// input  ifu2itcm_icb_rsp_err,
input  [`E203_ITCM_DATA_WIDTH-1:0] ifu2itcm_icb_rsp_rdata,
input  ifu2itcm_holdup 
`endif


	);

`ifndef E203_HAS_ITCM
	!!! ERROR: There is no ITCM and no System interface, where to fetch the instructions? must be wrong configuration.
`endif



	// wire i_ifu_rsp_valid;
	wire i_ifu_rsp_ready;


	sirv_gnrl_bypbuf # (
	.DP(1),
	.DW(`E203_INSTR_SIZE) 
	) u_e203_ifetch_rsp_bypbuf(
		.i_vld   (ifu2itcm_icb_rsp_valid),
		.i_rdy   (i_ifu_rsp_ready),

		.o_vld   (ifu_rsp_valid),
		.o_rdy   (ifu_rsp_ready),

		.i_dat   (ifu2itcm_icb_rsp_rdata),
		.o_dat   (ifu_rsp_instr),
	
		.clk     (clk),
		.rst_n   (rst_n)
	);
	
	// The current accessing PC is same as last accessed ICB address
	wire ifu_req_lane_holdup = ( ifu2itcm_holdup & (~itcm_nohold) );

	wire ifu_req_hsked = ifu_req_valid & ifu_req_ready;
	wire i_ifu_rsp_hsked = ifu2itcm_icb_rsp_valid & i_ifu_rsp_ready;
	

	// wire ifu_icb_cmd_ready;
	wire ifu_icb_cmd_hsked = ifu_req_valid_pos & ifu2itcm_icb_cmd_ready;

	// wire ifu_icb_rsp_ready;
	wire ifu_icb_rsp_hsked = ifu2itcm_icb_rsp_valid & i_ifu_rsp_ready;



	localparam ICB_STATE_WIDTH  = 2;
	// State 0: The idle state, means there is no any oustanding ifetch request
	localparam ICB_STATE_IDLE = 2'd0;
	// State 1: Issued first request and wait response
	localparam ICB_STATE_1ST  = 2'd1;

	
	wire [ICB_STATE_WIDTH-1:0] icb_state_nxt;
	wire [ICB_STATE_WIDTH-1:0] icb_state_r;
	wire icb_state_ena;
	wire [ICB_STATE_WIDTH-1:0] state_1st_nxt;

	wire state_idle_exit_ena;
	wire state_1st_exit_ena;


	// Define some common signals and reused later to save gatecounts
	wire icb_sta_is_idle    = (icb_state_r == ICB_STATE_IDLE);
	wire icb_sta_is_1st     = (icb_state_r == ICB_STATE_1ST);


	// **** If the current state is idle,
	// If a new request come, next state is ICB_STATE_1ST
	assign state_idle_exit_ena = icb_sta_is_idle & ifu_req_hsked;

	// **** If the current state is 1st,
	// If a response come, exit this state
	assign state_1st_exit_ena  = icb_sta_is_1st & ( i_ifu_rsp_hsked);
	assign state_1st_nxt = 
		(	
			// If it need zero or one requests and new req handshaked, then 
			//   next state is ICB_STATE_1ST
			// If it need zero or one requests and no new req handshaked, then
			//   next state is ICB_STATE_IDLE
			ifu_req_hsked  ?  ICB_STATE_1ST : ICB_STATE_IDLE 
		) ;



	// The state will only toggle when each state is meeting the condition to exit:
	assign icb_state_ena = state_idle_exit_ena | state_1st_exit_ena;

	// The next-state is onehot mux to select different entries
	assign icb_state_nxt = 
				({ICB_STATE_WIDTH{state_idle_exit_ena   }} & ICB_STATE_1ST   )
			| ({ICB_STATE_WIDTH{state_1st_exit_ena    }} & state_1st_nxt    );

	sirv_gnrl_dfflr #(ICB_STATE_WIDTH) icb_state_dfflr (icb_state_ena, icb_state_nxt, icb_state_r, clk, rst_n);


	/////////////////////////////////////////////////////////////////////////////////
	// Save the indicate flags for this ICB transaction to be used
	// wire [`E203_PC_SIZE-1:0] ifu_icb_cmd_addr;



	wire icb_cmd_addr_2_1_ena = ifu_icb_cmd_hsked | ifu_req_hsked;
	wire [1:0] icb_cmd_addr_2_1_r;
	sirv_gnrl_dffl #(2)icb_addr_2_1_dffl(icb_cmd_addr_2_1_ena, ifu_req_pc[2:1], icb_cmd_addr_2_1_r, clk);


	// issue ICB CMD request, use ICB response valid. But not each response
	// valid will be sent to ifetch-response. The ICB response data will put 
	// into the leftover buffer when:
	// It need two uops and itf-state is in 1ST stage (the leftover
	// buffer is always ready to accept this)

	// wire ifu_icb_rsp2ir_ready;

	// wire ifu_icb_rsp2ir_valid = ifu2itcm_icb_rsp_valid;
	// assign ifu_icb_rsp_ready  = i_ifu_rsp_ready;
	// assign i_ifu_rsp_valid = ifu2itcm_icb_rsp_valid;
	// assign ifu_icb_rsp2ir_ready = i_ifu_rsp_ready;



	wire ifu_req_valid_pos;
	

	wire [`E203_PC_SIZE-1:0] nxtalgn_plus_offset = ifu_req_seq_rv32  ? `E203_PC_SIZE'd6 : `E203_PC_SIZE'd4;
	// Since we always fetch 32bits
	wire [`E203_PC_SIZE-1:0] icb_algn_nxt_lane_addr = ifu_req_last_pc + nxtalgn_plus_offset;

	// assign ifu_icb_cmd_addr =  ifu_req_pc;


	wire ifu_req_ready_condi = 
				(
					icb_sta_is_idle 
					| ( icb_sta_is_1st & i_ifu_rsp_hsked)
				);
	assign ifu_req_ready     = ifu2itcm_icb_cmd_ready & ifu_req_ready_condi; 
	assign ifu_req_valid_pos = ifu_req_valid     & ifu_req_ready_condi; // Handshake valid



	assign ifu2itcm_icb_cmd_valid = ifu_req_valid_pos;
	assign ifu2itcm_icb_cmd_addr = ifu_req_pc[`E203_ITCM_ADDR_WIDTH-1:0];
	assign ifu2itcm_icb_rsp_ready = i_ifu_rsp_ready;
	// assign ifu_icb_cmd_ready =  ifu2itcm_icb_cmd_ready;


endmodule

