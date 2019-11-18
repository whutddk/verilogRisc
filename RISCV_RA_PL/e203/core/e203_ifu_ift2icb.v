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
  //////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////
  // Fetch Interface to memory system, internal protocol
  //    * IFetch REQ channel
  input  ifu_req_valid, // Handshake valid
  output ifu_req_ready, // Handshake ready
            // Note: the req-addr can be unaligned with the length indicated
            //       by req_len signal.
            //       The targetd (ITCM, ICache or Sys-MEM) ctrl modules 
            //       will handle the unalign cases and split-and-merge works
  input  [`E203_PC_SIZE-1:0] ifu_req_pc, // Fetch PC
  input  ifu_req_seq, // This request is a sequential instruction fetch
  input  ifu_req_seq_rv32, // This request is incremented 32bits fetch
  input  [`E203_PC_SIZE-1:0] ifu_req_last_pc, // The last accessed
                                           // PC address (i.e., pc_r)
                             
  //    * IFetch RSP channel
  output ifu_rsp_valid, // Response valid 
  input  ifu_rsp_ready, // Response ready
  output ifu_rsp_err,   // Response error
            // Note: the RSP channel always return a valid instruction
            //   fetched from the fetching start PC address.
            //   The targetd (ITCM, ICache or Sys-MEM) ctrl modules 
            //   will handle the unalign cases and split-and-merge works
  //output ifu_rsp_replay,   // Response error
  output [32-1:0] ifu_rsp_instr, // Response instruction



  `ifdef E203_HAS_MEM_ITF //{
  //////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////
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
  
  //input  ifu2biu_replay,
  `endif//}




  input  clk,
  input  rst_n
  );


  `ifndef E203_HAS_MEM_ITF
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

  assign {
                          ifu_rsp_err,
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
  
      .clk     (clk  ),
      .rst_n   (rst_n)
  );


  
  // The current accessing PC is same as last accessed ICB address

  wire ifu_req_hsked = ifu_req_valid & ifu_req_ready;
  wire i_ifu_rsp_hsked = i_ifu_rsp_valid & i_ifu_rsp_ready;
  wire ifu_icb_cmd_valid;

  wire ifu_icb_cmd_hsked = ifu_icb_cmd_valid & ifu2biu_icb_cmd_ready;

  wire ifu_icb_rsp_hsked = ifu2biu_icb_rsp_valid & i_ifu_rsp_ready;




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


  assign state_1st_exit_ena  = icb_sta_is_1st & (i_ifu_rsp_hsked);
  assign state_1st_nxt     = 
                (
                    ifu_req_hsked  ?  ICB_STATE_1ST 
                                    : ICB_STATE_IDLE 
                ) ;


  assign icb_state_ena = 
            state_idle_exit_ena | state_1st_exit_ena ;


  assign icb_state_nxt = 
              ({ICB_STATE_WIDTH{state_idle_exit_ena   }} & state_idle_nxt   )
            | ({ICB_STATE_WIDTH{state_1st_exit_ena    }} & state_1st_nxt    )
            ;

  sirv_gnrl_dfflr #(ICB_STATE_WIDTH) icb_state_dfflr (icb_state_ena, icb_state_nxt, icb_state_r, clk, rst_n);

  wire icb_cmd_addr_2_1_ena = ifu_icb_cmd_hsked | ifu_req_hsked;
  wire [1:0] icb_cmd_addr_2_1_r;

  sirv_gnrl_dffl #(2)icb_addr_2_1_dffl(icb_cmd_addr_2_1_ena, ifu_req_pc[2:1], icb_cmd_addr_2_1_r, clk);


  assign i_ifu_rsp_instr = ifu2biu_icb_rsp_rdata;
  assign i_ifu_rsp_err = ifu2biu_icb_rsp_err;

  assign i_ifu_rsp_valid = ifu2biu_icb_rsp_valid;
 
  assign ifu_icb_cmd_valid = ifu_req_valid     & ifu_req_ready_condi; // Handshake valid
                     



  wire ifu_req_ready_condi = 
                (
                    icb_sta_is_idle 
                  | ( icb_sta_is_1st & i_ifu_rsp_hsked)
                );

  assign ifu_req_ready     = ifu2biu_icb_cmd_ready & ifu_req_ready_condi; 



  assign ifu2biu_icb_rsp_ready = i_ifu_rsp_ready;



     assign ifu2biu_icb_cmd_addr      = ifu_req_pc[`E203_ADDR_SIZE-1:0];
     assign ifu2biu_icb_cmd_valid     = ifu_icb_cmd_valid ;




endmodule

