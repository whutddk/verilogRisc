//////////////////////////////////////////////////////////////////////////////////
// Company:   
// Engineer: Ruige_Lee
// Create Date: 2019-02-17 17:25:12
// Last Modified by:   Ruige_Lee
// Last Modified time: 2019-04-23 19:39:08
// Email: 295054118@whut.edu.cn
// Design Name:   
// Module Name: e203_dtcm_ctrl
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
//  The dtcm_ctrl module control the DTCM access requests 
//
// ====================================================================
`include "e203_defines.v"



module e203_dtcm_ctrl(
	// output dtcm_active,
	// The cgstop is coming from CSR (0xBFE mcgstop)'s filed 1
	// // This register is our self-defined CSR register to disable the 
	// DTCM SRAM clock gating for debugging purpose
	// input  tcm_cgstop,
	// Note: the DTCM ICB interface only support the single-transaction
	
	//////////////////////////////////////////////////////////////
	//////////////////////////////////////////////////////////////
	// LSU ICB to DTCM
	//    * Bus cmd channel
	input  lsu2dtcm_icb_cmd_valid, // Handshake valid
	output lsu2dtcm_icb_cmd_ready, // Handshake ready
	input  [`E203_DTCM_ADDR_WIDTH-1:0]   lsu2dtcm_icb_cmd_addr, // Bus transaction start addr 
	input  lsu2dtcm_icb_cmd_read,   // Read or write
	input  [32-1:0] lsu2dtcm_icb_cmd_wdata, 
	input  [4-1:0] lsu2dtcm_icb_cmd_wmask, 

	//    * Bus RSP channel
	output lsu2dtcm_icb_rsp_valid, // Response valid 
	input  lsu2dtcm_icb_rsp_ready, // Response ready
	output lsu2dtcm_icb_rsp_err,   // Response error
						// Note: the RSP rdata is inline with AXI definition
	output [31:0] lsu2dtcm_icb_rsp_rdata, 

	input  clk,
	input  rst_n
	);




	// assign lsu2dtcm_icb_cmd_ready = lsu2dtcm_icb_rsp_ready;
	// assign lsu2dtcm_icb_rsp_valid = lsu2dtcm_icb_cmd_valid;

	sirv_gnrl_dffr # (.DW(2)) (.dnxt({lsu2dtcm_icb_rsp_ready,lsu2dtcm_icb_cmd_valid}),.qout({lsu2dtcm_icb_cmd_ready,lsu2dtcm_icb_rsp_valid}),.clk(clk),.rst_n(rst_n));

	wire [31:0] ram_dout; 
	assign lsu2dtcm_icb_rsp_err = 1'b0;
	assign lsu2dtcm_icb_rsp_rdata = ram_dout;




	wire ram_cs = lsu2dtcm_icb_cmd_valid & lsu2dtcm_icb_rsp_ready;  
	wire ram_we = (~lsu2dtcm_icb_cmd_read);  
	wire [13:0] ram_addr = lsu2dtcm_icb_cmd_addr [`E203_DTCM_ADDR_WIDTH-1:2];                
	wire [31:0] ram_din = { 
							{8{lsu2dtcm_icb_cmd_wmask[3]}},
							{8{lsu2dtcm_icb_cmd_wmask[2]}},
							{8{lsu2dtcm_icb_cmd_wmask[1]}},
							{8{lsu2dtcm_icb_cmd_wmask[0]}}
						  } 
							& 
							lsu2dtcm_icb_cmd_wdata[31:0];
					



dtcm_ram i_dtcm_ram (
		.addra(ram_addr),
		.clka(clk),
		.dina(ram_din),
		.douta(ram_dout),
		.ena(ram_cs),
		.wea(ram_we)
	);



endmodule

