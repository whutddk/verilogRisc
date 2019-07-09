set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]

#####               create clock              #####



set_property -dict {PACKAGE_PIN N11 IOSTANDARD LVCMOS33} [get_ports CLK100MHZ]
create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} -add [get_ports CLK100MHZ]


set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets IOBUF_jtag_TCK/O]


#####            rst define           #####


set_property PACKAGE_PIN K12 [get_ports mcu_rst]



#####               MCU JTAG define           #####
set_property PACKAGE_PIN P1 [get_ports mcu_TDO]
set_property PACKAGE_PIN N3 [get_ports mcu_TCK]
set_property PACKAGE_PIN R1 [get_ports mcu_TDI]
set_property PACKAGE_PIN P3 [get_ports mcu_TMS]


#####                gpio define              #####
set_property PACKAGE_PIN M1 [get_ports {gpio[1]}]
set_property PACKAGE_PIN M2 [get_ports {gpio[0]}]



set_property IOSTANDARD LVCMOS33 [get_ports mcu_rst]

#####               MCU JTAG define           #####
set_property IOSTANDARD LVCMOS33 [get_ports mcu_TDO]
set_property IOSTANDARD LVCMOS33 [get_ports mcu_TCK]
set_property IOSTANDARD LVCMOS33 [get_ports mcu_TDI]
set_property IOSTANDARD LVCMOS33 [get_ports mcu_TMS]

#####                gpio define              #####
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[0]}]




