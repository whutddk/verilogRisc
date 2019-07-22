//////////////////////////////////////////////////////////////////////////////////
// Company:   
// Engineer: Ruige_Lee
// Create Date: 2019-04-12 16:13:12
// Last Modified by:   29505
// Last Modified time: 2019-05-25 09:43:19
// Email: 295054118@whut.edu.cn
// page: https://whutddk.github.io/
// Design Name: e203_subsys_main.v  
// Module Name: e203_subsys_main
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
//////////////////////////////////////////////////////////////////////////////////
// Company:   
// Engineer: Ruige_Lee
// Create Date: 2019-02-17 17:25:12
// Last Modified by:   Ruige_Lee
// Last Modified time: 2019-04-21 16:57:36
// Email: 295054118@whut.edu.cn
// Design Name:   
// Module Name: e203_subsys_main
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

//////////////////////////////////////////////////////////////////////////////////
// Company:    
// Engineer: 29505
// Create Date: 2019-01-31 17:35:43
// Last Modified by:   29505
// Last Modified time: 2019-02-01 22:12:12
// Email: 295054118@whut.edu.cn
// Design Name: e203_subsys_main.v  
// Module Name: e203_subsys_main
// Project Name:    
// Target Devices:    
// Tool Versions:    
// Description:    
// 
// Dependencies:    
// 
// Revision:   
// Revision  
// Additional Comments:   
// 
//////////////////////////////////////////////////////////////////////////////////
/*
* @File Name: e203_subsys_main.v
* @File Path: K:\work\dark+PRJ\e200_opensource\rtl\e203\subsys\e203_subsys_main.v
* @Author: 29505
* @Date:   2019-01-31 17:35:43
* @Last Modified by:   29505
* @Last Modified time: 2019-01-31 18:42:10
* @Email: 295054118@whut.edu.cn
*/ 

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
//  The Subsystem-TOP module to implement CPU and some closely coupled devices
//
// ====================================================================


