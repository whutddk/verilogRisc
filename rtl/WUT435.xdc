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