#####         SPI Configurate Setting        #######
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
set_property CONFIG_MODE SPIx4 [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 50 [current_design]





set_property PACKAGE_PIN C1 [get_ports {SRAM_ADDR_io[19]}]
set_property PACKAGE_PIN C2 [get_ports {SRAM_ADDR_io[18]}]
set_property PACKAGE_PIN E2 [get_ports {SRAM_ADDR_io[17]}]
set_property PACKAGE_PIN H5 [get_ports {SRAM_ADDR_io[16]}]
set_property PACKAGE_PIN F4 [get_ports {SRAM_ADDR_io[15]}]
set_property PACKAGE_PIN G5 [get_ports {SRAM_ADDR_io[14]}]
set_property PACKAGE_PIN A2 [get_ports {SRAM_ADDR_io[13]}]
set_property PACKAGE_PIN B1 [get_ports {SRAM_ADDR_io[12]}]
set_property PACKAGE_PIN B4 [get_ports {SRAM_ADDR_io[11]}]
set_property PACKAGE_PIN A3 [get_ports {SRAM_ADDR_io[10]}]
set_property PACKAGE_PIN B2 [get_ports {SRAM_ADDR_io[9]}]
set_property PACKAGE_PIN C3 [get_ports {SRAM_ADDR_io[8]}]
set_property PACKAGE_PIN L3 [get_ports {SRAM_ADDR_io[7]}]
set_property PACKAGE_PIN J5 [get_ports {SRAM_ADDR_io[6]}]
set_property PACKAGE_PIN H4 [get_ports {SRAM_ADDR_io[5]}]
set_property PACKAGE_PIN H2 [get_ports {SRAM_ADDR_io[4]}]
set_property PACKAGE_PIN H3 [get_ports {SRAM_ADDR_io[3]}]
set_property PACKAGE_PIN J4 [get_ports {SRAM_ADDR_io[2]}]
set_property PACKAGE_PIN J1 [get_ports {SRAM_ADDR_io[1]}]
set_property PACKAGE_PIN H1 [get_ports {SRAM_ADDR_io[0]}]
set_property PACKAGE_PIN D1 [get_ports {SRAM_DATA[15]}]
set_property PACKAGE_PIN E3 [get_ports {SRAM_DATA[14]}]
set_property PACKAGE_PIN D3 [get_ports {SRAM_DATA[13]}]
set_property PACKAGE_PIN E1 [get_ports {SRAM_DATA[12]}]
set_property PACKAGE_PIN F2 [get_ports {SRAM_DATA[11]}]
set_property PACKAGE_PIN G2 [get_ports {SRAM_DATA[10]}]
set_property PACKAGE_PIN F3 [get_ports {SRAM_DATA[9]}]
set_property PACKAGE_PIN G1 [get_ports {SRAM_DATA[8]}]
set_property PACKAGE_PIN A4 [get_ports {SRAM_DATA[7]}]
set_property PACKAGE_PIN E6 [get_ports {SRAM_DATA[6]}]
set_property PACKAGE_PIN D4 [get_ports {SRAM_DATA[5]}]
set_property PACKAGE_PIN A5 [get_ports {SRAM_DATA[4]}]
set_property PACKAGE_PIN L2 [get_ports {SRAM_DATA[3]}]
set_property PACKAGE_PIN K3 [get_ports {SRAM_DATA[2]}]
set_property PACKAGE_PIN K2 [get_ports {SRAM_DATA[1]}]
set_property PACKAGE_PIN K1 [get_ports {SRAM_DATA[0]}]
set_property PACKAGE_PIN J3 [get_ports SRAM_CSn_io]
set_property PACKAGE_PIN G4 [get_ports SRAM_OEn_io]
set_property PACKAGE_PIN C4 [get_ports SRAM_WRn_io]

set_property IOSTANDARD LVCMOS33 [get_ports {SRAM_ADDR_io[19]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SRAM_ADDR_io[18]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SRAM_ADDR_io[17]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SRAM_ADDR_io[16]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SRAM_ADDR_io[15]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SRAM_ADDR_io[14]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SRAM_ADDR_io[13]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SRAM_ADDR_io[12]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SRAM_ADDR_io[11]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SRAM_ADDR_io[10]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SRAM_ADDR_io[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SRAM_ADDR_io[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SRAM_ADDR_io[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SRAM_ADDR_io[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SRAM_ADDR_io[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SRAM_ADDR_io[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SRAM_ADDR_io[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SRAM_ADDR_io[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SRAM_ADDR_io[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SRAM_ADDR_io[0]}]

set_property IOSTANDARD LVCMOS33 [get_ports {SRAM_DATA[15]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SRAM_DATA[14]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SRAM_DATA[13]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SRAM_DATA[12]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SRAM_DATA[11]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SRAM_DATA[10]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SRAM_DATA[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SRAM_DATA[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SRAM_DATA[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SRAM_DATA[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SRAM_DATA[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SRAM_DATA[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SRAM_DATA[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SRAM_DATA[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SRAM_DATA[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SRAM_DATA[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports SRAM_CSn_io]
set_property IOSTANDARD LVCMOS33 [get_ports SRAM_OEn_io]
set_property IOSTANDARD LVCMOS33 [get_ports SRAM_WRn_io]




create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 4 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER true [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 4096 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL true [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 2 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list ip_mmcm/inst/clk_out2]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 20 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {SRAM_ADDR_io_OBUF[0]} {SRAM_ADDR_io_OBUF[1]} {SRAM_ADDR_io_OBUF[2]} {SRAM_ADDR_io_OBUF[3]} {SRAM_ADDR_io_OBUF[4]} {SRAM_ADDR_io_OBUF[5]} {SRAM_ADDR_io_OBUF[6]} {SRAM_ADDR_io_OBUF[7]} {SRAM_ADDR_io_OBUF[8]} {SRAM_ADDR_io_OBUF[9]} {SRAM_ADDR_io_OBUF[10]} {SRAM_ADDR_io_OBUF[11]} {SRAM_ADDR_io_OBUF[12]} {SRAM_ADDR_io_OBUF[13]} {SRAM_ADDR_io_OBUF[14]} {SRAM_ADDR_io_OBUF[15]} {SRAM_ADDR_io_OBUF[16]} {SRAM_ADDR_io_OBUF[17]} {SRAM_ADDR_io_OBUF[18]} {SRAM_ADDR_io_OBUF[19]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 16 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {SRAM_DATA_OUT_io[0]} {SRAM_DATA_OUT_io[1]} {SRAM_DATA_OUT_io[2]} {SRAM_DATA_OUT_io[3]} {SRAM_DATA_OUT_io[4]} {SRAM_DATA_OUT_io[5]} {SRAM_DATA_OUT_io[6]} {SRAM_DATA_OUT_io[7]} {SRAM_DATA_OUT_io[8]} {SRAM_DATA_OUT_io[9]} {SRAM_DATA_OUT_io[10]} {SRAM_DATA_OUT_io[11]} {SRAM_DATA_OUT_io[12]} {SRAM_DATA_OUT_io[13]} {SRAM_DATA_OUT_io[14]} {SRAM_DATA_OUT_io[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 16 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {SRAM_DATA_IN_io[0]} {SRAM_DATA_IN_io[1]} {SRAM_DATA_IN_io[2]} {SRAM_DATA_IN_io[3]} {SRAM_DATA_IN_io[4]} {SRAM_DATA_IN_io[5]} {SRAM_DATA_IN_io[6]} {SRAM_DATA_IN_io[7]} {SRAM_DATA_IN_io[8]} {SRAM_DATA_IN_io[9]} {SRAM_DATA_IN_io[10]} {SRAM_DATA_IN_io[11]} {SRAM_DATA_IN_io[12]} {SRAM_DATA_IN_io[13]} {SRAM_DATA_IN_io[14]} {SRAM_DATA_IN_io[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 1 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list SRAM_CSn_io_OBUF]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 1 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list SRAM_OEn_io_OBUF]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 1 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list SRAM_WRn_io_OBUF]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk_16M]
