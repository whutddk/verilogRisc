//////////////////////////////////////////////////////////////////////////////////
// Company:   
// Engineer: Ruige_Lee
// Create Date: 2019-02-17 17:25:12
// Last Modified by:   Ruige_Lee
// Last Modified time: 2019-04-10 19:57:33
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

module e203_ifu_ift2itcm(
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
	output [32-1:0] ifu_rsp_instr // Response instruction
	);




`ifndef E203_HAS_ITCM
	!!! ERROR: There is no ITCM and no System interface, where to fetch the instructions? must be wrong configuration.
`endif

	//这里打一拍应该就可以了
	assign ifu_req_ready = ifu_rsp_ready; 
	assign ifu_rsp_valid = ifu_req_valid;


	wire [`E203_PC_SIZE-1:0] nxtalgn_plus_offset = ifu_req_seq_rv32  ? `E203_PC_SIZE'd6 : `E203_PC_SIZE'd4;
	// Since we always fetch 32bits
	wire [`E203_PC_SIZE-1:0] icb_algn_nxt_lane_addr = ifu_req_last_pc + nxtalgn_plus_offset;


	assign itcm_ram_cs = ifu_req_valid & ifu_rsp_ready;  
assign itcm_ram_we = ( ~ifu2itcm_icb_cmd_read );  
	assign itcm_ram_addr = ifu_req_pc[15:2];          


	wire itcm_ram_cs;  
	wire itcm_ram_we;  
	wire [`E203_ITCM_RAM_AW-1:0] itcm_ram_addr; 
	  

	wire clk_itcm = clk & ifu_req_valid;


	itcm_rom i_itcm_rom(
		.addra(itcm_ram_addr),
		.clka(clk_itcm),
		.douta(ifu_rsp_instr)
		);











endmodule

