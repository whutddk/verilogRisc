//////////////////////////////////////////////////////////////////////////////////
// Company:   
// Engineer: Ruige_Lee
// Create Date: 2019-02-17 17:25:12
// Last Modified by:   Ruige_Lee
// Last Modified time: 2019-04-04 17:11:08
// Email: 295054118@whut.edu.cn
// Design Name:   
// Module Name: e203_cpu
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
// Last Modified time: 2019-02-01 20:40:43
// Email: 295054118@whut.edu.cn
// Design Name: e203_cpu.v  
// Module Name: e203_cpu
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
//  The CPU module to implement Core and other top level glue logics 
//
// ====================================================================

`include "e203_defines.v"

module e203_cpu #(
	parameter MASTER = 1
)
(
	output [`E203_PC_SIZE-1:0] inspect_pc,
	output inspect_dbg_irq,
	output inspect_core_clk,
	output core_csr_clk,

	// `ifdef E203_HAS_DTCM
	// output rst_dtcm,
	// `endif


	output  core_wfi,
	output  tm_stop,
	
	input  [`E203_PC_SIZE-1:0] pc_rtvec,

	///////////////////////////////////////
	// With the interface to debug module 
	//
	// The interface with commit stage
	output  [`E203_PC_SIZE-1:0] cmt_dpc,
	output  cmt_dpc_ena,

	output  [3-1:0] cmt_dcause,
	output  cmt_dcause_ena,

	output  dbg_irq_r,

	// The interface with CSR control 
	output  wr_dcsr_ena    ,
	output  wr_dpc_ena     ,
	output  wr_dscratch_ena,


	output  [32-1:0] wr_csr_nxt    ,

	input  [32-1:0] dcsr_r    ,
	input  [`E203_PC_SIZE-1:0] dpc_r     ,
	input  [32-1:0] dscratch_r,

	input  dbg_mode,
	input  dbg_halt_r,
	input  dbg_step_r,
	input  dbg_ebreakm_r,
	input  dbg_stopcycle,


	/////////////////////////////////////////////////////
	input [`E203_HART_ID_W-1:0] core_mhartid,  

	input  dbg_irq_a,
	input  ext_irq_a,
	input  sft_irq_a,
	input  tmr_irq_a,

	
	input [`E203_ADDR_SIZE-1:0]    clint_region_indic,
	input                          clint_icb_enable,

	output                         clint_icb_cmd_valid,
	input                          clint_icb_cmd_ready,
	output [`E203_ADDR_SIZE-1:0]   clint_icb_cmd_addr, 
	output                         clint_icb_cmd_read, 
	output [`E203_XLEN-1:0]        clint_icb_cmd_wdata,
	output [`E203_XLEN/8-1:0]      clint_icb_cmd_wmask,
	output                         clint_icb_cmd_lock,
	output                         clint_icb_cmd_excl,
	output [1:0]                   clint_icb_cmd_size,
	//
	//    * Bus RSP channel
	input                          clint_icb_rsp_valid,
	output                         clint_icb_rsp_ready,
	input                          clint_icb_rsp_err  ,
	input                          clint_icb_rsp_excl_ok  ,
	input  [`E203_XLEN-1:0]        clint_icb_rsp_rdata,

	input [`E203_ADDR_SIZE-1:0]    plic_region_indic,
	input                          plic_icb_enable,

	output                         plic_icb_cmd_valid,
	input                          plic_icb_cmd_ready,
	output [`E203_ADDR_SIZE-1:0]   plic_icb_cmd_addr, 
	output                         plic_icb_cmd_read, 
	output [`E203_XLEN-1:0]        plic_icb_cmd_wdata,
	output [`E203_XLEN/8-1:0]      plic_icb_cmd_wmask,
	output                         plic_icb_cmd_lock,
	output                         plic_icb_cmd_excl,
	output [1:0]                   plic_icb_cmd_size,
	//
	//    * Bus RSP channel
	input                          plic_icb_rsp_valid,
	output                         plic_icb_rsp_ready,
	input                          plic_icb_rsp_err  ,
	input                          plic_icb_rsp_excl_ok  ,
	input  [`E203_XLEN-1:0]        plic_icb_rsp_rdata,


	// `ifdef E203_HAS_DTCM
	// output dtcm_ls,

	// output                         dtcm_ram_cs,  
	// output                         dtcm_ram_we,  
	// output [`E203_DTCM_RAM_AW-1:0] dtcm_ram_addr, 
	// output [`E203_DTCM_RAM_MW-1:0] dtcm_ram_wem,
	// output [`E203_DTCM_RAM_DW-1:0] dtcm_ram_din,          
	// input  [`E203_DTCM_RAM_DW-1:0] dtcm_ram_dout,
	// output                         clk_dtcm_ram,
	// `endif//}

	input  clk,
	input  rst_n
	);

	wire core_cgstop;
	wire tcm_cgstop;
	
	wire core_ifu_active;
	wire core_exu_active;
	wire core_lsu_active;
	wire core_biu_active;
	
	// The core's clk and rst
	wire rst_core;
	wire clk_core_ifu;
	wire clk_core_exu;
	wire clk_core_lsu;
	wire clk_core_biu;
	
	// The ITCM/DTCM clk and rst
	`ifdef E203_HAS_ITCM
	wire clk_itcm;
	wire itcm_active;
	`endif
	`ifdef E203_HAS_DTCM
	wire clk_dtcm;
	wire dtcm_active;
	`endif

	// The Top always on clk and rst
	wire rst_aon;
	wire clk_aon;

	// The reset ctrl and clock ctrl should be in the power always-on domain


	wire rst_itcm;



