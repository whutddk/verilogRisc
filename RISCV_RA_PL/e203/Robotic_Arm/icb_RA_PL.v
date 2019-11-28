



module PRM_RA_PL (

	output [5:0] powerENA,
	output [5:0] thrusterDirectA,
	output [5:0] powerENB,
	output [5:0] thrusterDirectB,

	input [3:0] petectIO,
	output [5:0]  safetyPluseA,
	output [5:0]  safetyPluseB,

    output redLed,
    output greenLed,

    output BZ,
    input CLK100MHZ,





	input			i_icb_cmd_valid,
	output			i_icb_cmd_ready,
	input [31:0]	i_icb_cmd_addr, 
	input			i_icb_cmd_read, 
	input [31:0]	i_icb_cmd_wdata,
	
	output			i_icb_rsp_valid,
	input			i_icb_rsp_ready,
	output [31:0]	i_icb_rsp_rdata,

	input	clk,
	input	rst_n
);




wire [383:0] stepperPosition;

wire [383:0] stepCnt;
wire currentLoopPowerOnA;
wire currentLoopEnableA;

wire currentLoopPowerOnB;
wire currentLoopEnableB;

wire stepperRST;

















reg [31:0] icb_reg0;
reg [31:0] icb_reg1;
reg [31:0] icb_reg2;
reg [31:0] icb_reg3;
reg [31:0] icb_reg4;
reg [31:0] icb_reg5;
reg [31:0] icb_reg6;
reg [31:0] icb_reg7;
reg [31:0] icb_reg8;
reg [31:0] icb_reg9;
reg [31:0] icb_reg10;
reg [31:0] icb_reg11;
reg [31:0] icb_reg12;
reg [31:0] icb_reg13;
reg [31:0] icb_reg14;
reg [31:0] icb_reg15;
reg [31:0] icb_reg16;
reg [31:0] icb_reg17;
reg [31:0] icb_reg18;
reg [31:0] icb_reg19;
reg [31:0] icb_reg20;
reg [31:0] icb_reg21;
reg [31:0] icb_reg22;
reg [31:0] icb_reg23;
reg [31:0] icb_reg24;
reg [31:0] icb_reg25;
reg [31:0] icb_reg26;
reg [31:0] icb_reg27;
reg [31:0] icb_reg28;
reg [31:0] icb_reg29;
reg [31:0] icb_reg30;
reg [31:0] icb_reg31;



reg icb_rsp_valid_reg;

reg [31:0] icb_rsp_rdata_reg;

assign i_icb_cmd_ready = i_icb_cmd_valid;
assign i_icb_rsp_valid = ( (~i_icb_cmd_read) & i_icb_cmd_valid ) 
						| icb_rsp_valid_reg;
assign i_icb_rsp_rdata = icb_rsp_rdata_reg;

wire [4:0] reg_mux = i_icb_cmd_addr[6:2];




