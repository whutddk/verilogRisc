//////////////////////////////////////////////////////////////////////////////////
// Company:   
// Engineer: Ruige_Lee
// Create Date: 2019-02-17 17:25:12
// Last Modified by:   Ruige_Lee
// Last Modified time: 2019-04-08 11:36:44
// Email: 295054118@whut.edu.cn
// Design Name:   
// Module Name: e203_clk_ctrl
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
//  The Clock Ctrl module to implement Clock control
//
// ====================================================================

`include "e203_defines.v"

module e203_clk_ctrl (
  input  clk,        // clock
  input  rst_n,      // async reset
  input  test_mode,  // test mode 

  // The cgstop is coming from CSR (0xBFE mcgstop)'s filed 0
  // // This register is our self-defined CSR register to disable the 
	  // automaticall clock gating for CPU logics for debugging purpose
  input  core_cgstop,

  // The Top always on clk and rst


  input  core_ifu_active,
  input  core_exu_active,
  input  core_lsu_active,
  input  core_biu_active,

  `ifdef E203_HAS_DTCM
  input  dtcm_active,
  output dtcm_ls,
  `endif
	// The core's clk and rst
  output clk_core_ifu,
  output clk_core_exu,
  output clk_core_lsu,
  output clk_core_biu,

	// The ITCM/DTCM clk and rst

  `ifdef E203_HAS_DTCM
  output clk_dtcm,
  `endif

  input  core_wfi
);

	// The CSR control bit CGSTOP will override the automatical clock gating here for special debug purpose

	// The IFU is always actively fetching unless it is WFI to override it
	wire ifu_clk_en = core_cgstop | (core_ifu_active & (~core_wfi));
	// The EXU, LSU and BIU module's clock gating does not need to check
	//  WFI because it may have request from external agent
	//  and also, it actually will automactically become inactive regardess
	//  currently is WFI or not, hence we dont need WFI here
	wire exu_clk_en = core_cgstop | (core_exu_active);
	wire lsu_clk_en = core_cgstop | (core_lsu_active);
	wire biu_clk_en = core_cgstop | (core_biu_active);




	e203_clkgate u_ifu_clkgate(
		.clk_in   (clk),
		.test_mode(test_mode  ),
		.clock_en (ifu_clk_en),
		.clk_out  (clk_core_ifu)
	);

  e203_clkgate u_exu_clkgate(
	.clk_in   (clk        ),
	.test_mode(test_mode  ),
	.clock_en (exu_clk_en),
	.clk_out  (clk_core_exu)
  );

  e203_clkgate u_lsu_clkgate(
	.clk_in   (clk        ),
	.test_mode(test_mode  ),
	.clock_en (lsu_clk_en),
	.clk_out  (clk_core_lsu)
  );

  e203_clkgate u_biu_clkgate(
	.clk_in   (clk        ),
	.test_mode(test_mode  ),
	.clock_en (biu_clk_en),
	.clk_out  (clk_core_biu)
  );



  `ifdef E203_HAS_DTCM
  wire dtcm_active_r;
  sirv_gnrl_dffr #(1)dtcm_active_dffr(dtcm_active, dtcm_active_r, clk, rst_n);
  wire dtcm_clk_en = core_cgstop | dtcm_active | dtcm_active_r;
  assign dtcm_ls = ~dtcm_clk_en;

  e203_clkgate u_dtcm_clkgate(
	.clk_in   (clk        ),
	.test_mode(test_mode  ),
	.clock_en (dtcm_clk_en),
	.clk_out  (clk_dtcm)
  );
  `endif



endmodule

