
//////////////////////////////////////////////////////////////////////////////////
// Company:    
// Engineer: 29505
// Create Date: 2019-06-26 09:51:22
// Last Modified by:   29505
// Last Modified time: 2019-06-30 16:24:20
// Email: 295054118@whut.edu.cn
// Design Name: e203_subsys_perips.v  
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
//  The peirpheral bus and the connected devices 
//
// ====================================================================

`include "e203_defines.v"


module e203_subsys_perips(
  input                          ppi_icb_cmd_valid,
  output                         ppi_icb_cmd_ready,
  input  [`E203_ADDR_SIZE-1:0]   ppi_icb_cmd_addr, 
  input                          ppi_icb_cmd_read, 
  input  [`E203_XLEN-1:0]        ppi_icb_cmd_wdata,
  input  [`E203_XLEN/8-1:0]      ppi_icb_cmd_wmask,
  //
  output                         ppi_icb_rsp_valid,
  input                          ppi_icb_rsp_ready,
  output                         ppi_icb_rsp_err,
  output [`E203_XLEN-1:0]        ppi_icb_rsp_rdata,
  
  //////////////////////////////////////////////////////////
  output                         sysper_icb_cmd_valid,
  input                          sysper_icb_cmd_ready,
  output [`E203_ADDR_SIZE-1:0]   sysper_icb_cmd_addr, 
  output                         sysper_icb_cmd_read, 
  output [`E203_XLEN-1:0]        sysper_icb_cmd_wdata,
  output [`E203_XLEN/8-1:0]      sysper_icb_cmd_wmask,
  //
  input                          sysper_icb_rsp_valid,
  output                         sysper_icb_rsp_ready,
  input                          sysper_icb_rsp_err,
  input  [`E203_XLEN-1:0]        sysper_icb_rsp_rdata,

  //////////////////////////////////////////////////////////
  output                         aon_icb_cmd_valid,
  input                          aon_icb_cmd_ready,
  output [`E203_ADDR_SIZE-1:0]   aon_icb_cmd_addr, 
  output                         aon_icb_cmd_read, 
  output [`E203_XLEN-1:0]        aon_icb_cmd_wdata,
  //
  input                          aon_icb_rsp_valid,
  output                         aon_icb_rsp_ready,
  input                          aon_icb_rsp_err,
  input  [`E203_XLEN-1:0]        aon_icb_rsp_rdata,

  
  input                      otp_ro_icb_cmd_valid,
  output                     otp_ro_icb_cmd_ready,
  input  [32-1:0]            otp_ro_icb_cmd_addr, 
  input                      otp_ro_icb_cmd_read, 
  input  [32-1:0]            otp_ro_icb_cmd_wdata,
  
  output                     otp_ro_icb_rsp_valid,
  input                      otp_ro_icb_rsp_ready,
  output [32-1:0]            otp_ro_icb_rsp_rdata,


  input  io_pads_gpio_0_i_ival,
  output io_pads_gpio_0_o_oval,
  output io_pads_gpio_0_o_oe,
  output io_pads_gpio_0_o_ie,
  output io_pads_gpio_0_o_pue,
  output io_pads_gpio_0_o_ds,
  input  io_pads_gpio_1_i_ival,
  output io_pads_gpio_1_o_oval,
  output io_pads_gpio_1_o_oe,
  output io_pads_gpio_1_o_ie,
  output io_pads_gpio_1_o_pue,
  output io_pads_gpio_1_o_ds,
  input  io_pads_gpio_2_i_ival,
  output io_pads_gpio_2_o_oval,
  output io_pads_gpio_2_o_oe,
  output io_pads_gpio_2_o_ie,
  output io_pads_gpio_2_o_pue,
  output io_pads_gpio_2_o_ds,
  input  io_pads_gpio_3_i_ival,
  output io_pads_gpio_3_o_oval,
  output io_pads_gpio_3_o_oe,
  output io_pads_gpio_3_o_ie,
  output io_pads_gpio_3_o_pue,
  output io_pads_gpio_3_o_ds,
  input  io_pads_gpio_4_i_ival,
  output io_pads_gpio_4_o_oval,
  output io_pads_gpio_4_o_oe,
  output io_pads_gpio_4_o_ie,
  output io_pads_gpio_4_o_pue,
  output io_pads_gpio_4_o_ds,
  input  io_pads_gpio_5_i_ival,
  output io_pads_gpio_5_o_oval,
  output io_pads_gpio_5_o_oe,
  output io_pads_gpio_5_o_ie,
  output io_pads_gpio_5_o_pue,
  output io_pads_gpio_5_o_ds,
  input  io_pads_gpio_6_i_ival,
  output io_pads_gpio_6_o_oval,
  output io_pads_gpio_6_o_oe,
  output io_pads_gpio_6_o_ie,
  output io_pads_gpio_6_o_pue,
  output io_pads_gpio_6_o_ds,
  input  io_pads_gpio_7_i_ival,
  output io_pads_gpio_7_o_oval,
  output io_pads_gpio_7_o_oe,
  output io_pads_gpio_7_o_ie,
  output io_pads_gpio_7_o_pue,
  output io_pads_gpio_7_o_ds,
  input  io_pads_gpio_8_i_ival,
  output io_pads_gpio_8_o_oval,
  output io_pads_gpio_8_o_oe,
  output io_pads_gpio_8_o_ie,
  output io_pads_gpio_8_o_pue,
  output io_pads_gpio_8_o_ds,
  input  io_pads_gpio_9_i_ival,
  output io_pads_gpio_9_o_oval,
  output io_pads_gpio_9_o_oe,
  output io_pads_gpio_9_o_ie,
  output io_pads_gpio_9_o_pue,
  output io_pads_gpio_9_o_ds,
  input  io_pads_gpio_10_i_ival,
  output io_pads_gpio_10_o_oval,
  output io_pads_gpio_10_o_oe,
  output io_pads_gpio_10_o_ie,
  output io_pads_gpio_10_o_pue,
  output io_pads_gpio_10_o_ds,
  input  io_pads_gpio_11_i_ival,
  output io_pads_gpio_11_o_oval,
  output io_pads_gpio_11_o_oe,
  output io_pads_gpio_11_o_ie,
  output io_pads_gpio_11_o_pue,
  output io_pads_gpio_11_o_ds,
  input  io_pads_gpio_12_i_ival,
  output io_pads_gpio_12_o_oval,
  output io_pads_gpio_12_o_oe,
  output io_pads_gpio_12_o_ie,
  output io_pads_gpio_12_o_pue,
  output io_pads_gpio_12_o_ds,
  input  io_pads_gpio_13_i_ival,
  output io_pads_gpio_13_o_oval,
  output io_pads_gpio_13_o_oe,
  output io_pads_gpio_13_o_ie,
  output io_pads_gpio_13_o_pue,
  output io_pads_gpio_13_o_ds,
  input  io_pads_gpio_14_i_ival,
  output io_pads_gpio_14_o_oval,
  output io_pads_gpio_14_o_oe,
  output io_pads_gpio_14_o_ie,
  output io_pads_gpio_14_o_pue,
  output io_pads_gpio_14_o_ds,
  input  io_pads_gpio_15_i_ival,
  output io_pads_gpio_15_o_oval,
  output io_pads_gpio_15_o_oe,
  output io_pads_gpio_15_o_ie,
  output io_pads_gpio_15_o_pue,
  output io_pads_gpio_15_o_ds,
  input  io_pads_gpio_16_i_ival,
  output io_pads_gpio_16_o_oval,
  output io_pads_gpio_16_o_oe,
  output io_pads_gpio_16_o_ie,
  output io_pads_gpio_16_o_pue,
  output io_pads_gpio_16_o_ds,
  input  io_pads_gpio_17_i_ival,
  output io_pads_gpio_17_o_oval,
  output io_pads_gpio_17_o_oe,
  output io_pads_gpio_17_o_ie,
  output io_pads_gpio_17_o_pue,
  output io_pads_gpio_17_o_ds,
  input  io_pads_gpio_18_i_ival,
  output io_pads_gpio_18_o_oval,
  output io_pads_gpio_18_o_oe,
  output io_pads_gpio_18_o_ie,
  output io_pads_gpio_18_o_pue,
  output io_pads_gpio_18_o_ds,
  input  io_pads_gpio_19_i_ival,
  output io_pads_gpio_19_o_oval,
  output io_pads_gpio_19_o_oe,
  output io_pads_gpio_19_o_ie,
  output io_pads_gpio_19_o_pue,
  output io_pads_gpio_19_o_ds,
  input  io_pads_gpio_20_i_ival,
  output io_pads_gpio_20_o_oval,
  output io_pads_gpio_20_o_oe,
  output io_pads_gpio_20_o_ie,
  output io_pads_gpio_20_o_pue,
  output io_pads_gpio_20_o_ds,
  input  io_pads_gpio_21_i_ival,
  output io_pads_gpio_21_o_oval,
  output io_pads_gpio_21_o_oe,
  output io_pads_gpio_21_o_ie,
  output io_pads_gpio_21_o_pue,
  output io_pads_gpio_21_o_ds,
  input  io_pads_gpio_22_i_ival,
  output io_pads_gpio_22_o_oval,
  output io_pads_gpio_22_o_oe,
  output io_pads_gpio_22_o_ie,
  output io_pads_gpio_22_o_pue,
  output io_pads_gpio_22_o_ds,
  input  io_pads_gpio_23_i_ival,
  output io_pads_gpio_23_o_oval,
  output io_pads_gpio_23_o_oe,
  output io_pads_gpio_23_o_ie,
  output io_pads_gpio_23_o_pue,
  output io_pads_gpio_23_o_ds,
  input  io_pads_gpio_24_i_ival,
  output io_pads_gpio_24_o_oval,
  output io_pads_gpio_24_o_oe,
  output io_pads_gpio_24_o_ie,
  output io_pads_gpio_24_o_pue,
  output io_pads_gpio_24_o_ds,
  input  io_pads_gpio_25_i_ival,
  output io_pads_gpio_25_o_oval,
  output io_pads_gpio_25_o_oe,
  output io_pads_gpio_25_o_ie,
  output io_pads_gpio_25_o_pue,
  output io_pads_gpio_25_o_ds,
  input  io_pads_gpio_26_i_ival,
  output io_pads_gpio_26_o_oval,
  output io_pads_gpio_26_o_oe,
  output io_pads_gpio_26_o_ie,
  output io_pads_gpio_26_o_pue,
  output io_pads_gpio_26_o_ds,
  input  io_pads_gpio_27_i_ival,
  output io_pads_gpio_27_o_oval,
  output io_pads_gpio_27_o_oe,
  output io_pads_gpio_27_o_ie,
  output io_pads_gpio_27_o_pue,
  output io_pads_gpio_27_o_ds,
  input  io_pads_gpio_28_i_ival,
  output io_pads_gpio_28_o_oval,
  output io_pads_gpio_28_o_oe,
  output io_pads_gpio_28_o_ie,
  output io_pads_gpio_28_o_pue,
  output io_pads_gpio_28_o_ds,
  input  io_pads_gpio_29_i_ival,
  output io_pads_gpio_29_o_oval,
  output io_pads_gpio_29_o_oe,
  output io_pads_gpio_29_o_ie,
  output io_pads_gpio_29_o_pue,
  output io_pads_gpio_29_o_ds,
  input  io_pads_gpio_30_i_ival,
  output io_pads_gpio_30_o_oval,
  output io_pads_gpio_30_o_oe,
  output io_pads_gpio_30_o_ie,
  output io_pads_gpio_30_o_pue,
  output io_pads_gpio_30_o_ds,
  input  io_pads_gpio_31_i_ival,
  output io_pads_gpio_31_o_oval,
  output io_pads_gpio_31_o_oe,
  output io_pads_gpio_31_o_ie,
  output io_pads_gpio_31_o_pue,
  output io_pads_gpio_31_o_ds,


  output uart0_irq,                

  output gpio_irq_0,
  output gpio_irq_1,
  output gpio_irq_2,
  output gpio_irq_3,
  output gpio_irq_4,
  output gpio_irq_5,
  output gpio_irq_6,
  output gpio_irq_7,
  output gpio_irq_8,
  output gpio_irq_9,
  output gpio_irq_10,
  output gpio_irq_11,
  output gpio_irq_12,
  output gpio_irq_13,
  output gpio_irq_14,
  output gpio_irq_15,
  output gpio_irq_16,
  output gpio_irq_17,
  output gpio_irq_18,
  output gpio_irq_19,
  output gpio_irq_20,
  output gpio_irq_21,
  output gpio_irq_22,
  output gpio_irq_23,
  output gpio_irq_24,
  output gpio_irq_25,
  output gpio_irq_26,
  output gpio_irq_27,
  output gpio_irq_28,
  output gpio_irq_29,
  output gpio_irq_30,
  output gpio_irq_31,

  output pllbypass ,
  output pll_RESET ,
  output pll_ASLEEP ,
  output [1:0]  pll_OD,
  output [7:0]  pll_M,
  output [4:0]  pll_N,
  output plloutdivby1,
  output [5:0] plloutdiv,

  output hfxoscen,



  input  clk,
  input  bus_rst_n,
  input  rst_n
  );

  
  wire                         i_aon_icb_cmd_valid;
  wire                         i_aon_icb_cmd_ready;
  wire [`E203_ADDR_SIZE-1:0]   i_aon_icb_cmd_addr; 
  wire                         i_aon_icb_cmd_read; 
  wire [`E203_XLEN-1:0]        i_aon_icb_cmd_wdata;

  wire                         i_aon_icb_rsp_valid;
  wire                         i_aon_icb_rsp_ready;
  wire                         i_aon_icb_rsp_err;
  wire [`E203_XLEN-1:0]        i_aon_icb_rsp_rdata;


  wire gpio_iof_0_0_i_ival   ;
  wire gpio_iof_0_0_o_oval   ;
  wire gpio_iof_0_0_o_oe   ;
  wire gpio_iof_0_0_o_ie   ;
  wire gpio_iof_0_0_o_valid   ;
  wire gpio_iof_0_1_i_ival   ;
  wire gpio_iof_0_1_o_oval   ;
  wire gpio_iof_0_1_o_oe   ;
  wire gpio_iof_0_1_o_ie   ;
  wire gpio_iof_0_1_o_valid   ;
  wire gpio_iof_0_2_i_ival   ;
  wire gpio_iof_0_2_o_oval   ;
  wire gpio_iof_0_2_o_oe   ;
  wire gpio_iof_0_2_o_ie   ;
  wire gpio_iof_0_2_o_valid   ;
  wire gpio_iof_0_3_i_ival   ;
  wire gpio_iof_0_3_o_oval   ;
  wire gpio_iof_0_3_o_oe   ;
  wire gpio_iof_0_3_o_ie   ;
  wire gpio_iof_0_3_o_valid   ;
  wire gpio_iof_0_4_i_ival   ;
  wire gpio_iof_0_4_o_oval   ;
  wire gpio_iof_0_4_o_oe   ;
  wire gpio_iof_0_4_o_ie   ;
  wire gpio_iof_0_4_o_valid   ;
  wire gpio_iof_0_5_i_ival   ;
  wire gpio_iof_0_5_o_oval   ;
  wire gpio_iof_0_5_o_oe   ;
  wire gpio_iof_0_5_o_ie   ;
  wire gpio_iof_0_5_o_valid   ;
  wire gpio_iof_0_6_i_ival   ;
  wire gpio_iof_0_6_o_oval   ;
  wire gpio_iof_0_6_o_oe   ;
  wire gpio_iof_0_6_o_ie   ;
  wire gpio_iof_0_6_o_valid   ;
  wire gpio_iof_0_7_i_ival   ;
  wire gpio_iof_0_7_o_oval   ;
  wire gpio_iof_0_7_o_oe   ;
  wire gpio_iof_0_7_o_ie   ;
  wire gpio_iof_0_7_o_valid   ;
  wire gpio_iof_0_8_i_ival   ;
  wire gpio_iof_0_8_o_oval   ;
  wire gpio_iof_0_8_o_oe   ;
  wire gpio_iof_0_8_o_ie   ;
  wire gpio_iof_0_8_o_valid   ;
  wire gpio_iof_0_9_i_ival   ;
  wire gpio_iof_0_9_o_oval   ;
  wire gpio_iof_0_9_o_oe   ;
  wire gpio_iof_0_9_o_ie   ;
  wire gpio_iof_0_9_o_valid   ;
  wire gpio_iof_0_10_i_ival   ;
  wire gpio_iof_0_10_o_oval   ;
  wire gpio_iof_0_10_o_oe   ;
  wire gpio_iof_0_10_o_ie   ;
  wire gpio_iof_0_10_o_valid   ;
  wire gpio_iof_0_11_i_ival   ;
  wire gpio_iof_0_11_o_oval   ;
  wire gpio_iof_0_11_o_oe   ;
  wire gpio_iof_0_11_o_ie   ;
  wire gpio_iof_0_11_o_valid   ;
  wire gpio_iof_0_12_i_ival   ;
  wire gpio_iof_0_12_o_oval   ;
  wire gpio_iof_0_12_o_oe   ;
  wire gpio_iof_0_12_o_ie   ;
  wire gpio_iof_0_12_o_valid   ;
  wire gpio_iof_0_13_i_ival   ;
  wire gpio_iof_0_13_o_oval   ;
  wire gpio_iof_0_13_o_oe   ;
  wire gpio_iof_0_13_o_ie   ;
  wire gpio_iof_0_13_o_valid   ;
  wire gpio_iof_0_14_i_ival   ;
  wire gpio_iof_0_14_o_oval   ;
  wire gpio_iof_0_14_o_oe   ;
  wire gpio_iof_0_14_o_ie   ;
  wire gpio_iof_0_14_o_valid   ;
  wire gpio_iof_0_15_i_ival   ;
  wire gpio_iof_0_15_o_oval   ;
  wire gpio_iof_0_15_o_oe   ;
  wire gpio_iof_0_15_o_ie   ;
  wire gpio_iof_0_15_o_valid   ;
  wire gpio_iof_0_16_i_ival   ;
  wire gpio_iof_0_16_o_oval   ;
  wire gpio_iof_0_16_o_oe   ;
  wire gpio_iof_0_16_o_ie   ;
  wire gpio_iof_0_16_o_valid   ;
  wire gpio_iof_0_17_i_ival   ;
  wire gpio_iof_0_17_o_oval   ;
  wire gpio_iof_0_17_o_oe   ;
  wire gpio_iof_0_17_o_ie   ;
  wire gpio_iof_0_17_o_valid   ;
  wire gpio_iof_0_18_i_ival   ;
  wire gpio_iof_0_18_o_oval   ;
  wire gpio_iof_0_18_o_oe   ;
  wire gpio_iof_0_18_o_ie   ;
  wire gpio_iof_0_18_o_valid   ;
  wire gpio_iof_0_19_i_ival   ;
  wire gpio_iof_0_19_o_oval   ;
  wire gpio_iof_0_19_o_oe   ;
  wire gpio_iof_0_19_o_ie   ;
  wire gpio_iof_0_19_o_valid   ;
  wire gpio_iof_0_20_i_ival   ;
  wire gpio_iof_0_20_o_oval   ;
  wire gpio_iof_0_20_o_oe   ;
  wire gpio_iof_0_20_o_ie   ;
  wire gpio_iof_0_20_o_valid   ;
  wire gpio_iof_0_21_i_ival   ;
  wire gpio_iof_0_21_o_oval   ;
  wire gpio_iof_0_21_o_oe   ;
  wire gpio_iof_0_21_o_ie   ;
  wire gpio_iof_0_21_o_valid   ;
  wire gpio_iof_0_22_i_ival   ;
  wire gpio_iof_0_22_o_oval   ;
  wire gpio_iof_0_22_o_oe   ;
  wire gpio_iof_0_22_o_ie   ;
  wire gpio_iof_0_22_o_valid   ;
  wire gpio_iof_0_23_i_ival   ;
  wire gpio_iof_0_23_o_oval   ;
  wire gpio_iof_0_23_o_oe   ;
  wire gpio_iof_0_23_o_ie   ;
  wire gpio_iof_0_23_o_valid   ;
  wire gpio_iof_0_24_i_ival   ;
  wire gpio_iof_0_24_o_oval   ;
  wire gpio_iof_0_24_o_oe   ;
  wire gpio_iof_0_24_o_ie   ;
  wire gpio_iof_0_24_o_valid   ;
  wire gpio_iof_0_25_i_ival   ;
  wire gpio_iof_0_25_o_oval   ;
  wire gpio_iof_0_25_o_oe   ;
  wire gpio_iof_0_25_o_ie   ;
  wire gpio_iof_0_25_o_valid   ;
  wire gpio_iof_0_26_i_ival   ;
  wire gpio_iof_0_26_o_oval   ;
  wire gpio_iof_0_26_o_oe   ;
  wire gpio_iof_0_26_o_ie   ;
  wire gpio_iof_0_26_o_valid   ;
  wire gpio_iof_0_27_i_ival   ;
  wire gpio_iof_0_27_o_oval   ;
  wire gpio_iof_0_27_o_oe   ;
  wire gpio_iof_0_27_o_ie   ;
  wire gpio_iof_0_27_o_valid   ;
  wire gpio_iof_0_28_i_ival   ;
  wire gpio_iof_0_28_o_oval   ;
  wire gpio_iof_0_28_o_oe   ;
  wire gpio_iof_0_28_o_ie   ;
  wire gpio_iof_0_28_o_valid   ;
  wire gpio_iof_0_29_i_ival   ;
  wire gpio_iof_0_29_o_oval   ;
  wire gpio_iof_0_29_o_oe   ;
  wire gpio_iof_0_29_o_ie   ;
  wire gpio_iof_0_29_o_valid   ;
  wire gpio_iof_0_30_i_ival   ;
  wire gpio_iof_0_30_o_oval   ;
  wire gpio_iof_0_30_o_oe   ;
  wire gpio_iof_0_30_o_ie   ;
  wire gpio_iof_0_30_o_valid   ;
  wire gpio_iof_0_31_i_ival   ;
  wire gpio_iof_0_31_o_oval   ;
  wire gpio_iof_0_31_o_oe   ;
  wire gpio_iof_0_31_o_ie   ;
  wire gpio_iof_0_31_o_valid   ;
  
  wire gpio_iof_1_0_i_ival   ;
  wire gpio_iof_1_0_o_oval   ;
  wire gpio_iof_1_0_o_oe   ;
  wire gpio_iof_1_0_o_ie   ;
  wire gpio_iof_1_0_o_valid   ;
  wire gpio_iof_1_1_i_ival   ;
  wire gpio_iof_1_1_o_oval   ;
  wire gpio_iof_1_1_o_oe   ;
  wire gpio_iof_1_1_o_ie   ;
  wire gpio_iof_1_1_o_valid   ;
  wire gpio_iof_1_2_i_ival   ;
  wire gpio_iof_1_2_o_oval   ;
  wire gpio_iof_1_2_o_oe   ;
  wire gpio_iof_1_2_o_ie   ;
  wire gpio_iof_1_2_o_valid   ;
  wire gpio_iof_1_3_i_ival   ;
  wire gpio_iof_1_3_o_oval   ;
  wire gpio_iof_1_3_o_oe   ;
  wire gpio_iof_1_3_o_ie   ;
  wire gpio_iof_1_3_o_valid   ;
  wire gpio_iof_1_4_i_ival   ;
  wire gpio_iof_1_4_o_oval   ;
  wire gpio_iof_1_4_o_oe   ;
  wire gpio_iof_1_4_o_ie   ;
  wire gpio_iof_1_4_o_valid   ;
  wire gpio_iof_1_5_i_ival   ;
  wire gpio_iof_1_5_o_oval   ;
  wire gpio_iof_1_5_o_oe   ;
  wire gpio_iof_1_5_o_ie   ;
  wire gpio_iof_1_5_o_valid   ;
  wire gpio_iof_1_6_i_ival   ;
  wire gpio_iof_1_6_o_oval   ;
  wire gpio_iof_1_6_o_oe   ;
  wire gpio_iof_1_6_o_ie   ;
  wire gpio_iof_1_6_o_valid   ;
  wire gpio_iof_1_7_i_ival   ;
  wire gpio_iof_1_7_o_oval   ;
  wire gpio_iof_1_7_o_oe   ;
  wire gpio_iof_1_7_o_ie   ;
  wire gpio_iof_1_7_o_valid   ;
  wire gpio_iof_1_8_i_ival   ;
  wire gpio_iof_1_8_o_oval   ;
  wire gpio_iof_1_8_o_oe   ;
  wire gpio_iof_1_8_o_ie   ;
  wire gpio_iof_1_8_o_valid   ;
  wire gpio_iof_1_9_i_ival   ;
  wire gpio_iof_1_9_o_oval   ;
  wire gpio_iof_1_9_o_oe   ;
  wire gpio_iof_1_9_o_ie   ;
  wire gpio_iof_1_9_o_valid   ;
  wire gpio_iof_1_10_i_ival   ;
  wire gpio_iof_1_10_o_oval   ;
  wire gpio_iof_1_10_o_oe   ;
  wire gpio_iof_1_10_o_ie   ;
  wire gpio_iof_1_10_o_valid   ;
  wire gpio_iof_1_11_i_ival   ;
  wire gpio_iof_1_11_o_oval   ;
  wire gpio_iof_1_11_o_oe   ;
  wire gpio_iof_1_11_o_ie   ;
  wire gpio_iof_1_11_o_valid   ;
  wire gpio_iof_1_12_i_ival   ;
  wire gpio_iof_1_12_o_oval   ;
  wire gpio_iof_1_12_o_oe   ;
  wire gpio_iof_1_12_o_ie   ;
  wire gpio_iof_1_12_o_valid   ;
  wire gpio_iof_1_13_i_ival   ;
  wire gpio_iof_1_13_o_oval   ;
  wire gpio_iof_1_13_o_oe   ;
  wire gpio_iof_1_13_o_ie   ;
  wire gpio_iof_1_13_o_valid   ;
  wire gpio_iof_1_14_i_ival   ;
  wire gpio_iof_1_14_o_oval   ;
  wire gpio_iof_1_14_o_oe   ;
  wire gpio_iof_1_14_o_ie   ;
  wire gpio_iof_1_14_o_valid   ;
  wire gpio_iof_1_15_i_ival   ;
  wire gpio_iof_1_15_o_oval   ;
  wire gpio_iof_1_15_o_oe   ;
  wire gpio_iof_1_15_o_ie   ;
  wire gpio_iof_1_15_o_valid   ;
  wire gpio_iof_1_16_i_ival   ;
  wire gpio_iof_1_16_o_oval   ;
  wire gpio_iof_1_16_o_oe   ;
  wire gpio_iof_1_16_o_ie   ;
  wire gpio_iof_1_16_o_valid   ;
  wire gpio_iof_1_17_i_ival   ;
  wire gpio_iof_1_17_o_oval   ;
  wire gpio_iof_1_17_o_oe   ;
  wire gpio_iof_1_17_o_ie   ;
  wire gpio_iof_1_17_o_valid   ;
  wire gpio_iof_1_18_i_ival   ;
  wire gpio_iof_1_18_o_oval   ;
  wire gpio_iof_1_18_o_oe   ;
  wire gpio_iof_1_18_o_ie   ;
  wire gpio_iof_1_18_o_valid   ;
  wire gpio_iof_1_19_i_ival   ;
  wire gpio_iof_1_19_o_oval   ;
  wire gpio_iof_1_19_o_oe   ;
  wire gpio_iof_1_19_o_ie   ;
  wire gpio_iof_1_19_o_valid   ;
  wire gpio_iof_1_20_i_ival   ;
  wire gpio_iof_1_20_o_oval   ;
  wire gpio_iof_1_20_o_oe   ;
  wire gpio_iof_1_20_o_ie   ;
  wire gpio_iof_1_20_o_valid   ;
  wire gpio_iof_1_21_i_ival   ;
  wire gpio_iof_1_21_o_oval   ;
  wire gpio_iof_1_21_o_oe   ;
  wire gpio_iof_1_21_o_ie   ;
  wire gpio_iof_1_21_o_valid   ;
  wire gpio_iof_1_22_i_ival   ;
  wire gpio_iof_1_22_o_oval   ;
  wire gpio_iof_1_22_o_oe   ;
  wire gpio_iof_1_22_o_ie   ;
  wire gpio_iof_1_22_o_valid   ;
  wire gpio_iof_1_23_i_ival   ;
  wire gpio_iof_1_23_o_oval   ;
  wire gpio_iof_1_23_o_oe   ;
  wire gpio_iof_1_23_o_ie   ;
  wire gpio_iof_1_23_o_valid   ;
  wire gpio_iof_1_24_i_ival   ;
  wire gpio_iof_1_24_o_oval   ;
  wire gpio_iof_1_24_o_oe   ;
  wire gpio_iof_1_24_o_ie   ;
  wire gpio_iof_1_24_o_valid   ;
  wire gpio_iof_1_25_i_ival   ;
  wire gpio_iof_1_25_o_oval   ;
  wire gpio_iof_1_25_o_oe   ;
  wire gpio_iof_1_25_o_ie   ;
  wire gpio_iof_1_25_o_valid   ;
  wire gpio_iof_1_26_i_ival   ;
  wire gpio_iof_1_26_o_oval   ;
  wire gpio_iof_1_26_o_oe   ;
  wire gpio_iof_1_26_o_ie   ;
  wire gpio_iof_1_26_o_valid   ;
  wire gpio_iof_1_27_i_ival   ;
  wire gpio_iof_1_27_o_oval   ;
  wire gpio_iof_1_27_o_oe   ;
  wire gpio_iof_1_27_o_ie   ;
  wire gpio_iof_1_27_o_valid   ;
  wire gpio_iof_1_28_i_ival   ;
  wire gpio_iof_1_28_o_oval   ;
  wire gpio_iof_1_28_o_oe   ;
  wire gpio_iof_1_28_o_ie   ;
  wire gpio_iof_1_28_o_valid   ;
  wire gpio_iof_1_29_i_ival   ;
  wire gpio_iof_1_29_o_oval   ;
  wire gpio_iof_1_29_o_oe   ;
  wire gpio_iof_1_29_o_ie   ;
  wire gpio_iof_1_29_o_valid   ;
  wire gpio_iof_1_30_i_ival   ;
  wire gpio_iof_1_30_o_oval   ;
  wire gpio_iof_1_30_o_oe   ;
  wire gpio_iof_1_30_o_ie   ;
  wire gpio_iof_1_30_o_valid   ;
  wire gpio_iof_1_31_i_ival   ;
  wire gpio_iof_1_31_o_oval   ;
  wire gpio_iof_1_31_o_oe   ;
  wire gpio_iof_1_31_o_ie   ;
  wire gpio_iof_1_31_o_valid   ;

  wire  uart0_txd;
  wire  uart0_rxd;
  wire  uart_pins_0_io_pins_rxd_i_ival;
  wire  uart_pins_0_io_pins_rxd_o_oval;
  wire  uart_pins_0_io_pins_rxd_o_oe;
  wire  uart_pins_0_io_pins_rxd_o_ie;
  wire  uart_pins_0_io_pins_rxd_o_pue;
  wire  uart_pins_0_io_pins_rxd_o_ds;
  wire  uart_pins_0_io_pins_txd_i_ival;
  wire  uart_pins_0_io_pins_txd_o_oval;
  wire  uart_pins_0_io_pins_txd_o_oe;
  wire  uart_pins_0_io_pins_txd_o_ie;
  wire  uart_pins_0_io_pins_txd_o_pue;
  wire  uart_pins_0_io_pins_txd_o_ds;
  // wire  uart1_txd;

  assign gpio_iof_0_0_o_oval       = 1'b0;
  assign gpio_iof_0_0_o_oe         = 1'b0;
  assign gpio_iof_0_0_o_ie         = 1'b0;
  assign gpio_iof_0_0_o_valid      = 1'b0;

  assign gpio_iof_0_1_o_oval       = 1'b0;
  assign gpio_iof_0_1_o_oe         = 1'b0;
  assign gpio_iof_0_1_o_ie         = 1'b0;
  assign gpio_iof_0_1_o_valid      = 1'b0;

  assign spi_pins_0_io_pins_cs_0_i_ival = 1'b0;
  assign gpio_iof_0_2_o_oval       = 1'b0;
  assign gpio_iof_0_2_o_oe         = 1'b0;
  assign gpio_iof_0_2_o_ie         = 1'b0;
  assign gpio_iof_0_2_o_valid      = 1'b0;

  assign spi_pins_0_io_pins_dq_0_i_ival = 1'b0;
  assign gpio_iof_0_3_o_oval       = 1'b0;
  assign gpio_iof_0_3_o_oe         = 1'b0;
  assign gpio_iof_0_3_o_ie         = 1'b0;
  assign gpio_iof_0_3_o_valid      = 1'b0;

  assign spi_pins_0_io_pins_dq_1_i_ival = 1'b0;
  assign gpio_iof_0_4_o_oval       = 1'b0;
  assign gpio_iof_0_4_o_oe         = 1'b0;
  assign gpio_iof_0_4_o_ie         = 1'b0;
  assign gpio_iof_0_4_o_valid      = 1'b0;

  assign spi_pins_0_io_pins_sck_i_ival = 1'b0;
  assign gpio_iof_0_5_o_oval       = 1'b0;
  assign gpio_iof_0_5_o_oe         = 1'b0;
  assign gpio_iof_0_5_o_ie         = 1'b0;
  assign gpio_iof_0_5_o_valid      = 1'b0;

  assign spi_pins_0_io_pins_dq_2_i_ival = 1'b0;
  assign gpio_iof_0_6_o_oval       = 1'b0;
  assign gpio_iof_0_6_o_oe         = 1'b0;
  assign gpio_iof_0_6_o_ie         = 1'b0;
  assign gpio_iof_0_6_o_valid      = 1'b0;

  assign spi_pins_0_io_pins_dq_3_i_ival =1'b0;
  assign gpio_iof_0_7_o_oval       = 1'b0;
  assign gpio_iof_0_7_o_oe         = 1'b0;
  assign gpio_iof_0_7_o_ie         = 1'b0;
  assign gpio_iof_0_7_o_valid      = 1'b0;

  assign spi_pins_0_io_pins_cs_1_i_ival = 1'b0;
  assign gpio_iof_0_8_o_oval       = 1'b0;
  assign gpio_iof_0_8_o_oe         = 1'b0;
  assign gpio_iof_0_8_o_ie         = 1'b0;
  assign gpio_iof_0_8_o_valid      = 1'b0;;

  assign spi_pins_0_io_pins_cs_2_i_ival = 1'b0;
  assign gpio_iof_0_9_o_oval       = 1'b0;
  assign gpio_iof_0_9_o_oe         = 1'b0;
  assign gpio_iof_0_9_o_ie         = 1'b0;
  assign gpio_iof_0_9_o_valid      = 1'b0;;

  assign spi_pins_0_io_pins_cs_3_i_ival = 1'b0;
  assign gpio_iof_0_10_o_oval      = 1'b0;
  assign gpio_iof_0_10_o_oe        = 1'b0;
  assign gpio_iof_0_10_o_ie        = 1'b0;
  assign gpio_iof_0_10_o_valid     = 1'b0;;

  assign gpio_iof_0_11_o_oval      = 1'b0;
  assign gpio_iof_0_11_o_oe        = 1'b0;
  assign gpio_iof_0_11_o_ie        = 1'b0;
  assign gpio_iof_0_11_o_valid     = 1'b0;

  assign gpio_iof_0_12_o_oval      = 1'b0;
  assign gpio_iof_0_12_o_oe        = 1'b0;
  assign gpio_iof_0_12_o_ie        = 1'b0;
  assign gpio_iof_0_12_o_valid     = 1'b0;

  assign gpio_iof_0_13_o_oval      = 1'b0;
  assign gpio_iof_0_13_o_oe        = 1'b0;
  assign gpio_iof_0_13_o_ie        = 1'b0;
  assign gpio_iof_0_13_o_valid     = 1'b0;

  assign i2c_sda_pad_i             = 1'b0;
  assign gpio_iof_0_14_o_oval      = 1'b0;
  assign gpio_iof_0_14_o_oe        = 1'b0;
  assign gpio_iof_0_14_o_ie        = 1'b0;
  assign gpio_iof_0_14_o_valid     = 1'b0;

  assign i2c_scl_pad_i             = 1'b0;
  assign gpio_iof_0_15_o_oval      = 1'b0;
  assign gpio_iof_0_15_o_oe        = 1'b0;
  assign gpio_iof_0_15_o_ie        = 1'b0;
  assign gpio_iof_0_15_o_valid     = 1'b0;

  assign uart_pins_0_io_pins_rxd_i_ival = 1'b0;
  assign gpio_iof_0_16_o_oval      = uart_pins_0_io_pins_rxd_o_oval;
  assign gpio_iof_0_16_o_oe        = uart_pins_0_io_pins_rxd_o_oe;
  assign gpio_iof_0_16_o_ie        = uart_pins_0_io_pins_rxd_o_ie;
  assign gpio_iof_0_16_o_valid     = 1'h1;

  assign uart_pins_0_io_pins_txd_i_ival = 1'b0;
  assign gpio_iof_0_17_o_oval      = uart_pins_0_io_pins_txd_o_oval;
  assign gpio_iof_0_17_o_oe        = uart_pins_0_io_pins_txd_o_oe;
  assign gpio_iof_0_17_o_ie        = uart_pins_0_io_pins_txd_o_ie;
  assign gpio_iof_0_17_o_valid     = 1'h1;

  assign gpio_iof_0_18_o_oval      = 1'b0;
  assign gpio_iof_0_18_o_oe        = 1'b0;
  assign gpio_iof_0_18_o_ie        = 1'b0;
  assign gpio_iof_0_18_o_valid     = 1'b0;

  assign gpio_iof_0_19_o_oval      = 1'b0;
  assign gpio_iof_0_19_o_oe        = 1'b0;
  assign gpio_iof_0_19_o_ie        = 1'b0;
  assign gpio_iof_0_19_o_valid     = 1'b0;

  assign gpio_iof_0_20_o_oval      = 1'b0;
  assign gpio_iof_0_20_o_oe        = 1'b0;
  assign gpio_iof_0_20_o_ie        = 1'b0;
  assign gpio_iof_0_20_o_valid     = 1'b0;

  assign gpio_iof_0_21_o_oval      = 1'b0;
  assign gpio_iof_0_21_o_oe        = 1'b0;
  assign gpio_iof_0_21_o_ie        = 1'b0;
  assign gpio_iof_0_21_o_valid     = 1'b0;

  assign gpio_iof_0_22_o_oval      = 1'b0;
  assign gpio_iof_0_22_o_oe        = 1'b0;
  assign gpio_iof_0_22_o_ie        = 1'b0;
  assign gpio_iof_0_22_o_valid     = 1'b0;

  assign gpio_iof_0_23_o_oval      = 1'b0;
  assign gpio_iof_0_23_o_oe        = 1'b0;
  assign gpio_iof_0_23_o_ie        = 1'b0;
  assign gpio_iof_0_23_o_valid     = 1'b0;

  assign uart_pins_1_io_pins_rxd_i_ival = 1'b0;
  assign gpio_iof_0_24_o_oval      = 1'b0;
  assign gpio_iof_0_24_o_oe        = 1'b0;
  assign gpio_iof_0_24_o_ie        = 1'b0;
  assign gpio_iof_0_24_o_valid     = 1'b0;

  assign uart_pins_1_io_pins_txd_i_ival = 1'b0;
  assign gpio_iof_0_25_o_oval      = 1'b0;
  assign gpio_iof_0_25_o_oe        = 1'b0;
  assign gpio_iof_0_25_o_ie        = 1'b0;
  assign gpio_iof_0_25_o_valid     = 1'b0;

  assign spi_pins_1_io_pins_cs_0_i_ival = 1'b0;
  assign gpio_iof_0_26_o_oval      = 1'b0;
  assign gpio_iof_0_26_o_oe        = 1'b0;
  assign gpio_iof_0_26_o_ie        = 1'b0;
  assign gpio_iof_0_26_o_valid     = 1'b0;

  assign spi_pins_1_io_pins_dq_0_i_ival = 1'b0;
  assign gpio_iof_0_27_o_oval      = 1'b0;
  assign gpio_iof_0_27_o_oe        = 1'b0;
  assign gpio_iof_0_27_o_ie        = 1'b0;
  assign gpio_iof_0_27_o_valid     = 1'b0;

  assign spi_pins_1_io_pins_dq_1_i_ival = 1'b0;
  assign gpio_iof_0_28_o_oval      = 1'b0;
  assign gpio_iof_0_28_o_oe        = 1'b0;
  assign gpio_iof_0_28_o_ie        = 1'b0;
  assign gpio_iof_0_28_o_valid     = 1'b0;

  assign spi_pins_1_io_pins_sck_i_ival = 1'b0;
  assign gpio_iof_0_29_o_oval      = 1'b0;
  assign gpio_iof_0_29_o_oe        = 1'b0;
  assign gpio_iof_0_29_o_ie        = 1'b0;
  assign gpio_iof_0_29_o_valid     = 1'b0;

  assign spi_pins_1_io_pins_dq_2_i_ival = 1'b0;
  assign gpio_iof_0_30_o_oval      = 1'b0;
  assign gpio_iof_0_30_o_oe        = 1'b0;
  assign gpio_iof_0_30_o_ie        = 1'b0;
  assign gpio_iof_0_30_o_valid     = 1'b0;

  assign spi_pins_1_io_pins_dq_3_i_ival = 1'b0;
  assign gpio_iof_0_31_o_oval      = 1'b0;
  assign gpio_iof_0_31_o_oe        = 1'b0;
  assign gpio_iof_0_31_o_ie        = 1'b0;
  assign gpio_iof_0_31_o_valid     = 1'b0;

  assign pwm_pins_0_io_pins_pwm_0_i_ival = 1'b0;
  assign gpio_iof_1_0_o_oval       = 1'b0;
  assign gpio_iof_1_0_o_oe         = 1'b0;
  assign gpio_iof_1_0_o_ie         = 1'b0;
  assign gpio_iof_1_0_o_valid      = 1'b0;

  assign pwm_pins_0_io_pins_pwm_1_i_ival = 1'b0;
  assign gpio_iof_1_1_o_oval       = 1'b0;
  assign gpio_iof_1_1_o_oe         = 1'b0;
  assign gpio_iof_1_1_o_ie         = 1'b0;
  assign gpio_iof_1_1_o_valid      = 1'b0;

  assign pwm_pins_0_io_pins_pwm_2_i_ival = 1'b0;
  assign gpio_iof_1_2_o_oval       = 1'b0;
  assign gpio_iof_1_2_o_oe         = 1'b0;
  assign gpio_iof_1_2_o_ie         = 1'b0;
  assign gpio_iof_1_2_o_valid      = 1'b0;

  assign pwm_pins_0_io_pins_pwm_3_i_ival = 1'b0;
  assign gpio_iof_1_3_o_oval       = 1'b0;
  assign gpio_iof_1_3_o_oe         = 1'b0;
  assign gpio_iof_1_3_o_ie         = 1'b0;
  assign gpio_iof_1_3_o_valid      = 1'b0;

  assign gpio_iof_1_4_o_oval       = 1'b0;
  assign gpio_iof_1_4_o_oe         = 1'b0;
  assign gpio_iof_1_4_o_ie         = 1'b0;
  assign gpio_iof_1_4_o_valid      = 1'b0;

  assign gpio_iof_1_5_o_oval       = 1'b0;
  assign gpio_iof_1_5_o_oe         = 1'b0;
  assign gpio_iof_1_5_o_ie         = 1'b0;
  assign gpio_iof_1_5_o_valid      = 1'b0;

  assign gpio_iof_1_6_o_oval       = 1'b0;
  assign gpio_iof_1_6_o_oe         = 1'b0;
  assign gpio_iof_1_6_o_ie         = 1'b0;
  assign gpio_iof_1_6_o_valid      = 1'b0;

  assign gpio_iof_1_7_o_oval       = 1'b0;
  assign gpio_iof_1_7_o_oe         = 1'b0;
  assign gpio_iof_1_7_o_ie         = 1'b0;
  assign gpio_iof_1_7_o_valid      = 1'b0;

  assign gpio_iof_1_8_o_oval       = 1'b0;
  assign gpio_iof_1_8_o_oe         = 1'b0;
  assign gpio_iof_1_8_o_ie         = 1'b0;
  assign gpio_iof_1_8_o_valid      = 1'b0;

  assign gpio_iof_1_9_o_oval       = 1'b0;
  assign gpio_iof_1_9_o_oe         = 1'b0;
  assign gpio_iof_1_9_o_ie         = 1'b0;
  assign gpio_iof_1_9_o_valid      = 1'b0;

  assign pwm_pins_2_io_pins_pwm_0_i_ival = 1'b0;
  assign gpio_iof_1_10_o_oval      = 1'b0;
  assign gpio_iof_1_10_o_oe        = 1'b0;
  assign gpio_iof_1_10_o_ie        = 1'b0;
  assign gpio_iof_1_10_o_valid     = 1'b0;

  assign pwm_pins_2_io_pins_pwm_1_i_ival = 1'b0;
  assign gpio_iof_1_11_o_oval      = 1'b0;
  assign gpio_iof_1_11_o_oe        = 1'b0;
  assign gpio_iof_1_11_o_ie        = 1'b0;
  assign gpio_iof_1_11_o_valid     = 1'b0;

  assign pwm_pins_2_io_pins_pwm_2_i_ival = 1'b0;
  assign gpio_iof_1_12_o_oval      = 1'b0;
  assign gpio_iof_1_12_o_oe        = 1'b0;
  assign gpio_iof_1_12_o_ie        = 1'b0;
  assign gpio_iof_1_12_o_valid     = 1'b0;

  assign pwm_pins_2_io_pins_pwm_3_i_ival = 1'b0;
  assign gpio_iof_1_13_o_oval      = 1'b0;
  assign gpio_iof_1_13_o_oe        = 1'b0;
  assign gpio_iof_1_13_o_ie        = 1'b0;
  assign gpio_iof_1_13_o_valid     = 1'b0;

  assign gpio_iof_1_14_o_oval      = 1'b0;
  assign gpio_iof_1_14_o_oe        = 1'b0;
  assign gpio_iof_1_14_o_ie        = 1'b0;
  assign gpio_iof_1_14_o_valid     = 1'b0;

  assign gpio_iof_1_15_o_oval      = 1'b0;
  assign gpio_iof_1_15_o_oe        = 1'b0;
  assign gpio_iof_1_15_o_ie        = 1'b0;
  assign gpio_iof_1_15_o_valid     = 1'b0;

  assign gpio_iof_1_16_o_oval      = 1'b0;
  assign gpio_iof_1_16_o_oe        = 1'b0;
  assign gpio_iof_1_16_o_ie        = 1'b0;
  assign gpio_iof_1_16_o_valid     = 1'b0;

  assign gpio_iof_1_17_o_oval      = 1'b0;
  assign gpio_iof_1_17_o_oe        = 1'b0;
  assign gpio_iof_1_17_o_ie        = 1'b0;
  assign gpio_iof_1_17_o_valid     = 1'b0;

  assign gpio_iof_1_18_o_oval      = 1'b0;
  assign gpio_iof_1_18_o_oe        = 1'b0;
  assign gpio_iof_1_18_o_ie        = 1'b0;
  assign gpio_iof_1_18_o_valid     = 1'b0;

  assign pwm_pins_1_io_pins_pwm_1_i_ival = 1'b0;
  assign gpio_iof_1_19_o_oval      = 1'b0;
  assign gpio_iof_1_19_o_oe        = 1'b0;
  assign gpio_iof_1_19_o_ie        = 1'b0;
  assign gpio_iof_1_19_o_valid     = 1'b0;

  assign pwm_pins_1_io_pins_pwm_0_i_ival = 1'b0;
  assign gpio_iof_1_20_o_oval      = 1'b0;
  assign gpio_iof_1_20_o_oe        = 1'b0;
  assign gpio_iof_1_20_o_ie        = 1'b0;
  assign gpio_iof_1_20_o_valid     = 1'b0;

  assign pwm_pins_1_io_pins_pwm_2_i_ival = 1'b0;
  assign gpio_iof_1_21_o_oval      = 1'b0;
  assign gpio_iof_1_21_o_oe        = 1'b0;
  assign gpio_iof_1_21_o_ie        = 1'b0;
  assign gpio_iof_1_21_o_valid     = 1'b0;

  assign pwm_pins_1_io_pins_pwm_3_i_ival = 1'b0;
  assign gpio_iof_1_22_o_oval      = 1'b0;
  assign gpio_iof_1_22_o_oe        = 1'b0;
  assign gpio_iof_1_22_o_ie        = 1'b0;
  assign gpio_iof_1_22_o_valid     = 1'b0;

  assign gpio_iof_1_23_o_oval      = 1'b0;
  assign gpio_iof_1_23_o_oe        = 1'b0;
  assign gpio_iof_1_23_o_ie        = 1'b0;
  assign gpio_iof_1_23_o_valid     = 1'b0;

  assign gpio_iof_1_24_o_oval      = 1'b0;
  assign gpio_iof_1_24_o_oe        = 1'b0;
  assign gpio_iof_1_24_o_ie        = 1'b0;
  assign gpio_iof_1_24_o_valid     = 1'b0;

  assign gpio_iof_1_25_o_oval      = 1'b0;
  assign gpio_iof_1_25_o_oe        = 1'b0;
  assign gpio_iof_1_25_o_ie        = 1'b0;
  assign gpio_iof_1_25_o_valid     = 1'b0;

  assign gpio_iof_1_26_o_oval      = 1'b0;
  assign gpio_iof_1_26_o_oe        = 1'b0;
  assign gpio_iof_1_26_o_ie        = 1'b0;
  assign gpio_iof_1_26_o_valid     = 1'b0;

  assign gpio_iof_1_27_o_oval      = 1'b0;
  assign gpio_iof_1_27_o_oe        = 1'b0;
  assign gpio_iof_1_27_o_ie        = 1'b0;
  assign gpio_iof_1_27_o_valid     = 1'b0;

  assign gpio_iof_1_28_o_oval      = 1'b0;
  assign gpio_iof_1_28_o_oe        = 1'b0;
  assign gpio_iof_1_28_o_ie        = 1'b0;
  assign gpio_iof_1_28_o_valid     = 1'b0;

  assign gpio_iof_1_29_o_oval      = 1'b0;
  assign gpio_iof_1_29_o_oe        = 1'b0;
  assign gpio_iof_1_29_o_ie        = 1'b0;
  assign gpio_iof_1_29_o_valid     = 1'b0;

  assign gpio_iof_1_30_o_oval      = 1'b0;
  assign gpio_iof_1_30_o_oe        = 1'b0;
  assign gpio_iof_1_30_o_ie        = 1'b0;
  assign gpio_iof_1_30_o_valid     = 1'b0;

  assign gpio_iof_1_31_o_oval      = 1'b0;
  assign gpio_iof_1_31_o_oe        = 1'b0;
  assign gpio_iof_1_31_o_ie        = 1'b0;
  assign gpio_iof_1_31_o_valid     = 1'b0;

  wire                     otp_icb_cmd_valid;
  wire                     otp_icb_cmd_ready;
  wire [32-1:0]            otp_icb_cmd_addr; 
  wire                     otp_icb_cmd_read; 
  wire [32-1:0]            otp_icb_cmd_wdata;
  
  wire                     otp_icb_rsp_valid;
  wire                     otp_icb_rsp_ready;
  wire [32-1:0]            otp_icb_rsp_rdata;

  wire                     gpio_icb_cmd_valid;
  wire                     gpio_icb_cmd_ready;
  wire [32-1:0]            gpio_icb_cmd_addr; 
  wire                     gpio_icb_cmd_read; 
  wire [32-1:0]            gpio_icb_cmd_wdata;
  
  wire                     gpio_icb_rsp_valid;
  wire                     gpio_icb_rsp_ready;
  wire [32-1:0]            gpio_icb_rsp_rdata;

  wire                     uart0_icb_cmd_valid;
  wire                     uart0_icb_cmd_ready;
  wire [32-1:0]            uart0_icb_cmd_addr; 
  wire                     uart0_icb_cmd_read; 
  wire [32-1:0]            uart0_icb_cmd_wdata;
  
  wire                     uart0_icb_rsp_valid;
  wire                     uart0_icb_rsp_ready;
  wire [32-1:0]            uart0_icb_rsp_rdata;

  wire                     expl_axi_icb_cmd_valid;
  wire                     expl_axi_icb_cmd_ready;
  wire [32-1:0]            expl_axi_icb_cmd_addr; 
  wire                     expl_axi_icb_cmd_read; 
  wire [32-1:0]            expl_axi_icb_cmd_wdata;
  wire [4 -1:0]            expl_axi_icb_cmd_wmask;
  
  wire                     expl_axi_icb_rsp_valid;
  wire                     expl_axi_icb_rsp_ready;
  wire [32-1:0]            expl_axi_icb_rsp_rdata;
  wire                     expl_axi_icb_rsp_err;

  wire                     expl_apb_icb_cmd_valid;
  wire                     expl_apb_icb_cmd_ready;
  wire [32-1:0]            expl_apb_icb_cmd_addr; 
  wire                     expl_apb_icb_cmd_read; 
  wire [32-1:0]            expl_apb_icb_cmd_wdata;
  wire [4 -1:0]            expl_apb_icb_cmd_wmask;
  
  wire                     expl_apb_icb_rsp_valid;
  wire                     expl_apb_icb_rsp_ready;
  wire [32-1:0]            expl_apb_icb_rsp_rdata;
  wire                     expl_apb_icb_rsp_err;

  wire                     hclkgen_icb_cmd_valid;
  wire                     hclkgen_icb_cmd_ready;
  wire [32-1:0]            hclkgen_icb_cmd_addr; 
  wire                     hclkgen_icb_cmd_read; 
  wire [32-1:0]            hclkgen_icb_cmd_wdata;
  wire [4 -1:0]            hclkgen_icb_cmd_wmask;
  
  wire                     hclkgen_icb_rsp_valid;
  wire                     hclkgen_icb_rsp_ready;
  wire [32-1:0]            hclkgen_icb_rsp_rdata;
  wire                     hclkgen_icb_rsp_err;

  // The total address range for the PPI is from/to
  //  **************0x1000 0000 -- 0x1FFF FFFF
  // There are several slaves for PPI bus, including:
  //  * AON       : 0x1000 0000 -- 0x1000 7FFF
  //  * HCLKGEN   : 0x1000 8000 -- 0x1000 8FFF
  //  * OTP       : 0x1001 0000 -- 0x1001 0FFF
  //  * GPIO      : 0x1001 2000 -- 0x1001 2FFF
  //  * UART0     : 0x1001 3000 -- 0x1001 3FFF
  //  * QSPI0     : 0x1001 4000 -- 0x1001 4FFF
  //  * PWM0      : 0x1001 5000 -- 0x1001 5FFF
  //  * UART1     : 0x1002 3000 -- 0x1002 3FFF
  //  * QSPI1     : 0x1002 4000 -- 0x1002 4FFF
  //  * PWM1      : 0x1002 5000 -- 0x1002 5FFF
  //  * QSPI2     : 0x1003 4000 -- 0x1003 4FFF
  //  * PWM2      : 0x1003 5000 -- 0x1003 5FFF
  //  * Example-AXI      : 0x1004 0000 -- 0x1004 0FFF
  //  * Example-APB      : 0x1004 1000 -- 0x1004 1FFF
  //  * Example-WishBone : 0x1004 2000 -- 0x1004 2FFF
  //  * SysPer    : 0x1100 0000 -- 0x11FF FFFF
sirv_icb1to8_bus # (
  .ICB_FIFO_DP(2),
  .ICB_FIFO_CUT_READY(1),

  .AW(32),
  .DW(`E203_XLEN),
  .SPLT_FIFO_OUTS_NUM(1),
  .SPLT_FIFO_CUT_READY(1),

