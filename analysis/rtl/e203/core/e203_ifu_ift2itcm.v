//////////////////////////////////////////////////////////////////////////////////
// Company:   
// Engineer: Ruige_Lee
// Create Date: 2019-02-17 17:25:12
// Last Modified by:   Ruige_Lee
// Last Modified time: 2019-04-21 17:23:35
// Email: 295054118@whut.edu.cn
// Design Name:   
// Module Name: e203_ifu_ift2itcm
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

	input  ifu_req_valid, // Handshake valid
	output ifu_req_ready, // Handshake ready

	input  [`E203_PC_SIZE-1:0] ifu_req_pc, // Fetch PC

	output ifu_rsp_valid, // Response valid 
	input  ifu_rsp_ready, // Response ready

	output [31:0] ifu_rsp_instr // Response instruction
	);


`ifndef E203_HAS_ITCM
	!!! ERROR: There is no ITCM and no System interface, where to fetch the instructions? must be wrong configuration.
`endif

	//这里打一拍应该就可以了
	// assign ifu_req_ready = ifu_rsp_ready; 
	// assign ifu_rsp_valid = ifu_req_valid;
       
sirv_gnrl_dffr # (.DW(2)) (.dnxt({ifu_rsp_ready,ifu_req_valid}),.qout({ifu_req_ready,ifu_rsp_valid}),.clk(clk),.rst_n(rst_n));

	itcm_rom i_itcm_rom(
		.addra(ifu_req_pc[15:2]),
		.clka(clk),
		.douta(ifu_rsp_instr)
		);











endmodule

