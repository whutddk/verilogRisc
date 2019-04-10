//////////////////////////////////////////////////////////////////////////////////
// Company:   
// Engineer: Ruige_Lee
// Create Date: 2019-02-17 17:25:12
// Last Modified by:   Ruige_Lee
// Last Modified time: 2019-04-10 16:33:31
// Email: 295054118@whut.edu.cn
// Design Name:   
// Module Name: e203_itcm_ctrl
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
//  The itcm_ctrl module control the ITCM access requests 
//
// ====================================================================
`include "e203_defines.v"

module e203_itcm_ctrl(



	input  ifu2itcm_icb_cmd_valid,
	output ifu2itcm_icb_cmd_ready,
	input  [`E203_ITCM_ADDR_WIDTH-1:0] ifu2itcm_icb_cmd_addr,
	input  ifu2itcm_icb_cmd_read,

	output ifu2itcm_icb_rsp_valid,
	input  ifu2itcm_icb_rsp_ready,
	// output ifu2itcm_icb_rsp_err,
	output [`E203_ITCM_DATA_WIDTH-1:0] ifu2itcm_icb_rsp_rdata, 	
	output ifu2itcm_holdup,


	input  clk,
	input  rst_n
	);

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




	wire itcm_ram_cs;  
	wire itcm_ram_we;  
	wire [`E203_ITCM_RAM_AW-1:0] itcm_ram_addr; 
	wire [`E203_ITCM_RAM_MW-1:0] itcm_ram_wem;
	wire [`E203_ITCM_RAM_DW-1:0] itcm_ram_din;          
	wire [`E203_ITCM_RAM_DW-1:0] itcm_ram_dout;
	// wire clk_itcm_ram;

	// assign ifu2itcm_icb_rsp_err   = 1'b0;

	wire ifu_holdup_r;
	// The IFU holdup will be set after last time accessed by a IFU access
	wire ifu_holdup_set =   ifu2itcm_icb_cmd_valid & itcm_ram_cs;
	// The IFU holdup will be cleared after last time accessed by a non-IFU access
	wire ifu_holdup_clr = (~ifu2itcm_icb_cmd_valid) & itcm_ram_cs;
	wire ifu_holdup_ena = ifu_holdup_set | ifu_holdup_clr;
	wire ifu_holdup_nxt = ifu_holdup_set & (~ifu_holdup_clr);
	sirv_gnrl_dfflr #(1)ifu_holdup_dffl(ifu_holdup_ena, ifu_holdup_nxt, ifu_holdup_r, clk_itcm, rst_n);
	assign ifu2itcm_holdup = ifu_holdup_r ;
	  

	wire itcm_active = ifu2itcm_icb_cmd_valid;

	e203_itcm_ram u_e203_itcm_ram (
		.cs   (itcm_ram_cs),
		.we   (itcm_ram_we),
		.addr (itcm_ram_addr),
		.wem  (itcm_ram_wem),
		.din  (itcm_ram_din),
		.dout (itcm_ram_dout),
		.rst_n(rst_n),
		.clk  (clk_itcm)
	);





	assign itcm_ram_cs = ifu2itcm_icb_cmd_valid & ifu2itcm_icb_cmd_ready;  
	assign itcm_ram_we = ( ~ifu2itcm_icb_cmd_read );  
	assign itcm_ram_addr = ifu2itcm_icb_cmd_addr [15:3];          
	assign itcm_ram_wem = {`E203_ITCM_DATA_WIDTH/8{1'b0}};          
	assign itcm_ram_din = {`E203_ITCM_DATA_WIDTH{1'b0}}; 
	assign uop_rsp_rdata = itcm_ram_dout;


endmodule



	

