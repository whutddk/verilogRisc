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
//  The Regfile module to implement the core's general purpose registers file
//
// ====================================================================
`include "e203_defines.v"

module e203_exu_regfile(
	input  [`E203_RFIDX_WIDTH-1:0] read_src1_idx,
	input  [`E203_RFIDX_WIDTH-1:0] read_src2_idx,
	output [`E203_XLEN-1:0] read_src1_dat,
	output [`E203_XLEN-1:0] read_src2_dat,

	input  wbck_dest_wen,
	input  [`E203_RFIDX_WIDTH-1:0] wbck_dest_idx,
	input  [`E203_XLEN-1:0] wbck_dest_dat,

	output [`E203_XLEN-1:0] x1_r,

	input  test_mode,
	input  clk,
	input  rst_n
	);

	wire [`E203_XLEN-1:0] rf_r [`E203_RFREG_NUM-1:0];
	wire [`E203_RFREG_NUM-1:0] rf_wen;
		
	genvar i;
	generate //{
	
			for (i=0; i<`E203_RFREG_NUM; i=i+1) begin:regfile//{
	
				if(i==0) begin: rf0
						// x0 cannot be wrote since it is constant-zeros
						assign rf_wen[i] = 1'b0;
						assign rf_r[i] = `E203_XLEN'b0;
					`ifdef E203_REGFILE_LATCH_BASED //{
						assign clk_rf_ltch[i] = 1'b0;
					`endif//}
				end
				else begin: rfno0
						assign rf_wen[i] = wbck_dest_wen & (wbck_dest_idx == i) ;
						sirv_gnrl_dffl #(`E203_XLEN) rf_dffl (rf_wen[i], wbck_dest_dat, rf_r[i], clk);
				end
	
			end//}
	endgenerate//}
	
	assign read_src1_dat = rf_r[read_src1_idx];
	assign read_src2_dat = rf_r[read_src2_idx];
	

	assign x1_r = rf_r[1];
			
endmodule

