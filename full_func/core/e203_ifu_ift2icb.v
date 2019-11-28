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

		input  itcm_nohold,

		// Fetch Interface to memory system, internal protocol
		//    * IFetch REQ channel
		input  ifu_req_valid, // Handshake valid
		output ifu_req_ready, // Handshake ready
		input  [`E203_PC_SIZE-1:0] ifu_req_pc, // Fetch PC
		input  ifu_req_seq, // This request is a sequential instruction fetch
		input  ifu_req_seq_rv32, // This request is incremented 32bits fetch
		input  [`E203_PC_SIZE-1:0] ifu_req_last_pc, // The last accessed
																						 // PC address (i.e., pc_r)
															 
		//    * IFetch RSP channel
		output ifu_rsp_valid, // Response valid 
		input  ifu_rsp_ready, // Response ready
		output ifu_rsp_err,   // Response error
		output [32-1:0] ifu_rsp_instr, // Response instruction



		// The ITCM address region indication signal
		input [`E203_ADDR_SIZE-1:0] itcm_region_indic,
		// Bus Interface to ITCM, internal protocol called ICB (Internal Chip Bus)
		//    * Bus cmd channel
		output ifu2itcm_icb_cmd_valid, // Handshake valid
		input  ifu2itcm_icb_cmd_ready, // Handshake ready
							// Note: The data on rdata or wdata channel must be naturally
							//       aligned, this is in line with the AXI definition
		output [`E203_ITCM_ADDR_WIDTH-1:0]   ifu2itcm_icb_cmd_addr, // Bus transaction start addr 

		//    * Bus RSP channel
		input  ifu2itcm_icb_rsp_valid, // Response valid 
		output ifu2itcm_icb_rsp_ready, // Response ready
		input  ifu2itcm_icb_rsp_err,   // Response error
		input  [`E203_ITCM_DATA_WIDTH-1:0] ifu2itcm_icb_rsp_rdata, 


		// Bus Interface to System Memory, internal protocol called ICB (Internal Chip Bus)
		//    * Bus cmd channel
		output ifu2biu_icb_cmd_valid, // Handshake valid
		input  ifu2biu_icb_cmd_ready, // Handshake ready
							// Note: The data on rdata or wdata channel must be naturally
							//       aligned, this is in line with the AXI definition
		output [`E203_ADDR_SIZE-1:0]   ifu2biu_icb_cmd_addr, // Bus transaction start addr 

		//    * Bus RSP channel
		input  ifu2biu_icb_rsp_valid, // Response valid 
		output ifu2biu_icb_rsp_ready, // Response ready
		input  ifu2biu_icb_rsp_err,   // Response error
							// Note: the RSP rdata is inline with AXI definition
		input  [`E203_SYSMEM_DATA_WIDTH-1:0] ifu2biu_icb_rsp_rdata, 
		

		input  ifu2itcm_holdup,

		input  clk,
		input  rst_n
	);



	wire i_ifu_rsp_ready;

	wire [`E203_INSTR_SIZE+1-1:0]ifu_rsp_bypbuf_i_data;
	wire [`E203_INSTR_SIZE+1-1:0]ifu_rsp_bypbuf_o_data;

	assign ifu_rsp_bypbuf_i_data = { ifu_icb_rsp_err, ifu_icb_rsp_instr };

	assign { ifu_rsp_err, ifu_rsp_instr } = ifu_rsp_bypbuf_o_data;

	sirv_gnrl_bypbuf # (
		.DP(1),
		.DW(`E203_INSTR_SIZE+1) 
	) u_e203_ifetch_rsp_bypbuf(
			.i_vld   (ifu_icb_rsp_valid),
			.i_rdy   (i_ifu_rsp_ready),

			.o_vld   (ifu_rsp_valid),
			.o_rdy   (ifu_rsp_ready),

			.i_dat   (ifu_rsp_bypbuf_i_data),
			.o_dat   (ifu_rsp_bypbuf_o_data),
	
			.clk     (clk  ),
			.rst_n   (rst_n)
	);

	wire ifu_icb_cmd_ready;
	wire ifu_icb_rsp_valid;

	wire ifu_req_hsked = ifu_req_valid & ifu_req_ready;
	wire i_ifu_rsp_hsked = ifu_icb_rsp_valid & i_ifu_rsp_ready;
	wire ifu_icb_cmd_hsked = ifu_req_valid_pos & ifu_icb_cmd_ready;
	wire ifu_icb_rsp_hsked = ifu_icb_rsp_valid & i_ifu_rsp_ready;



	localparam ICB_STATE_WIDTH  = 1;
	// State 0: The idle state, means there is no any oustanding ifetch request
	localparam ICB_STATE_IDLE = 1'd0;
	// State 1: Issued first request and wait response
	localparam ICB_STATE_1ST  = 1'd1;

	
	wire [ICB_STATE_WIDTH-1:0] icb_state_nxt;
	wire [ICB_STATE_WIDTH-1:0] icb_state_r;
	wire icb_state_ena;
	wire [ICB_STATE_WIDTH-1:0] state_idle_nxt   ;
	wire [ICB_STATE_WIDTH-1:0] state_1st_nxt    ;
	wire state_idle_exit_ena     ;
	wire state_1st_exit_ena      ;

	wire icb_sta_is_idle    = (icb_state_r == ICB_STATE_IDLE   );
	wire icb_sta_is_1st     = (icb_state_r == ICB_STATE_1ST    );

	assign state_idle_exit_ena = icb_sta_is_idle & ifu_req_hsked;
	assign state_idle_nxt      = ICB_STATE_1ST;

	assign state_1st_exit_ena  = icb_sta_is_1st & i_ifu_rsp_hsked;
	assign state_1st_nxt     =  ifu_req_hsked  ?  ICB_STATE_1ST : ICB_STATE_IDLE;

	// The state will only toggle when each state is meeting the condition to exit:
	assign icb_state_ena =  state_idle_exit_ena | state_1st_exit_ena;

	// The next-state is onehot mux to select different entries
	assign icb_state_nxt = ({ICB_STATE_WIDTH{state_idle_exit_ena   }} & state_idle_nxt   )
						| ({ICB_STATE_WIDTH{state_1st_exit_ena    }} & state_1st_nxt    );

	sirv_gnrl_dfflr #(ICB_STATE_WIDTH) icb_state_dfflr (icb_state_ena, icb_state_nxt, icb_state_r, clk, rst_n);

	wire ifu_icb_cmd2itcm;
	wire icb_cmd2itcm_r;
	sirv_gnrl_dfflr #(1) icb2itcm_dfflr(ifu_icb_cmd_hsked, ifu_icb_cmd2itcm, icb_cmd2itcm_r, clk, rst_n);

	wire ifu_icb_cmd2biu ;
	wire icb_cmd2biu_r;
	sirv_gnrl_dfflr #(1) icb2mem_dfflr (ifu_icb_cmd_hsked, ifu_icb_cmd2biu , icb_cmd2biu_r,  clk, rst_n);

	
		 
	wire [31:0] ifu_icb_rsp_instr = ({32{icb_cmd2itcm_r}} & ifu2itcm_icb_rsp_rdata)
										| ({32{icb_cmd2biu_r}} & ifu2biu_icb_rsp_rdata);

	wire ifu_icb_rsp_err = (icb_cmd2itcm_r & ifu2itcm_icb_rsp_err)
							| (icb_cmd2biu_r  & ifu2biu_icb_rsp_err);



	assign ifu_icb_rsp_valid =  (icb_cmd2itcm_r & ifu2itcm_icb_rsp_valid)
								| (icb_cmd2biu_r  & ifu2biu_icb_rsp_valid);
 
	
	wire ifu_req_valid_pos;


	wire [`E203_PC_SIZE-1:0] icb_algn_nxt_lane_addr = ifu_req_last_pc + `E203_PC_SIZE'd6;


	wire ifu_req_ready_condi = ( icb_sta_is_idle | ( icb_sta_is_1st & i_ifu_rsp_hsked) );

	assign ifu_req_ready     = ifu_icb_cmd_ready & ifu_req_ready_condi; 
	assign ifu_req_valid_pos = ifu_req_valid     & ifu_req_ready_condi; // Handshake valid

	///////////////////////////////////////////////////////
	// Dispatch the ICB CMD and RSP Channel to ITCM and System Memory
	//   according to the address range

	assign ifu_icb_cmd2itcm = (ifu_req_pc[`E203_ITCM_BASE_REGION] == itcm_region_indic[`E203_ITCM_BASE_REGION]);

	assign ifu2itcm_icb_cmd_valid = ifu_req_valid_pos & ifu_icb_cmd2itcm;
	assign ifu2itcm_icb_cmd_addr = ifu_req_pc[`E203_ITCM_ADDR_WIDTH-1:0];

	assign ifu2itcm_icb_rsp_ready = i_ifu_rsp_ready;

	assign ifu_icb_cmd2biu =  ~(ifu_icb_cmd2itcm);

	assign ifu2biu_icb_rsp_ready = i_ifu_rsp_ready;

	assign ifu_icb_cmd_ready = (ifu_icb_cmd2itcm & ifu2itcm_icb_cmd_ready) 
								| (ifu_icb_cmd2biu  & ifu2biu_icb_cmd_ready );


	assign ifu2biu_icb_cmd_addr = ifu_req_pc[`E203_ADDR_SIZE-1:0];;
	assign ifu2biu_icb_cmd_valid = ifu_req_valid_pos & ifu_icb_cmd2biu;




endmodule

