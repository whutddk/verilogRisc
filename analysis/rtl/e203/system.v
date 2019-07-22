//////////////////////////////////////////////////////////////////////////////////
// Company:   
// Engineer: Ruige_Lee
// Create Date: 2019-02-17 17:25:12
// Last Modified by:   Ruige_Lee
// Last Modified time: 2019-04-04 11:39:21
// Email: 295054118@whut.edu.cn
// Design Name:   
// Module Name: system
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
// Engineer: Ruige_Lee
// Create Date: 2019-01-24 08:57:00
// Last Modified by:   29505
// Last Modified time: 2019-02-02 21:07:21
// Email: 295054118@whut.edu.cn
// Design Name: system.v  
// Module Name: system
// Project Name:   
// Target Devices:   
// Tool Versions:   
// Description:   
// 
// Dependencies:   
// 
// Revision:  
// Revision 0.01 - File Created
// Additional Comments:  
// 
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module system
(
  input wire CLK100MHZ,//GCLK-W19
  input wire CLK32768KHZ,//RTC_CLK-Y18

  input wire fpga_rst,//FPGA_RESET-T6
  input wire mcu_rst//MCU_RESET-P20

);

  wire clk_out1;
  wire mmcm_locked;

  wire reset_periph;

  wire ck_rst;

  // All wires connected to the chip top
  wire dut_clock;
  wire dut_reset;
 
  //=================================================
  // Clock & Reset
  wire clk_8388;
  wire clk_16M;
  


  mmcm ip_mmcm
  (
    .resetn(ck_rst),
    .clk_in1(CLK100MHZ),
    
    .clk_out2(clk_16M), // 16 MHz, this clock we set to 16MHz 
    .locked(mmcm_locked)
  );

  assign ck_rst = fpga_rst & mcu_rst;

  

  reset_sys ip_reset_sys
  (
    .slowest_sync_clk(clk_16M),
    .ext_reset_in(ck_rst), // Active-low
    .aux_reset_in(1'b1),
    .mb_debug_sys_rst(1'b0),
    .dcm_locked(mmcm_locked),
    .mb_reset(),
    .bus_struct_reset(),
    .peripheral_reset(reset_periph),
    .interconnect_aresetn(),
    .peripheral_aresetn()
  );

  
(* DONT_TOUCH = "TRUE" *)
  e203_soc_top dut
  (
    .hfextclk(clk_16M),
    // .hfxoscen(),

    .lfextclk(CLK32768KHZ)
    // .lfxoscen(),

   
  );

  
endmodule


