//////////////////////////////////////////////////////////////////////////////////
// Company:   
// Engineer: Ruige_Lee
// Create Date: 2018/06/21 10:07:43
// Last Modified by:   Ruige_Lee
// Last Modified time: 2019-07-06 15:51:25
// Email: 295054118@whut.edu.cn
// page: https://whutddk.github.io/
// Design Name:   
// Module Name: ip_SRAM
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

`timescale 1ns / 1ps


module perip_SRAM # (
		parameter AW = 20,
		parameter DW = 16
	)
	( 
		// input CLK,
		// input RST_n,

		input [AW-1:0] mem_address,
		input mem_wren,
		input mem_rden,
		input [DW-1:0] data_in,
		output [DW-1:0] data_out,

		//driver pin
		output SRAM_OEn_io,
		output SRAM_WRn_io,
		output SRAM_CSn_io,

		output [AW-1:0] SRAM_ADDR_io,
		output [DW-1:0] SRAM_DATA_IN_io,
		input [DW-1:0] SRAM_DATA_OUT_io,
		output SRAM_DATA_t
);
	
assign SRAM_CSn_Pin = 1'b0;
assign SRAM_OEn_io = ~mem_rden;
assign SRAM_WRn_io = ~mem_wren;
assign SRAM_ADDR_io = mem_address;
assign SRAM_DATA_IN_io = data_in;
assign data_out = SRAM_DATA_OUT_io; 

assign SRAM_DATA_t = mem_wren ? 1'b0 : 1'b1;




endmodule
