//////////////////////////////////////////////////////////////////////////////////
// Company:   
// Engineer: Ruige_Lee
// Create Date: 2019-02-17 17:25:12
// Last Modified by:   Ruige_Lee
// Last Modified time: 2019-04-21 16:57:55
// Email: 295054118@whut.edu.cn
// Design Name:   
// Module Name: e203_cpu_top
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
// Create Date: 2019-01-28 20:59:01
// Last Modified by:   29505
// Last Modified time: 2019-02-01 18:20:14
// Email: 295054118@whut.edu.cn
// Design Name: e203_cpu_top.v  
// Module Name: e203_cpu_top
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
//  The CPU-TOP module to implement CPU and SRAMs
//
// ====================================================================

`include "e203_defines.v"

module e203_cpu_top(

	output inspect_dbg_irq,

	output inspect_core_clk,

	output core_csr_clk,

	

	// If this signal is high, then indicate the Core have executed WFI instruction
	//   and entered into the sleep state
	output core_wfi,

	// This signal is from our self-defined COUNTERSTOP (0xBFF) CSR's TM field
	//   software can programe this CSR to turn off the MTIME timer to save power
	// If this signal is high, then the MTIME timer from CLINT module will stop counting
	output tm_stop,

	// This signal can be used to indicate the PC value for the core after reset
	input  [`E203_PC_SIZE-1:0] pc_rtvec,

	///////////////////////////////////////
	// The interface to Debug Module: Begin
	//
	// The synced debug interrupt back to Debug module 
	output  dbg_irq_r,

	// The debug mode CSR registers control interface from/to Debug module
	output  [`E203_PC_SIZE-1:0] cmt_dpc,
	output  cmt_dpc_ena,
	output  [3-1:0] cmt_dcause,
	output  cmt_dcause_ena,
	output  wr_dcsr_ena    ,
	output  wr_dpc_ena     ,
	output  wr_dscratch_ena,
	output  [32-1:0] wr_csr_nxt    ,
	input  [32-1:0] dcsr_r    ,
	input  [`E203_PC_SIZE-1:0] dpc_r     ,
	input  [32-1:0] dscratch_r,

	// The debug mode control signals from Debug Module
	input  dbg_mode,
	input  dbg_halt_r,
	input  dbg_step_r,
	input  dbg_ebreakm_r,
	input  dbg_stopcycle,
	input  dbg_irq_a,
	// The interface to Debug Module: End


	// This signal can be used to indicate the HART ID for this core
	input  [`E203_HART_ID_W-1:0] core_mhartid,  

	// The External Interrupt signal from PLIC
	input  ext_irq_a,
	// The Software Interrupt signal from CLINT
	input  sft_irq_a,
	// The Timer Interrupt signal from CLINT
	input  tmr_irq_a,
  	
	// The CLINT Interface (ICB): Begin
	output                         clint_icb_cmd_valid,
	input                          clint_icb_cmd_ready,
	output [`E203_ADDR_SIZE-1:0]   clint_icb_cmd_addr, 
	output                         clint_icb_cmd_read, 
	output [`E203_XLEN-1:0]        clint_icb_cmd_wdata,
	output [`E203_XLEN/8-1:0]      clint_icb_cmd_wmask,
	//
	//    * Bus RSP channel
	input                          clint_icb_rsp_valid,
	output                         clint_icb_rsp_ready,
	input                          clint_icb_rsp_err  ,
	input  [`E203_XLEN-1:0]        clint_icb_rsp_rdata,
	// The CLINT Interface (ICB): End

	//////////////////////////////////////////////////////////////
	// The PLIC Interface (ICB): Begin
	output                         plic_icb_cmd_valid,
	input                          plic_icb_cmd_ready,
	output [`E203_ADDR_SIZE-1:0]   plic_icb_cmd_addr, 
	output                         plic_icb_cmd_read, 
	output [`E203_XLEN-1:0]        plic_icb_cmd_wdata,
	output [`E203_XLEN/8-1:0]      plic_icb_cmd_wmask,
	//
	//    * Bus RSP channel
	input                          plic_icb_rsp_valid,
	output                         plic_icb_rsp_ready,
	input                          plic_icb_rsp_err  ,
	input  [`E203_XLEN-1:0]        plic_icb_rsp_rdata,
	// The PLIC Interface (ICB): End

	// The Clock
	input  clk,

	// The low-level active reset signal, treated as async
	input  rst_n
);





`ifndef E203_HAS_LOCKSTEP//{

	wire plic_icb_rsp_excl_ok  ;
	wire clint_icb_rsp_excl_ok ;


`ifdef E203_HAS_PLIC
	wire plic_icb_enable;
	wire [`E203_ADDR_SIZE-1:0] plic_region_indic;