//写状态，本拍给结果，下一拍录?
//读状态，下拍给结?
always @ ( posedge clk or negedge rst_n ) begin
	if ( !rst_n ) begin
		#1 icb_reg0 <= 'd0;
		#1 icb_reg1 <= 'd0;
		#1 icb_reg2 <= 'd0;
		#1 icb_reg3 <= 'd0;
		#1 icb_reg4 <= 'd0;
		#1 icb_reg5 <= 'd0;
		#1 icb_reg6 <= 'd0;
		#1 icb_reg7 <= 'd0;
		#1 icb_reg8 <= 'd0;
		#1 icb_reg9 <= 'd0;
		#1 icb_reg10 <= 'd0;
		#1 icb_reg11 <= 'd0;
		#1 icb_reg12 <= 'd0;
		#1 icb_reg13 <= 'd0;
		#1 icb_reg14 <= 'd0;
		#1 icb_reg15 <= 'd0;
		#1 icb_reg16 <= 'd0;
		#1 icb_reg17 <= 'd0;
		#1 icb_reg18 <= 'd0;
		#1 icb_reg19 <= 'd0;
		#1 icb_reg20 <= 'd0;
		#1 icb_reg21 <= 'd0;
		#1 icb_reg22 <= 'd0;
		#1 icb_reg23 <= 'd0;
		#1 icb_reg24 <= 'd0;
		#1 icb_reg25 <= 'd0;
		#1 icb_reg26 <= 'd0;
		#1 icb_reg27 <= 'd0;
		#1 icb_reg28 <= 'd0;
		#1 icb_reg29 <= 'd0;
		#1 icb_reg30 <= 'd0;
		#1 icb_reg31 <= 'd0;


		#1 icb_rsp_valid_reg <= 1'b0;
		#1 icb_rsp_rdata_reg <= 'd0;
	end
	else begin
		if ( ~i_icb_cmd_read & i_icb_cmd_valid ) begin //?
			case(reg_mux)
				5'd0: begin   #1 icb_reg0 <= i_icb_cmd_wdata;end
				5'd1: begin   #1 icb_reg1 <= i_icb_cmd_wdata;end
				5'd2: begin   #1 icb_reg2 <= i_icb_cmd_wdata;end
				5'd3: begin   #1 icb_reg3 <= i_icb_cmd_wdata;end
				5'd4: begin   #1 icb_reg4 <= i_icb_cmd_wdata;end
				5'd5: begin   #1 icb_reg5 <= i_icb_cmd_wdata;end
				5'd6: begin   #1 icb_reg6 <= i_icb_cmd_wdata;end
				5'd7: begin   #1 icb_reg7 <= i_icb_cmd_wdata;end
				5'd8: begin   #1 icb_reg8 <= i_icb_cmd_wdata;end
				5'd9: begin   #1 icb_reg9 <= i_icb_cmd_wdata;end
				5'd10:begin  #1  icb_reg10 <= i_icb_cmd_wdata;end
				5'd11:begin  #1  icb_reg11 <= i_icb_cmd_wdata;end
				5'd12:begin  #1  icb_reg12 <= i_icb_cmd_wdata;end
				5'd13:begin  #1  icb_reg13 <= i_icb_cmd_wdata;end
				5'd14:begin  #1  icb_reg14 <= i_icb_cmd_wdata;end
				5'd15:begin  #1  icb_reg15 <= i_icb_cmd_wdata;end
				5'd16:begin  #1  icb_reg16 <= i_icb_cmd_wdata;end
				5'd17:begin  #1  icb_reg17 <= i_icb_cmd_wdata;end
				5'd18:begin  #1  icb_reg18 <= i_icb_cmd_wdata;end
				5'd19:begin  #1  icb_reg19 <= i_icb_cmd_wdata;end
				5'd20:begin  #1  icb_reg20 <= i_icb_cmd_wdata;end
				5'd21:begin  #1  icb_reg21 <= i_icb_cmd_wdata;end
				5'd22:begin  #1  icb_reg22 <= i_icb_cmd_wdata;end
				5'd23:begin  #1  icb_reg23 <= i_icb_cmd_wdata;end
				5'd24:begin  #1  icb_reg24 <= i_icb_cmd_wdata;end
				5'd25:begin  #1  icb_reg25 <= i_icb_cmd_wdata;end
				5'd26:begin  #1  icb_reg26 <= i_icb_cmd_wdata;end
				5'd27:begin  #1  icb_reg27 <= i_icb_cmd_wdata;end
				5'd28:begin  #1  icb_reg28 <= i_icb_cmd_wdata;end
				5'd29:begin  #1  icb_reg29 <= i_icb_cmd_wdata;end
				5'd30:begin  #1  icb_reg30 <= i_icb_cmd_wdata;end
				5'd31:begin  #1  icb_reg31 <= i_icb_cmd_wdata;end
				default: begin end 





			endcase // reg_mux

			#1 icb_rsp_valid_reg <= 1'b0;
			#1 icb_rsp_rdata_reg <= 'd0;
		end

		else if ( i_icb_cmd_read & i_icb_cmd_valid ) begin //?
			#1 icb_rsp_valid_reg <= 1'b1;

			case(reg_mux)
				5'd0:  begin  #1 icb_rsp_rdata_reg <= icb_reg0;end
				5'd1:  begin  #1 icb_rsp_rdata_reg <= icb_reg1;end
				5'd2:  begin  #1 icb_rsp_rdata_reg <= icb_reg2;end
				5'd3:  begin  #1 icb_rsp_rdata_reg <= icb_reg3;end
				5'd4:  begin  #1 icb_rsp_rdata_reg <= icb_reg4;end
				5'd5:  begin  #1 icb_rsp_rdata_reg <= icb_reg5;end
				5'd6:  begin  #1 icb_rsp_rdata_reg <= icb_reg6;end
				5'd7:  begin  #1 icb_rsp_rdata_reg <= icb_reg7;end
				5'd8:  begin  #1 icb_rsp_rdata_reg <= icb_reg8;end
				5'd9:  begin  #1 icb_rsp_rdata_reg <= icb_reg9;end
				5'd10: begin #1  icb_rsp_rdata_reg <= icb_reg10;end
				5'd11: begin #1  icb_rsp_rdata_reg <= icb_reg11;end
				5'd12: begin #1  icb_rsp_rdata_reg <= stepperPosition[31:0]; end
				5'd13: begin #1  icb_rsp_rdata_reg <= stepperPosition[63:32]; end
				5'd14: begin #1  icb_rsp_rdata_reg <= stepperPosition[95:64]; end
				5'd15: begin #1  icb_rsp_rdata_reg <= stepperPosition[127:96]; end
				5'd16: begin #1  icb_rsp_rdata_reg <= stepperPosition[159:128]; end
				5'd17: begin #1  icb_rsp_rdata_reg <= stepperPosition[191:160]; end
				5'd18: begin #1  icb_rsp_rdata_reg <= stepperPosition[223:192]; end
				5'd19: begin #1  icb_rsp_rdata_reg <= stepperPosition[255:224]; end
				5'd20: begin #1  icb_rsp_rdata_reg <= stepperPosition[287:256]; end
				5'd21: begin #1  icb_rsp_rdata_reg <= stepperPosition[319:288]; end
				5'd22: begin #1  icb_rsp_rdata_reg <= stepperPosition[351:320]; end
				5'd23: begin #1  icb_rsp_rdata_reg <= stepperPosition[383:352]; end
				5'd24: begin #1  icb_rsp_rdata_reg <= icb_reg24;end
				5'd25: begin #1  icb_rsp_rdata_reg <= icb_reg25;end
				5'd26: begin #1  icb_rsp_rdata_reg <= icb_reg26;end
				5'd27: begin #1  icb_rsp_rdata_reg <= icb_reg27;end
				5'd28: begin #1  icb_rsp_rdata_reg <= icb_reg28;end
				5'd29: begin #1  icb_rsp_rdata_reg <= icb_reg29;end
				5'd30: begin #1  icb_rsp_rdata_reg <= icb_reg30;end
				5'd31: begin #1  icb_rsp_rdata_reg <= icb_reg31;end
			default: #1 icb_rsp_rdata_reg <= 'd66;



			endcase // reg_mux


		end

		else if ( i_icb_rsp_ready == 1'b1 ) begin
			#1 icb_rsp_valid_reg <= 1'b0;
			#1 icb_rsp_rdata_reg <= 'd0;
		end

		else begin


		end



	end


end




assign stepCnt = {icb_reg11,icb_reg10,icb_reg9,icb_reg8,icb_reg7,icb_reg6,icb_reg5,icb_reg4,icb_reg3,icb_reg2,icb_reg1,icb_reg0};

assign currentLoopPowerOnA = icb_reg25[0];
assign currentLoopEnableA = icb_reg24[0];

assign currentLoopPowerOnB = icb_reg27[0];
assign currentLoopEnableB = icb_reg26[0];

assign stepperRST = icb_reg28[0];







wire [ 5 : 0 ] thrusterPluseA;
wire [ 5 : 0 ] thrusterPluseB;




stepper_package i_stepper_package0 
(
	.CLK(CLK100MHZ),
	.RST_n(stepperRST),
	
	.stepCnt(stepCnt[191:0]), //step n step ,int16_t
	.currentLoopPowerOn(currentLoopPowerOnA),
	.currentLoopEnable(currentLoopEnableA),

	.stepperPosition(stepperPosition[191:0]),

	.powerEN(powerENA),
	.thrusterPluse(thrusterPluseA),
	.thrusterDirect(thrusterDirectA)
);




stepper_package i_stepper_package1
(
	.CLK(CLK100MHZ),
	.RST_n(stepperRST),
	
	.stepCnt(stepCnt[383:192]), //step n step ,int16_t
	.currentLoopPowerOn(currentLoopPowerOnB),
	.currentLoopEnable(currentLoopEnableB),

	.stepperPosition(stepperPosition[383:192]),

	.powerEN(powerENB),
	.thrusterPluse(thrusterPluseB),
	.thrusterDirect(thrusterDirectB)
);






teleStop i_teleStop
(
	.CLK(CLK100MHZ),
	.RST_n(stepperRST),

	.petectIO(petectIO),

	.thrusterPluseA(thrusterPluseA),
	.safetyPluseA(safetyPluseA),
   
	.thrusterPluseB(thrusterPluseB),
	.safetyPluseB(safetyPluseB),

    .redLed(redLed),
    .greenLed(greenLed),
    .BZ(BZ)
);










endmodule






