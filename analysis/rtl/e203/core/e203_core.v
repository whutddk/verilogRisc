
//////////////////////////////////////////////////////////////////////////////////
// Company:    
// Engineer: 29505
// Create Date: 2019-05-24 21:39:36
// Last Modified by:   29505
// Last Modified time: 2019-05-25 09:45:23
// Email: 295054118@whut.edu.cn
// Design Name: e203_core.v  
// Module Name:  
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
//////////////////////////////////////////////////////////////////////////////////
// Company:   
// Engineer: Ruige_Lee
// Create Date: 2019-04-23 19:53:51
// Last Modified by:   Ruige_Lee
// Last Modified time: 2019-05-07 12:02:14
// Email: 295054118@whut.edu.cn
// page: https://whutddk.github.io/
// Design Name: e203_core.v  
// Module Name: e203_core
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
//
// Designer   : Bob Hu
//
// Description:
//  The Core module to implement the core portion of the cpu
//
// ====================================================================

`include "e203_defines.v"

module e203_core(

	output core_wfi,
	output tm_stop,
	output core_cgstop,
	// output tcm_cgstop,

	input  [`E203_PC_SIZE-1:0] pc_rtvec,

	input  [`E203_HART_ID_W-1:0] core_mhartid,
	// input  dbg_irq_r,
	input  [`E203_LIRQ_NUM-1:0] lcl_irq_r,
	input  [`E203_EVT_NUM-1:0] evt_r,
	input  ext_irq_r,
	input  sft_irq_r,
	input  tmr_irq_r,

	//////////////////////////////////////////////////////////////
	// From/To debug ctrl module
	output  wr_dcsr_ena    ,
	output  wr_dpc_ena     ,
	output  wr_dscratch_ena,

	output  [32-1:0] wr_csr_nxt    ,

	input  [32-1:0] dcsr_r    ,
	input  [`E203_PC_SIZE-1:0] dpc_r     ,
	input  [32-1:0] dscratch_r,

	output  [`E203_PC_SIZE-1:0] cmt_dpc,
	output  cmt_dpc_ena,
	output  [3-1:0] cmt_dcause,
	output  cmt_dcause_ena,

	// input  dbg_mode,
	// input  dbg_halt_r,
	// input  dbg_step_r,
	// input  dbg_ebreakm_r,
	// input  dbg_stopcycle,

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


	output exu_active,
// output ifu_active,
	output lsu_active,
	output biu_active,

	input  clk_core_ifu,
	input  clk_core_exu,
	input  clk_core_lsu,
	input  clk_core_biu,
	input  clk,

	// input test_mode,
	input  rst_n
	);



	wire ifu_o_valid;
	wire ifu_o_ready;
	wire [`E203_INSTR_SIZE-1:0] ifu_o_ir;
	wire [`E203_PC_SIZE-1:0] ifu_o_pc;
	wire ifu_o_pc_vld; 
// wire ifu_o_misalgn; 
// wire ifu_o_buserr; 
	wire [`E203_RFIDX_WIDTH-1:0] ifu_o_rs1idx;
	wire [`E203_RFIDX_WIDTH-1:0] ifu_o_rs2idx;
	wire ifu_o_prdt_taken;
	wire ifu_o_muldiv_b2b;

	wire wfi_halt_ifu_req;
	wire wfi_halt_ifu_ack;
// wire pipe_flush_ack;
	wire pipe_flush_req;
	wire [`E203_PC_SIZE-1:0] pipe_flush_add_op1;  
	wire [`E203_PC_SIZE-1:0] pipe_flush_add_op2;  
	`ifdef E203_TIMING_BOOST//}
	wire [`E203_PC_SIZE-1:0] pipe_flush_pc;  
	`endif//}

	wire oitf_empty;
	wire [`E203_XLEN-1:0] rf2ifu_x1;
	wire [`E203_XLEN-1:0] rf2ifu_rs1;
	wire dec2ifu_rden;
	wire dec2ifu_rs1en;
	wire [`E203_RFIDX_WIDTH-1:0] dec2ifu_rdidx;
	wire dec2ifu_mulhsu;
	wire dec2ifu_div   ;
	wire dec2ifu_rem   ;
	wire dec2ifu_divu  ;
	wire dec2ifu_remu  ;


	// wire itcm_nohold;

e203_ifu u_e203_ifu(

	.pc_rtvec        (pc_rtvec),  


	.ifu_o_valid            (ifu_o_valid         ),
	.ifu_o_ready            (ifu_o_ready         ),
	.ifu_o_ir               (ifu_o_ir            ),
	.ifu_o_pc               (ifu_o_pc            ),
	.ifu_o_pc_vld           (ifu_o_pc_vld        ),

	.ifu_o_rs1idx           (ifu_o_rs1idx        ),
	.ifu_o_rs2idx           (ifu_o_rs2idx        ),
	.ifu_o_prdt_taken       (ifu_o_prdt_taken    ),
	.ifu_o_muldiv_b2b       (ifu_o_muldiv_b2b    ),

	.ifu_halt_req           (wfi_halt_ifu_req),
	.ifu_halt_ack           (wfi_halt_ifu_ack),

	.pipe_flush_req         (pipe_flush_req      ),
	.pipe_flush_add_op1     (pipe_flush_add_op1  ),  
	.pipe_flush_add_op2     (pipe_flush_add_op2  ),  

`ifdef E203_TIMING_BOOST//}
	.pipe_flush_pc          (pipe_flush_pc),  
`endif//}
														 
	.oitf_empty             (oitf_empty   ),
	.rf2ifu_x1              (rf2ifu_x1    ),
	.rf2ifu_rs1             (rf2ifu_rs1   ),
	.dec2ifu_rden           (dec2ifu_rden ),
	.dec2ifu_rs1en          (dec2ifu_rs1en),
	.dec2ifu_rdidx          (dec2ifu_rdidx),
	.dec2ifu_mulhsu         (dec2ifu_mulhsu),
	.dec2ifu_div            (dec2ifu_div   ),
	.dec2ifu_rem            (dec2ifu_rem   ),
	.dec2ifu_divu           (dec2ifu_divu  ),
	.dec2ifu_remu           (dec2ifu_remu  ),

	.clk                    (clk_core_ifu  ),
	.rst_n                  (rst_n         ) 
);

	

	wire                         lsu_o_valid; 
	wire                         lsu_o_ready; 
	wire [`E203_XLEN-1:0]        lsu_o_wbck_wdat;
	wire [`E203_ITAG_WIDTH -1:0] lsu_o_wbck_itag;
	wire                         lsu_o_wbck_err ; 
	wire                         lsu_o_cmt_buserr ; 
	wire                         lsu_o_cmt_ld;
	wire                         lsu_o_cmt_st;
	wire [`E203_ADDR_SIZE -1:0]  lsu_o_cmt_badaddr;

	wire                         agu_icb_cmd_valid; 
	wire                         agu_icb_cmd_ready; 
	wire [`E203_ADDR_SIZE-1:0]   agu_icb_cmd_addr; 
	wire                         agu_icb_cmd_read;   
	wire [`E203_XLEN-1:0]        agu_icb_cmd_wdata; 
	wire [`E203_XLEN/8-1:0]      agu_icb_cmd_wmask; 
	wire                         agu_icb_cmd_lock;
	wire                         agu_icb_cmd_excl;
	wire [1:0]                   agu_icb_cmd_size;
	wire                         agu_icb_cmd_back2agu; 
	wire                         agu_icb_cmd_usign;
	wire [`E203_ITAG_WIDTH -1:0] agu_icb_cmd_itag;
	wire                         agu_icb_rsp_valid; 
	wire                         agu_icb_rsp_ready; 
	wire                         agu_icb_rsp_err  ; 
	wire                         agu_icb_rsp_excl_ok  ; 
	wire [`E203_XLEN-1:0]        agu_icb_rsp_rdata;

	wire commit_mret;
	wire commit_trap;
	wire excp_active;

e203_exu u_e203_exu(


	.excp_active            (excp_active),
	.commit_mret            (commit_mret),
	.commit_trap            (commit_trap),
	// .test_mode              (test_mode),
	.core_wfi               (core_wfi),
	.tm_stop                (tm_stop),
	.itcm_nohold            (),
	.core_cgstop            (core_cgstop),
	.tcm_cgstop             (tcm_cgstop),
	.exu_active             (exu_active),

	.core_mhartid           (core_mhartid),
	.dbg_irq_r              (dbg_irq_r),
	.lcl_irq_r              (lcl_irq_r    ),
	.ext_irq_r              (ext_irq_r    ),
	.sft_irq_r              (sft_irq_r    ),
	.tmr_irq_r              (tmr_irq_r    ),
	.evt_r                  (evt_r    ),

	.cmt_dpc                (cmt_dpc        ),
	.cmt_dpc_ena            (cmt_dpc_ena    ),
	.cmt_dcause             (cmt_dcause     ),
	.cmt_dcause_ena         (cmt_dcause_ena ),

	.wr_dcsr_ena     (wr_dcsr_ena    ),
	.wr_dpc_ena      (wr_dpc_ena     ),
	.wr_dscratch_ena (wr_dscratch_ena),


																	 
	.wr_csr_nxt      (wr_csr_nxt    ),
																	 
	.dcsr_r          (dcsr_r         ),
	.dpc_r           (dpc_r          ),
	.dscratch_r      (dscratch_r     ),

	// .dbg_mode               (dbg_mode  ),
	.dbg_halt_r             (dbg_halt_r),
	.dbg_step_r             (dbg_step_r),
	.dbg_ebreakm_r          (dbg_ebreakm_r),
	.dbg_stopcycle          (dbg_stopcycle),

	.i_valid                (ifu_o_valid         ),
	.i_ready                (ifu_o_ready         ),
	.i_ir                   (ifu_o_ir            ),
	.i_pc                   (ifu_o_pc            ),
	.i_pc_vld               (ifu_o_pc_vld        ),
	// .i_misalgn              (1'b0), 
	// .i_buserr               (1'b0), 
	.i_rs1idx               (ifu_o_rs1idx        ),
	.i_rs2idx               (ifu_o_rs2idx        ),
	.i_prdt_taken           (ifu_o_prdt_taken    ),
	.i_muldiv_b2b           (ifu_o_muldiv_b2b    ),

	.wfi_halt_ifu_req       (wfi_halt_ifu_req),
	.wfi_halt_ifu_ack       (wfi_halt_ifu_ack),

	// .pipe_flush_ack         (1'b1),
	.pipe_flush_req         (pipe_flush_req      ),
	.pipe_flush_add_op1     (pipe_flush_add_op1  ),  
	.pipe_flush_add_op2     (pipe_flush_add_op2  ),  
`ifdef E203_TIMING_BOOST//}
	.pipe_flush_pc          (pipe_flush_pc),  
`endif//}

	.lsu_o_valid            (lsu_o_valid   ),
	.lsu_o_ready            (lsu_o_ready   ),
	.lsu_o_wbck_wdat        (lsu_o_wbck_wdat    ),
	.lsu_o_wbck_itag        (lsu_o_wbck_itag    ),
	.lsu_o_wbck_err         (lsu_o_wbck_err     ),
	.lsu_o_cmt_buserr       (lsu_o_cmt_buserr     ),
	.lsu_o_cmt_ld           (lsu_o_cmt_ld),
	.lsu_o_cmt_st           (lsu_o_cmt_st),
	.lsu_o_cmt_badaddr      (lsu_o_cmt_badaddr     ),

	.agu_icb_cmd_valid      (agu_icb_cmd_valid   ),
	.agu_icb_cmd_ready      (agu_icb_cmd_ready   ),
	.agu_icb_cmd_addr       (agu_icb_cmd_addr    ),
	.agu_icb_cmd_read       (agu_icb_cmd_read    ),
	.agu_icb_cmd_wdata      (agu_icb_cmd_wdata   ),
	.agu_icb_cmd_wmask      (agu_icb_cmd_wmask   ),
	.agu_icb_cmd_lock       (agu_icb_cmd_lock    ),
	.agu_icb_cmd_excl       (agu_icb_cmd_excl    ),
	.agu_icb_cmd_size       (agu_icb_cmd_size    ),
	.agu_icb_cmd_back2agu   (agu_icb_cmd_back2agu),
	.agu_icb_cmd_usign      (agu_icb_cmd_usign   ),
	.agu_icb_cmd_itag       (agu_icb_cmd_itag    ),
	.agu_icb_rsp_valid      (agu_icb_rsp_valid   ),
	.agu_icb_rsp_ready      (agu_icb_rsp_ready   ),
	.agu_icb_rsp_err        (agu_icb_rsp_err     ),
	.agu_icb_rsp_excl_ok    (agu_icb_rsp_excl_ok ),
	.agu_icb_rsp_rdata      (agu_icb_rsp_rdata   ),

	.oitf_empty             (oitf_empty   ),
	.rf2ifu_x1              (rf2ifu_x1    ),
	.rf2ifu_rs1             (rf2ifu_rs1   ),
	.dec2ifu_rden           (dec2ifu_rden ),
	.dec2ifu_rs1en          (dec2ifu_rs1en),
	.dec2ifu_rdidx          (dec2ifu_rdidx),
	.dec2ifu_mulhsu         (dec2ifu_mulhsu),
	.dec2ifu_div            (dec2ifu_div   ),
	.dec2ifu_rem            (dec2ifu_rem   ),
	.dec2ifu_divu           (dec2ifu_divu  ),
	.dec2ifu_remu           (dec2ifu_remu  ),


	.clk_aon                (clk),
	.clk                    (clk_core_exu),
	.rst_n                  (rst_n  ) 
);

	wire                         lsu2biu_icb_cmd_valid;
	wire                         lsu2biu_icb_cmd_ready;
	wire [`E203_ADDR_SIZE-1:0]   lsu2biu_icb_cmd_addr; 
	wire                         lsu2biu_icb_cmd_read; 
	wire [`E203_XLEN-1:0]        lsu2biu_icb_cmd_wdata;
	wire [`E203_XLEN/8-1:0]      lsu2biu_icb_cmd_wmask;
	wire                         lsu2biu_icb_cmd_lock;
	wire                         lsu2biu_icb_cmd_excl;
	wire [1:0]                   lsu2biu_icb_cmd_size;

	wire                         lsu2biu_icb_rsp_valid;
	wire                         lsu2biu_icb_rsp_ready;
	wire                         lsu2biu_icb_rsp_err  ;
	wire                         lsu2biu_icb_rsp_excl_ok;
	wire [`E203_XLEN-1:0]        lsu2biu_icb_rsp_rdata;

e203_lsu u_e203_lsu(
	.excp_active         (excp_active),
	.commit_mret         (commit_mret),
	.commit_trap         (commit_trap),
	.lsu_active          (lsu_active),
	.lsu_o_valid         (lsu_o_valid   ),
	.lsu_o_ready         (lsu_o_ready   ),
	.lsu_o_wbck_wdat     (lsu_o_wbck_wdat    ),
	.lsu_o_wbck_itag     (lsu_o_wbck_itag    ),
	.lsu_o_wbck_err      (lsu_o_wbck_err     ),
	.lsu_o_cmt_buserr    (lsu_o_cmt_buserr     ),
	.lsu_o_cmt_ld        (lsu_o_cmt_ld),
	.lsu_o_cmt_st        (lsu_o_cmt_st),
	.lsu_o_cmt_badaddr   (lsu_o_cmt_badaddr     ),
											
	.agu_icb_cmd_valid   (agu_icb_cmd_valid ),
	.agu_icb_cmd_ready   (agu_icb_cmd_ready ),
	.agu_icb_cmd_addr    (agu_icb_cmd_addr  ),
	.agu_icb_cmd_read    (agu_icb_cmd_read  ),
	.agu_icb_cmd_wdata   (agu_icb_cmd_wdata ),
	.agu_icb_cmd_wmask   (agu_icb_cmd_wmask ),
	.agu_icb_cmd_lock    (agu_icb_cmd_lock  ),
	.agu_icb_cmd_excl    (agu_icb_cmd_excl  ),
	.agu_icb_cmd_size    (agu_icb_cmd_size  ),
 
	.agu_icb_cmd_back2agu(agu_icb_cmd_back2agu ),
	.agu_icb_cmd_usign   (agu_icb_cmd_usign),
	.agu_icb_cmd_itag    (agu_icb_cmd_itag),

	.agu_icb_rsp_valid   (agu_icb_rsp_valid ),
	.agu_icb_rsp_ready   (agu_icb_rsp_ready ),
	.agu_icb_rsp_err     (agu_icb_rsp_err   ),
	.agu_icb_rsp_excl_ok (agu_icb_rsp_excl_ok),
	.agu_icb_rsp_rdata   (agu_icb_rsp_rdata),

	.biu_icb_cmd_valid  (lsu2biu_icb_cmd_valid),
	.biu_icb_cmd_ready  (lsu2biu_icb_cmd_ready),
	.biu_icb_cmd_addr   (lsu2biu_icb_cmd_addr ),
	.biu_icb_cmd_read   (lsu2biu_icb_cmd_read ),
	.biu_icb_cmd_wdata  (lsu2biu_icb_cmd_wdata),
	.biu_icb_cmd_wmask  (lsu2biu_icb_cmd_wmask),
	.biu_icb_cmd_lock   (lsu2biu_icb_cmd_lock ),
	.biu_icb_cmd_excl   (lsu2biu_icb_cmd_excl ),
	.biu_icb_cmd_size   (lsu2biu_icb_cmd_size ),
	
	.biu_icb_rsp_valid  (lsu2biu_icb_rsp_valid),
	.biu_icb_rsp_ready  (lsu2biu_icb_rsp_ready),
	.biu_icb_rsp_err    (lsu2biu_icb_rsp_err  ),
	.biu_icb_rsp_excl_ok(lsu2biu_icb_rsp_excl_ok),
	.biu_icb_rsp_rdata  (lsu2biu_icb_rsp_rdata),

	.clk           (clk_core_lsu ),
	.rst_n         (rst_n        ) 
);


e203_biu u_e203_biu(
	.biu_active             (biu_active),

	.lsu2biu_icb_cmd_valid  (lsu2biu_icb_cmd_valid),
	.lsu2biu_icb_cmd_ready  (lsu2biu_icb_cmd_ready),
	.lsu2biu_icb_cmd_addr   (lsu2biu_icb_cmd_addr ),
	.lsu2biu_icb_cmd_read   (lsu2biu_icb_cmd_read ),
	.lsu2biu_icb_cmd_wdata  (lsu2biu_icb_cmd_wdata),
	.lsu2biu_icb_cmd_wmask  (lsu2biu_icb_cmd_wmask),
	.lsu2biu_icb_cmd_lock   (lsu2biu_icb_cmd_lock ),
	.lsu2biu_icb_cmd_excl   (lsu2biu_icb_cmd_excl ),
	.lsu2biu_icb_cmd_size   (lsu2biu_icb_cmd_size ),
	.lsu2biu_icb_cmd_burst  (2'b0),
	.lsu2biu_icb_cmd_beat   (2'b0 ),

	.lsu2biu_icb_rsp_valid  (lsu2biu_icb_rsp_valid),
	.lsu2biu_icb_rsp_ready  (lsu2biu_icb_rsp_ready),
	.lsu2biu_icb_rsp_err    (lsu2biu_icb_rsp_err  ),
	.lsu2biu_icb_rsp_excl_ok(lsu2biu_icb_rsp_excl_ok),
	.lsu2biu_icb_rsp_rdata  (lsu2biu_icb_rsp_rdata),

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
	.plic_icb_cmd_burst     (),
	.plic_icb_cmd_beat      (),
	
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
	.clint_icb_cmd_burst     (),
	.clint_icb_cmd_beat      (),
	
	.clint_icb_rsp_valid     (clint_icb_rsp_valid),
	.clint_icb_rsp_ready     (clint_icb_rsp_ready),
	.clint_icb_rsp_err       (clint_icb_rsp_err  ),
	.clint_icb_rsp_excl_ok   (clint_icb_rsp_excl_ok),
	.clint_icb_rsp_rdata     (clint_icb_rsp_rdata),

	.clk                    (clk_core_biu ),
	.rst_n                  (rst_n        ) 
);













endmodule                                      
																							 
																							 
																							 