`endif

`ifdef E203_HAS_CLINT
	wire clint_icb_enable;
	wire [`E203_ADDR_SIZE-1:0] clint_region_indic;
`endif


`endif//}


	assign plic_icb_rsp_excl_ok  = 1'b0;
	assign clint_icb_rsp_excl_ok = 1'b0;


	`ifdef E203_HAS_PLIC
	assign plic_icb_enable = 1'b1;
	assign plic_region_indic = `E203_PLIC_ADDR_BASE;
	`else
	assign plic_icb_enable = 1'b0;
	`endif

	`ifdef E203_HAS_CLINT
	assign clint_icb_enable = 1'b1;
	assign clint_region_indic = `E203_CLINT_ADDR_BASE;
	`else
	assign clint_icb_enable = 1'b0;
	`endif



e203_cpu #(.MASTER(1)) u_e203_cpu(
	.inspect_dbg_irq          (inspect_dbg_irq      ),

	.inspect_core_clk         (inspect_core_clk     ),


	.core_csr_clk          (core_csr_clk      ),


	.tm_stop (tm_stop),
	.pc_rtvec(pc_rtvec),

	.core_wfi        (core_wfi),
	.dbg_irq_r       (dbg_irq_r      ),

	.cmt_dpc         (cmt_dpc        ),
	.cmt_dpc_ena     (cmt_dpc_ena    ),
	.cmt_dcause      (cmt_dcause     ),
	.cmt_dcause_ena  (cmt_dcause_ena ),

	.wr_dcsr_ena     (wr_dcsr_ena    ),
	.wr_dpc_ena      (wr_dpc_ena     ),
	.wr_dscratch_ena (wr_dscratch_ena),


									 
	.wr_csr_nxt      (wr_csr_nxt    ),
									 
	.dcsr_r          (dcsr_r         ),
	.dpc_r           (dpc_r          ),
	.dscratch_r      (dscratch_r     ),

	.dbg_mode        (dbg_mode),
	.dbg_halt_r      (dbg_halt_r),
	.dbg_step_r      (dbg_step_r),
	.dbg_ebreakm_r   (dbg_ebreakm_r),
	.dbg_stopcycle   (dbg_stopcycle),

	.core_mhartid    (core_mhartid),  
	.dbg_irq_a       (dbg_irq_a),
	.ext_irq_a       (ext_irq_a),
	.sft_irq_a       (sft_irq_a),
	.tmr_irq_a       (tmr_irq_a),

	.clint_region_indic      (clint_region_indic),
	.clint_icb_enable        (clint_icb_enable),
	.clint_icb_cmd_valid     (clint_icb_cmd_valid),
	.clint_icb_cmd_ready     (clint_icb_cmd_ready),
	.clint_icb_cmd_addr      (clint_icb_cmd_addr ),
	.clint_icb_cmd_read      (clint_icb_cmd_read ),
	.clint_icb_cmd_wdata     (clint_icb_cmd_wdata),
	.clint_icb_cmd_wmask     (clint_icb_cmd_wmask),
	.clint_icb_cmd_lock      (),
	.clint_icb_cmd_excl      (),
	.clint_icb_cmd_size      (),
	
	.clint_icb_rsp_valid     (clint_icb_rsp_valid),
	.clint_icb_rsp_ready     (clint_icb_rsp_ready),
	.clint_icb_rsp_err       (clint_icb_rsp_err  ),
	.clint_icb_rsp_excl_ok   (clint_icb_rsp_excl_ok  ),
	.clint_icb_rsp_rdata     (clint_icb_rsp_rdata),

	.plic_region_indic      (plic_region_indic),
	.plic_icb_enable        (plic_icb_enable),
	.plic_icb_cmd_valid     (plic_icb_cmd_valid),
	.plic_icb_cmd_ready     (plic_icb_cmd_ready),
	.plic_icb_cmd_addr      (plic_icb_cmd_addr ),
	.plic_icb_cmd_read      (plic_icb_cmd_read ),
	.plic_icb_cmd_wdata     (plic_icb_cmd_wdata),
	.plic_icb_cmd_wmask     (plic_icb_cmd_wmask),
	.plic_icb_cmd_lock      (),
	.plic_icb_cmd_excl      (),
	.plic_icb_cmd_size      (),
	
	.plic_icb_rsp_valid     (plic_icb_rsp_valid),
	.plic_icb_rsp_ready     (plic_icb_rsp_ready),
	.plic_icb_rsp_err       (plic_icb_rsp_err  ),
	.plic_icb_rsp_excl_ok   (plic_icb_rsp_excl_ok  ),
	.plic_icb_rsp_rdata     (plic_icb_rsp_rdata),




`ifndef E203_HAS_LOCKSTEP//{
`endif//}
	.rst_n         (rst_n),
	.clk           (clk  ) 

  );



		

		 


endmodule
