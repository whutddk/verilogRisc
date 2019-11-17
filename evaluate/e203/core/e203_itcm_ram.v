//////////////////////////////////////////////////////////////////////////////////
// Company:   
// Engineer: Ruige_Lee
// Create Date: 2019-06-25 19:07:21
// Last Modified by:   Ruige_Lee
// Last Modified time: 2019-06-29 10:00:45
// Email: 295054118@whut.edu.cn
// page: https://whutddk.github.io/
// Design Name:   
// Module Name: e203_itcm_ram
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
// Designer   : Bob Hu
//
// Description:
//  The ITCM-SRAM module to implement ITCM SRAM
//
// ====================================================================

`include "e203_defines.v"

	`ifdef E203_HAS_ITCM //{
module e203_itcm_ram(

	input                              sd,
	input                              ds,
	input                              ls,

	input                              cs,  
	input                              we,  
	input  [`E203_ITCM_RAM_AW-1:0] addr, 
	input  [`E203_ITCM_RAM_MW-1:0] wem,
	input  [`E203_ITCM_RAM_DW-1:0] din,          
	output [`E203_ITCM_RAM_DW-1:0] dout,
	input                              rst_n,
	input                              clk

);

 
	sirv_gnrl_ram #(
			`ifndef E203_HAS_ECC//{
		.FORCE_X2ZERO(0),
			`endif//}
		.DP(`E203_ITCM_RAM_DP),
		.DW(`E203_ITCM_RAM_DW),
		.MW(`E203_ITCM_RAM_MW),
		.AW(`E203_ITCM_RAM_AW) 
	) u_e203_itcm_gnrl_ram(
	.sd  (sd  ),
	.ds  (ds  ),
	.ls  (ls  ),

	.rst_n (rst_n ),
	.clk (clk ),
	.cs  (cs  ),
	.we  (we  ),
	.addr(addr),
	.din (din ),
	.wem (wem ),
	.dout(dout)
	);
																											
endmodule
	`endif//}
