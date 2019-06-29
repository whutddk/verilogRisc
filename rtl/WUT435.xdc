set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]

#####               create clock              #####



set_property -dict { PACKAGE_PIN N11    IOSTANDARD LVCMOS33 } [get_ports { CLK100MHZ }]; 
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports {CLK100MHZ}];


set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets dut_io_pads_jtag_TCK_i_ival]
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



set_property IOSTANDARD LVCMOS33 [get_ports mcu_rst   ]

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




