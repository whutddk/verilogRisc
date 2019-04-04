//////////////////////////////////////////////////////////////////////////////////
// Company:   
// Engineer: Ruige_Lee
// Create Date: 2019-02-17 17:25:12
// Last Modified by:   Ruige_Lee
// Last Modified time: 2019-04-04 11:41:28
// Email: 295054118@whut.edu.cn
// Design Name:   
// Module Name: e203_soc_top
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
// Last Modified time: 2019-02-02 21:06:40
// Email: 295054118@whut.edu.cn
// Design Name: e203_soc_top.v  
// Module Name: e203_soc_top
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
* @File Name: e203_soc_top.v
* @File Path: K:\work\dark+PRJ\e200_opensource\rtl\e203\soc\e203_soc_top.v
* @Author: 29505
* @Date:   2019-01-28 20:59:01
* @Last Modified by:   29505
* @Last Modified time: 2019-01-31 18:47:11
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
																		 
																		 
																		 
module e203_soc_top(

	input  hfextclk,
	input  lfextclk
 
);


 
(* DONT_TOUCH = "TRUE" *)
 e203_subsys_top u_e203_subsys_top(

	.hfextclk        (hfextclk),
	.lfextclk        (lfextclk)

  );

endmodule
