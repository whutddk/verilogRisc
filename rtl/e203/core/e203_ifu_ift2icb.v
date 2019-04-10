//////////////////////////////////////////////////////////////////////////////////
// Company:   
// Engineer: Ruige_Lee
// Create Date: 2019-02-17 17:25:12
// Last Modified by:   Ruige_Lee
// Last Modified time: 2019-04-10 18:13:56
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
	output [32-1:0] ifu_rsp_instr, // Response instruction
	);




`ifndef E203_HAS_ITCM
	!!! ERROR: There is no ITCM and no System interface, where to fetch the instructions? must be wrong configuration.
`endif


	assign ifu_rsp_valid = ifu_req_valid;


	
	// The current accessing PC is same as last accessed ICB address
	// wire ifu_req_lane_holdup = ( ifu_holdup_r & (~itcm_nohold) );

	wire ifu_req_hsked = ifu_req_valid & ifu_req_ready;
	wire i_ifu_rsp_hsked = ifu_req_valid & ifu_rsp_ready;
	

	// wire ifu_icb_cmd_ready;
	wire ifu_icb_cmd_hsked = ifu_req_valid_pos & ifu_rsp_ready;

	// wire ifu_icb_rsp_ready;
	wire ifu_icb_rsp_hsked = ifu_req_valid & ifu_rsp_ready;





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


	
	assign state_idle_exit_ena = icb_sta_is_idle & ifu_req_hsked;// **** If the current state is idle, If a new request come, next state is ICB_STATE_1ST
	assign state_1st_exit_ena  = icb_sta_is_1st & ( i_ifu_rsp_hsked);// **** If the current state is 1st, If a response come, exit this state
	
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



	// wire icb_cmd_addr_2_1_ena = ifu_icb_cmd_hsked | ifu_req_hsked;

	wire ifu_req_valid_pos;
	

	wire [`E203_PC_SIZE-1:0] nxtalgn_plus_offset = ifu_req_seq_rv32  ? `E203_PC_SIZE'd6 : `E203_PC_SIZE'd4;
	// Since we always fetch 32bits
	wire [`E203_PC_SIZE-1:0] icb_algn_nxt_lane_addr = ifu_req_last_pc + nxtalgn_plus_offset;


	wire ifu_req_ready_condi = 
				(
					icb_sta_is_idle 
					| ( icb_sta_is_1st & i_ifu_rsp_hsked)
				);
				// wire i_ifu_rsp_hsked = ifu_req_valid & ifu_rsp_ready;
	assign ifu_req_ready     = ifu_rsp_ready & ifu_req_ready_condi; 
	assign ifu_req_valid_pos = ifu_req_valid     & ifu_req_ready_condi; // Handshake valid


	assign itcm_ram_cs = ifu_req_valid_pos & ifu_rsp_ready;  
assign itcm_ram_we = ( ~ifu2itcm_icb_cmd_read );  
	assign itcm_ram_addr = ifu_req_pc[15:2];          


	wire itcm_ram_cs;  
	wire itcm_ram_we;  
	wire [`E203_ITCM_RAM_AW-1:0] itcm_ram_addr; 
	  

	wire itcm_active = ifu_req_valid_pos;



	wire clk_itcm;

	wire itcm_active_r;
	sirv_gnrl_dffr #(1)itcm_active_dffr(itcm_active, itcm_active_r, clk_itcm, rst_n);
	wire itcm_clk_en = itcm_active | itcm_active_r;


	e203_clkgate u_itcm_clkgate(
		.clk_in   (clk),
		.test_mode(1'b0),
		.clock_en (itcm_clk_en),
		.clk_out  (clk_itcm)
	);


	e203_itcm_ram u_e203_itcm_ram (
		.cs   (itcm_ram_cs),
		.we   (itcm_ram_we),
		.addr (itcm_ram_addr),
		.wem  ({`E203_ITCM_DATA_WIDTH/8{1'b0}}),
		.din  ({`E203_ITCM_DATA_WIDTH{1'b0}}),
		.dout (ifu_rsp_instr),
		.rst_n(rst_n),
		.clk  (clk_itcm)
	);










endmodule

