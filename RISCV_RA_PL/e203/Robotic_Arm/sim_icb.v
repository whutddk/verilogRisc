
module sim_icb (

	
);


reg	i_icb_cmd_valid;
wire i_icb_cmd_ready;
reg [31:0] i_icb_cmd_addr; 
reg i_icb_cmd_read; 
reg [31:0] i_icb_cmd_wdata;
	
wire i_icb_rsp_valid;
wire i_icb_rsp_ready;
wire [31:0]	i_icb_rsp_rdata;

reg	clk;
reg	rst_n;



icb_interface sim_icb_interface (

	.i_icb_cmd_valid(i_icb_cmd_valid),
	.i_icb_cmd_ready(i_icb_cmd_ready),
	.i_icb_cmd_addr(i_icb_cmd_addr),
	.i_icb_cmd_read(i_icb_cmd_read),
	.i_icb_cmd_wdata(i_icb_cmd_wdata),

	.i_icb_rsp_valid(i_icb_rsp_valid),
	.i_icb_rsp_ready(i_icb_rsp_ready),
	.i_icb_rsp_rdata(i_icb_rsp_rdata),

	.clk(clk),
	.rst_n(rst_n)

);


assign i_icb_rsp_ready = i_icb_rsp_valid;



always begin
	#10
	clk = ~clk;

end


initial begin
	clk = 1'b0;



	rst_n = 1'b0;

	i_icb_cmd_valid = 'd0;
	i_icb_cmd_addr = 'd0; 
	i_icb_cmd_read = 'd0; 
	i_icb_cmd_wdata = 'd0;

# 100
	rst_n = 1'b1;

# 100	

	i_icb_cmd_valid = 1'b1;
	i_icb_cmd_addr = 5'd0; 
	i_icb_cmd_read = 'd0; 
	i_icb_cmd_wdata = 32'd10;

# 20 

	i_icb_cmd_valid = 1'b1;
	i_icb_cmd_addr = 5'd1; 
	i_icb_cmd_read = 'd0; 
	i_icb_cmd_wdata = 32'd12;

# 20 

	i_icb_cmd_valid = 1'b1;
	i_icb_cmd_addr = 5'd2; 
	i_icb_cmd_read = 'd0; 
	i_icb_cmd_wdata = 32'd14;

# 20 

	i_icb_cmd_valid = 1'b0;
	i_icb_cmd_addr = 5'd2; 
	i_icb_cmd_read = 'd0; 
	i_icb_cmd_wdata = 32'd14;


# 20 

	i_icb_cmd_valid = 1'b1;
	i_icb_cmd_addr = 5'd0; 
	i_icb_cmd_read = 'd1; 

# 20 

	i_icb_cmd_valid = 1'b1;
	i_icb_cmd_addr = 5'd3; 
	i_icb_cmd_read = 'd1; 

# 20 

	i_icb_cmd_valid = 1'b1;
	i_icb_cmd_addr = 5'd2; 
	i_icb_cmd_read = 'd1; 

end


endmodule