e203_reset_ctrl #(.MASTER(MASTER)) u_e203_reset_ctrl (
	.clk        (clk_aon  ),
	.rst_n      (rst_n    ),

	.rst_core   (rst_core),

`ifdef E203_HAS_ITCM
	.rst_itcm   (rst_itcm),
`endif
`ifdef E203_HAS_DTCM
	.rst_dtcm   (rst_dtcm),
`endif

	.rst_aon   (rst_aon) 
);



e203_clk_ctrl u_e203_clk_ctrl(
	.clk          (clk          ),
	.rst_n        (rst_aon      ),
	.test_mode    (1'b0    ),
															
	.clk_aon      (clk_aon      ),

	.core_cgstop   (core_cgstop),
		
	.clk_core_ifu (clk_core_ifu      ),
	.clk_core_exu (clk_core_exu      ),
	.clk_core_lsu (clk_core_lsu      ),
	.clk_core_biu (clk_core_biu      ),
`ifdef E203_HAS_ITCM
	.clk_itcm     (clk_itcm     ),
	.itcm_active  (itcm_active),
	.itcm_ls      ( ),
`endif
`ifdef E203_HAS_DTCM
	.clk_dtcm     (clk_dtcm     ),
	.dtcm_active  (dtcm_active),
	.dtcm_ls      ( ),
`endif

	.core_ifu_active(core_ifu_active),
	.core_exu_active(core_exu_active),
	.core_lsu_active(core_lsu_active),
	.core_biu_active(core_biu_active),
	.core_wfi     (core_wfi ) 
);

	wire ext_irq_r;
	wire sft_irq_r;
	wire tmr_irq_r;

e203_irq_sync  #(.MASTER(MASTER)) u_e203_irq_sync(
	.clk       (clk_aon  ),
	.rst_n     (rst_aon  ),
											 

	.dbg_irq_a (dbg_irq_a),
	.dbg_irq_r (dbg_irq_r),

	.ext_irq_a   (ext_irq_a),
	.sft_irq_a   (sft_irq_a),
	.tmr_irq_a   (tmr_irq_a),
	.ext_irq_r   (ext_irq_r),
	.sft_irq_r   (sft_irq_r),
	.tmr_irq_r   (tmr_irq_r) 
);



