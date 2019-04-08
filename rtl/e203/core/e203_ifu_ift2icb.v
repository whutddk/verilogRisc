//////////////////////////////////////////////////////////////////////////////////
// Company:   
// Engineer: Ruige_Lee
// Create Date: 2019-02-17 17:25:12
// Last Modified by:   Ruige_Lee
// Last Modified time: 2019-04-08 15:52:25
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
	output ifu_rsp_err,   // Response error
	// Note: the RSP channel always return a valid instruction fetched from the fetching start PC address. The targetd (ITCM, ICache or Sys-MEM) ctrl modules  will handle the unalign cases and split-and-merge works
	output [32-1:0] ifu_rsp_instr, // Response instruction



`ifdef E203_HAS_ITCM

input [`E203_ADDR_SIZE-1:0] itcm_region_indic,
output ifu2itcm_icb_cmd_valid,
input  ifu2itcm_icb_cmd_ready,
output [`E203_ITCM_ADDR_WIDTH-1:0]   ifu2itcm_icb_cmd_addr,
input  ifu2itcm_icb_rsp_valid,
output ifu2itcm_icb_rsp_ready,
input  ifu2itcm_icb_rsp_err,
input  [`E203_ITCM_DATA_WIDTH-1:0] ifu2itcm_icb_rsp_rdata,
input  ifu2itcm_holdup 
`endif//}


	);

`ifndef E203_HAS_ITCM
	!!! ERROR: There is no ITCM and no System interface, where to fetch the instructions? must be wrong configuration.
