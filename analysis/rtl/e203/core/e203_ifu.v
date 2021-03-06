//////////////////////////////////////////////////////////////////////////////////
// Company:   
// Engineer: Ruige_Lee
// Create Date: 2019-04-01 16:33:19
// Last Modified by:   Ruige_Lee
// Last Modified time: 2019-04-21 17:52:22
// Email: 295054118@whut.edu.cn
// Design Name:   
// Module Name: e203_ifu
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
//  The IFU to implement entire instruction fetch unit.
//
// ====================================================================
`include "e203_defines.v"

module e203_ifu(

	input  [`E203_PC_SIZE-1:0] pc_rtvec,  
	
	//////////////////////////////////////////////////////////////
	//////////////////////////////////////////////////////////////
	// The IR stage to EXU interface
	output [`E203_INSTR_SIZE-1:0] ifu_o_ir,// The instruction register
	output [`E203_PC_SIZE-1:0] ifu_o_pc,   // The PC register along with
	output ifu_o_pc_vld,

	output [`E203_RFIDX_WIDTH-1:0] ifu_o_rs1idx,
	output [`E203_RFIDX_WIDTH-1:0] ifu_o_rs2idx,
	output ifu_o_prdt_taken,               // The Bxx is predicted as taken
	output ifu_o_muldiv_b2b,               
	output ifu_o_valid, // Handshake signals with EXU stage
	input  ifu_o_ready,

// output  pipe_flush_ack,
	input   pipe_flush_req,
	input   [`E203_PC_SIZE-1:0] pipe_flush_add_op1,  
	input   [`E203_PC_SIZE-1:0] pipe_flush_add_op2,
	`ifdef E203_TIMING_BOOST//}
	input   [`E203_PC_SIZE-1:0] pipe_flush_pc,  
	`endif//}

			
	// The halt request come from other commit stage
	//   If the ifu_halt_req is asserting, then IFU will stop fetching new 
	//     instructions and after the oustanding transactions are completed,
	//     asserting the ifu_halt_ack as the response.
	//   The IFU will resume fetching only after the ifu_halt_req is deasserted
	input  ifu_halt_req,
	output ifu_halt_ack,

	input  oitf_empty,
	input  [`E203_XLEN-1:0] rf2ifu_x1,
	input  [`E203_XLEN-1:0] rf2ifu_rs1,
	input  dec2ifu_rden,
	input  dec2ifu_rs1en,
	input  [`E203_RFIDX_WIDTH-1:0] dec2ifu_rdidx,
	input  dec2ifu_mulhsu,
	input  dec2ifu_div   ,
	input  dec2ifu_rem   ,
	input  dec2ifu_divu  ,
	input  dec2ifu_remu  ,

	input  clk,
	input  rst_n
	);





	
	wire ifu_req_valid; 
	wire ifu_req_ready; 
	wire [`E203_PC_SIZE-1:0]   ifu_req_pc; 
	// wire ifu_req_seq;
	// wire ifu_req_seq_rv32;
	// wire [`E203_PC_SIZE-1:0] ifu_req_last_pc;
	wire ifu_rsp_valid; 
	wire ifu_rsp_ready; 
	// wire ifu_rsp_err;    
	wire [`E203_INSTR_SIZE-1:0] ifu_rsp_instr; 





(* DONT_TOUCH = "TRUE" *)
	e203_ifu_ifetch u_e203_ifu_ifetch(

		.pc_rtvec      (pc_rtvec),  
.ifu_req_valid (ifu_req_valid),
.ifu_req_ready (ifu_req_ready),
.ifu_req_pc    (ifu_req_pc   ),

.ifu_rsp_valid (ifu_rsp_valid),
.ifu_rsp_ready (ifu_rsp_ready),
.ifu_rsp_instr (ifu_rsp_instr),


		.ifu_o_ir      (ifu_o_ir     ),
		.ifu_o_pc      (ifu_o_pc     ),
		.ifu_o_pc_vld  (ifu_o_pc_vld ),
		.ifu_o_rs1idx  (ifu_o_rs1idx),
		.ifu_o_rs2idx  (ifu_o_rs2idx),
		.ifu_o_prdt_taken(ifu_o_prdt_taken),
		.ifu_o_muldiv_b2b(ifu_o_muldiv_b2b),
		.ifu_o_valid   (ifu_o_valid  ),
		.ifu_o_ready   (ifu_o_ready  ),
// .pipe_flush_ack     (pipe_flush_ack    ), 
		.pipe_flush_req     (pipe_flush_req    ),
		.pipe_flush_add_op1 (pipe_flush_add_op1),     
	`ifdef E203_TIMING_BOOST//}
		.pipe_flush_pc      (pipe_flush_pc),  
	`endif//}
		.pipe_flush_add_op2 (pipe_flush_add_op2), 
		.ifu_halt_req  (ifu_halt_req ),
		.ifu_halt_ack  (ifu_halt_ack ),

		.oitf_empty    (oitf_empty   ),
		.rf2ifu_x1     (rf2ifu_x1    ),
		.rf2ifu_rs1    (rf2ifu_rs1   ),
		.dec2ifu_rden  (dec2ifu_rden ),
		.dec2ifu_rs1en (dec2ifu_rs1en),
		.dec2ifu_rdidx (dec2ifu_rdidx),
		.dec2ifu_mulhsu(dec2ifu_mulhsu),
		.dec2ifu_div   (dec2ifu_div   ),
		.dec2ifu_rem   (dec2ifu_rem   ),
		.dec2ifu_divu  (dec2ifu_divu  ),
		.dec2ifu_remu  (dec2ifu_remu  ),

		.clk           (clk          ),
		.rst_n         (rst_n        ) 
	);


(* DONT_TOUCH = "TRUE" *)
	e203_ifu_ift2itcm u_e203_ifu_ift2itcm (
		.ifu_req_valid (ifu_req_valid),
		.ifu_req_ready (ifu_req_ready),
		.ifu_req_pc    (ifu_req_pc   ),

		.ifu_rsp_valid (ifu_rsp_valid),
		.ifu_rsp_ready (ifu_rsp_ready),
		.ifu_rsp_instr (ifu_rsp_instr),


		.clk           (clk          ),
		.rst_n         (rst_n        ) 
	);

	
endmodule

