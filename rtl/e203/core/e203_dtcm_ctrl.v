//////////////////////////////////////////////////////////////////////////////////
// Company:   
// Engineer: Ruige_Lee
// Create Date: 2019-02-17 17:25:12
// Last Modified by:   Ruige_Lee
// Last Modified time: 2019-04-23 17:41:27
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
	// Note: The data on rdata or wdata channel must be naturally aligned, this is in line with the AXI definition
	input  [`E203_DTCM_ADDR_WIDTH-1:0]   lsu2dtcm_icb_cmd_addr, // Bus transaction start addr 
	input  lsu2dtcm_icb_cmd_read,   // Read or write
	input  [32-1:0] lsu2dtcm_icb_cmd_wdata, 
	input  [4-1:0] lsu2dtcm_icb_cmd_wmask, 

	//    * Bus RSP channel
	output lsu2dtcm_icb_rsp_valid, // Response valid 
	input  lsu2dtcm_icb_rsp_ready, // Response ready
	output lsu2dtcm_icb_rsp_err,   // Response error
						// Note: the RSP rdata is inline with AXI definition
	output [32-1:0] lsu2dtcm_icb_rsp_rdata, 

	input  clk,
	input  rst_n
	);

	wire clk_dtcm_ram;


	// wire sram_icb_cmd_ready;
// wire sram_icb_cmd_valid;
	// wire [`E203_DTCM_ADDR_WIDTH-1:0] sram_icb_cmd_addr;
	// wire sram_icb_cmd_read;
	// wire [`E203_DTCM_DATA_WIDTH-1:0] sram_icb_cmd_wdata;
	wire [`E203_DTCM_WMSK_WIDTH-1:0] sram_icb_cmd_wmask;


	wire sram_icb_rsp_valid;
	wire sram_icb_rsp_ready;
	// wire [`E203_DTCM_DATA_WIDTH-1:0] sram_icb_rsp_rdata;



	//LSU take higher priority
	assign sram_icb_cmd_valid = lsu2dtcm_icb_cmd_valid;
	// assign sram_icb_cmd_addr = lsu2dtcm_icb_cmd_addr;
	// assign sram_icb_cmd_read = lsu2dtcm_icb_cmd_read;
	// assign sram_icb_cmd_wdata = lsu2dtcm_icb_cmd_wdata;
	assign sram_icb_cmd_wmask = lsu2dtcm_icb_cmd_wmask;
	assign lsu2dtcm_icb_cmd_ready = lsu2dtcm_icb_rsp_ready;


	assign lsu2dtcm_icb_rsp_valid = sram_icb_rsp_valid;
	assign lsu2dtcm_icb_rsp_err = 1'b0;
	assign lsu2dtcm_icb_rsp_rdata = ram_dout;
	assign sram_icb_rsp_ready = lsu2dtcm_icb_rsp_ready;




// 	sirv_sram_icb_ctrl #(
// 		.DW     (`E203_DTCM_DATA_WIDTH),
// 		.AW     (`E203_DTCM_ADDR_WIDTH),
// 		.MW     (`E203_DTCM_WMSK_WIDTH),
// 		.AW_LSB (2),// DTCM is 32bits wide, so the LSB is 2
// 		.USR_W  (1) 
// 	) u_sram_icb_ctrl (
// 		.sram_ctrl_active (),
// 		// .tcm_cgstop       (tcm_cgstop),
		 
// 		.i_icb_cmd_valid (sram_icb_cmd_valid),
// 		.i_icb_cmd_ready (sram_icb_cmd_ready),
// 		.i_icb_cmd_read  (sram_icb_cmd_read ),
// 		.i_icb_cmd_addr  (sram_icb_cmd_addr ), 
// 		.i_icb_cmd_wdata (sram_icb_cmd_wdata), 
// 		.i_icb_cmd_wmask (sram_icb_cmd_wmask), 
// 		.i_icb_cmd_usr   (sram_icb_cmd_read ),
	
// 		.i_icb_rsp_valid (sram_icb_rsp_valid),
// 		.i_icb_rsp_ready (sram_icb_rsp_ready),
// 		.i_icb_rsp_rdata (sram_icb_rsp_rdata),
// 		.i_icb_rsp_usr   (),
	
// 		.ram_cs   (dtcm_ram_cs  ),  
// 		.ram_we   (dtcm_ram_we  ),  
// 		.ram_addr (dtcm_ram_addr), 
// 		.ram_wem  (dtcm_ram_wem ),
// 		.ram_din  (dtcm_ram_din ),          
// 		.ram_dout (dtcm_ram_dout),
// 		.clk_ram  (clk_dtcm_ram ),
	
// 		.test_mode(1'b0),
// 		.clk  (clk  ),
// 		.rst_n(rst_n)  
// 	);



// (* DONT_TOUCH = "TRUE" *)
// 	e203_dtcm_ram u_e203_dtcm_ram (
// 		.cs   (dtcm_ram_cs),
// 		.we   (dtcm_ram_we),
// 		.addr (dtcm_ram_addr),
// 		.wem  (dtcm_ram_wem),
// 		.din  (dtcm_ram_din),
// 		.dout (dtcm_ram_dout),
// 		.rst_n(rst_n),
// 		.clk  (clk_dtcm_ram)
// 	);

	wire ram_cs = lsu2dtcm_icb_cmd_valid & lsu2dtcm_icb_rsp_ready;  
	wire ram_we = (~lsu2dtcm_icb_cmd_read);  
	wire ram_addr = lsu2dtcm_icb_cmd_addr [`E203_DTCM_ADDR_WIDTH-1:2];          
// assign ram_wem = uop_cmd_wmask[`E203_DTCM_WMSK_WIDTH-1:0];          
	wire ram_din = lsu2dtcm_icb_cmd_wdata[`E203_DTCM_DATA_WIDTH-1:0];  
	wire ram_dout; 
	assign sram_icb_rsp_rdata = ram_dout;

i_dtcm_ram dtcm_ram(
		.addra(ram_addr)
		.clka(clk_dtcm_ram)
		.dina(ram_din)
		.douta(ram_dout)
		.ena(ram_cs)
		.wea(ram_we)
	);



endmodule

