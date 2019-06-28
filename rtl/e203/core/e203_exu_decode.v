
//////////////////////////////////////////////////////////////////////////////////
// Company:    
// Engineer: 29505
// Create Date: 2019-06-27 21:03:47
// Last Modified by:   29505
// Last Modified time: 2019-06-28 13:10:20
// Email: 295054118@whut.edu.cn
// Design Name: e203_exu_decode.v  
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
// Create Date: 2019-06-25 19:07:21
// Last Modified by:   Ruige_Lee
// Last Modified time: 2019-06-27 20:08:51
// Email: 295054118@whut.edu.cn
// page: https://whutddk.github.io/
// Design Name: e203_exu_decode.v  
// Module Name: e203_exu_decode
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
//  The decode module to decode the instruction details
//
// ====================================================================
`include "e203_defines.v"

module e203_exu_decode(

  //////////////////////////////////////////////////////////////
  // The IR stage to Decoder
  input  [`E203_INSTR_SIZE-1:0] i_instr,
  input  [`E203_PC_SIZE-1:0] i_pc,
  input  i_prdt_taken, 
  input  i_misalgn,              // The fetch misalign
  input  i_buserr,               // The fetch bus error
  input  i_muldiv_b2b,           // The back2back case for mul/div

  input  dbg_mode,
  //////////////////////////////////////////////////////////////
  // The Decoded Info-Bus

  output dec_rs1x0,
  output dec_rs2x0,
  output dec_rs1en,
  output dec_rs2en,
  output dec_rdwen,
  output [`E203_RFIDX_WIDTH-1:0] dec_rs1idx,
  output [`E203_RFIDX_WIDTH-1:0] dec_rs2idx,
  output [`E203_RFIDX_WIDTH-1:0] dec_rdidx,
  output [`E203_DECINFO_WIDTH-1:0] dec_info,  
  output [`E203_XLEN-1:0] dec_imm,
  output [`E203_PC_SIZE-1:0] dec_pc,
  output dec_misalgn,
  output dec_buserr,
  output dec_ilegl,
  

  output dec_mulhsu,
  output dec_mul   ,
  output dec_div   ,
  output dec_rem   ,
  output dec_divu  ,
  output dec_remu  ,

  output dec_rv32,
  output dec_bjp,
  output dec_jal,
  output dec_jalr,
  output dec_bxx,

  output [`E203_RFIDX_WIDTH-1:0] dec_jalr_rs1idx,
  output [`E203_XLEN-1:0] dec_bjp_imm 
  );



  wire [32-1:0] rv32_instr = i_instr;

  wire [6:0]  opcode = rv32_instr[6:0];

  wire opcode_1_0_11  = (opcode[1:0] == 2'b11);

  // wire rv32 = (~(i_instr[4:2] == 3'b111)) & opcode_1_0_11;
  wire rv32 = 1'b1;

  wire [4:0]  rv32_rd     = rv32_instr[11:7];
  wire [2:0]  rv32_func3  = rv32_instr[14:12];
  wire [4:0]  rv32_rs1    = rv32_instr[19:15];
  wire [4:0]  rv32_rs2    = rv32_instr[24:20];
  wire [6:0]  rv32_func7  = rv32_instr[31:25];



  
  // We generate the signals and reused them as much as possible to save gatecounts
  wire opcode_4_2_000 = (opcode[4:2] == 3'b000);
  wire opcode_4_2_001 = (opcode[4:2] == 3'b001);
  wire opcode_4_2_010 = (opcode[4:2] == 3'b010);
  wire opcode_4_2_011 = (opcode[4:2] == 3'b011);
  wire opcode_4_2_100 = (opcode[4:2] == 3'b100);
  wire opcode_4_2_101 = (opcode[4:2] == 3'b101);
  wire opcode_4_2_110 = (opcode[4:2] == 3'b110);
  wire opcode_4_2_111 = (opcode[4:2] == 3'b111);
  wire opcode_6_5_00  = (opcode[6:5] == 2'b00);
  wire opcode_6_5_01  = (opcode[6:5] == 2'b01);
  wire opcode_6_5_10  = (opcode[6:5] == 2'b10);
  wire opcode_6_5_11  = (opcode[6:5] == 2'b11);

  wire rv32_func3_000 = (rv32_func3 == 3'b000);
  wire rv32_func3_001 = (rv32_func3 == 3'b001);
  wire rv32_func3_010 = (rv32_func3 == 3'b010);
  wire rv32_func3_011 = (rv32_func3 == 3'b011);
  wire rv32_func3_100 = (rv32_func3 == 3'b100);
  wire rv32_func3_101 = (rv32_func3 == 3'b101);
  wire rv32_func3_110 = (rv32_func3 == 3'b110);
  wire rv32_func3_111 = (rv32_func3 == 3'b111);



  wire rv32_func7_0000000 = (rv32_func7 == 7'b0000000);
  wire rv32_func7_0100000 = (rv32_func7 == 7'b0100000);
  wire rv32_func7_0000001 = (rv32_func7 == 7'b0000001);
  wire rv32_func7_0000101 = (rv32_func7 == 7'b0000101);
  wire rv32_func7_0001001 = (rv32_func7 == 7'b0001001);
  wire rv32_func7_0001101 = (rv32_func7 == 7'b0001101);
  wire rv32_func7_0010101 = (rv32_func7 == 7'b0010101);
  wire rv32_func7_0100001 = (rv32_func7 == 7'b0100001);
  wire rv32_func7_0010001 = (rv32_func7 == 7'b0010001);
  wire rv32_func7_0101101 = (rv32_func7 == 7'b0101101);
  wire rv32_func7_1111111 = (rv32_func7 == 7'b1111111);
  wire rv32_func7_0000100 = (rv32_func7 == 7'b0000100); 
  wire rv32_func7_0001000 = (rv32_func7 == 7'b0001000); 
  wire rv32_func7_0001100 = (rv32_func7 == 7'b0001100); 
  wire rv32_func7_0101100 = (rv32_func7 == 7'b0101100); 
  wire rv32_func7_0010000 = (rv32_func7 == 7'b0010000); 
  wire rv32_func7_0010100 = (rv32_func7 == 7'b0010100); 
  wire rv32_func7_1100000 = (rv32_func7 == 7'b1100000); 
  wire rv32_func7_1110000 = (rv32_func7 == 7'b1110000); 
  wire rv32_func7_1010000 = (rv32_func7 == 7'b1010000); 
  wire rv32_func7_1101000 = (rv32_func7 == 7'b1101000); 
  wire rv32_func7_1111000 = (rv32_func7 == 7'b1111000); 
  wire rv32_func7_1010001 = (rv32_func7 == 7'b1010001);  
  wire rv32_func7_1110001 = (rv32_func7 == 7'b1110001);  
  wire rv32_func7_1100001 = (rv32_func7 == 7'b1100001);  
  wire rv32_func7_1101001 = (rv32_func7 == 7'b1101001);  

  wire rv32_rs1_x0 = (rv32_rs1 == 5'b00000);
  wire rv32_rs2_x0 = (rv32_rs2 == 5'b00000);
  wire rv32_rs2_x1 = (rv32_rs2 == 5'b00001);
  wire rv32_rd_x0  = (rv32_rd  == 5'b00000);
  wire rv32_rd_x2  = (rv32_rd  == 5'b00010);


  wire rv32_rs1_x31 = (rv32_rs1 == 5'b11111);
  wire rv32_rs2_x31 = (rv32_rs2 == 5'b11111);
  wire rv32_rd_x31  = (rv32_rd  == 5'b11111);

  wire rv32_load     = opcode_6_5_00 & opcode_4_2_000 & opcode_1_0_11; 
  wire rv32_store    = opcode_6_5_01 & opcode_4_2_000 & opcode_1_0_11; 
  wire rv32_madd     = opcode_6_5_10 & opcode_4_2_000 & opcode_1_0_11; 
  wire rv32_branch   = opcode_6_5_11 & opcode_4_2_000 & opcode_1_0_11; 

  wire rv32_load_fp  = opcode_6_5_00 & opcode_4_2_001 & opcode_1_0_11; 
  wire rv32_store_fp = opcode_6_5_01 & opcode_4_2_001 & opcode_1_0_11; 
  wire rv32_msub     = opcode_6_5_10 & opcode_4_2_001 & opcode_1_0_11; 
  wire rv32_jalr     = opcode_6_5_11 & opcode_4_2_001 & opcode_1_0_11; 

  wire rv32_custom0  = opcode_6_5_00 & opcode_4_2_010 & opcode_1_0_11; 
  wire rv32_custom1  = opcode_6_5_01 & opcode_4_2_010 & opcode_1_0_11; 
  wire rv32_nmsub    = opcode_6_5_10 & opcode_4_2_010 & opcode_1_0_11; 
  wire rv32_resved0  = opcode_6_5_11 & opcode_4_2_010 & opcode_1_0_11; 

  wire rv32_miscmem  = opcode_6_5_00 & opcode_4_2_011 & opcode_1_0_11; 
  


  wire rv32_nmadd    = opcode_6_5_10 & opcode_4_2_011 & opcode_1_0_11; 
  wire rv32_jal      = opcode_6_5_11 & opcode_4_2_011 & opcode_1_0_11; 

  wire rv32_op_imm   = opcode_6_5_00 & opcode_4_2_100 & opcode_1_0_11; 
  wire rv32_op       = opcode_6_5_01 & opcode_4_2_100 & opcode_1_0_11; 
  wire rv32_op_fp    = opcode_6_5_10 & opcode_4_2_100 & opcode_1_0_11; 
  wire rv32_system   = opcode_6_5_11 & opcode_4_2_100 & opcode_1_0_11; 

  wire rv32_auipc    = opcode_6_5_00 & opcode_4_2_101 & opcode_1_0_11; 
  wire rv32_lui      = opcode_6_5_01 & opcode_4_2_101 & opcode_1_0_11; 
  wire rv32_resved1  = opcode_6_5_10 & opcode_4_2_101 & opcode_1_0_11; 
  wire rv32_resved2  = opcode_6_5_11 & opcode_4_2_101 & opcode_1_0_11; 

  wire rv32_op_imm_32= opcode_6_5_00 & opcode_4_2_110 & opcode_1_0_11; 
  wire rv32_op_32    = opcode_6_5_01 & opcode_4_2_110 & opcode_1_0_11; 
  wire rv32_custom2  = opcode_6_5_10 & opcode_4_2_110 & opcode_1_0_11; 
  wire rv32_custom3  = opcode_6_5_11 & opcode_4_2_110 & opcode_1_0_11; 








  // ===========================================================================
  // Branch Instructions
  wire rv32_beq      = rv32_branch & rv32_func3_000;
  wire rv32_bne      = rv32_branch & rv32_func3_001;
  wire rv32_blt      = rv32_branch & rv32_func3_100;
  wire rv32_bgt      = rv32_branch & rv32_func3_101;
  wire rv32_bltu     = rv32_branch & rv32_func3_110;
  wire rv32_bgtu     = rv32_branch & rv32_func3_111;

  // ===========================================================================
  // System Instructions
  wire rv32_ecall    = rv32_system & rv32_func3_000 & (rv32_instr[31:20] == 12'b0000_0000_0000);
  wire rv32_ebreak   = rv32_system & rv32_func3_000 & (rv32_instr[31:20] == 12'b0000_0000_0001);
  wire rv32_mret     = rv32_system & rv32_func3_000 & (rv32_instr[31:20] == 12'b0011_0000_0010);
  wire rv32_dret     = rv32_system & rv32_func3_000 & (rv32_instr[31:20] == 12'b0111_1011_0010);
  wire rv32_wfi      = rv32_system & rv32_func3_000 & (rv32_instr[31:20] == 12'b0001_0000_0101);
  // We dont implement the WFI and MRET illegal exception when the rs and rd is not zeros

  wire rv32_csrrw    = rv32_system & rv32_func3_001; 
  wire rv32_csrrs    = rv32_system & rv32_func3_010; 
  wire rv32_csrrc    = rv32_system & rv32_func3_011; 
  wire rv32_csrrwi   = rv32_system & rv32_func3_101; 
  wire rv32_csrrsi   = rv32_system & rv32_func3_110; 
  wire rv32_csrrci   = rv32_system & rv32_func3_111; 

  wire rv32_dret_ilgl = rv32_dret & (~dbg_mode);

  wire rv32_ecall_ebreak_ret_wfi = rv32_system & rv32_func3_000;
  wire rv32_csr          = rv32_system & (~rv32_func3_000);


  // ===========================================================================
    // The Branch and system group of instructions will be handled by BJP

  assign dec_jal     = rv32_jal;
  assign dec_jalr    = rv32_jalr ;
  assign dec_bxx     = rv32_branch ;
  assign dec_bjp     = dec_jal | dec_jalr | dec_bxx;


  wire rv32_fence  ;
  wire rv32_fence_i;
  wire rv32_fence_fencei;
  wire bjp_op = dec_bjp | rv32_mret | (rv32_dret & (~rv32_dret_ilgl)) | rv32_fence_fencei;

  wire [`E203_DECINFO_BJP_WIDTH-1:0] bjp_info_bus;
  assign bjp_info_bus[`E203_DECINFO_GRP    ]    = `E203_DECINFO_GRP_BJP;
  assign bjp_info_bus[`E203_DECINFO_RV32   ]    = rv32;
  assign bjp_info_bus[`E203_DECINFO_BJP_JUMP ]  = dec_jal | dec_jalr;
  assign bjp_info_bus[`E203_DECINFO_BJP_BPRDT]  = i_prdt_taken;
  assign bjp_info_bus[`E203_DECINFO_BJP_BEQ  ]  = rv32_beq ;
  assign bjp_info_bus[`E203_DECINFO_BJP_BNE  ]  = rv32_bne ;
  assign bjp_info_bus[`E203_DECINFO_BJP_BLT  ]  = rv32_blt; 
  assign bjp_info_bus[`E203_DECINFO_BJP_BGT  ]  = rv32_bgt ;
  assign bjp_info_bus[`E203_DECINFO_BJP_BLTU ]  = rv32_bltu;
  assign bjp_info_bus[`E203_DECINFO_BJP_BGTU ]  = rv32_bgtu;
  assign bjp_info_bus[`E203_DECINFO_BJP_BXX  ]  = dec_bxx;
  assign bjp_info_bus[`E203_DECINFO_BJP_MRET ]  = rv32_mret;
  assign bjp_info_bus[`E203_DECINFO_BJP_DRET ]  = rv32_dret;
  assign bjp_info_bus[`E203_DECINFO_BJP_FENCE ]  = rv32_fence;
  assign bjp_info_bus[`E203_DECINFO_BJP_FENCEI]  = rv32_fence_i;


  // ===========================================================================
  // ALU Instructions
  wire rv32_addi     = rv32_op_imm & rv32_func3_000;
  wire rv32_slti     = rv32_op_imm & rv32_func3_010;
  wire rv32_sltiu    = rv32_op_imm & rv32_func3_011;
  wire rv32_xori     = rv32_op_imm & rv32_func3_100;
  wire rv32_ori      = rv32_op_imm & rv32_func3_110;
  wire rv32_andi     = rv32_op_imm & rv32_func3_111;

  wire rv32_slli     = rv32_op_imm & rv32_func3_001 & (rv32_instr[31:26] == 6'b000000);
  wire rv32_srli     = rv32_op_imm & rv32_func3_101 & (rv32_instr[31:26] == 6'b000000);
  wire rv32_srai     = rv32_op_imm & rv32_func3_101 & (rv32_instr[31:26] == 6'b010000);

  wire rv32_sxxi_shamt_legl = (rv32_instr[25] == 1'b0); //shamt[5] must be zero for RV32I
  wire rv32_sxxi_shamt_ilgl =  (rv32_slli | rv32_srli | rv32_srai) & (~rv32_sxxi_shamt_legl);

  wire rv32_add      = rv32_op     & rv32_func3_000 & rv32_func7_0000000;
  wire rv32_sub      = rv32_op     & rv32_func3_000 & rv32_func7_0100000;
  wire rv32_sll      = rv32_op     & rv32_func3_001 & rv32_func7_0000000;
  wire rv32_slt      = rv32_op     & rv32_func3_010 & rv32_func7_0000000;
  wire rv32_sltu     = rv32_op     & rv32_func3_011 & rv32_func7_0000000;
  wire rv32_xor      = rv32_op     & rv32_func3_100 & rv32_func7_0000000;
  wire rv32_srl      = rv32_op     & rv32_func3_101 & rv32_func7_0000000;
  wire rv32_sra      = rv32_op     & rv32_func3_101 & rv32_func7_0100000;
  wire rv32_or       = rv32_op     & rv32_func3_110 & rv32_func7_0000000;
  wire rv32_and      = rv32_op     & rv32_func3_111 & rv32_func7_0000000;

  wire rv32_nop      = rv32_addi & rv32_rs1_x0 & rv32_rd_x0 & (~(|rv32_instr[31:20]));
  // The ALU group of instructions will be handled by 1cycle ALU-datapath
  wire ecall_ebreak = rv32_ecall | rv32_ebreak;

  wire alu_op = (~rv32_sxxi_shamt_ilgl)
                & 
              ( rv32_op_imm 
              | rv32_op & (~rv32_func7_0000001) // Exclude the MULDIV
              | rv32_auipc
              | rv32_lui
              | rv32_nop
              | rv32_wfi // We just put WFI into ALU and do nothing in ALU
              | ecall_ebreak)
              ;
  wire need_imm;
  wire [`E203_DECINFO_ALU_WIDTH-1:0] alu_info_bus;
  assign alu_info_bus[`E203_DECINFO_GRP    ]    = `E203_DECINFO_GRP_ALU;
  assign alu_info_bus[`E203_DECINFO_RV32   ]    = rv32;
  assign alu_info_bus[`E203_DECINFO_ALU_ADD]    = rv32_add  | rv32_addi | rv32_auipc;
  assign alu_info_bus[`E203_DECINFO_ALU_SUB]    = rv32_sub;      
  assign alu_info_bus[`E203_DECINFO_ALU_SLT]    = rv32_slt  | rv32_slti;     
  assign alu_info_bus[`E203_DECINFO_ALU_SLTU]   = rv32_sltu | rv32_sltiu;  
  assign alu_info_bus[`E203_DECINFO_ALU_XOR]    = rv32_xor  | rv32_xori;    
  assign alu_info_bus[`E203_DECINFO_ALU_SLL]    = rv32_sll  | rv32_slli;   
  assign alu_info_bus[`E203_DECINFO_ALU_SRL]    = rv32_srl  | rv32_srli ;
  assign alu_info_bus[`E203_DECINFO_ALU_SRA]    = rv32_sra  | rv32_srai;   
  assign alu_info_bus[`E203_DECINFO_ALU_OR ]    = rv32_or   | rv32_ori ;     
  assign alu_info_bus[`E203_DECINFO_ALU_AND]    = rv32_and  | rv32_andi;
  assign alu_info_bus[`E203_DECINFO_ALU_LUI]    = rv32_lui  ; 
  assign alu_info_bus[`E203_DECINFO_ALU_OP2IMM] = need_imm; 
  assign alu_info_bus[`E203_DECINFO_ALU_OP1PC ] = rv32_auipc;
  assign alu_info_bus[`E203_DECINFO_ALU_NOP ]   = rv32_nop;
  assign alu_info_bus[`E203_DECINFO_ALU_ECAL ]  = rv32_ecall; 
  assign alu_info_bus[`E203_DECINFO_ALU_EBRK ]  = rv32_ebreak;
  assign alu_info_bus[`E203_DECINFO_ALU_WFI  ]  = rv32_wfi;


  
  wire csr_op = rv32_csr;
  wire [`E203_DECINFO_CSR_WIDTH-1:0] csr_info_bus;
  assign csr_info_bus[`E203_DECINFO_GRP    ]    = `E203_DECINFO_GRP_CSR;
  assign csr_info_bus[`E203_DECINFO_RV32   ]    = rv32;
  assign csr_info_bus[`E203_DECINFO_CSR_CSRRW ] = rv32_csrrw | rv32_csrrwi; 
  assign csr_info_bus[`E203_DECINFO_CSR_CSRRS ] = rv32_csrrs | rv32_csrrsi;
  assign csr_info_bus[`E203_DECINFO_CSR_CSRRC ] = rv32_csrrc | rv32_csrrci;
  assign csr_info_bus[`E203_DECINFO_CSR_RS1IMM] = rv32_csrrwi | rv32_csrrsi | rv32_csrrci;
  assign csr_info_bus[`E203_DECINFO_CSR_ZIMMM ] = rv32_rs1;
  assign csr_info_bus[`E203_DECINFO_CSR_RS1IS0] = rv32_rs1_x0;
  assign csr_info_bus[`E203_DECINFO_CSR_CSRIDX] = rv32_instr[31:20];

  
  // ===========================================================================
  // Memory Order Instructions
  assign rv32_fence    = rv32_miscmem & rv32_func3_000;
  assign rv32_fence_i  = rv32_miscmem & rv32_func3_001;

  assign rv32_fence_fencei  = rv32_miscmem;


  // ===========================================================================
  // MUL/DIV Instructions
  wire rv32_mul      = rv32_op     & rv32_func3_000 & rv32_func7_0000001;
  wire rv32_mulh     = rv32_op     & rv32_func3_001 & rv32_func7_0000001;
  wire rv32_mulhsu   = rv32_op     & rv32_func3_010 & rv32_func7_0000001;
  wire rv32_mulhu    = rv32_op     & rv32_func3_011 & rv32_func7_0000001;
  wire rv32_div      = rv32_op     & rv32_func3_100 & rv32_func7_0000001;
  wire rv32_divu     = rv32_op     & rv32_func3_101 & rv32_func7_0000001;
  wire rv32_rem      = rv32_op     & rv32_func3_110 & rv32_func7_0000001;
  wire rv32_remu     = rv32_op     & rv32_func3_111 & rv32_func7_0000001;
  
  // The MULDIV group of instructions will be handled by MUL-DIV-datapath
  `ifdef E203_SUPPORT_MULDIV//{
  wire muldiv_op = rv32_op & rv32_func7_0000001;
  `endif//}
  `ifndef E203_SUPPORT_MULDIV//{
  wire muldiv_op = 1'b0;
  `endif//}

  wire [`E203_DECINFO_MULDIV_WIDTH-1:0] muldiv_info_bus;
  assign muldiv_info_bus[`E203_DECINFO_GRP          ] = `E203_DECINFO_GRP_MULDIV;
  assign muldiv_info_bus[`E203_DECINFO_RV32         ] = rv32        ;
  assign muldiv_info_bus[`E203_DECINFO_MULDIV_MUL   ] = rv32_mul    ;   
  assign muldiv_info_bus[`E203_DECINFO_MULDIV_MULH  ] = rv32_mulh   ;
  assign muldiv_info_bus[`E203_DECINFO_MULDIV_MULHSU] = rv32_mulhsu ;
  assign muldiv_info_bus[`E203_DECINFO_MULDIV_MULHU ] = rv32_mulhu  ;
  assign muldiv_info_bus[`E203_DECINFO_MULDIV_DIV   ] = rv32_div    ;
  assign muldiv_info_bus[`E203_DECINFO_MULDIV_DIVU  ] = rv32_divu   ;
  assign muldiv_info_bus[`E203_DECINFO_MULDIV_REM   ] = rv32_rem    ;
  assign muldiv_info_bus[`E203_DECINFO_MULDIV_REMU  ] = rv32_remu   ;
  assign muldiv_info_bus[`E203_DECINFO_MULDIV_B2B   ] = i_muldiv_b2b;

  assign dec_mulhsu = rv32_mulh | rv32_mulhsu | rv32_mulhu;
  assign dec_mul    = rv32_mul;
  assign dec_div    = rv32_div ;
  assign dec_divu   = rv32_divu;
  assign dec_rem    = rv32_rem;
  assign dec_remu   = rv32_remu;
 
  // ===========================================================================
  // Load/Store Instructions
  wire rv32_lb       = rv32_load   & rv32_func3_000;
  wire rv32_lh       = rv32_load   & rv32_func3_001;
  wire rv32_lw       = rv32_load   & rv32_func3_010;
  wire rv32_lbu      = rv32_load   & rv32_func3_100;
  wire rv32_lhu      = rv32_load   & rv32_func3_101;

  wire rv32_sb       = rv32_store  & rv32_func3_000;
  wire rv32_sh       = rv32_store  & rv32_func3_001;
  wire rv32_sw       = rv32_store  & rv32_func3_010;



  wire   amoldst_op = rv32_load | rv32_store ;

  wire [1:0] lsu_info_size = rv32_func3[1:0];

  wire       lsu_info_usign = rv32_func3[2];

  wire [`E203_DECINFO_AGU_WIDTH-1:0] agu_info_bus;
  assign agu_info_bus[`E203_DECINFO_GRP    ] = `E203_DECINFO_GRP_AGU;
  assign agu_info_bus[`E203_DECINFO_RV32   ] = rv32;
  assign agu_info_bus[`E203_DECINFO_AGU_LOAD   ] = rv32_load;
  assign agu_info_bus[`E203_DECINFO_AGU_STORE  ] = rv32_store;
  assign agu_info_bus[`E203_DECINFO_AGU_SIZE   ] = lsu_info_size;
  assign agu_info_bus[`E203_DECINFO_AGU_USIGN  ] = lsu_info_usign;
  assign agu_info_bus[`E203_DECINFO_AGU_EXCL   ] = 1'b0;
  assign agu_info_bus[`E203_DECINFO_AGU_AMO    ] = 1'b0;// We seperated the EXCL out of AMO in LSU handling
  assign agu_info_bus[`E203_DECINFO_AGU_AMOSWAP] = 1'b0;
  assign agu_info_bus[`E203_DECINFO_AGU_AMOADD ] = 1'b0 ;
  assign agu_info_bus[`E203_DECINFO_AGU_AMOAND ] = 1'b0;
  assign agu_info_bus[`E203_DECINFO_AGU_AMOOR  ] = 1'b0;
  assign agu_info_bus[`E203_DECINFO_AGU_AMOXOR ] = 1'b0;
  assign agu_info_bus[`E203_DECINFO_AGU_AMOMAX ] = 1'b0;
  assign agu_info_bus[`E203_DECINFO_AGU_AMOMIN ] = 1'b0;
  assign agu_info_bus[`E203_DECINFO_AGU_AMOMAXU] = 1'b0;
  assign agu_info_bus[`E203_DECINFO_AGU_AMOMINU] = 1'b0;
  assign agu_info_bus[`E203_DECINFO_AGU_OP2IMM ] = need_imm; 




  // Reuse the common signals as much as possible to save gatecounts
  wire rv32_all0s_ilgl  = rv32_func7_0000000 
                        & rv32_rs2_x0 
                        & rv32_rs1_x0 
                        & rv32_func3_000 
                        & rv32_rd_x0 
                        & opcode_6_5_00 
                        & opcode_4_2_000 
                        & (opcode[1:0] == 2'b00); 

  wire rv32_all1s_ilgl  = rv32_func7_1111111 
                        & rv32_rs2_x31 
                        & rv32_rs1_x31 
                        & rv32_func3_111 
                        & rv32_rd_x31 
                        & opcode_6_5_11 
                        & opcode_4_2_111 
                        & (opcode[1:0] == 2'b11); 


  
  wire rv_all0s1s_ilgl = (rv32_all0s_ilgl | rv32_all1s_ilgl);

  //
  // All the RV32IMA need RD register except the
  //   * Branch, Store,
  //   * fence, fence_i 
  //   * ecall, ebreak  
  wire rv32_need_rd = 
                      (~rv32_rd_x0) & (
                    (
                      (~rv32_branch) & (~rv32_store)
                    & (~rv32_fence_fencei)
                    & (~rv32_ecall_ebreak_ret_wfi) 
                    )
                   );

  // All the RV32IMA need RS1 register except the
  //   * lui
  //   * auipc
  //   * jal
  //   * fence, fence_i 
  //   * ecall, ebreak  
  //   * csrrwi
  //   * csrrsi
  //   * csrrci
  wire rv32_need_rs1 =
                      (~rv32_rs1_x0) & (
                    (
                      (~rv32_lui)
                    & (~rv32_auipc)
                    & (~rv32_jal)
                    & (~rv32_fence_fencei)
                    & (~rv32_ecall_ebreak_ret_wfi)
                    & (~rv32_csrrwi)
                    & (~rv32_csrrsi)
                    & (~rv32_csrrci)
                    )
                  );
                    
  // Following RV32IMA instructions need RS2 register
  //   * branch
  //   * store
  //   * rv32_op

  wire rv32_need_rs2 = (~rv32_rs2_x0) & (
                (
                 (rv32_branch)
               | (rv32_store)
               | (rv32_op)
                 )
                 );

  wire [31:0]  rv32_i_imm = { 
                               {20{rv32_instr[31]}} 
                              , rv32_instr[31:20]
                             };

  wire [31:0]  rv32_s_imm = {
                               {20{rv32_instr[31]}} 
                              , rv32_instr[31:25] 
                              , rv32_instr[11:7]
                             };


  wire [31:0]  rv32_b_imm = {
                               {19{rv32_instr[31]}} 
                              , rv32_instr[31] 
                              , rv32_instr[7] 
                              , rv32_instr[30:25] 
                              , rv32_instr[11:8]
                              , 1'b0
                              };

  wire [31:0]  rv32_u_imm = {rv32_instr[31:12],12'b0};

  wire [31:0]  rv32_j_imm = {
                               {11{rv32_instr[31]}} 
                              , rv32_instr[31] 
                              , rv32_instr[19:12] 
                              , rv32_instr[20] 
                              , rv32_instr[30:21]
                              , 1'b0
                              };

                   // It will select i-type immediate when
                   //    * rv32_op_imm
                   //    * rv32_jalr
                   //    * rv32_load
  wire rv32_imm_sel_i = rv32_op_imm | rv32_jalr | rv32_load;
  wire rv32_imm_sel_jalr = rv32_jalr;
  wire [31:0]  rv32_jalr_imm = rv32_i_imm;

                   // It will select u-type immediate when
                   //    * rv32_lui, rv32_auipc 
  wire rv32_imm_sel_u = rv32_lui | rv32_auipc;

                   // It will select j-type immediate when
                   //    * rv32_jal
  wire rv32_imm_sel_j = rv32_jal;
  wire rv32_imm_sel_jal = rv32_jal;
  wire [31:0]  rv32_jal_imm = rv32_j_imm;

                   // It will select b-type immediate when
                   //    * rv32_branch
  wire rv32_imm_sel_b = rv32_branch;
  wire rv32_imm_sel_bxx = rv32_branch;
  wire [31:0]  rv32_bxx_imm = rv32_b_imm;
                   
                   // It will select s-type immediate when
                   //    * rv32_store
  wire rv32_imm_sel_s = rv32_store;



  //   * Note: this CIS/CILI/CILUI/CI16SP-type is named by myself, because in 
  //           ISA doc, the CI format for LWSP is different
  //           with other CI formats in terms of immediate

                   
  
                   
  wire [31:0]  rv32_load_fp_imm  = rv32_i_imm;
  wire [31:0]  rv32_store_fp_imm = rv32_s_imm;
  wire [31:0]  rv32_imm = 
                     ({32{rv32_imm_sel_i}} & rv32_i_imm)
                   | ({32{rv32_imm_sel_s}} & rv32_s_imm)
                   | ({32{rv32_imm_sel_b}} & rv32_b_imm)
                   | ({32{rv32_imm_sel_u}} & rv32_u_imm)
                   | ({32{rv32_imm_sel_j}} & rv32_j_imm)
                   ;
                   
  wire  rv32_need_imm = 
                     rv32_imm_sel_i
                   | rv32_imm_sel_s
                   | rv32_imm_sel_b
                   | rv32_imm_sel_u
                   | rv32_imm_sel_j
                   ;




  assign need_imm =  rv32_need_imm; 

  assign dec_imm =  rv32_imm;
  assign dec_pc  = i_pc;

  

  assign dec_info = 
              ({`E203_DECINFO_WIDTH{alu_op}}     & {{`E203_DECINFO_WIDTH-`E203_DECINFO_ALU_WIDTH{1'b0}},alu_info_bus})
            | ({`E203_DECINFO_WIDTH{amoldst_op}} & {{`E203_DECINFO_WIDTH-`E203_DECINFO_AGU_WIDTH{1'b0}},agu_info_bus})
            | ({`E203_DECINFO_WIDTH{bjp_op}}     & {{`E203_DECINFO_WIDTH-`E203_DECINFO_BJP_WIDTH{1'b0}},bjp_info_bus})
            | ({`E203_DECINFO_WIDTH{csr_op}}     & {{`E203_DECINFO_WIDTH-`E203_DECINFO_CSR_WIDTH{1'b0}},csr_info_bus})
            | ({`E203_DECINFO_WIDTH{muldiv_op}}  & {{`E203_DECINFO_WIDTH-`E203_DECINFO_CSR_WIDTH{1'b0}},muldiv_info_bus})
              ;


  wire legl_ops = 
              alu_op
            | amoldst_op
            | bjp_op
            | csr_op
            | muldiv_op
            ;


                      

                     

  


  assign dec_rs1idx =  rv32_rs1[`E203_RFIDX_WIDTH-1:0];
  assign dec_rs2idx =  rv32_rs2[`E203_RFIDX_WIDTH-1:0];
  assign dec_rdidx  =  rv32_rd [`E203_RFIDX_WIDTH-1:0];


  assign dec_rs1en =  rv32_need_rs1 ; 
  assign dec_rs2en =  rv32_need_rs2 ;
  assign dec_rdwen =  rv32_need_rd  ;

  assign dec_rs1x0 = (dec_rs1idx == `E203_RFIDX_WIDTH'b0);
  assign dec_rs2x0 = (dec_rs2idx == `E203_RFIDX_WIDTH'b0);
                     


  assign dec_rv32 = rv32;

  assign dec_bjp_imm = ({32{rv32_jal              }} & rv32_jal_imm)
                   | ({32{rv32_jalr             }} & rv32_jalr_imm)
                   | ({32{rv32_branch           }} & rv32_bxx_imm)
                   ;

  assign dec_jalr_rs1idx =  rv32_rs1[`E203_RFIDX_WIDTH-1:0];

  assign dec_misalgn = i_misalgn;
  assign dec_buserr  = i_buserr ;


  assign dec_ilegl = 
            (rv_all0s1s_ilgl) 
          | (rv32_sxxi_shamt_ilgl)
          | (rv32_dret_ilgl)
          | (~legl_ops);


endmodule                                      
                                               
                                               
                                               