`ifdef E203_HAS_ITCM
	wire ifu2itcm_holdup;

	wire ifu2itcm_icb_cmd_valid;
	wire ifu2itcm_icb_cmd_ready;
	wire [`E203_ITCM_ADDR_WIDTH-1:0]   ifu2itcm_icb_cmd_addr;

	wire ifu2itcm_icb_rsp_valid;
	wire ifu2itcm_icb_rsp_ready;
	wire ifu2itcm_icb_rsp_err;
	wire [`E203_ITCM_DATA_WIDTH-1:0] ifu2itcm_icb_rsp_rdata; 

`endif

`ifdef E203_HAS_DTCM
	wire                               lsu2dtcm_icb_cmd_valid;
	wire                               lsu2dtcm_icb_cmd_ready;
	wire [`E203_DTCM_ADDR_WIDTH-1:0]   lsu2dtcm_icb_cmd_addr; 
	wire                               lsu2dtcm_icb_cmd_read; 
	wire [`E203_XLEN-1:0]              lsu2dtcm_icb_cmd_wdata;
	wire [`E203_XLEN/8-1:0]            lsu2dtcm_icb_cmd_wmask;
	wire                               lsu2dtcm_icb_cmd_lock;
	wire                               lsu2dtcm_icb_cmd_excl;
	wire [1:0]                         lsu2dtcm_icb_cmd_size;
	wire                               lsu2dtcm_icb_rsp_valid;
	wire                               lsu2dtcm_icb_rsp_ready;
	wire                               lsu2dtcm_icb_rsp_err  ;
	wire [`E203_XLEN-1:0]              lsu2dtcm_icb_rsp_rdata;
`endif

`ifdef E203_HAS_CSR_EAI//{
	wire         eai_csr_valid;
	wire         eai_csr_ready;
	wire  [31:0] eai_csr_addr;
	wire         eai_csr_wr;
	wire  [31:0] eai_csr_wdata;
	wire  [31:0] eai_csr_rdata;

	// This is an empty module to just connect the EAI CSR interface, 
	//  user can hack it to become a real one
e203_extend_csr u_e203_extend_csr(
	.eai_csr_valid (eai_csr_valid),
	.eai_csr_ready (eai_csr_ready),
	.eai_csr_addr  (eai_csr_addr ),
	.eai_csr_wr    (eai_csr_wr   ),
	.eai_csr_wdata (eai_csr_wdata),
	.eai_csr_rdata (eai_csr_rdata),
	.clk           (clk_core_exu ),
	.rst_n         (rst_core ) 
 );
`endif//}

 
(* DONT_TOUCH = "TRUE" *)
e203_core u_e203_core(
	.inspect_pc            (inspect_pc),

`ifdef E203_HAS_CSR_EAI
	.eai_csr_valid (eai_csr_valid),
	.eai_csr_ready (eai_csr_ready),
	.eai_csr_addr  (eai_csr_addr ),
	.eai_csr_wr    (eai_csr_wr   ),
	.eai_csr_wdata (eai_csr_wdata),
	.eai_csr_rdata (eai_csr_rdata),
`endif
	.tcm_cgstop              (tcm_cgstop),
	.core_cgstop             (core_cgstop),
	.tm_stop                 (tm_stop),

	.pc_rtvec                (pc_rtvec),

	.ifu_active              (core_ifu_active),
	.exu_active              (core_exu_active),
	.lsu_active              (core_lsu_active),
	.biu_active              (core_biu_active),
	.core_wfi                (core_wfi),

	.core_mhartid            (core_mhartid),  
	.dbg_irq_r               (dbg_irq_r),
	.lcl_irq_r               (`E203_LIRQ_NUM'b0),// Not implemented now
	.ext_irq_r               (ext_irq_r),
	.sft_irq_r               (sft_irq_r),
	.tmr_irq_r               (tmr_irq_r),
	.evt_r                   (`E203_EVT_NUM'b0),// Not implemented now

	.cmt_dpc                 (cmt_dpc        ),
	.cmt_dpc_ena             (cmt_dpc_ena    ),
	.cmt_dcause              (cmt_dcause     ),
	.cmt_dcause_ena          (cmt_dcause_ena ),

	.wr_dcsr_ena     (wr_dcsr_ena    ),
	.wr_dpc_ena      (wr_dpc_ena     ),
	.wr_dscratch_ena (wr_dscratch_ena),
																	 
	.wr_csr_nxt      (wr_csr_nxt    ),
																	 
	.dcsr_r          (dcsr_r         ),
	.dpc_r           (dpc_r          ),
	.dscratch_r      (dscratch_r     ),
																					 
	.dbg_mode                (dbg_mode       ),
	.dbg_halt_r              (dbg_halt_r     ),
	.dbg_step_r              (dbg_step_r     ),
	.dbg_ebreakm_r           (dbg_ebreakm_r),
	.dbg_stopcycle           (dbg_stopcycle),

`ifdef E203_HAS_ITCM //{
	//.itcm_region_indic       (itcm_region_indic),
	.itcm_region_indic       (`E203_ITCM_ADDR_BASE),
`endif//}
`ifdef E203_HAS_DTCM //{
	//.dtcm_region_indic       (dtcm_region_indic),
	.dtcm_region_indic       (`E203_DTCM_ADDR_BASE),
`endif//}

`ifdef E203_HAS_ITCM //{

	.ifu2itcm_holdup         (ifu2itcm_holdup       ),

	.ifu2itcm_icb_cmd_valid  (ifu2itcm_icb_cmd_valid),
	.ifu2itcm_icb_cmd_ready  (ifu2itcm_icb_cmd_ready),
	.ifu2itcm_icb_cmd_addr   (ifu2itcm_icb_cmd_addr ),
	.ifu2itcm_icb_rsp_valid  (ifu2itcm_icb_rsp_valid),
	.ifu2itcm_icb_rsp_ready  (ifu2itcm_icb_rsp_ready),
	.ifu2itcm_icb_rsp_err    (ifu2itcm_icb_rsp_err  ),
	.ifu2itcm_icb_rsp_rdata  (ifu2itcm_icb_rsp_rdata),

`endif//}

`ifdef E203_HAS_DTCM //{

	.lsu2dtcm_icb_cmd_valid  (lsu2dtcm_icb_cmd_valid),
	.lsu2dtcm_icb_cmd_ready  (lsu2dtcm_icb_cmd_ready),
	.lsu2dtcm_icb_cmd_addr   (lsu2dtcm_icb_cmd_addr ),
	.lsu2dtcm_icb_cmd_read   (lsu2dtcm_icb_cmd_read ),
	.lsu2dtcm_icb_cmd_wdata  (lsu2dtcm_icb_cmd_wdata),
	.lsu2dtcm_icb_cmd_wmask  (lsu2dtcm_icb_cmd_wmask),
	.lsu2dtcm_icb_cmd_lock   (lsu2dtcm_icb_cmd_lock ),
	.lsu2dtcm_icb_cmd_excl   (lsu2dtcm_icb_cmd_excl ),
	.lsu2dtcm_icb_cmd_size   (lsu2dtcm_icb_cmd_size ),
	
	.lsu2dtcm_icb_rsp_valid  (lsu2dtcm_icb_rsp_valid),
	.lsu2dtcm_icb_rsp_ready  (lsu2dtcm_icb_rsp_ready),
	.lsu2dtcm_icb_rsp_err    (lsu2dtcm_icb_rsp_err  ),
	.lsu2dtcm_icb_rsp_excl_ok(1'b0),
	.lsu2dtcm_icb_rsp_rdata  (lsu2dtcm_icb_rsp_rdata),

`endif//}

	.plic_icb_enable        (plic_icb_enable),
	.plic_region_indic      (plic_region_indic ),
	.plic_icb_cmd_valid     (plic_icb_cmd_valid),
	.plic_icb_cmd_ready     (plic_icb_cmd_ready),
	.plic_icb_cmd_addr      (plic_icb_cmd_addr ),
	.plic_icb_cmd_read      (plic_icb_cmd_read ),
	.plic_icb_cmd_wdata     (plic_icb_cmd_wdata),
	.plic_icb_cmd_wmask     (plic_icb_cmd_wmask),
	.plic_icb_cmd_lock      (plic_icb_cmd_lock ),
	.plic_icb_cmd_excl      (plic_icb_cmd_excl ),
	.plic_icb_cmd_size      (plic_icb_cmd_size ),
	
	.plic_icb_rsp_valid     (plic_icb_rsp_valid),
	.plic_icb_rsp_ready     (plic_icb_rsp_ready),
	.plic_icb_rsp_err       (plic_icb_rsp_err  ),
	.plic_icb_rsp_excl_ok   (plic_icb_rsp_excl_ok),
	.plic_icb_rsp_rdata     (plic_icb_rsp_rdata),

	.clint_icb_enable        (clint_icb_enable),
	.clint_region_indic      (clint_region_indic ),
	.clint_icb_cmd_valid     (clint_icb_cmd_valid),
	.clint_icb_cmd_ready     (clint_icb_cmd_ready),
	.clint_icb_cmd_addr      (clint_icb_cmd_addr ),
	.clint_icb_cmd_read      (clint_icb_cmd_read ),
	.clint_icb_cmd_wdata     (clint_icb_cmd_wdata),
	.clint_icb_cmd_wmask     (clint_icb_cmd_wmask),
	.clint_icb_cmd_lock      (clint_icb_cmd_lock ),
	.clint_icb_cmd_excl      (clint_icb_cmd_excl ),
	.clint_icb_cmd_size      (clint_icb_cmd_size ),
	
	.clint_icb_rsp_valid     (clint_icb_rsp_valid),
	.clint_icb_rsp_ready     (clint_icb_rsp_ready),
	.clint_icb_rsp_err       (clint_icb_rsp_err  ),
	.clint_icb_rsp_excl_ok   (clint_icb_rsp_excl_ok),
	.clint_icb_rsp_rdata     (clint_icb_rsp_rdata),

	.clk_aon           (clk_aon           ),
	.clk_core_ifu      (clk_core_ifu      ),
	.clk_core_exu      (clk_core_exu      ),
	.clk_core_lsu      (clk_core_lsu      ),
	.clk_core_biu      (clk_core_biu      ),
	.test_mode         (1'b0),
	.rst_n             (rst_core ) 
);

`ifdef E203_HAS_ITCM //{
(* DONT_TOUCH = "TRUE" *)
e203_itcm_ctrl u_e203_itcm_ctrl(
	.tcm_cgstop   (tcm_cgstop),

	.itcm_active  (itcm_active),

	.ifu2itcm_icb_cmd_valid  (ifu2itcm_icb_cmd_valid),
	.ifu2itcm_icb_cmd_ready  (ifu2itcm_icb_cmd_ready),
	.ifu2itcm_icb_cmd_addr   (ifu2itcm_icb_cmd_addr ),
	.ifu2itcm_icb_cmd_read   (1'b1 ),
	.ifu2itcm_icb_cmd_wdata  ({`E203_ITCM_DATA_WIDTH{1'b0}}),
	.ifu2itcm_icb_cmd_wmask  ({`E203_ITCM_DATA_WIDTH/8{1'b0}}),

	.ifu2itcm_icb_rsp_valid  (ifu2itcm_icb_rsp_valid),
	.ifu2itcm_icb_rsp_ready  (ifu2itcm_icb_rsp_ready),
	.ifu2itcm_icb_rsp_err    (ifu2itcm_icb_rsp_err  ),
	.ifu2itcm_icb_rsp_rdata  (ifu2itcm_icb_rsp_rdata),

	.ifu2itcm_holdup         (ifu2itcm_holdup       ),

	// .itcm_ram_cs             (itcm_ram_cs  ),
	// .itcm_ram_we             (itcm_ram_we  ),
	// .itcm_ram_addr           (itcm_ram_addr), 
	// .itcm_ram_wem            (itcm_ram_wem ),
	// .itcm_ram_din            (itcm_ram_din ),         
	// .itcm_ram_dout           (itcm_ram_dout),
	// .clk_itcm_ram            (clk_itcm_ram ),

	.clk                     (clk_itcm),
	.rst_n                   (rst_itcm) 
);
`endif//}

`ifdef E203_HAS_DTCM //{
e203_dtcm_ctrl u_e203_dtcm_ctrl(
	.tcm_cgstop   (tcm_cgstop),

	.dtcm_active  (dtcm_active),

	.lsu2dtcm_icb_cmd_valid  (lsu2dtcm_icb_cmd_valid),
	.lsu2dtcm_icb_cmd_ready  (lsu2dtcm_icb_cmd_ready),
	.lsu2dtcm_icb_cmd_addr   (lsu2dtcm_icb_cmd_addr ),
	.lsu2dtcm_icb_cmd_read   (lsu2dtcm_icb_cmd_read ),
	.lsu2dtcm_icb_cmd_wdata  (lsu2dtcm_icb_cmd_wdata),
	.lsu2dtcm_icb_cmd_wmask  (lsu2dtcm_icb_cmd_wmask),
	
	.lsu2dtcm_icb_rsp_valid  (lsu2dtcm_icb_rsp_valid),
	.lsu2dtcm_icb_rsp_ready  (lsu2dtcm_icb_rsp_ready),
	.lsu2dtcm_icb_rsp_err    (lsu2dtcm_icb_rsp_err  ),
	.lsu2dtcm_icb_rsp_rdata  (lsu2dtcm_icb_rsp_rdata),

	// .dtcm_ram_cs             (dtcm_ram_cs  ),
	// .dtcm_ram_we             (dtcm_ram_we  ),
	// .dtcm_ram_addr           (dtcm_ram_addr), 
	// .dtcm_ram_wem            (dtcm_ram_wem ),
	// .dtcm_ram_din            (dtcm_ram_din ),         
	// .dtcm_ram_dout           (dtcm_ram_dout),
	// .clk_dtcm_ram            (clk_dtcm_ram ),


	.test_mode               (1'b0),
	.clk                     (clk_dtcm),
	.rst_n                   (rst_dtcm) 
);
`endif//}


	assign inspect_dbg_irq = dbg_irq_a;
	assign inspect_core_clk = clk;

endmodule