.O0_BASE_ADDR       (32'h1000_0000),       
  .O0_BASE_REGION_LSB (15),
  //  * HCLKGEN   : 0x1000 8000 -- 0x1000 8FFF
  .O1_BASE_ADDR       (32'h1000_8000),       
  .O1_BASE_REGION_LSB (12),
  //  * OTP       : 0x1001 0000 -- 0x1001 0FFF
  .O2_BASE_ADDR       (32'h1001_0000),       
  .O2_BASE_REGION_LSB (12),
  //  * GPIO      : 0x1001 2000 -- 0x1001 2FFF
  .O3_BASE_ADDR       (32'h1001_2000),       
  .O3_BASE_REGION_LSB (12),
  //  * UART0     : 0x1001 3000 -- 0x1001 3FFF
  .O4_BASE_ADDR       (32'h1001_3000),       
  .O4_BASE_REGION_LSB (12),
  //  * SysPer    : 0x1100 0000 -- 0x11FF FFFF
  .O5_BASE_ADDR       (32'h1100_0000),       
  .O5_BASE_REGION_LSB (24),

      // * Here is an example AXI Peripheral
  .O6_BASE_ADDR       (32'h1004_0000),       
  .O6_BASE_REGION_LSB (12),
  
      // * Here is an example APB Peripheral
  .O7_BASE_ADDR       (32'h1004_1000),       
  .O7_BASE_REGION_LSB (12)
  
)
u_sirv_ppi_fab(

    .i_icb_cmd_valid  (ppi_icb_cmd_valid),
    .i_icb_cmd_ready  (ppi_icb_cmd_ready),
    .i_icb_cmd_addr   (ppi_icb_cmd_addr ),
    .i_icb_cmd_read   (ppi_icb_cmd_read ),
    .i_icb_cmd_wdata  (ppi_icb_cmd_wdata),
    .i_icb_cmd_wmask  (ppi_icb_cmd_wmask),
    .i_icb_cmd_lock   (1'b0),
    .i_icb_cmd_excl   (1'b0 ),
    .i_icb_cmd_size   (2'b0 ),
    .i_icb_cmd_burst  (2'b0 ),
    .i_icb_cmd_beat   (2'b0 ),
    
    .i_icb_rsp_valid  (ppi_icb_rsp_valid),
    .i_icb_rsp_ready  (ppi_icb_rsp_ready),
    .i_icb_rsp_err    (ppi_icb_rsp_err  ),
    .i_icb_rsp_excl_ok(),
    .i_icb_rsp_rdata  (ppi_icb_rsp_rdata),
    
  //  * AON 
    .o0_icb_enable     (1'b1),

        //
    .o0_icb_cmd_valid  (i_aon_icb_cmd_valid),
    .o0_icb_cmd_ready  (i_aon_icb_cmd_ready),
    .o0_icb_cmd_addr   (i_aon_icb_cmd_addr ),
    .o0_icb_cmd_read   (i_aon_icb_cmd_read ),
    .o0_icb_cmd_wdata  (i_aon_icb_cmd_wdata),
    .o0_icb_cmd_wmask  (),
    .o0_icb_cmd_lock   (),
    .o0_icb_cmd_excl   (),
    .o0_icb_cmd_size   (),
    .o0_icb_cmd_burst  (),
    .o0_icb_cmd_beat   (),
    
    .o0_icb_rsp_valid  (i_aon_icb_rsp_valid),
    .o0_icb_rsp_ready  (i_aon_icb_rsp_ready),
    .o0_icb_rsp_err    (i_aon_icb_rsp_err),
    .o0_icb_rsp_excl_ok(1'b0  ),
    .o0_icb_rsp_rdata  (i_aon_icb_rsp_rdata),

  //  * HCLKGEN      
    .o1_icb_enable     (1'b1),

    .o1_icb_cmd_valid  (hclkgen_icb_cmd_valid),
    .o1_icb_cmd_ready  (hclkgen_icb_cmd_ready),
    .o1_icb_cmd_addr   (hclkgen_icb_cmd_addr ),
    .o1_icb_cmd_read   (hclkgen_icb_cmd_read ),
    .o1_icb_cmd_wdata  (hclkgen_icb_cmd_wdata),
    .o1_icb_cmd_wmask  (),
    .o1_icb_cmd_lock   (),
    .o1_icb_cmd_excl   (),
    .o1_icb_cmd_size   (),
    .o1_icb_cmd_burst  (),
    .o1_icb_cmd_beat   (),
    
    .o1_icb_rsp_valid  (hclkgen_icb_rsp_valid),
    .o1_icb_rsp_ready  (hclkgen_icb_rsp_ready),
    .o1_icb_rsp_err    (1'b0  ),
    .o1_icb_rsp_excl_ok(1'b0  ),
    .o1_icb_rsp_rdata  (hclkgen_icb_rsp_rdata),

  //  * OTP       
    .o2_icb_enable     (1'b1),

    .o2_icb_cmd_valid  (otp_icb_cmd_valid),
    .o2_icb_cmd_ready  (otp_icb_cmd_ready),
    .o2_icb_cmd_addr   (otp_icb_cmd_addr ),
    .o2_icb_cmd_read   (otp_icb_cmd_read ),
    .o2_icb_cmd_wdata  (otp_icb_cmd_wdata),
    .o2_icb_cmd_wmask  (),
    .o2_icb_cmd_lock   (),
    .o2_icb_cmd_excl   (),
    .o2_icb_cmd_size   (),
    .o2_icb_cmd_burst  (),
    .o2_icb_cmd_beat   (),
    
    .o2_icb_rsp_valid  (otp_icb_rsp_valid),
    .o2_icb_rsp_ready  (otp_icb_rsp_ready),
    .o2_icb_rsp_err    (1'b0  ),
    .o2_icb_rsp_excl_ok(1'b0  ),
    .o2_icb_rsp_rdata  (otp_icb_rsp_rdata),


  //  * GPIO      
    .o3_icb_enable     (1'b1),

    .o3_icb_cmd_valid  (gpio_icb_cmd_valid),
    .o3_icb_cmd_ready  (gpio_icb_cmd_ready),
    .o3_icb_cmd_addr   (gpio_icb_cmd_addr ),
    .o3_icb_cmd_read   (gpio_icb_cmd_read ),
    .o3_icb_cmd_wdata  (gpio_icb_cmd_wdata),
    .o3_icb_cmd_wmask  (),
    .o3_icb_cmd_lock   (),
    .o3_icb_cmd_excl   (),
    .o3_icb_cmd_size   (),
    .o3_icb_cmd_burst  (),
    .o3_icb_cmd_beat   (),
    
    .o3_icb_rsp_valid  (gpio_icb_rsp_valid),
    .o3_icb_rsp_ready  (gpio_icb_rsp_ready),
    .o3_icb_rsp_err    (1'b0  ),
    .o3_icb_rsp_excl_ok(1'b0  ),
    .o3_icb_rsp_rdata  (gpio_icb_rsp_rdata),


  //  * UART0     
    .o4_icb_enable     (1'b1),

    .o4_icb_cmd_valid  (uart0_icb_cmd_valid),
    .o4_icb_cmd_ready  (uart0_icb_cmd_ready),
    .o4_icb_cmd_addr   (uart0_icb_cmd_addr ),
    .o4_icb_cmd_read   (uart0_icb_cmd_read ),
    .o4_icb_cmd_wdata  (uart0_icb_cmd_wdata),
    .o4_icb_cmd_wmask  (),
    .o4_icb_cmd_lock   (),
    .o4_icb_cmd_excl   (),
    .o4_icb_cmd_size   (),
    .o4_icb_cmd_burst  (),
    .o4_icb_cmd_beat   (),
    
    .o4_icb_rsp_valid  (uart0_icb_rsp_valid),
    .o4_icb_rsp_ready  (uart0_icb_rsp_ready),
    .o4_icb_rsp_err    (1'b0  ),
    .o4_icb_rsp_excl_ok(1'b0  ),
    .o4_icb_rsp_rdata  (uart0_icb_rsp_rdata),

  //  * SysPer    
    .o5_icb_enable     (1'b1),

    .o5_icb_cmd_valid  (sysper_icb_cmd_valid),
    .o5_icb_cmd_ready  (sysper_icb_cmd_ready),
    .o5_icb_cmd_addr   (sysper_icb_cmd_addr ),
    .o5_icb_cmd_read   (sysper_icb_cmd_read ),
    .o5_icb_cmd_wdata  (sysper_icb_cmd_wdata),
    .o5_icb_cmd_wmask  (sysper_icb_cmd_wmask),
    .o5_icb_cmd_lock   (),
    .o5_icb_cmd_excl   (),
    .o5_icb_cmd_size   (),
    .o5_icb_cmd_burst  (),
    .o5_icb_cmd_beat   (),
    
    .o5_icb_rsp_valid  (sysper_icb_rsp_valid),
    .o5_icb_rsp_ready  (sysper_icb_rsp_ready),
    .o5_icb_rsp_err    (sysper_icb_rsp_err),
    .o5_icb_rsp_excl_ok(1'b0  ),
    .o5_icb_rsp_rdata  (sysper_icb_rsp_rdata),

   //  * Example AXI    
    .o6_icb_enable     (1'b1),

    .o6_icb_cmd_valid  (expl_axi_icb_cmd_valid),
    .o6_icb_cmd_ready  (expl_axi_icb_cmd_ready),
    .o6_icb_cmd_addr   (expl_axi_icb_cmd_addr ),
    .o6_icb_cmd_read   (expl_axi_icb_cmd_read ),
    .o6_icb_cmd_wdata  (expl_axi_icb_cmd_wdata),
    .o6_icb_cmd_wmask  (expl_axi_icb_cmd_wmask),
    .o6_icb_cmd_lock   (),
    .o6_icb_cmd_excl   (),
    .o6_icb_cmd_size   (),
    .o6_icb_cmd_burst  (),
    .o6_icb_cmd_beat   (),
    
    .o6_icb_rsp_valid  (expl_axi_icb_rsp_valid),
    .o6_icb_rsp_ready  (expl_axi_icb_rsp_ready),
    .o6_icb_rsp_err    (expl_axi_icb_rsp_err),
    .o6_icb_rsp_excl_ok(1'b0  ),
    .o6_icb_rsp_rdata  (expl_axi_icb_rsp_rdata),

   //  * Example APB    
    .o7_icb_enable     (1'b1),

    .o7_icb_cmd_valid  (expl_apb_icb_cmd_valid),
    .o7_icb_cmd_ready  (expl_apb_icb_cmd_ready),
    .o7_icb_cmd_addr   (expl_apb_icb_cmd_addr ),
    .o7_icb_cmd_read   (expl_apb_icb_cmd_read ),
    .o7_icb_cmd_wdata  (expl_apb_icb_cmd_wdata),
    .o7_icb_cmd_wmask  (expl_apb_icb_cmd_wmask),
    .o7_icb_cmd_lock   (),
    .o7_icb_cmd_excl   (),
    .o7_icb_cmd_size   (),
    .o7_icb_cmd_burst  (),
    .o7_icb_cmd_beat   (),
    
    .o7_icb_rsp_valid  (expl_apb_icb_rsp_valid),
    .o7_icb_rsp_ready  (expl_apb_icb_rsp_ready),
    .o7_icb_rsp_err    (expl_apb_icb_rsp_err),
    .o7_icb_rsp_excl_ok(1'b0  ),
    .o7_icb_rsp_rdata  (expl_apb_icb_rsp_rdata),

    .clk           (clk  ),
    .rst_n         (bus_rst_n) 
  );



  //  * OTP       
  sirv_otp_top u_sirv_otp_top( 
    .clk           (clk  ),
    .rst_n         (rst_n), 

    .i_icb_cmd_valid (otp_icb_cmd_valid),
    .i_icb_cmd_ready (otp_icb_cmd_ready),
    .i_icb_cmd_addr  (otp_icb_cmd_addr ),
    .i_icb_cmd_read  (otp_icb_cmd_read ),
    .i_icb_cmd_wdata (otp_icb_cmd_wdata),
    
    .i_icb_rsp_valid (otp_icb_rsp_valid),
    .i_icb_rsp_ready (otp_icb_rsp_ready),
    .i_icb_rsp_rdata (otp_icb_rsp_rdata),
   
    .f_icb_cmd_valid (otp_ro_icb_cmd_valid),
    .f_icb_cmd_ready (otp_ro_icb_cmd_ready),
    .f_icb_cmd_addr  (otp_ro_icb_cmd_addr ),
    .f_icb_cmd_read  (otp_ro_icb_cmd_read ),
    .f_icb_cmd_wdata (otp_ro_icb_cmd_wdata),
  
    .f_icb_rsp_valid (otp_ro_icb_rsp_valid),
    .f_icb_rsp_ready (otp_ro_icb_rsp_ready),
    .f_icb_rsp_rdata (otp_ro_icb_rsp_rdata) 
);

  //  * GPIO      
sirv_gpio_top u_sirv_gpio_top(
    .clk           (clk  ),
    .rst_n         (rst_n),

    .i_icb_cmd_valid (gpio_icb_cmd_valid),
    .i_icb_cmd_ready (gpio_icb_cmd_ready),
    .i_icb_cmd_addr  (gpio_icb_cmd_addr ),
    .i_icb_cmd_read  (gpio_icb_cmd_read ),
    .i_icb_cmd_wdata (gpio_icb_cmd_wdata),
    
    .i_icb_rsp_valid (gpio_icb_rsp_valid),
    .i_icb_rsp_ready (gpio_icb_rsp_ready),
    .i_icb_rsp_rdata (gpio_icb_rsp_rdata),

    .gpio_irq_0               (gpio_irq_0),
    .gpio_irq_1               (gpio_irq_1),
    .gpio_irq_2               (gpio_irq_2),
    .gpio_irq_3               (gpio_irq_3),
    .gpio_irq_4               (gpio_irq_4),
    .gpio_irq_5               (gpio_irq_5),
    .gpio_irq_6               (gpio_irq_6),
    .gpio_irq_7               (gpio_irq_7),
    .gpio_irq_8               (gpio_irq_8),
    .gpio_irq_9               (gpio_irq_9),
    .gpio_irq_10              (gpio_irq_10),
    .gpio_irq_11              (gpio_irq_11),
    .gpio_irq_12              (gpio_irq_12),
    .gpio_irq_13              (gpio_irq_13),
    .gpio_irq_14              (gpio_irq_14),
    .gpio_irq_15              (gpio_irq_15),
    .gpio_irq_16              (gpio_irq_16),
    .gpio_irq_17              (gpio_irq_17),
    .gpio_irq_18              (gpio_irq_18),
    .gpio_irq_19              (gpio_irq_19),
    .gpio_irq_20              (gpio_irq_20),
    .gpio_irq_21              (gpio_irq_21),
    .gpio_irq_22              (gpio_irq_22),
    .gpio_irq_23              (gpio_irq_23),
    .gpio_irq_24              (gpio_irq_24),
    .gpio_irq_25              (gpio_irq_25),
    .gpio_irq_26              (gpio_irq_26),
    .gpio_irq_27              (gpio_irq_27),
    .gpio_irq_28              (gpio_irq_28),
    .gpio_irq_29              (gpio_irq_29),
    .gpio_irq_30              (gpio_irq_30),
    .gpio_irq_31              (gpio_irq_31),
   
    .io_port_pins_0_i_ival           (io_pads_gpio_0_i_ival),
    .io_port_pins_0_o_oval           (io_pads_gpio_0_o_oval),
    .io_port_pins_0_o_oe             (io_pads_gpio_0_o_oe),
    .io_port_pins_0_o_ie             (io_pads_gpio_0_o_ie),
    .io_port_pins_0_o_pue            (io_pads_gpio_0_o_pue),
    .io_port_pins_0_o_ds             (io_pads_gpio_0_o_ds),
    .io_port_pins_1_i_ival           (io_pads_gpio_1_i_ival),
    .io_port_pins_1_o_oval           (io_pads_gpio_1_o_oval),
    .io_port_pins_1_o_oe             (io_pads_gpio_1_o_oe),
    .io_port_pins_1_o_ie             (io_pads_gpio_1_o_ie),
    .io_port_pins_1_o_pue            (io_pads_gpio_1_o_pue),
    .io_port_pins_1_o_ds             (io_pads_gpio_1_o_ds),
    .io_port_pins_2_i_ival           (io_pads_gpio_2_i_ival),
    .io_port_pins_2_o_oval           (io_pads_gpio_2_o_oval),
    .io_port_pins_2_o_oe             (io_pads_gpio_2_o_oe),
    .io_port_pins_2_o_ie             (io_pads_gpio_2_o_ie),
    .io_port_pins_2_o_pue            (io_pads_gpio_2_o_pue),
    .io_port_pins_2_o_ds             (io_pads_gpio_2_o_ds),
    .io_port_pins_3_i_ival           (io_pads_gpio_3_i_ival),
    .io_port_pins_3_o_oval           (io_pads_gpio_3_o_oval),
    .io_port_pins_3_o_oe             (io_pads_gpio_3_o_oe),
    .io_port_pins_3_o_ie             (io_pads_gpio_3_o_ie),
    .io_port_pins_3_o_pue            (io_pads_gpio_3_o_pue),
    .io_port_pins_3_o_ds             (io_pads_gpio_3_o_ds),
    .io_port_pins_4_i_ival           (io_pads_gpio_4_i_ival),
    .io_port_pins_4_o_oval           (io_pads_gpio_4_o_oval),
    .io_port_pins_4_o_oe             (io_pads_gpio_4_o_oe),
    .io_port_pins_4_o_ie             (io_pads_gpio_4_o_ie),
    .io_port_pins_4_o_pue            (io_pads_gpio_4_o_pue),
    .io_port_pins_4_o_ds             (io_pads_gpio_4_o_ds),
    .io_port_pins_5_i_ival           (io_pads_gpio_5_i_ival),
    .io_port_pins_5_o_oval           (io_pads_gpio_5_o_oval),
    .io_port_pins_5_o_oe             (io_pads_gpio_5_o_oe),
    .io_port_pins_5_o_ie             (io_pads_gpio_5_o_ie),
    .io_port_pins_5_o_pue            (io_pads_gpio_5_o_pue),
    .io_port_pins_5_o_ds             (io_pads_gpio_5_o_ds),
    .io_port_pins_6_i_ival           (io_pads_gpio_6_i_ival),
    .io_port_pins_6_o_oval           (io_pads_gpio_6_o_oval),
    .io_port_pins_6_o_oe             (io_pads_gpio_6_o_oe),
    .io_port_pins_6_o_ie             (io_pads_gpio_6_o_ie),
    .io_port_pins_6_o_pue            (io_pads_gpio_6_o_pue),
    .io_port_pins_6_o_ds             (io_pads_gpio_6_o_ds),
    .io_port_pins_7_i_ival           (io_pads_gpio_7_i_ival),
    .io_port_pins_7_o_oval           (io_pads_gpio_7_o_oval),
    .io_port_pins_7_o_oe             (io_pads_gpio_7_o_oe),
    .io_port_pins_7_o_ie             (io_pads_gpio_7_o_ie),
    .io_port_pins_7_o_pue            (io_pads_gpio_7_o_pue),
    .io_port_pins_7_o_ds             (io_pads_gpio_7_o_ds),
    .io_port_pins_8_i_ival           (io_pads_gpio_8_i_ival),
    .io_port_pins_8_o_oval           (io_pads_gpio_8_o_oval),
    .io_port_pins_8_o_oe             (io_pads_gpio_8_o_oe),
    .io_port_pins_8_o_ie             (io_pads_gpio_8_o_ie),
    .io_port_pins_8_o_pue            (io_pads_gpio_8_o_pue),
    .io_port_pins_8_o_ds             (io_pads_gpio_8_o_ds),
    .io_port_pins_9_i_ival           (io_pads_gpio_9_i_ival),
    .io_port_pins_9_o_oval           (io_pads_gpio_9_o_oval),
    .io_port_pins_9_o_oe             (io_pads_gpio_9_o_oe),
    .io_port_pins_9_o_ie             (io_pads_gpio_9_o_ie),
    .io_port_pins_9_o_pue            (io_pads_gpio_9_o_pue),
    .io_port_pins_9_o_ds             (io_pads_gpio_9_o_ds),
    .io_port_pins_10_i_ival          (io_pads_gpio_10_i_ival),
    .io_port_pins_10_o_oval          (io_pads_gpio_10_o_oval),
    .io_port_pins_10_o_oe            (io_pads_gpio_10_o_oe),
    .io_port_pins_10_o_ie            (io_pads_gpio_10_o_ie),
    .io_port_pins_10_o_pue           (io_pads_gpio_10_o_pue),
    .io_port_pins_10_o_ds            (io_pads_gpio_10_o_ds),
    .io_port_pins_11_i_ival          (io_pads_gpio_11_i_ival),
    .io_port_pins_11_o_oval          (io_pads_gpio_11_o_oval),
    .io_port_pins_11_o_oe            (io_pads_gpio_11_o_oe),
    .io_port_pins_11_o_ie            (io_pads_gpio_11_o_ie),
    .io_port_pins_11_o_pue           (io_pads_gpio_11_o_pue),
    .io_port_pins_11_o_ds            (io_pads_gpio_11_o_ds),
    .io_port_pins_12_i_ival          (io_pads_gpio_12_i_ival),
    .io_port_pins_12_o_oval          (io_pads_gpio_12_o_oval),
    .io_port_pins_12_o_oe            (io_pads_gpio_12_o_oe),
    .io_port_pins_12_o_ie            (io_pads_gpio_12_o_ie),
    .io_port_pins_12_o_pue           (io_pads_gpio_12_o_pue),
    .io_port_pins_12_o_ds            (io_pads_gpio_12_o_ds),
    .io_port_pins_13_i_ival          (io_pads_gpio_13_i_ival),
    .io_port_pins_13_o_oval          (io_pads_gpio_13_o_oval),
    .io_port_pins_13_o_oe            (io_pads_gpio_13_o_oe),
    .io_port_pins_13_o_ie            (io_pads_gpio_13_o_ie),
    .io_port_pins_13_o_pue           (io_pads_gpio_13_o_pue),
    .io_port_pins_13_o_ds            (io_pads_gpio_13_o_ds),
    .io_port_pins_14_i_ival          (io_pads_gpio_14_i_ival),
    .io_port_pins_14_o_oval          (io_pads_gpio_14_o_oval),
    .io_port_pins_14_o_oe            (io_pads_gpio_14_o_oe),
    .io_port_pins_14_o_ie            (io_pads_gpio_14_o_ie),
    .io_port_pins_14_o_pue           (io_pads_gpio_14_o_pue),
    .io_port_pins_14_o_ds            (io_pads_gpio_14_o_ds),
    .io_port_pins_15_i_ival          (io_pads_gpio_15_i_ival),
    .io_port_pins_15_o_oval          (io_pads_gpio_15_o_oval),
    .io_port_pins_15_o_oe            (io_pads_gpio_15_o_oe),
    .io_port_pins_15_o_ie            (io_pads_gpio_15_o_ie),
    .io_port_pins_15_o_pue           (io_pads_gpio_15_o_pue),
    .io_port_pins_15_o_ds            (io_pads_gpio_15_o_ds),
    .io_port_pins_16_i_ival          (io_pads_gpio_16_i_ival),
    .io_port_pins_16_o_oval          (io_pads_gpio_16_o_oval),
    .io_port_pins_16_o_oe            (io_pads_gpio_16_o_oe),
    .io_port_pins_16_o_ie            (io_pads_gpio_16_o_ie),
    .io_port_pins_16_o_pue           (io_pads_gpio_16_o_pue),
    .io_port_pins_16_o_ds            (io_pads_gpio_16_o_ds),
    .io_port_pins_17_i_ival          (io_pads_gpio_17_i_ival),
    .io_port_pins_17_o_oval          (io_pads_gpio_17_o_oval),
    .io_port_pins_17_o_oe            (io_pads_gpio_17_o_oe),
    .io_port_pins_17_o_ie            (io_pads_gpio_17_o_ie),
    .io_port_pins_17_o_pue           (io_pads_gpio_17_o_pue),
    .io_port_pins_17_o_ds            (io_pads_gpio_17_o_ds),
    .io_port_pins_18_i_ival          (io_pads_gpio_18_i_ival),
    .io_port_pins_18_o_oval          (io_pads_gpio_18_o_oval),
    .io_port_pins_18_o_oe            (io_pads_gpio_18_o_oe),
    .io_port_pins_18_o_ie            (io_pads_gpio_18_o_ie),
    .io_port_pins_18_o_pue           (io_pads_gpio_18_o_pue),
    .io_port_pins_18_o_ds            (io_pads_gpio_18_o_ds),
    .io_port_pins_19_i_ival          (io_pads_gpio_19_i_ival),
    .io_port_pins_19_o_oval          (io_pads_gpio_19_o_oval),
    .io_port_pins_19_o_oe            (io_pads_gpio_19_o_oe),
    .io_port_pins_19_o_ie            (io_pads_gpio_19_o_ie),
    .io_port_pins_19_o_pue           (io_pads_gpio_19_o_pue),
    .io_port_pins_19_o_ds            (io_pads_gpio_19_o_ds),
    .io_port_pins_20_i_ival          (io_pads_gpio_20_i_ival),
    .io_port_pins_20_o_oval          (io_pads_gpio_20_o_oval),
    .io_port_pins_20_o_oe            (io_pads_gpio_20_o_oe),
    .io_port_pins_20_o_ie            (io_pads_gpio_20_o_ie),
    .io_port_pins_20_o_pue           (io_pads_gpio_20_o_pue),
    .io_port_pins_20_o_ds            (io_pads_gpio_20_o_ds),
    .io_port_pins_21_i_ival          (io_pads_gpio_21_i_ival),
    .io_port_pins_21_o_oval          (io_pads_gpio_21_o_oval),
    .io_port_pins_21_o_oe            (io_pads_gpio_21_o_oe),
    .io_port_pins_21_o_ie            (io_pads_gpio_21_o_ie),
    .io_port_pins_21_o_pue           (io_pads_gpio_21_o_pue),
    .io_port_pins_21_o_ds            (io_pads_gpio_21_o_ds),
    .io_port_pins_22_i_ival          (io_pads_gpio_22_i_ival),
    .io_port_pins_22_o_oval          (io_pads_gpio_22_o_oval),
    .io_port_pins_22_o_oe            (io_pads_gpio_22_o_oe),
    .io_port_pins_22_o_ie            (io_pads_gpio_22_o_ie),
    .io_port_pins_22_o_pue           (io_pads_gpio_22_o_pue),
    .io_port_pins_22_o_ds            (io_pads_gpio_22_o_ds),
    .io_port_pins_23_i_ival          (io_pads_gpio_23_i_ival),
    .io_port_pins_23_o_oval          (io_pads_gpio_23_o_oval),
    .io_port_pins_23_o_oe            (io_pads_gpio_23_o_oe),
    .io_port_pins_23_o_ie            (io_pads_gpio_23_o_ie),
    .io_port_pins_23_o_pue           (io_pads_gpio_23_o_pue),
    .io_port_pins_23_o_ds            (io_pads_gpio_23_o_ds),
    .io_port_pins_24_i_ival          (io_pads_gpio_24_i_ival),
    .io_port_pins_24_o_oval          (io_pads_gpio_24_o_oval),
    .io_port_pins_24_o_oe            (io_pads_gpio_24_o_oe),
    .io_port_pins_24_o_ie            (io_pads_gpio_24_o_ie),
    .io_port_pins_24_o_pue           (io_pads_gpio_24_o_pue),
    .io_port_pins_24_o_ds            (io_pads_gpio_24_o_ds),
    .io_port_pins_25_i_ival          (io_pads_gpio_25_i_ival),
    .io_port_pins_25_o_oval          (io_pads_gpio_25_o_oval),
    .io_port_pins_25_o_oe            (io_pads_gpio_25_o_oe),
    .io_port_pins_25_o_ie            (io_pads_gpio_25_o_ie),
    .io_port_pins_25_o_pue           (io_pads_gpio_25_o_pue),
    .io_port_pins_25_o_ds            (io_pads_gpio_25_o_ds),
    .io_port_pins_26_i_ival          (io_pads_gpio_26_i_ival),
    .io_port_pins_26_o_oval          (io_pads_gpio_26_o_oval),
    .io_port_pins_26_o_oe            (io_pads_gpio_26_o_oe),
    .io_port_pins_26_o_ie            (io_pads_gpio_26_o_ie),
    .io_port_pins_26_o_pue           (io_pads_gpio_26_o_pue),
    .io_port_pins_26_o_ds            (io_pads_gpio_26_o_ds),
    .io_port_pins_27_i_ival          (io_pads_gpio_27_i_ival),
    .io_port_pins_27_o_oval          (io_pads_gpio_27_o_oval),
    .io_port_pins_27_o_oe            (io_pads_gpio_27_o_oe),
    .io_port_pins_27_o_ie            (io_pads_gpio_27_o_ie),
    .io_port_pins_27_o_pue           (io_pads_gpio_27_o_pue),
    .io_port_pins_27_o_ds            (io_pads_gpio_27_o_ds),
    .io_port_pins_28_i_ival          (io_pads_gpio_28_i_ival),
    .io_port_pins_28_o_oval          (io_pads_gpio_28_o_oval),
    .io_port_pins_28_o_oe            (io_pads_gpio_28_o_oe),
    .io_port_pins_28_o_ie            (io_pads_gpio_28_o_ie),
    .io_port_pins_28_o_pue           (io_pads_gpio_28_o_pue),
    .io_port_pins_28_o_ds            (io_pads_gpio_28_o_ds),
    .io_port_pins_29_i_ival          (io_pads_gpio_29_i_ival),
    .io_port_pins_29_o_oval          (io_pads_gpio_29_o_oval),
    .io_port_pins_29_o_oe            (io_pads_gpio_29_o_oe),
    .io_port_pins_29_o_ie            (io_pads_gpio_29_o_ie),
    .io_port_pins_29_o_pue           (io_pads_gpio_29_o_pue),
    .io_port_pins_29_o_ds            (io_pads_gpio_29_o_ds),
    .io_port_pins_30_i_ival          (io_pads_gpio_30_i_ival),
    .io_port_pins_30_o_oval          (io_pads_gpio_30_o_oval),
    .io_port_pins_30_o_oe            (io_pads_gpio_30_o_oe),
    .io_port_pins_30_o_ie            (io_pads_gpio_30_o_ie),
    .io_port_pins_30_o_pue           (io_pads_gpio_30_o_pue),
    .io_port_pins_30_o_ds            (io_pads_gpio_30_o_ds),
    .io_port_pins_31_i_ival          (io_pads_gpio_31_i_ival),
    .io_port_pins_31_o_oval          (io_pads_gpio_31_o_oval),
    .io_port_pins_31_o_oe            (io_pads_gpio_31_o_oe),
    .io_port_pins_31_o_ie            (io_pads_gpio_31_o_ie),
    .io_port_pins_31_o_pue           (io_pads_gpio_31_o_pue),
    .io_port_pins_31_o_ds            (io_pads_gpio_31_o_ds),
    .io_port_iof_0_0_i_ival          (gpio_iof_0_0_i_ival   ),// (),
    .io_port_iof_0_0_o_oval          (gpio_iof_0_0_o_oval   ),// (1'b0),
    .io_port_iof_0_0_o_oe            (gpio_iof_0_0_o_oe     ),// (1'b0),
    .io_port_iof_0_0_o_ie            (gpio_iof_0_0_o_ie     ),// (1'b0),
    .io_port_iof_0_0_o_valid         (gpio_iof_0_0_o_valid  ),// (1'b0),
    .io_port_iof_0_1_i_ival          (gpio_iof_0_1_i_ival   ),// (),
    .io_port_iof_0_1_o_oval          (gpio_iof_0_1_o_oval   ),// (1'b0),
    .io_port_iof_0_1_o_oe            (gpio_iof_0_1_o_oe     ),// (1'b0),
    .io_port_iof_0_1_o_ie            (gpio_iof_0_1_o_ie     ),// (1'b0),
    .io_port_iof_0_1_o_valid         (gpio_iof_0_1_o_valid  ),// (1'b0),
    .io_port_iof_0_2_i_ival          (gpio_iof_0_2_i_ival   ),// (),
    .io_port_iof_0_2_o_oval          (gpio_iof_0_2_o_oval   ),// (qspi1_cs_0),
    .io_port_iof_0_2_o_oe            (gpio_iof_0_2_o_oe     ),// (1'b1),
    .io_port_iof_0_2_o_ie            (gpio_iof_0_2_o_ie     ),// (1'b0),
    .io_port_iof_0_2_o_valid         (gpio_iof_0_2_o_valid  ),// (1'b1),
    .io_port_iof_0_3_i_ival          (gpio_iof_0_3_i_ival   ),// (),
    .io_port_iof_0_3_o_oval          (gpio_iof_0_3_o_oval   ),// (qspi1_dq_0_o),
    .io_port_iof_0_3_o_oe            (gpio_iof_0_3_o_oe     ),// (1'b1),
    .io_port_iof_0_3_o_ie            (gpio_iof_0_3_o_ie     ),// (1'b0),
    .io_port_iof_0_3_o_valid         (gpio_iof_0_3_o_valid  ),// (1'b1),
    .io_port_iof_0_4_i_ival          (gpio_iof_0_4_i_ival   ),// (),
    .io_port_iof_0_4_o_oval          (gpio_iof_0_4_o_oval   ),// (gpio_iof_0_4_o_oval),
    .io_port_iof_0_4_o_oe            (gpio_iof_0_4_o_oe     ),// (1'b1),
    .io_port_iof_0_4_o_ie            (gpio_iof_0_4_o_ie     ),// (1'b0),
    .io_port_iof_0_4_o_valid         (gpio_iof_0_4_o_valid  ),// (1'b1),
    .io_port_iof_0_5_i_ival          (gpio_iof_0_5_i_ival   ),// (),
    .io_port_iof_0_5_o_oval          (gpio_iof_0_5_o_oval   ),// (gpio_iof_0_5_o_oval),
    .io_port_iof_0_5_o_oe            (gpio_iof_0_5_o_oe     ),// (1'b1),
    .io_port_iof_0_5_o_ie            (gpio_iof_0_5_o_ie     ),// (1'b0),
    .io_port_iof_0_5_o_valid         (gpio_iof_0_5_o_valid  ),// (1'b1),
    .io_port_iof_0_6_i_ival          (gpio_iof_0_6_i_ival   ),// (),
    .io_port_iof_0_6_o_oval          (gpio_iof_0_6_o_oval   ),// (gpio_iof_0_6_o_oval),
    .io_port_iof_0_6_o_oe            (gpio_iof_0_6_o_oe     ),// (1'b1),
    .io_port_iof_0_6_o_ie            (gpio_iof_0_6_o_ie     ),// (1'b0),
    .io_port_iof_0_6_o_valid         (gpio_iof_0_6_o_valid  ),// (1'b1),
    .io_port_iof_0_7_i_ival          (gpio_iof_0_7_i_ival   ),// (),
    .io_port_iof_0_7_o_oval          (gpio_iof_0_7_o_oval   ),// (gpio_iof_0_7_o_oval),
    .io_port_iof_0_7_o_oe            (gpio_iof_0_7_o_oe     ),// (1'b1),
    .io_port_iof_0_7_o_ie            (gpio_iof_0_7_o_ie     ),// (1'b0),
    .io_port_iof_0_7_o_valid         (gpio_iof_0_7_o_valid  ),// (1'b1),
    .io_port_iof_0_8_i_ival          (gpio_iof_0_8_i_ival   ),// (),
    .io_port_iof_0_8_o_oval          (gpio_iof_0_8_o_oval   ),// (gpio_iof_0_8_o_oval),
    .io_port_iof_0_8_o_oe            (gpio_iof_0_8_o_oe     ),// (1'b1),
    .io_port_iof_0_8_o_ie            (gpio_iof_0_8_o_ie     ),// (1'b0),
    .io_port_iof_0_8_o_valid         (gpio_iof_0_8_o_valid  ),// (1'b1),
    .io_port_iof_0_9_i_ival          (gpio_iof_0_9_i_ival   ),// (),
    .io_port_iof_0_9_o_oval          (gpio_iof_0_9_o_oval   ),// (gpio_iof_0_9_o_oval),
    .io_port_iof_0_9_o_oe            (gpio_iof_0_9_o_oe     ),// (1'b1),
    .io_port_iof_0_9_o_ie            (gpio_iof_0_9_o_ie     ),// (1'b0),
    .io_port_iof_0_9_o_valid         (gpio_iof_0_9_o_valid  ),// (1'b1),
    .io_port_iof_0_10_i_ival         (gpio_iof_0_10_i_ival  ),// (),
    .io_port_iof_0_10_o_oval         (gpio_iof_0_10_o_oval  ),// (gpio_iof_0_10_o_oval),
    .io_port_iof_0_10_o_oe           (gpio_iof_0_10_o_oe    ),// (1'b1),
    .io_port_iof_0_10_o_ie           (gpio_iof_0_10_o_ie    ),// (1'b0),
    .io_port_iof_0_10_o_valid        (gpio_iof_0_10_o_valid ),// (1'b1),
    .io_port_iof_0_11_i_ival         (gpio_iof_0_11_i_ival  ),// (),
    .io_port_iof_0_11_o_oval         (gpio_iof_0_11_o_oval  ),// (1'b0),
    .io_port_iof_0_11_o_oe           (gpio_iof_0_11_o_oe    ),// (1'b0),
    .io_port_iof_0_11_o_ie           (gpio_iof_0_11_o_ie    ),// (1'b0),
    .io_port_iof_0_11_o_valid        (gpio_iof_0_11_o_valid ),// (1'b0),
    .io_port_iof_0_12_i_ival         (gpio_iof_0_12_i_ival  ),// (),
    .io_port_iof_0_12_o_oval         (gpio_iof_0_12_o_oval  ),// (1'b0),
    .io_port_iof_0_12_o_oe           (gpio_iof_0_12_o_oe    ),// (1'b0),
    .io_port_iof_0_12_o_ie           (gpio_iof_0_12_o_ie    ),// (1'b0),
    .io_port_iof_0_12_o_valid        (gpio_iof_0_12_o_valid ),// (1'b0),
    .io_port_iof_0_13_i_ival         (gpio_iof_0_13_i_ival  ),// (),
    .io_port_iof_0_13_o_oval         (gpio_iof_0_13_o_oval  ),// (1'b0),
    .io_port_iof_0_13_o_oe           (gpio_iof_0_13_o_oe    ),// (1'b0),
    .io_port_iof_0_13_o_ie           (gpio_iof_0_13_o_ie    ),// (1'b0),
    .io_port_iof_0_13_o_valid        (gpio_iof_0_13_o_valid ),// (1'b0),
    .io_port_iof_0_14_i_ival         (gpio_iof_0_14_i_ival  ),// (),
    .io_port_iof_0_14_o_oval         (gpio_iof_0_14_o_oval  ),// (1'b0),
    .io_port_iof_0_14_o_oe           (gpio_iof_0_14_o_oe    ),// (1'b0),
    .io_port_iof_0_14_o_ie           (gpio_iof_0_14_o_ie    ),// (1'b0),
    .io_port_iof_0_14_o_valid        (gpio_iof_0_14_o_valid ),// (1'b0),
    .io_port_iof_0_15_i_ival         (gpio_iof_0_15_i_ival  ),// (),
    .io_port_iof_0_15_o_oval         (gpio_iof_0_15_o_oval  ),// (1'b0),
    .io_port_iof_0_15_o_oe           (gpio_iof_0_15_o_oe    ),// (1'b0),
    .io_port_iof_0_15_o_ie           (gpio_iof_0_15_o_ie    ),// (1'b0),
    .io_port_iof_0_15_o_valid        (gpio_iof_0_15_o_valid ),// (1'b0),
    .io_port_iof_0_16_i_ival         (gpio_iof_0_16_i_ival  ),// (),
    .io_port_iof_0_16_o_oval         (gpio_iof_0_16_o_oval  ),// (gpio_iof_0_16_o_oval),
    .io_port_iof_0_16_o_oe           (gpio_iof_0_16_o_oe    ),// (1'b1),
    .io_port_iof_0_16_o_ie           (gpio_iof_0_16_o_ie    ),// (1'b0),
    .io_port_iof_0_16_o_valid        (gpio_iof_0_16_o_valid ),// (1'b1),
    .io_port_iof_0_17_i_ival         (gpio_iof_0_17_i_ival  ),// (),
    .io_port_iof_0_17_o_oval         (gpio_iof_0_17_o_oval  ),// (gpio_iof_0_17_o_oval),
    .io_port_iof_0_17_o_oe           (gpio_iof_0_17_o_oe    ),// (1'b1),
    .io_port_iof_0_17_o_ie           (gpio_iof_0_17_o_ie    ),// (1'b0),
    .io_port_iof_0_17_o_valid        (gpio_iof_0_17_o_valid ),// (1'b1),
    .io_port_iof_0_18_i_ival         (gpio_iof_0_18_i_ival  ),// (),
    .io_port_iof_0_18_o_oval         (gpio_iof_0_18_o_oval  ),// (1'b0),
    .io_port_iof_0_18_o_oe           (gpio_iof_0_18_o_oe    ),// (1'b0),
    .io_port_iof_0_18_o_ie           (gpio_iof_0_18_o_ie    ),// (1'b0),
    .io_port_iof_0_18_o_valid        (gpio_iof_0_18_o_valid ),// (1'b0),
    .io_port_iof_0_19_i_ival         (gpio_iof_0_19_i_ival  ),// (),
    .io_port_iof_0_19_o_oval         (gpio_iof_0_19_o_oval  ),// (1'b0),
    .io_port_iof_0_19_o_oe           (gpio_iof_0_19_o_oe    ),// (1'b0),
    .io_port_iof_0_19_o_ie           (gpio_iof_0_19_o_ie    ),// (1'b0),
    .io_port_iof_0_19_o_valid        (gpio_iof_0_19_o_valid ),// (1'b0),
    .io_port_iof_0_20_i_ival         (gpio_iof_0_20_i_ival  ),// (),
    .io_port_iof_0_20_o_oval         (gpio_iof_0_20_o_oval  ),// (1'b0),
    .io_port_iof_0_20_o_oe           (gpio_iof_0_20_o_oe    ),// (1'b0),
    .io_port_iof_0_20_o_ie           (gpio_iof_0_20_o_ie    ),// (1'b0),
    .io_port_iof_0_20_o_valid        (gpio_iof_0_20_o_valid ),// (1'b0),
    .io_port_iof_0_21_i_ival         (gpio_iof_0_21_i_ival  ),// (),
    .io_port_iof_0_21_o_oval         (gpio_iof_0_21_o_oval  ),// (1'b0),
    .io_port_iof_0_21_o_oe           (gpio_iof_0_21_o_oe    ),// (1'b0),
    .io_port_iof_0_21_o_ie           (gpio_iof_0_21_o_ie    ),// (1'b0),
    .io_port_iof_0_21_o_valid        (gpio_iof_0_21_o_valid ),// (1'b0),
    .io_port_iof_0_22_i_ival         (gpio_iof_0_22_i_ival  ),// (),
    .io_port_iof_0_22_o_oval         (gpio_iof_0_22_o_oval  ),// (1'b0),
    .io_port_iof_0_22_o_oe           (gpio_iof_0_22_o_oe    ),// (1'b0),
    .io_port_iof_0_22_o_ie           (gpio_iof_0_22_o_ie    ),// (1'b0),
    .io_port_iof_0_22_o_valid        (gpio_iof_0_22_o_valid ),// (1'b0),
    .io_port_iof_0_23_i_ival         (gpio_iof_0_23_i_ival  ),// (),
    .io_port_iof_0_23_o_oval         (gpio_iof_0_23_o_oval  ),// (1'b0),
    .io_port_iof_0_23_o_oe           (gpio_iof_0_23_o_oe    ),// (1'b0),
    .io_port_iof_0_23_o_ie           (gpio_iof_0_23_o_ie    ),// (1'b0),
    .io_port_iof_0_23_o_valid        (gpio_iof_0_23_o_valid ),// (1'b0),
    .io_port_iof_0_24_i_ival         (gpio_iof_0_24_i_ival  ),// (),
    .io_port_iof_0_24_o_oval         (gpio_iof_0_24_o_oval  ),// (gpio_iof_0_24_o_oval),
    .io_port_iof_0_24_o_oe           (gpio_iof_0_24_o_oe    ),// (1'b1),
    .io_port_iof_0_24_o_ie           (gpio_iof_0_24_o_ie    ),// (1'b0),
    .io_port_iof_0_24_o_valid        (gpio_iof_0_24_o_valid ),// (1'b1),
    .io_port_iof_0_25_i_ival         (gpio_iof_0_25_i_ival  ),// (),
    .io_port_iof_0_25_o_oval         (gpio_iof_0_25_o_oval  ),// (gpio_iof_0_25_o_oval),
    .io_port_iof_0_25_o_oe           (gpio_iof_0_25_o_oe    ),// (1'b1),
    .io_port_iof_0_25_o_ie           (gpio_iof_0_25_o_ie    ),// (1'b0),
    .io_port_iof_0_25_o_valid        (gpio_iof_0_25_o_valid ),// (1'b1),
    .io_port_iof_0_26_i_ival         (gpio_iof_0_26_i_ival  ),// (),
    .io_port_iof_0_26_o_oval         (gpio_iof_0_26_o_oval  ),// (gpio_iof_0_26_o_oval),
    .io_port_iof_0_26_o_oe           (gpio_iof_0_26_o_oe    ),// (1'b1),
    .io_port_iof_0_26_o_ie           (gpio_iof_0_26_o_ie    ),// (1'b0),
    .io_port_iof_0_26_o_valid        (gpio_iof_0_26_o_valid ),// (1'b1),
    .io_port_iof_0_27_i_ival         (gpio_iof_0_27_i_ival  ),// (),
    .io_port_iof_0_27_o_oval         (gpio_iof_0_27_o_oval  ),// (gpio_iof_0_27_o_oval),
    .io_port_iof_0_27_o_oe           (gpio_iof_0_27_o_oe    ),// (1'b1),
    .io_port_iof_0_27_o_ie           (gpio_iof_0_27_o_ie    ),// (1'b0),
    .io_port_iof_0_27_o_valid        (gpio_iof_0_27_o_valid ),// (1'b1),
    .io_port_iof_0_28_i_ival         (gpio_iof_0_28_i_ival  ),// (),
    .io_port_iof_0_28_o_oval         (gpio_iof_0_28_o_oval  ),// (gpio_iof_0_28_o_oval),
    .io_port_iof_0_28_o_oe           (gpio_iof_0_28_o_oe    ),// (1'b1),
    .io_port_iof_0_28_o_ie           (gpio_iof_0_28_o_ie    ),// (1'b0),
    .io_port_iof_0_28_o_valid        (gpio_iof_0_28_o_valid ),// (1'b1),
    .io_port_iof_0_29_i_ival         (gpio_iof_0_29_i_ival  ),// (),
    .io_port_iof_0_29_o_oval         (gpio_iof_0_29_o_oval  ),// (gpio_iof_0_29_o_oval),
    .io_port_iof_0_29_o_oe           (gpio_iof_0_29_o_oe    ),// (1'b1),
    .io_port_iof_0_29_o_ie           (gpio_iof_0_29_o_ie    ),// (1'b0),
    .io_port_iof_0_29_o_valid        (gpio_iof_0_29_o_valid ),// (1'b1),
    .io_port_iof_0_30_i_ival         (gpio_iof_0_30_i_ival  ),// (),
    .io_port_iof_0_30_o_oval         (gpio_iof_0_30_o_oval  ),// (gpio_iof_0_30_o_oval),
    .io_port_iof_0_30_o_oe           (gpio_iof_0_30_o_oe    ),// (1'b1),
    .io_port_iof_0_30_o_ie           (gpio_iof_0_30_o_ie    ),// (1'b0),
    .io_port_iof_0_30_o_valid        (gpio_iof_0_30_o_valid ),// (1'b1),
    .io_port_iof_0_31_i_ival         (gpio_iof_0_31_i_ival  ),// (),
    .io_port_iof_0_31_o_oval         (gpio_iof_0_31_o_oval  ),// (gpio_iof_0_31_o_oval),
    .io_port_iof_0_31_o_oe           (gpio_iof_0_31_o_oe    ),// (1'b1),
    .io_port_iof_0_31_o_ie           (gpio_iof_0_31_o_ie    ),// (1'b0),
    .io_port_iof_0_31_o_valid        (gpio_iof_0_31_o_valid ),// (1'b1),
    .io_port_iof_1_0_i_ival          (gpio_iof_1_0_i_ival   ),// (),
    .io_port_iof_1_0_o_oval          (gpio_iof_1_0_o_oval   ),// (gpio_iof_1_0_o_oval),
    .io_port_iof_1_0_o_oe            (gpio_iof_1_0_o_oe     ),// (gpio_iof_1_0_o_oe),
    .io_port_iof_1_0_o_ie            (gpio_iof_1_0_o_ie     ),// (gpio_iof_1_0_o_ie),
    .io_port_iof_1_0_o_valid         (gpio_iof_1_0_o_valid  ),// (gpio_iof_1_0_o_valid),
    .io_port_iof_1_1_i_ival          (gpio_iof_1_1_i_ival   ),// (),
    .io_port_iof_1_1_o_oval          (gpio_iof_1_1_o_oval   ),// (gpio_iof_1_1_o_oval),
    .io_port_iof_1_1_o_oe            (gpio_iof_1_1_o_oe     ),// (gpio_iof_1_1_o_oe),
    .io_port_iof_1_1_o_ie            (gpio_iof_1_1_o_ie     ),// (gpio_iof_1_1_o_ie),
    .io_port_iof_1_1_o_valid         (gpio_iof_1_1_o_valid  ),// (gpio_iof_1_1_o_valid),
    .io_port_iof_1_2_i_ival          (gpio_iof_1_2_i_ival   ),// (),
    .io_port_iof_1_2_o_oval          (gpio_iof_1_2_o_oval   ),// (gpio_iof_1_2_o_oval),
    .io_port_iof_1_2_o_oe            (gpio_iof_1_2_o_oe     ),// (gpio_iof_1_2_o_oe),
    .io_port_iof_1_2_o_ie            (gpio_iof_1_2_o_ie     ),// (gpio_iof_1_2_o_ie),
    .io_port_iof_1_2_o_valid         (gpio_iof_1_2_o_valid  ),// (gpio_iof_1_2_o_valid),
    .io_port_iof_1_3_i_ival          (gpio_iof_1_3_i_ival   ),// (),
    .io_port_iof_1_3_o_oval          (gpio_iof_1_3_o_oval   ),// (gpio_iof_1_3_o_oval),
    .io_port_iof_1_3_o_oe            (gpio_iof_1_3_o_oe     ),// (gpio_iof_1_3_o_oe),
    .io_port_iof_1_3_o_ie            (gpio_iof_1_3_o_ie     ),// (gpio_iof_1_3_o_ie),
    .io_port_iof_1_3_o_valid         (gpio_iof_1_3_o_valid  ),// (gpio_iof_1_3_o_valid),
    .io_port_iof_1_4_i_ival          (gpio_iof_1_4_i_ival   ),// (),
    .io_port_iof_1_4_o_oval          (gpio_iof_1_4_o_oval   ),// (gpio_iof_1_4_o_oval),
    .io_port_iof_1_4_o_oe            (gpio_iof_1_4_o_oe     ),// (gpio_iof_1_4_o_oe),
    .io_port_iof_1_4_o_ie            (gpio_iof_1_4_o_ie     ),// (gpio_iof_1_4_o_ie),
    .io_port_iof_1_4_o_valid         (gpio_iof_1_4_o_valid  ),// (gpio_iof_1_4_o_valid),
    .io_port_iof_1_5_i_ival          (gpio_iof_1_5_i_ival   ),// (),
    .io_port_iof_1_5_o_oval          (gpio_iof_1_5_o_oval   ),// (gpio_iof_1_5_o_oval),
    .io_port_iof_1_5_o_oe            (gpio_iof_1_5_o_oe     ),// (gpio_iof_1_5_o_oe),
    .io_port_iof_1_5_o_ie            (gpio_iof_1_5_o_ie     ),// (gpio_iof_1_5_o_ie),
    .io_port_iof_1_5_o_valid         (gpio_iof_1_5_o_valid  ),// (gpio_iof_1_5_o_valid),
    .io_port_iof_1_6_i_ival          (gpio_iof_1_6_i_ival   ),// (),
    .io_port_iof_1_6_o_oval          (gpio_iof_1_6_o_oval   ),// (gpio_iof_1_6_o_oval),
    .io_port_iof_1_6_o_oe            (gpio_iof_1_6_o_oe     ),// (gpio_iof_1_6_o_oe),
    .io_port_iof_1_6_o_ie            (gpio_iof_1_6_o_ie     ),// (gpio_iof_1_6_o_ie),
    .io_port_iof_1_6_o_valid         (gpio_iof_1_6_o_valid  ),// (gpio_iof_1_6_o_valid),
    .io_port_iof_1_7_i_ival          (gpio_iof_1_7_i_ival   ),// (),
    .io_port_iof_1_7_o_oval          (gpio_iof_1_7_o_oval   ),// (gpio_iof_1_7_o_oval),
    .io_port_iof_1_7_o_oe            (gpio_iof_1_7_o_oe     ),// (gpio_iof_1_7_o_oe),
    .io_port_iof_1_7_o_ie            (gpio_iof_1_7_o_ie     ),// (gpio_iof_1_7_o_ie),
    .io_port_iof_1_7_o_valid         (gpio_iof_1_7_o_valid  ),// (gpio_iof_1_7_o_valid),
    .io_port_iof_1_8_i_ival          (gpio_iof_1_8_i_ival   ),// (),
    .io_port_iof_1_8_o_oval          (gpio_iof_1_8_o_oval   ),// (gpio_iof_1_8_o_oval),
    .io_port_iof_1_8_o_oe            (gpio_iof_1_8_o_oe     ),// (gpio_iof_1_8_o_oe),
    .io_port_iof_1_8_o_ie            (gpio_iof_1_8_o_ie     ),// (gpio_iof_1_8_o_ie),
    .io_port_iof_1_8_o_valid         (gpio_iof_1_8_o_valid  ),// (gpio_iof_1_8_o_valid),
    .io_port_iof_1_9_i_ival          (gpio_iof_1_9_i_ival   ),// (),
    .io_port_iof_1_9_o_oval          (gpio_iof_1_9_o_oval   ),// (gpio_iof_1_9_o_oval),
    .io_port_iof_1_9_o_oe            (gpio_iof_1_9_o_oe     ),// (gpio_iof_1_9_o_oe),
    .io_port_iof_1_9_o_ie            (gpio_iof_1_9_o_ie     ),// (gpio_iof_1_9_o_ie),
    .io_port_iof_1_9_o_valid         (gpio_iof_1_9_o_valid  ),// (gpio_iof_1_9_o_valid),
    .io_port_iof_1_10_i_ival         (gpio_iof_1_10_i_ival  ),// (gpio_iof_1_10_i_ival),
    .io_port_iof_1_10_o_oval         (gpio_iof_1_10_o_oval  ),// (gpio_iof_1_10_o_oval),
    .io_port_iof_1_10_o_oe           (gpio_iof_1_10_o_oe    ),// (gpio_iof_1_10_o_oe),
    .io_port_iof_1_10_o_ie           (gpio_iof_1_10_o_ie    ),// (gpio_iof_1_10_o_ie),
    .io_port_iof_1_10_o_valid        (gpio_iof_1_10_o_valid ),// (gpio_iof_1_10_o_valid),
    .io_port_iof_1_11_i_ival         (gpio_iof_1_11_i_ival  ),// (gpio_iof_1_11_i_ival),
    .io_port_iof_1_11_o_oval         (gpio_iof_1_11_o_oval  ),// (gpio_iof_1_11_o_oval),
    .io_port_iof_1_11_o_oe           (gpio_iof_1_11_o_oe    ),// (gpio_iof_1_11_o_oe),
    .io_port_iof_1_11_o_ie           (gpio_iof_1_11_o_ie    ),// (gpio_iof_1_11_o_ie),
    .io_port_iof_1_11_o_valid        (gpio_iof_1_11_o_valid ),// (gpio_iof_1_11_o_valid),
    .io_port_iof_1_12_i_ival         (gpio_iof_1_12_i_ival  ),// (gpio_iof_1_12_i_ival),
    .io_port_iof_1_12_o_oval         (gpio_iof_1_12_o_oval  ),// (gpio_iof_1_12_o_oval),
    .io_port_iof_1_12_o_oe           (gpio_iof_1_12_o_oe    ),// (gpio_iof_1_12_o_oe),
    .io_port_iof_1_12_o_ie           (gpio_iof_1_12_o_ie    ),// (gpio_iof_1_12_o_ie),
    .io_port_iof_1_12_o_valid        (gpio_iof_1_12_o_valid ),// (gpio_iof_1_12_o_valid),
    .io_port_iof_1_13_i_ival         (gpio_iof_1_13_i_ival  ),// (gpio_iof_1_13_i_ival),
    .io_port_iof_1_13_o_oval         (gpio_iof_1_13_o_oval  ),// (gpio_iof_1_13_o_oval),
    .io_port_iof_1_13_o_oe           (gpio_iof_1_13_o_oe    ),// (gpio_iof_1_13_o_oe),
    .io_port_iof_1_13_o_ie           (gpio_iof_1_13_o_ie    ),// (gpio_iof_1_13_o_ie),
    .io_port_iof_1_13_o_valid        (gpio_iof_1_13_o_valid ),// (gpio_iof_1_13_o_valid),
    .io_port_iof_1_14_i_ival         (gpio_iof_1_14_i_ival  ),// (gpio_iof_1_14_i_ival),
    .io_port_iof_1_14_o_oval         (gpio_iof_1_14_o_oval  ),// (gpio_iof_1_14_o_oval),
    .io_port_iof_1_14_o_oe           (gpio_iof_1_14_o_oe    ),// (gpio_iof_1_14_o_oe),
    .io_port_iof_1_14_o_ie           (gpio_iof_1_14_o_ie    ),// (gpio_iof_1_14_o_ie),
    .io_port_iof_1_14_o_valid        (gpio_iof_1_14_o_valid ),// (gpio_iof_1_14_o_valid),
    .io_port_iof_1_15_i_ival         (gpio_iof_1_15_i_ival  ),// (gpio_iof_1_15_i_ival),
    .io_port_iof_1_15_o_oval         (gpio_iof_1_15_o_oval  ),// (gpio_iof_1_15_o_oval),
    .io_port_iof_1_15_o_oe           (gpio_iof_1_15_o_oe    ),// (gpio_iof_1_15_o_oe),
    .io_port_iof_1_15_o_ie           (gpio_iof_1_15_o_ie    ),// (gpio_iof_1_15_o_ie),
    .io_port_iof_1_15_o_valid        (gpio_iof_1_15_o_valid ),// (gpio_iof_1_15_o_valid),
    .io_port_iof_1_16_i_ival         (gpio_iof_1_16_i_ival  ),// (gpio_iof_1_16_i_ival),
    .io_port_iof_1_16_o_oval         (gpio_iof_1_16_o_oval  ),// (gpio_iof_1_16_o_oval),
    .io_port_iof_1_16_o_oe           (gpio_iof_1_16_o_oe    ),// (gpio_iof_1_16_o_oe),
    .io_port_iof_1_16_o_ie           (gpio_iof_1_16_o_ie    ),// (gpio_iof_1_16_o_ie),
    .io_port_iof_1_16_o_valid        (gpio_iof_1_16_o_valid ),// (gpio_iof_1_16_o_valid),
    .io_port_iof_1_17_i_ival         (gpio_iof_1_17_i_ival  ),// (gpio_iof_1_17_i_ival),
    .io_port_iof_1_17_o_oval         (gpio_iof_1_17_o_oval  ),// (gpio_iof_1_17_o_oval),
    .io_port_iof_1_17_o_oe           (gpio_iof_1_17_o_oe    ),// (gpio_iof_1_17_o_oe),
    .io_port_iof_1_17_o_ie           (gpio_iof_1_17_o_ie    ),// (gpio_iof_1_17_o_ie),
    .io_port_iof_1_17_o_valid        (gpio_iof_1_17_o_valid ),// (gpio_iof_1_17_o_valid),
    .io_port_iof_1_18_i_ival         (gpio_iof_1_18_i_ival  ),// (gpio_iof_1_18_i_ival),
    .io_port_iof_1_18_o_oval         (gpio_iof_1_18_o_oval  ),// (gpio_iof_1_18_o_oval),
    .io_port_iof_1_18_o_oe           (gpio_iof_1_18_o_oe    ),// (gpio_iof_1_18_o_oe),
    .io_port_iof_1_18_o_ie           (gpio_iof_1_18_o_ie    ),// (gpio_iof_1_18_o_ie),
    .io_port_iof_1_18_o_valid        (gpio_iof_1_18_o_valid ),// (gpio_iof_1_18_o_valid),
    .io_port_iof_1_19_i_ival         (gpio_iof_1_19_i_ival  ),// (gpio_iof_1_19_i_ival),
    .io_port_iof_1_19_o_oval         (gpio_iof_1_19_o_oval  ),// (gpio_iof_1_19_o_oval),
    .io_port_iof_1_19_o_oe           (gpio_iof_1_19_o_oe    ),// (gpio_iof_1_19_o_oe),
    .io_port_iof_1_19_o_ie           (gpio_iof_1_19_o_ie    ),// (gpio_iof_1_19_o_ie),
    .io_port_iof_1_19_o_valid        (gpio_iof_1_19_o_valid ),// (gpio_iof_1_19_o_valid),
    .io_port_iof_1_20_i_ival         (gpio_iof_1_20_i_ival  ),// (gpio_iof_1_20_i_ival),
    .io_port_iof_1_20_o_oval         (gpio_iof_1_20_o_oval  ),// (gpio_iof_1_20_o_oval),
    .io_port_iof_1_20_o_oe           (gpio_iof_1_20_o_oe    ),// (gpio_iof_1_20_o_oe),
    .io_port_iof_1_20_o_ie           (gpio_iof_1_20_o_ie    ),// (gpio_iof_1_20_o_ie),
    .io_port_iof_1_20_o_valid        (gpio_iof_1_20_o_valid ),// (gpio_iof_1_20_o_valid),
    .io_port_iof_1_21_i_ival         (gpio_iof_1_21_i_ival  ),// (gpio_iof_1_21_i_ival),
    .io_port_iof_1_21_o_oval         (gpio_iof_1_21_o_oval  ),// (gpio_iof_1_21_o_oval),
    .io_port_iof_1_21_o_oe           (gpio_iof_1_21_o_oe    ),// (gpio_iof_1_21_o_oe),
    .io_port_iof_1_21_o_ie           (gpio_iof_1_21_o_ie    ),// (gpio_iof_1_21_o_ie),
    .io_port_iof_1_21_o_valid        (gpio_iof_1_21_o_valid ),// (gpio_iof_1_21_o_valid),
    .io_port_iof_1_22_i_ival         (gpio_iof_1_22_i_ival  ),// (gpio_iof_1_22_i_ival),
    .io_port_iof_1_22_o_oval         (gpio_iof_1_22_o_oval  ),// (gpio_iof_1_22_o_oval),
    .io_port_iof_1_22_o_oe           (gpio_iof_1_22_o_oe    ),// (gpio_iof_1_22_o_oe),
    .io_port_iof_1_22_o_ie           (gpio_iof_1_22_o_ie    ),// (gpio_iof_1_22_o_ie),
    .io_port_iof_1_22_o_valid        (gpio_iof_1_22_o_valid ),// (gpio_iof_1_22_o_valid),
    .io_port_iof_1_23_i_ival         (gpio_iof_1_23_i_ival  ),// (gpio_iof_1_23_i_ival),
    .io_port_iof_1_23_o_oval         (gpio_iof_1_23_o_oval  ),// (gpio_iof_1_23_o_oval),
    .io_port_iof_1_23_o_oe           (gpio_iof_1_23_o_oe    ),// (gpio_iof_1_23_o_oe),
    .io_port_iof_1_23_o_ie           (gpio_iof_1_23_o_ie    ),// (gpio_iof_1_23_o_ie),
    .io_port_iof_1_23_o_valid        (gpio_iof_1_23_o_valid ),// (gpio_iof_1_23_o_valid),
    .io_port_iof_1_24_i_ival         (gpio_iof_1_24_i_ival  ),// (gpio_iof_1_24_i_ival),
    .io_port_iof_1_24_o_oval         (gpio_iof_1_24_o_oval  ),// (gpio_iof_1_24_o_oval),
    .io_port_iof_1_24_o_oe           (gpio_iof_1_24_o_oe    ),// (gpio_iof_1_24_o_oe),
    .io_port_iof_1_24_o_ie           (gpio_iof_1_24_o_ie    ),// (gpio_iof_1_24_o_ie),
    .io_port_iof_1_24_o_valid        (gpio_iof_1_24_o_valid ),// (gpio_iof_1_24_o_valid),
    .io_port_iof_1_25_i_ival         (gpio_iof_1_25_i_ival  ),// (gpio_iof_1_25_i_ival),
    .io_port_iof_1_25_o_oval         (gpio_iof_1_25_o_oval  ),// (gpio_iof_1_25_o_oval),
    .io_port_iof_1_25_o_oe           (gpio_iof_1_25_o_oe    ),// (gpio_iof_1_25_o_oe),
    .io_port_iof_1_25_o_ie           (gpio_iof_1_25_o_ie    ),// (gpio_iof_1_25_o_ie),
    .io_port_iof_1_25_o_valid        (gpio_iof_1_25_o_valid ),// (gpio_iof_1_25_o_valid),
    .io_port_iof_1_26_i_ival         (gpio_iof_1_26_i_ival  ),// (gpio_iof_1_26_i_ival),
    .io_port_iof_1_26_o_oval         (gpio_iof_1_26_o_oval  ),// (gpio_iof_1_26_o_oval),
    .io_port_iof_1_26_o_oe           (gpio_iof_1_26_o_oe    ),// (gpio_iof_1_26_o_oe),
    .io_port_iof_1_26_o_ie           (gpio_iof_1_26_o_ie    ),// (gpio_iof_1_26_o_ie),
    .io_port_iof_1_26_o_valid        (gpio_iof_1_26_o_valid ),// (gpio_iof_1_26_o_valid),
    .io_port_iof_1_27_i_ival         (gpio_iof_1_27_i_ival  ),// (gpio_iof_1_27_i_ival),
    .io_port_iof_1_27_o_oval         (gpio_iof_1_27_o_oval  ),// (gpio_iof_1_27_o_oval),
    .io_port_iof_1_27_o_oe           (gpio_iof_1_27_o_oe    ),// (gpio_iof_1_27_o_oe),
    .io_port_iof_1_27_o_ie           (gpio_iof_1_27_o_ie    ),// (gpio_iof_1_27_o_ie),
    .io_port_iof_1_27_o_valid        (gpio_iof_1_27_o_valid ),// (gpio_iof_1_27_o_valid),
    .io_port_iof_1_28_i_ival         (gpio_iof_1_28_i_ival  ),// (gpio_iof_1_28_i_ival),
    .io_port_iof_1_28_o_oval         (gpio_iof_1_28_o_oval  ),// (gpio_iof_1_28_o_oval),
    .io_port_iof_1_28_o_oe           (gpio_iof_1_28_o_oe    ),// (gpio_iof_1_28_o_oe),
    .io_port_iof_1_28_o_ie           (gpio_iof_1_28_o_ie    ),// (gpio_iof_1_28_o_ie),
    .io_port_iof_1_28_o_valid        (gpio_iof_1_28_o_valid ),// (gpio_iof_1_28_o_valid),
    .io_port_iof_1_29_i_ival         (gpio_iof_1_29_i_ival  ),// (gpio_iof_1_29_i_ival),
    .io_port_iof_1_29_o_oval         (gpio_iof_1_29_o_oval  ),// (gpio_iof_1_29_o_oval),
    .io_port_iof_1_29_o_oe           (gpio_iof_1_29_o_oe    ),// (gpio_iof_1_29_o_oe),
    .io_port_iof_1_29_o_ie           (gpio_iof_1_29_o_ie    ),// (gpio_iof_1_29_o_ie),
    .io_port_iof_1_29_o_valid        (gpio_iof_1_29_o_valid ),// (gpio_iof_1_29_o_valid),
    .io_port_iof_1_30_i_ival         (gpio_iof_1_30_i_ival  ),// (gpio_iof_1_30_i_ival),
    .io_port_iof_1_30_o_oval         (gpio_iof_1_30_o_oval  ),// (gpio_iof_1_30_o_oval),
    .io_port_iof_1_30_o_oe           (gpio_iof_1_30_o_oe    ),// (gpio_iof_1_30_o_oe),
    .io_port_iof_1_30_o_ie           (gpio_iof_1_30_o_ie    ),// (gpio_iof_1_30_o_ie),
    .io_port_iof_1_30_o_valid        (gpio_iof_1_30_o_valid ),// (gpio_iof_1_30_o_valid),
    .io_port_iof_1_31_i_ival         (gpio_iof_1_31_i_ival  ),// (gpio_iof_1_31_i_ival),
    .io_port_iof_1_31_o_oval         (gpio_iof_1_31_o_oval  ),// (gpio_iof_1_31_o_oval),
    .io_port_iof_1_31_o_oe           (gpio_iof_1_31_o_oe    ),// (gpio_iof_1_31_o_oe),
    .io_port_iof_1_31_o_ie           (gpio_iof_1_31_o_ie    ),// (gpio_iof_1_31_o_ie),
    .io_port_iof_1_31_o_valid        (gpio_iof_1_31_o_valid ) // (gpio_iof_1_31_o_valid)
);

  //  * UART0     
sirv_uart_top u_sirv_uart0_top (
    .clk           (clk  ),
    .rst_n         (rst_n),

    .i_icb_cmd_valid (uart0_icb_cmd_valid),
    .i_icb_cmd_ready (uart0_icb_cmd_ready),
    .i_icb_cmd_addr  (uart0_icb_cmd_addr ),
    .i_icb_cmd_read  (uart0_icb_cmd_read ),
    .i_icb_cmd_wdata (uart0_icb_cmd_wdata),
    
    .i_icb_rsp_valid (uart0_icb_rsp_valid),
    .i_icb_rsp_ready (uart0_icb_rsp_ready),
    .i_icb_rsp_rdata (uart0_icb_rsp_rdata),

    .io_interrupts_0_0 (uart0_irq),                
    .io_port_txd       (uart0_txd),
    .io_port_rxd       (uart0_rxd)
);




  sirv_uartgpioport u_uart0_pins (
    .clock(clk),
    .reset(~rst_n),
    .io_uart_txd(uart0_txd),
    .io_uart_rxd(uart0_rxd),
    .io_pins_rxd_i_ival(uart_pins_0_io_pins_rxd_i_ival),
    .io_pins_rxd_o_oval(uart_pins_0_io_pins_rxd_o_oval),
    .io_pins_rxd_o_oe(uart_pins_0_io_pins_rxd_o_oe),
    .io_pins_rxd_o_ie(uart_pins_0_io_pins_rxd_o_ie),
    .io_pins_rxd_o_pue(uart_pins_0_io_pins_rxd_o_pue),
    .io_pins_rxd_o_ds(uart_pins_0_io_pins_rxd_o_ds),
    .io_pins_txd_i_ival(uart_pins_0_io_pins_txd_i_ival),
    .io_pins_txd_o_oval(uart_pins_0_io_pins_txd_o_oval),
    .io_pins_txd_o_oe(uart_pins_0_io_pins_txd_o_oe),
    .io_pins_txd_o_ie(uart_pins_0_io_pins_txd_o_ie),
    .io_pins_txd_o_pue(uart_pins_0_io_pins_txd_o_pue),
    .io_pins_txd_o_ds(uart_pins_0_io_pins_txd_o_ds)
  );

 
  localparam CMD_PACK_W = 65;
  localparam RSP_PACK_W = 33;




  wire [CMD_PACK_W-1:0] i_aon_icb_cmd_pack;
  wire [RSP_PACK_W-1:0] i_aon_icb_rsp_pack;
  wire [CMD_PACK_W-1:0] aon_icb_cmd_pack;
  wire [RSP_PACK_W-1:0] aon_icb_rsp_pack;
  
  assign i_aon_icb_cmd_pack = {
          i_aon_icb_cmd_addr, 
          i_aon_icb_cmd_read, 
          i_aon_icb_cmd_wdata};

  assign {aon_icb_cmd_addr, 
          aon_icb_cmd_read, 
          aon_icb_cmd_wdata} = aon_icb_cmd_pack;

  sirv_gnrl_cdc_tx   
   # (
     .DW      (CMD_PACK_W),
     .SYNC_DP (`E203_ASYNC_FF_LEVELS) 
   ) u_aon_icb_cdc_tx (
     .o_vld  (aon_icb_cmd_valid ), 
     .o_rdy_a(aon_icb_cmd_ready ), 
     .o_dat  (aon_icb_cmd_pack ),
     .i_vld  (i_aon_icb_cmd_valid ),
     .i_rdy  (i_aon_icb_cmd_ready ),
     .i_dat  (i_aon_icb_cmd_pack ),
   
     .clk    (clk),
     .rst_n  (rst_n)
   );
     

  assign aon_icb_rsp_pack = {
          aon_icb_rsp_err, 
          aon_icb_rsp_rdata};

  assign {i_aon_icb_rsp_err, 
          i_aon_icb_rsp_rdata} = i_aon_icb_rsp_pack;

   sirv_gnrl_cdc_rx   
      # (
     .DW      (RSP_PACK_W),
     .SYNC_DP (`E203_ASYNC_FF_LEVELS) 
   ) u_aon_icb_cdc_rx (
     .i_vld_a(aon_icb_rsp_valid), 
     .i_rdy  (aon_icb_rsp_ready), 
     .i_dat  (aon_icb_rsp_pack),
     .o_vld  (i_aon_icb_rsp_valid),
     .o_rdy  (i_aon_icb_rsp_ready),
     .o_dat  (i_aon_icb_rsp_pack),
   
     .clk    (clk),
     .rst_n  (rst_n)
   );


      // * Here is an example AXI Peripheral
  wire expl_axi_arvalid;
  wire expl_axi_arready;
  wire [`E203_ADDR_SIZE-1:0] expl_axi_araddr;
  wire [3:0] expl_axi_arcache;
  wire [2:0] expl_axi_arprot;
  wire [1:0] expl_axi_arlock;
  wire [1:0] expl_axi_arburst;
  wire [3:0] expl_axi_arlen;
  wire [2:0] expl_axi_arsize;

  wire expl_axi_awvalid;
  wire expl_axi_awready;
  wire [`E203_ADDR_SIZE-1:0] expl_axi_awaddr;
  wire [3:0] expl_axi_awcache;
  wire [2:0] expl_axi_awprot;
  wire [1:0] expl_axi_awlock;
  wire [1:0] expl_axi_awburst;
  wire [3:0] expl_axi_awlen;
  wire [2:0] expl_axi_awsize;

  wire expl_axi_rvalid;
  wire expl_axi_rready;
  wire [`E203_XLEN-1:0] expl_axi_rdata;
  wire [1:0] expl_axi_rresp;
  wire expl_axi_rlast;

  wire expl_axi_wvalid;
  wire expl_axi_wready;
  wire [`E203_XLEN-1:0] expl_axi_wdata;
  wire [(`E203_XLEN/8)-1:0] expl_axi_wstrb;
  wire expl_axi_wlast;

  wire expl_axi_bvalid;
  wire expl_axi_bready;
  wire [1:0] expl_axi_bresp;
   
sirv_gnrl_icb2axi # (
  .AXI_FIFO_DP (2), // We just add ping-pong buffer here to avoid any potential timing loops
                    //   User can change it to 0 if dont care
  .AXI_FIFO_CUT_READY (1), // This is to cut the back-pressure signal if you set as 1
  .AW   (32),
  .FIFO_OUTS_NUM (1),// We only allow 1 oustandings at most for peripheral, user can configure it to any value
  .FIFO_CUT_READY(1),
  .DW   (`E203_XLEN) 
) u_expl_axi_icb2axi(
    .i_icb_cmd_valid (expl_axi_icb_cmd_valid),
    .i_icb_cmd_ready (expl_axi_icb_cmd_ready),
    .i_icb_cmd_addr  (expl_axi_icb_cmd_addr ),
    .i_icb_cmd_read  (expl_axi_icb_cmd_read ),
    .i_icb_cmd_wdata (expl_axi_icb_cmd_wdata),
    .i_icb_cmd_wmask (expl_axi_icb_cmd_wmask),
    .i_icb_cmd_size  (),
    
    .i_icb_rsp_valid (expl_axi_icb_rsp_valid),
    .i_icb_rsp_ready (expl_axi_icb_rsp_ready),
    .i_icb_rsp_rdata (expl_axi_icb_rsp_rdata),
    .i_icb_rsp_err   (expl_axi_icb_rsp_err),

    .o_axi_arvalid   (expl_axi_arvalid),
    .o_axi_arready   (expl_axi_arready),
    .o_axi_araddr    (expl_axi_araddr ),
    .o_axi_arcache   (expl_axi_arcache),
    .o_axi_arprot    (expl_axi_arprot ),
    .o_axi_arlock    (expl_axi_arlock ),
    .o_axi_arburst   (expl_axi_arburst),
    .o_axi_arlen     (expl_axi_arlen  ),
    .o_axi_arsize    (expl_axi_arsize ),
                      
    .o_axi_awvalid   (expl_axi_awvalid),
    .o_axi_awready   (expl_axi_awready),
    .o_axi_awaddr    (expl_axi_awaddr ),
    .o_axi_awcache   (expl_axi_awcache),
    .o_axi_awprot    (expl_axi_awprot ),
    .o_axi_awlock    (expl_axi_awlock ),
    .o_axi_awburst   (expl_axi_awburst),
    .o_axi_awlen     (expl_axi_awlen  ),
    .o_axi_awsize    (expl_axi_awsize ),
                     
    .o_axi_rvalid    (expl_axi_rvalid ),
    .o_axi_rready    (expl_axi_rready ),
    .o_axi_rdata     (expl_axi_rdata  ),
    .o_axi_rresp     (expl_axi_rresp  ),
    .o_axi_rlast     (expl_axi_rlast  ),
                    
    .o_axi_wvalid    (expl_axi_wvalid ),
    .o_axi_wready    (expl_axi_wready ),
    .o_axi_wdata     (expl_axi_wdata  ),
    .o_axi_wstrb     (expl_axi_wstrb  ),
    .o_axi_wlast     (expl_axi_wlast  ),
                   
    .o_axi_bvalid    (expl_axi_bvalid ),
    .o_axi_bready    (expl_axi_bready ),
    .o_axi_bresp     (expl_axi_bresp  ),

    .clk           (clk  ),
    .rst_n         (bus_rst_n) 
  );

sirv_expl_axi_slv # (
  .AW   (32),
  .DW   (`E203_XLEN) 
) u_perips_expl_axi_slv (
    .axi_arvalid   (expl_axi_arvalid),
    .axi_arready   (expl_axi_arready),
    .axi_araddr    (expl_axi_araddr ),
    .axi_arcache   (expl_axi_arcache),
    .axi_arprot    (expl_axi_arprot ),
    .axi_arlock    (expl_axi_arlock ),
    .axi_arburst   (expl_axi_arburst),
    .axi_arlen     (expl_axi_arlen  ),
    .axi_arsize    (expl_axi_arsize ),
     
    .axi_awvalid   (expl_axi_awvalid),
    .axi_awready   (expl_axi_awready),
    .axi_awaddr    (expl_axi_awaddr ),
    .axi_awcache   (expl_axi_awcache),
    .axi_awprot    (expl_axi_awprot ),
    .axi_awlock    (expl_axi_awlock ),
    .axi_awburst   (expl_axi_awburst),
    .axi_awlen     (expl_axi_awlen  ),
    .axi_awsize    (expl_axi_awsize ),
    
    .axi_rvalid    (expl_axi_rvalid ),
    .axi_rready    (expl_axi_rready ),
    .axi_rdata     (expl_axi_rdata  ),
    .axi_rresp     (expl_axi_rresp  ),
    .axi_rlast     (expl_axi_rlast  ),
   
    .axi_wvalid    (expl_axi_wvalid ),
    .axi_wready    (expl_axi_wready ),
    .axi_wdata     (expl_axi_wdata  ),
    .axi_wstrb     (expl_axi_wstrb  ),
    .axi_wlast     (expl_axi_wlast  ),
  
    .axi_bvalid    (expl_axi_bvalid ),
    .axi_bready    (expl_axi_bready ),
    .axi_bresp     (expl_axi_bresp  ),

    .clk           (clk  ),
    .rst_n         (rst_n) 
  );


      // * Here is an example APB Peripheral
  wire [`E203_ADDR_SIZE-1:0] expl_apb_paddr;
  wire expl_apb_pwrite;
  wire expl_apb_pselx;
  wire expl_apb_penable;
  wire [`E203_XLEN-1:0] expl_apb_pwdata;
  wire [`E203_XLEN-1:0] expl_apb_prdata;
   
sirv_gnrl_icb2apb # (
  .AW   (32),
  .DW   (`E203_XLEN) 
) u_expl_apb_icb2apb(
    .i_icb_cmd_valid (expl_apb_icb_cmd_valid),
    .i_icb_cmd_ready (expl_apb_icb_cmd_ready),
    .i_icb_cmd_addr  (expl_apb_icb_cmd_addr ),
    .i_icb_cmd_read  (expl_apb_icb_cmd_read ),
    .i_icb_cmd_wdata (expl_apb_icb_cmd_wdata),
    .i_icb_cmd_wmask (expl_apb_icb_cmd_wmask),
    .i_icb_cmd_size  (),
    
    .i_icb_rsp_valid (expl_apb_icb_rsp_valid),
    .i_icb_rsp_ready (expl_apb_icb_rsp_ready),
    .i_icb_rsp_rdata (expl_apb_icb_rsp_rdata),
    .i_icb_rsp_err   (expl_apb_icb_rsp_err),

    .apb_paddr     (expl_apb_paddr  ),
    .apb_pwrite    (expl_apb_pwrite ),
    .apb_pselx     (expl_apb_pselx  ),
    .apb_penable   (expl_apb_penable), 
    .apb_pwdata    (expl_apb_pwdata ),
    .apb_prdata    (expl_apb_prdata ),

    .clk           (clk  ),
    .rst_n         (bus_rst_n) 
  );

sirv_expl_apb_slv # (
  .AW   (32),
  .DW   (`E203_XLEN) 
) u_perips_expl_apb_slv (

    .apb_paddr     (expl_apb_paddr  ),
    .apb_pwrite    (expl_apb_pwrite ),
    .apb_pselx     (expl_apb_pselx  ),
    .apb_penable   (expl_apb_penable), 
    .apb_pwdata    (expl_apb_pwdata ),
    .apb_prdata    (expl_apb_prdata ),

    .clk           (clk  ),
    .rst_n         (rst_n) 
  );


  sirv_hclkgen_regs u_sirv_hclkgen_regs(
    .clk  (clk),
    .rst_n(rst_n),

    .pllbypass   (pllbypass   ),
    .pll_RESET(pll_RESET),
    .pll_ASLEEP(pll_ASLEEP),
    .pll_OD(pll_OD),
    .pll_M (pll_M ),
    .pll_N (pll_N ),
    .plloutdivby1(plloutdivby1),
    .plloutdiv   (plloutdiv   ),
                              
    .hfxoscen    (hfxoscen    ),


    .i_icb_cmd_valid(hclkgen_icb_cmd_valid),
    .i_icb_cmd_ready(hclkgen_icb_cmd_ready),
    .i_icb_cmd_addr (hclkgen_icb_cmd_addr[11:0]), 
    .i_icb_cmd_read (hclkgen_icb_cmd_read ), 
    .i_icb_cmd_wdata(hclkgen_icb_cmd_wdata),
                     
    .i_icb_rsp_valid(hclkgen_icb_rsp_valid),
    .i_icb_rsp_ready(hclkgen_icb_rsp_ready),
    .i_icb_rsp_rdata(hclkgen_icb_rsp_rdata)
  );

endmodule