`include "e203_defines.v"


module e203_subsys_main(

	input  [`E203_PC_SIZE-1:0] pc_rtvec,
 

	input  [32-1:0] dcsr_r,
	input  [`E203_PC_SIZE-1:0] dpc_r,
	input  [32-1:0] dscratch_r,

	input  corerst, // The original async reset
	input  hfclkrst, // The original async reset
	input  hfextclk,// The original clock from crystal
	output hfclk // The generated clock by HCLKGEN

  );

	wire inspect_core_clk;
	wire inspect_pll_clk;
	wire inspect_16m_clk;


	//This is to reset the main domain
	wire main_rst;
sirv_ResetCatchAndSync_2 u_main_ResetCatchAndSync_2_1 (
	.test_mode(test_mode),
	.clock(hfclk),
	.reset(corerst),
	.io_sync_reset(main_rst)
);

	wire main_rst_n = ~main_rst;

	assign hfclk = hfextclk;

	// wire tcm_ds = 1'b0;// Currently we dont support it
	// wire tcm_sd = 1'b0;// Currently we dont support it

`ifndef E203_HAS_LOCKSTEP//{
  wire core_rst_n = main_rst_n;
  wire bus_rst_n  = main_rst_n;
  wire per_rst_n  = main_rst_n;
`endif//}



	wire                         clint_icb_cmd_valid;
	wire                         clint_icb_cmd_ready;
	wire [`E203_ADDR_SIZE-1:0]   clint_icb_cmd_addr; 
	wire                         clint_icb_cmd_read; 
	wire [`E203_XLEN-1:0]        clint_icb_cmd_wdata;
	wire [`E203_XLEN/8-1:0]      clint_icb_cmd_wmask;

	wire                         clint_icb_rsp_valid;
	wire                         clint_icb_rsp_ready;
	wire                         clint_icb_rsp_err  ;
	wire [`E203_XLEN-1:0]        clint_icb_rsp_rdata;

  
	wire                         plic_icb_cmd_valid;
	wire                         plic_icb_cmd_ready;
	wire [`E203_ADDR_SIZE-1:0]   plic_icb_cmd_addr; 
	wire                         plic_icb_cmd_read; 
	wire [`E203_XLEN-1:0]        plic_icb_cmd_wdata;
	wire [`E203_XLEN/8-1:0]      plic_icb_cmd_wmask;

	wire                         plic_icb_rsp_valid;
	wire                         plic_icb_rsp_ready;
	wire                         plic_icb_rsp_err  ;
	wire [`E203_XLEN-1:0]        plic_icb_rsp_rdata;



	wire  plic_ext_irq;
	wire  clint_sft_irq;
	wire  clint_tmr_irq;

	wire tm_stop;


	wire core_wfi;



e203_cpu_top u_e203_cpu_top(
	.inspect_dbg_irq          (),
	.inspect_core_clk         (inspect_core_clk),

	.tm_stop         (tm_stop),
	.pc_rtvec        (pc_rtvec),

	// .tcm_sd          (tcm_sd),
	// .tcm_ds          (tcm_ds),
	
	.core_wfi        (core_wfi),

	.dbg_irq_r       (),

	.cmt_dpc         (),
	.cmt_dpc_ena     (),
	.cmt_dcause      (),
	.cmt_dcause_ena  (),

	.wr_dcsr_ena     (),
	.wr_dpc_ena      (),
	.wr_dscratch_ena (),
								 
	.wr_csr_nxt      (),
									 
	.dcsr_r          (32'b0),
	.dpc_r           ({`E203_PC_SIZE{0}}),
	.dscratch_r      (32'b0),

	// .dbg_mode        (1'b0),
	// .dbg_halt_r      (1'b0),
	// .dbg_step_r      (1'b0),
	// .dbg_ebreakm_r   (1'b0),
	// .dbg_stopcycle   (1'b0),

	.core_mhartid            (1'b0),  
	// .dbg_irq_a               (1'b0),
	.ext_irq_a               (plic_ext_irq),
	.sft_irq_a               (clint_sft_irq),
	.tmr_irq_a               (clint_tmr_irq),

	.plic_icb_cmd_valid     (plic_icb_cmd_valid),
	.plic_icb_cmd_ready     (plic_icb_cmd_ready),
	.plic_icb_cmd_addr      (plic_icb_cmd_addr ),
	.plic_icb_cmd_read      (plic_icb_cmd_read ),
	.plic_icb_cmd_wdata     (plic_icb_cmd_wdata),
	.plic_icb_cmd_wmask     (plic_icb_cmd_wmask),
	
	.plic_icb_rsp_valid     (plic_icb_rsp_valid),
	.plic_icb_rsp_ready     (plic_icb_rsp_ready),
	.plic_icb_rsp_err       (plic_icb_rsp_err  ),
	.plic_icb_rsp_rdata     (plic_icb_rsp_rdata),

	.clint_icb_cmd_valid     (clint_icb_cmd_valid),
	.clint_icb_cmd_ready     (clint_icb_cmd_ready),
	.clint_icb_cmd_addr      (clint_icb_cmd_addr ),
	.clint_icb_cmd_read      (clint_icb_cmd_read ),
	.clint_icb_cmd_wdata     (clint_icb_cmd_wdata),
	.clint_icb_cmd_wmask     (clint_icb_cmd_wmask),
	
	.clint_icb_rsp_valid     (clint_icb_rsp_valid),
	.clint_icb_rsp_ready     (clint_icb_rsp_ready),
	.clint_icb_rsp_err       (clint_icb_rsp_err  ),
	.clint_icb_rsp_rdata     (clint_icb_rsp_rdata),

	.clk           (hfclk  ),
	.rst_n         (core_rst_n) 
);


e203_subsys_plic u_e203_subsys_plic(
	.plic_icb_cmd_valid     (plic_icb_cmd_valid),
	.plic_icb_cmd_ready     (plic_icb_cmd_ready),
	.plic_icb_cmd_addr      (plic_icb_cmd_addr ),
	.plic_icb_cmd_read      (plic_icb_cmd_read ),
	.plic_icb_cmd_wdata     (plic_icb_cmd_wdata),
	.plic_icb_cmd_wmask     (plic_icb_cmd_wmask),
	
	.plic_icb_rsp_valid     (plic_icb_rsp_valid),
	.plic_icb_rsp_ready     (plic_icb_rsp_ready),
	.plic_icb_rsp_err       (plic_icb_rsp_err  ),
	.plic_icb_rsp_rdata     (plic_icb_rsp_rdata),

	.plic_ext_irq           (plic_ext_irq),
	.clk                    (hfclk  ),
	.rst_n                  (per_rst_n) 
);

e203_subsys_clint u_e203_subsys_clint(
	.tm_stop                 (tm_stop),

	.clint_icb_cmd_valid     (clint_icb_cmd_valid),
	.clint_icb_cmd_ready     (clint_icb_cmd_ready),
	.clint_icb_cmd_addr      (clint_icb_cmd_addr ),
	.clint_icb_cmd_read      (clint_icb_cmd_read ),
	.clint_icb_cmd_wdata     (clint_icb_cmd_wdata),
	.clint_icb_cmd_wmask     (clint_icb_cmd_wmask),
	
	.clint_icb_rsp_valid     (clint_icb_rsp_valid),
	.clint_icb_rsp_ready     (clint_icb_rsp_ready),
	.clint_icb_rsp_err       (clint_icb_rsp_err  ),
	.clint_icb_rsp_rdata     (clint_icb_rsp_rdata),

	.clint_tmr_irq           (clint_tmr_irq),
	.clint_sft_irq           (clint_sft_irq),

	.aon_rtcToggle_a         (1'b0),

	.clk           (hfclk  ),
	.rst_n         (per_rst_n) 
);

 

endmodule
