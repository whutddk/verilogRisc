//////////////////////////////////////////////////////////////////////////////////
// Company:   
// Engineer: Ruige_Lee
// Create Date: 2019-02-17 17:25:12
// Last Modified by:   29505
// Last Modified time: 2019-06-26 09:50:17
// Email: 295054118@whut.edu.cn
// Design Name: e203_subsys_top.v  
// Module Name: e203_subsys_top
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
// Create Date: 2019-01-31 16:01:05
// Last Modified by:   29505
// Last Modified time: 2019-02-01 22:18:44
// Email: 295054118@whut.edu.cn
// Design Name: e203_subsys_top.v  
// Module Name: e203_subsys_top
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
* @File Name: e203_subsys_top.v
* @File Path: K:\work\dark+PRJ\e200_opensource\rtl\e203\subsys\e203_subsys_top.v
* @Author: 29505
* @Date:   2019-01-28 20:59:01
* @Last Modified by:   29505
* @Last Modified time: 2019-01-31 18:48:40
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

module e203_subsys_top(
	// This clock should comes from the crystal pad generated high speed clock (16MHz)
	input  hfextclk,
	// output hfxoscen,// The signal to enable the crystal pad generated clock
	// This clock should comes from the crystal pad generated low speed clock (32.768KHz)
	input  lfextclk
	);

	wire hfclk;// The PLL generated high-speed clock 
	wire hfclkrst;// The reset signal to disable PLL
	wire corerst;

	wire  [`E203_PC_SIZE-1:0] pc_rtvec;
(* DONT_TOUCH = "TRUE" *)
e203_subsys_main  u_e203_subsys_main(
	.pc_rtvec        (32'h0000_1000),

	.hfclk           (hfclk   ),
	.hfclkrst        (hfclkrst),
	.corerst       (corerst)
	);


endmodule