`endif//}


/////////////////////////////////////////////////////////
// We need to instante this bypbuf for several reasons:
//   * The IR stage ready signal is generated from EXU stage which 
//      incoperated several timing critical source (e.g., ECC error check, .etc)
//      and this ready signal will be back-pressure to ifetch rsponse channel here
//   * If there is no such bypbuf, the ifetch response channel may stuck waiting
//      the IR stage to be cleared, and this may end up with a deadlock, becuase 
//      EXU stage may access the BIU or ITCM and they are waiting the IFU to accept
//      last instruction access to make way of BIU and ITCM for LSU to access
	wire i_ifu_rsp_valid;
	wire i_ifu_rsp_ready;
	wire i_ifu_rsp_err;
	wire [`E203_INSTR_SIZE-1:0] i_ifu_rsp_instr;
	wire [`E203_INSTR_SIZE+1-1:0]ifu_rsp_bypbuf_i_data;
	wire [`E203_INSTR_SIZE+1-1:0]ifu_rsp_bypbuf_o_data;

	assign ifu_rsp_bypbuf_i_data = {
							i_ifu_rsp_err,
							i_ifu_rsp_instr
							};

	assign {	ifu_rsp_err,
				ifu_rsp_instr
			} = ifu_rsp_bypbuf_o_data;

	sirv_gnrl_bypbuf # (
	.DP(1),
	.DW(`E203_INSTR_SIZE+1) 
	) u_e203_ifetch_rsp_bypbuf(
		.i_vld   (i_ifu_rsp_valid),
		.i_rdy   (i_ifu_rsp_ready),

		.o_vld   (ifu_rsp_valid),
		.o_rdy   (ifu_rsp_ready),

		.i_dat   (ifu_rsp_bypbuf_i_data),
		.o_dat   (ifu_rsp_bypbuf_o_data),
	
		.clk     (clk),
		.rst_n   (rst_n)
	);

// ===========================================================================
//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////
/////// The itfctrl scheme introduction
//
// The instruction fetch is very tricky due to two reasons and purposes:
//   (1) We want to save area and dynamic power as much as possible
//   (2) The 32bits-length instructon may be in unaligned address
//
// In order to acheive above-mentioned purposes we define the tricky
//   fetch scheme detailed as below.
//
///////
// Firstly, several phrases are introduced here:
//   * Fetching target: the target address region including
//         ITCM,
//         System Memory Fetch Interface or ICache
//            (Note: Sys Mem and I cache are Exclusive with each other)
//   * Fetching target's Lane: The Lane here means the fetching 
//       target can read out one lane of data at one time. 
//       For example: 
//        * ITCM is 64bits wide SRAM, then it can read out one 
//          aligned 64bits one time (as a lane)
//        * System Memory is 32bits wide bus, then it can read out one 
//          aligned 32bits one time (as a lane)
//        * ICache line is N-Bytes wide SRAM, then it can read out one 
//          aligned N-Bytes one time (as a lane)
//   * Lane holding-up: The read-out Lane could be holding up there
//       For examaple:
//        * ITCM is impelemented as SRAM, the output of SRAM (readout lane)
//          will keep holding up and not change until next time the SRAM
//          is accessed (CS asserted) by new transaction
//        * ICache data ram is impelemented as SRAM, the output of
//          SRAM (readout lane) will keep holding up and not change until
//          next time the SRAM is accessed (CS asserted) by new transaction
//        * The system memory bus is from outside core peripheral or memory
//          we dont know if it will hold-up. Hence, we assume it is not
//          hoding up
//   * Crossing Lane: Since the 32bits-length instruction maybe unaligned with 
//       word address boundry, then it could be in a cross-lane address
//       For example: 
//        * If it is crossing 64bits boundry, then it is crossing ITCM Lane
//        * If it is crossing 32bits boundry, then it is crossing System Memory Lane
//        * If it is crossing N-Bytes boundry, then it is crossing ICache Lane
//   * IR register: The fetch instruction will be put into IR register which 
//       is to be used by decoder to decoding it at EXU stage
//       The Lower 16bits of IR will always be loaded with new coming
//       instructions, but in order to save dynamic power, the higher 
//       16bits IR will only be loaded when incoming instruction is
//       32bits-length (checked by mini-decode module upfront IR 
//       register)
//       Note: The source of IR register Din depends on different
//         situations described in detailed fetching sheme
//   * Leftover buffer: The ifetch will always speculatively fetch a 32bits
//       back since we dont know the instruction to be fetched is 32bits or
//       16bits length (until after it read-back and decoded by mini-decoder).
//       When the new fetch is crossing lane-boundry from current lane
//       to next lane, and if the current lane read-out value is holding up.
//       Then new 32bits instruction to be fetched can be concatated by 
//       "current holding-up lane's upper 16bits" and "next lane's lower 16bits".
//       To make it in one cycle, we push the "current holding-up lane's 
//       upper 16bits" into leftover buffer (16bits) and only issue one ifetch
//       request to memory system, and when it responded with rdata-back, 
//       directly concatate the upper 16bits rdata-back with leftover buffer
//       to become the full 32bits instruction.
//
// The new ifetch request could encounter several cases:
//   * If the new ifetch address is in the same lane portion as last fetch
//     address (current PC):
//     ** If it is crossing the lane boundry, and the current lane rdout is 
//        holding up, then
//        ---- Push current lane rdout's upper 16bits into leftover buffer
//        ---- Issue ICB cmd request with next lane address 
//        ---- After the response rdata back:
//            ---- Put the leftover buffer value into IR lower 16bits
//            ---- Put rdata lower 16bits into IR upper 16bits if instr is 32bits-long
//
//** If it is crossing the lane boundry, but the current lane rdout is not 
//holding up, then
//---- First cycle Issue ICB cmd request with current lane address 
//---- Put rdata upper 16bits into leftover buffer
//---- Second cycle Issue ICB cmd request with next lane address 
//---- Put the leftover buffer value into IR lower 16bits
//---- Put rdata upper 16bits into IR upper 16bits if instr is 32bits-long
//
//     ** If it is not crossing the lane boundry, and the current lane rdout is 
//        holding up, then
//        ---- Not issue ICB cmd request, just directly use current holding rdata
//            ---- Put aligned rdata into IR (upper 16bits 
//                    only loaded when instr is 32bits-long)
//
//** If it is not crossing the lane boundry, but the current lane rdout is 
//not holding up, then
//---- Issue ICB cmd request with current lane address, just directly use
//current holding rdata
//---- Put aligned rdata into IR (upper 16bits 
//only loaded when instr is 32bits-long)
//   
//
//* If the new ifetch address is in the different lane portion as last fetch
//address (current PC):
//** If it is crossing the lane boundry, regardless the current lane rdout is 
//holding up or not, then
//---- First cycle Issue ICB cmd reqeust with current lane address 
//---- Put rdata upper 16bits into leftover buffer
//---- Second cycle Issue ICB cmd reqeust with next lane address 
//---- Put the leftover buffer value into IR lower 16bits
//---- Put rdata upper 16bits into IR upper 16bits if instr is 32bits-long
//
//** If it is not crossing the lane boundry, then
//---- Issue ICB cmd request with current lane address, just directly use
//current holding rdata
//---- Put aligned rdata into IR (upper 16bits 
//only loaded when instr is 32bits-long)
//
// ===========================================================================





// The current accessing PC is crossing the lane boundry,删除C指令后不会发生了
// wire ifu_req_lane_cross = (ifu_req_pc[1] == 1'b1) ;

// The current accessing PC is begining of the lane boundry
	wire ifu_req_lane_begin = 1'b1;//永远为真
	

// The scheme to check if the current accessing PC is same as last accessed ICB address
//   is as below:
//     * We only treat this case as true when it is sequentially instruction-fetch
//         reqeust, and it is crossing the boundry as unalgned (1st 16bits and 2nd 16bits
//         is crossing the boundry)
//         ** If the ifetch request is the begining of lane boundry, and sequential fetch,
//            Then:
//                 **** If the last time it was prefetched ahead, then this time is accessing
//                        the same address as last time. Otherwise not.
//         ** If the ifetch request is not the begining of lane boundry, and sequential fetch,
//            Then:
//                 **** It must be access the same address as last time.
//     * Note: All other non-sequential cases (e.g., flush, branch or replay) are not
//          treated as this case
//  
// wire req_lane_cross_r;
// wire ifu_req_lane_same =  1'b0 ;
	
	// The current accessing PC is same as last accessed ICB address
	wire ifu_req_lane_holdup = ( ifu2itcm_holdup & (~itcm_nohold) );

	wire ifu_req_hsked = ifu_req_valid & ifu_req_ready;
	wire i_ifu_rsp_hsked = i_ifu_rsp_valid & i_ifu_rsp_ready;
	
	wire ifu_icb_cmd_valid;
	wire ifu_icb_cmd_ready;
	wire ifu_icb_cmd_hsked = ifu_icb_cmd_valid & ifu_icb_cmd_ready;
	wire ifu_icb_rsp_valid;
	wire ifu_icb_rsp_ready;
	wire ifu_icb_rsp_hsked = ifu_icb_rsp_valid & ifu_icb_rsp_ready;


	/////////////////////////////////////////////////////////////////////////////////
	// Implement the state machine for the ifetch req interface
	//
	// wire req_need_2uop_r;
	// wire req_need_0uop_r;


	localparam ICB_STATE_WIDTH  = 2;
	// State 0: The idle state, means there is no any oustanding ifetch request
	localparam ICB_STATE_IDLE = 2'd0;
	// State 1: Issued first request and wait response
	localparam ICB_STATE_1ST  = 2'd1;
	// State 2: Wait to issue second request 
	localparam ICB_STATE_WAIT2ND  = 2'd2;
	// State 3: Issued second request and wait response
	localparam ICB_STATE_2ND  = 2'd3;
	
	wire [ICB_STATE_WIDTH-1:0] icb_state_nxt;
	wire [ICB_STATE_WIDTH-1:0] icb_state_r;
	wire icb_state_ena;
	wire [ICB_STATE_WIDTH-1:0] state_1st_nxt;
	wire [ICB_STATE_WIDTH-1:0] state_2nd_nxt;
	wire state_idle_exit_ena;
	wire state_1st_exit_ena;
	wire state_wait2nd_exit_ena;
	wire state_2nd_exit_ena;

	// Define some common signals and reused later to save gatecounts
	wire icb_sta_is_idle    = (icb_state_r == ICB_STATE_IDLE   );
	wire icb_sta_is_1st     = (icb_state_r == ICB_STATE_1ST    );
	wire icb_sta_is_wait2nd = (icb_state_r == ICB_STATE_WAIT2ND);
	wire icb_sta_is_2nd     = (icb_state_r == ICB_STATE_2ND    );

	// **** If the current state is idle,
	// If a new request come, next state is ICB_STATE_1ST
	assign state_idle_exit_ena = icb_sta_is_idle & ifu_req_hsked;

	// **** If the current state is 1st,
	// If a response come, exit this state
	// wire ifu_icb_rsp2leftover;
	assign state_1st_exit_ena  = icb_sta_is_1st & ( i_ifu_rsp_hsked);
	assign state_1st_nxt     = 
				(
				
				// If it need zero or one requests and new req handshaked, then 
				//   next state is ICB_STATE_1ST
				// If it need zero or one requests and no new req handshaked, then
				//   next state is ICB_STATE_IDLE
					ifu_req_hsked  ?  ICB_STATE_1ST 
									: ICB_STATE_IDLE 
				) ;

	// **** If the current state is wait-2nd,
	// If the ICB CMD is ready, then next state is ICB_STATE_2ND
	assign state_wait2nd_exit_ena = icb_sta_is_wait2nd &  ifu_icb_cmd_ready;

	// **** If the current state is 2nd,
	// If a response come, exit this state
	assign state_2nd_exit_ena     =  icb_sta_is_2nd &  i_ifu_rsp_hsked;
	assign state_2nd_nxt          = 
		(
		// If meanwhile new req handshaked, then next state is ICB_STATE_1ST
			ifu_req_hsked  ?  ICB_STATE_1ST : 
			// otherwise, back to IDLE
			ICB_STATE_IDLE
		);

	// The state will only toggle when each state is meeting the condition to exit:
	assign icb_state_ena = 
			state_idle_exit_ena | state_1st_exit_ena | state_wait2nd_exit_ena | state_2nd_exit_ena;

	// The next-state is onehot mux to select different entries
	assign icb_state_nxt = 
				({ICB_STATE_WIDTH{state_idle_exit_ena   }} & ICB_STATE_1ST   )
			| ({ICB_STATE_WIDTH{state_1st_exit_ena    }} & state_1st_nxt    )
			| ({ICB_STATE_WIDTH{state_wait2nd_exit_ena}} & ICB_STATE_2ND)
			| ({ICB_STATE_WIDTH{state_2nd_exit_ena    }} & state_2nd_nxt    )
				;

	sirv_gnrl_dfflr #(ICB_STATE_WIDTH) icb_state_dfflr (icb_state_ena, icb_state_nxt, icb_state_r, clk, rst_n);


	/////////////////////////////////////////////////////////////////////////////////
	// Save the indicate flags for this ICB transaction to be used
	wire [`E203_PC_SIZE-1:0] ifu_icb_cmd_addr;

	wire ifu_icb_cmd2itcm;
	wire icb_cmd2itcm_r;
	sirv_gnrl_dfflr #(1) icb2itcm_dfflr(ifu_icb_cmd_hsked, ifu_icb_cmd2itcm, icb_cmd2itcm_r, clk, rst_n);
	wire icb_cmd_addr_2_1_ena = ifu_icb_cmd_hsked | ifu_req_hsked;
	wire [1:0] icb_cmd_addr_2_1_r;
	sirv_gnrl_dffl #(2)icb_addr_2_1_dffl(icb_cmd_addr_2_1_ena, ifu_icb_cmd_addr[2:1], icb_cmd_addr_2_1_r, clk);

	/////////////////////////////////////////////////////////////////////////////////
	// Implement Leftover Buffer
	wire leftover_ena; 
	wire [15:0] leftover_nxt; 
	wire [15:0] leftover_r; 


	// The leftover buffer will be loaded into two cases
	// Please see "The itfctrl scheme introduction" for more details 
	//    * Case #1: Loaded when the last holdup upper 16bits put into leftover
	//    * Case #2: Loaded when the 1st request uop rdata upper 16bits put into leftover 
	wire holdup2leftover_ena = ifu_req_hsked & holdup2leftover_sel;
	wire [15:0]  put2leftover_data = 16'b0    
		`ifdef E203_HAS_ITCM //{
			| ({16{icb_cmd2itcm_r}} & ifu2itcm_icb_rsp_rdata[`E203_ITCM_DATA_WIDTH-1:`E203_ITCM_DATA_WIDTH-16]) 
		`endif//}
			;


	wire uop1st2leftover_err = (icb_cmd2itcm_r & ifu2itcm_icb_rsp_err);

	assign leftover_ena = holdup2leftover_ena ;

	assign leftover_nxt = put2leftover_data[15:0];


	sirv_gnrl_dffl #(16) leftover_dffl     (leftover_ena, leftover_nxt,     leftover_r,     clk);
	
	/////////////////////////////////////////////////////////////////////////////////
	// Generate the ifetch response channel
	// 
	// The ifetch response instr will have 2 sources
	// Please see "The itfctrl scheme introduction" for more details 
	//    * Source #1: The concatenation by {rdata[15:0],leftover}, when
	//          ** the state is in 2ND uop
	//          ** the state is in 1ND uop but it is same-cross-holdup case
	//    * Source #2: The rdata-aligned, when
	//           ** not selecting leftover
	wire rsp_instr_sel_leftover = icb_sta_is_2nd;

	wire rsp_instr_sel_icb_rsp = ~rsp_instr_sel_leftover;

	wire [16-1:0] ifu_icb_rsp_rdata_lsb16 = 16'b0
			| ({16{icb_cmd2itcm_r}} & ifu2itcm_icb_rsp_rdata[15:0])
			;


	// The fetched instruction from ICB rdata bus need to be aligned by PC LSB bits

	wire[31:0] ifu2itcm_icb_rsp_instr = ifu2itcm_icb_rsp_rdata;




	wire [32-1:0] ifu_icb_rsp_instr = 32'b0
				 | ({32{icb_cmd2itcm_r}} & ifu2itcm_icb_rsp_instr)
			;

	wire ifu_icb_rsp_err = (icb_cmd2itcm_r & ifu2itcm_icb_rsp_err)
			;

	assign i_ifu_rsp_instr = 
				({32{rsp_instr_sel_leftover}} & {ifu_icb_rsp_rdata_lsb16, leftover_r})
			| ({32{rsp_instr_sel_icb_rsp }} & ifu_icb_rsp_instr);
	assign i_ifu_rsp_err = 
				(rsp_instr_sel_leftover & (|{ifu_icb_rsp_err, 1'b0}))
			| (rsp_instr_sel_icb_rsp  & ifu_icb_rsp_err);

			
	// issue ICB CMD request, use ICB response valid. But not each response
	// valid will be sent to ifetch-response. The ICB response data will put 
	// into the leftover buffer when:
	// It need two uops and itf-state is in 1ST stage (the leftover
	// buffer is always ready to accept this)

	wire ifu_icb_rsp2ir_ready;

	wire ifu_icb_rsp2ir_valid = ifu_icb_rsp_valid;
	assign ifu_icb_rsp_ready  = ifu_icb_rsp2ir_ready;
	//

	assign i_ifu_rsp_valid = ifu_icb_rsp2ir_valid;
	assign ifu_icb_rsp2ir_ready = i_ifu_rsp_ready;


	/////////////////////////////////////////////////////////////////////////////////
	// Generate the ICB response channel
	//
	// The ICB response valid to ifetch generated in two cases:
	//    * Case #1: The itf need two uops, and it is in 2ND state response
	//    * Case #2: The itf need only one uop, and it is in 1ND state response
	assign ifu_icb_rsp_valid = (icb_cmd2itcm_r & ifu2itcm_icb_rsp_valid);
 
	/////////////////////////////////////////////////////////////////////////////////
	// Generate the ICB command channel
	//
	// The ICB cmd valid will be generated in two cases:
	//   * Case #1: When the new ifetch-request is coming, and it is not "need zero 
	//              uops"
	//   * Case #2: When the ongoing ifetch is "need 2 uops", and:
	//                ** itf-state is in 1ST state and its response is handshaking (about
	//                    to finish the 1ST state)
	//                ** or it is already in WAIT2ND state
	wire ifu_req_valid_pos;
	assign ifu_icb_cmd_valid = ifu_req_valid_pos;
					 
	// The ICB cmd address will be generated in 3 cases:
	//   * Case #1: Use next lane-aligned address, when 
	//                 ** It is same-cross-holdup case for 1st uop
	//                 The next-lane-aligned address can be generated by 
	//                 current request-PC plus 16bits. To optimize the
	//                 timing, we try to use last-fetched-PC (flop clean)
	//                 to caculate. So we caculate it by 
	//                 last-fetched-PC (flopped value pc_r) truncated
	//                 with lane-offset and plus a lane siz
	wire icb_addr_sel_1stnxtalgn = holdup2leftover_sel;
	//
	//   * Case #2: Use next lane-aligned address, when
	//                 ** It need 2 uops, and it is 1ST or WAIT2ND stage
	//                 The next-lane-aligned address can be generated by
	//                 last request-PC plus 16bits. 
	//
	//   * Case #3: Use current ifetch address in 1st uop, when 
	//                 ** It is not above two cases
	wire icb_addr_sel_cur = (~icb_addr_sel_1stnxtalgn);

	wire [`E203_PC_SIZE-1:0] nxtalgn_plus_offset = ifu_req_seq_rv32  ? `E203_PC_SIZE'd6 : `E203_PC_SIZE'd4;
	// Since we always fetch 32bits
	wire [`E203_PC_SIZE-1:0] icb_algn_nxt_lane_addr = ifu_req_last_pc + nxtalgn_plus_offset;

	assign ifu_icb_cmd_addr = 
		({`E203_PC_SIZE{icb_addr_sel_1stnxtalgn }} & icb_algn_nxt_lane_addr)
	| ({`E203_PC_SIZE{icb_addr_sel_cur}} & ifu_req_pc);

	/////////////////////////////////////////////////////////////////////////////////
	// Generate the ifetch req channel ready signal
	//
	// Ifu req channel will be ready when the ICB CMD channel is ready and 
	//    * the itf-state is idle
	//    * or only need zero or one uop, and in 1ST state response is backing
	//    * or need two uops, and in 2ND state response is backing
	wire ifu_req_ready_condi = 
				(
					icb_sta_is_idle 
					| ( icb_sta_is_1st & i_ifu_rsp_hsked)
				);
	assign ifu_req_ready     = ifu_icb_cmd_ready & ifu_req_ready_condi; 
	assign ifu_req_valid_pos = ifu_req_valid     & ifu_req_ready_condi; // Handshake valid




	///////////////////////////////////////////////////////
	// Dispatch the ICB CMD and RSP Channel to ITCM and System Memory
	//   according to the address range

	assign ifu_icb_cmd2itcm = (ifu_icb_cmd_addr[`E203_ITCM_BASE_REGION] == itcm_region_indic[`E203_ITCM_BASE_REGION]);

	assign ifu2itcm_icb_cmd_valid = ifu_icb_cmd_valid & ifu_icb_cmd2itcm;
	assign ifu2itcm_icb_cmd_addr = ifu_icb_cmd_addr[`E203_ITCM_ADDR_WIDTH-1:0];

	assign ifu2itcm_icb_rsp_ready = ifu_icb_rsp_ready;



	assign ifu_icb_cmd_ready = (ifu_icb_cmd2itcm & ifu2itcm_icb_cmd_ready);


endmodule

