set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]

#####               create clock              #####



set_property -dict { PACKAGE_PIN W19    IOSTANDARD LVCMOS33 } [get_ports { CLK100MHZ }]; 
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports {CLK100MHZ}];

set_property -dict { PACKAGE_PIN Y18    IOSTANDARD LVCMOS33 } [get_ports { CLK32768KHZ }]; 
create_clock -add -name sys_clk_pin -period 30517.58 -waveform {0 15258.79} [get_ports {CLK32768KHZ}];


set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets dut_io_pads_jtag_TCK_i_ival]
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets IOBUF_jtag_TCK/O]


#####            rst define           #####

set_property PACKAGE_PIN T6  [get_ports fpga_rst  ]
set_property PACKAGE_PIN P20 [get_ports mcu_rst   ]

#####                spi define               #####
set_property PACKAGE_PIN W16 [get_ports  qspi_cs    ]
set_property PACKAGE_PIN W15 [get_ports  qspi_sck   ]
set_property PACKAGE_PIN U16 [get_ports {qspi_dq[3]}]
set_property PACKAGE_PIN T16 [get_ports {qspi_dq[2]}]
set_property PACKAGE_PIN T14 [get_ports {qspi_dq[1]}]
set_property PACKAGE_PIN T15 [get_ports {qspi_dq[0]}]

#####               MCU JTAG define           #####
set_property PACKAGE_PIN N17 [get_ports mcu_TDO]
set_property PACKAGE_PIN P15 [get_ports mcu_TCK]
set_property PACKAGE_PIN T18 [get_ports mcu_TDI]
set_property PACKAGE_PIN P17 [get_ports mcu_TMS]

#####                PMU define               #####
set_property PACKAGE_PIN U15 [get_ports pmu_paden ]
set_property PACKAGE_PIN V15 [get_ports pmu_padrst]
set_property PACKAGE_PIN N15 [get_ports mcu_wakeup]

#####                gpio define              #####
set_property PACKAGE_PIN W17  [get_ports {gpio[31]}]
set_property PACKAGE_PIN AA18 [get_ports {gpio[30]}]
set_property PACKAGE_PIN AB18 [get_ports {gpio[29]}]
set_property PACKAGE_PIN U17  [get_ports {gpio[28]}]
set_property PACKAGE_PIN U18  [get_ports {gpio[27]}]
set_property PACKAGE_PIN P14  [get_ports {gpio[26]}]
set_property PACKAGE_PIN R14  [get_ports {gpio[25]}]
set_property PACKAGE_PIN R18  [get_ports {gpio[24]}]
set_property PACKAGE_PIN V20  [get_ports {gpio[23]}]
set_property PACKAGE_PIN W20  [get_ports {gpio[22]}]
set_property PACKAGE_PIN Y19  [get_ports {gpio[21]}]
set_property PACKAGE_PIN V18  [get_ports {gpio[20]}]
set_property PACKAGE_PIN V19  [get_ports {gpio[19]}]
set_property PACKAGE_PIN AA19 [get_ports {gpio[18]}]
set_property PACKAGE_PIN R17  [get_ports {gpio[17]}]  
set_property PACKAGE_PIN P16  [get_ports {gpio[16]}]  
set_property PACKAGE_PIN V22  [get_ports {gpio[15]}]
set_property PACKAGE_PIN T21  [get_ports {gpio[14]}]
set_property PACKAGE_PIN U21  [get_ports {gpio[13]}]
set_property PACKAGE_PIN P19  [get_ports {gpio[12]}]
set_property PACKAGE_PIN R19  [get_ports {gpio[11]}]
set_property PACKAGE_PIN N13  [get_ports {gpio[10]}]
set_property PACKAGE_PIN T20  [get_ports {gpio[9]}]
set_property PACKAGE_PIN W21  [get_ports {gpio[8]}]
set_property PACKAGE_PIN U20  [get_ports {gpio[7]}]
set_property PACKAGE_PIN AB22 [get_ports {gpio[6]}]
set_property PACKAGE_PIN AB21 [get_ports {gpio[5]}]
set_property PACKAGE_PIN Y22  [get_ports {gpio[4]}]
set_property PACKAGE_PIN Y21  [get_ports {gpio[3]}]
set_property PACKAGE_PIN AA21 [get_ports {gpio[2]}]
set_property PACKAGE_PIN AA20 [get_ports {gpio[1]}]
set_property PACKAGE_PIN W22  [get_ports {gpio[0]}]



#####            clock & rst define           #####

set_property IOSTANDARD LVCMOS15 [get_ports fpga_rst  ]
set_property IOSTANDARD LVCMOS33 [get_ports mcu_rst   ]


#####                spi define               #####
set_property IOSTANDARD LVCMOS33 [get_ports  qspi_cs    ]
set_property IOSTANDARD LVCMOS33 [get_ports  qspi_sck   ]
set_property IOSTANDARD LVCMOS33 [get_ports {qspi_dq[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {qspi_dq[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {qspi_dq[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {qspi_dq[0]}]


#####               MCU JTAG define           #####
set_property IOSTANDARD LVCMOS33 [get_ports mcu_TDO]
set_property IOSTANDARD LVCMOS33 [get_ports mcu_TCK]
set_property IOSTANDARD LVCMOS33 [get_ports mcu_TDI]
set_property IOSTANDARD LVCMOS33 [get_ports mcu_TMS]

#####                PMU define               #####
set_property IOSTANDARD LVCMOS33 [get_ports pmu_paden ]
set_property IOSTANDARD LVCMOS33 [get_ports pmu_padrst]
set_property IOSTANDARD LVCMOS33 [get_ports mcu_wakeup]

#####                gpio define              #####
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[31]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[30]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[29]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[28]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[27]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[26]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[25]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[24]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[23]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[22]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[21]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[20]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[19]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[18]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[17]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[16]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[15]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[14]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[13]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[12]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[11]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[10]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {gpio[0]}]





set_property -dict {PACKAGE_PIN J16 IOSTANDARD LVCMOS33} [get_ports {powerENA[0]}];
set_property -dict {PACKAGE_PIN H13 IOSTANDARD LVCMOS33} [get_ports {powerENA[1]}];
set_property -dict {PACKAGE_PIN G13 IOSTANDARD LVCMOS33} [get_ports {powerENA[2]}];
set_property -dict {PACKAGE_PIN G15 IOSTANDARD LVCMOS33} [get_ports {powerENA[3]}];
set_property -dict {PACKAGE_PIN G16 IOSTANDARD LVCMOS33} [get_ports {powerENA[4]}];
set_property -dict {PACKAGE_PIN J14 IOSTANDARD LVCMOS33} [get_ports {powerENA[5]}];

set_property -dict {PACKAGE_PIN H14 IOSTANDARD LVCMOS33} [get_ports {powerENB[0]}];
set_property -dict {PACKAGE_PIN G17 IOSTANDARD LVCMOS33} [get_ports {powerENB[1]}];
set_property -dict {PACKAGE_PIN G18 IOSTANDARD LVCMOS33} [get_ports {powerENB[2]}];
set_property -dict {PACKAGE_PIN J15 IOSTANDARD LVCMOS33} [get_ports {powerENB[3]}];
set_property -dict {PACKAGE_PIN H15 IOSTANDARD LVCMOS33} [get_ports {powerENB[4]}];
set_property -dict {PACKAGE_PIN H17 IOSTANDARD LVCMOS33} [get_ports {powerENB[5]}];

set_property -dict {PACKAGE_PIN H18 IOSTANDARD LVCMOS33} [get_ports {thrusterDirectA[0]}];
set_property -dict {PACKAGE_PIN J22 IOSTANDARD LVCMOS33} [get_ports {thrusterDirectA[1]}];
set_property -dict {PACKAGE_PIN H22 IOSTANDARD LVCMOS33} [get_ports {thrusterDirectA[2]}];
set_property -dict {PACKAGE_PIN H20 IOSTANDARD LVCMOS33} [get_ports {thrusterDirectA[3]}];
set_property -dict {PACKAGE_PIN G20 IOSTANDARD LVCMOS33} [get_ports {thrusterDirectA[4]}];
set_property -dict {PACKAGE_PIN K21 IOSTANDARD LVCMOS33} [get_ports {thrusterDirectA[5]}];

set_property -dict {PACKAGE_PIN K22 IOSTANDARD LVCMOS33} [get_ports {thrusterDirectB[0]}];
set_property -dict {PACKAGE_PIN M21 IOSTANDARD LVCMOS33} [get_ports {thrusterDirectB[1]}];
set_property -dict {PACKAGE_PIN L21 IOSTANDARD LVCMOS33} [get_ports {thrusterDirectB[2]}];
set_property -dict {PACKAGE_PIN J20 IOSTANDARD LVCMOS33} [get_ports {thrusterDirectB[3]}];
set_property -dict {PACKAGE_PIN J21 IOSTANDARD LVCMOS33} [get_ports {thrusterDirectB[4]}];
set_property -dict {PACKAGE_PIN J19 IOSTANDARD LVCMOS33} [get_ports {thrusterDirectB[5]}];

set_property -dict {PACKAGE_PIN H19 IOSTANDARD LVCMOS33} [get_ports {petectIO[0]}];
set_property -dict {PACKAGE_PIN K18 IOSTANDARD LVCMOS33} [get_ports {petectIO[1]}];
set_property -dict {PACKAGE_PIN K19 IOSTANDARD LVCMOS33} [get_ports {petectIO[2]}];
set_property -dict {PACKAGE_PIN L19 IOSTANDARD LVCMOS33} [get_ports {petectIO[3]}];


set_property -dict {PACKAGE_PIN L20 IOSTANDARD LVCMOS33} [get_ports {safetyPluseA[0]}];
set_property -dict {PACKAGE_PIN N22 IOSTANDARD LVCMOS33} [get_ports {safetyPluseA[1]}];
set_property -dict {PACKAGE_PIN M22 IOSTANDARD LVCMOS33} [get_ports {safetyPluseA[2]}];
set_property -dict {PACKAGE_PIN M18 IOSTANDARD LVCMOS33} [get_ports {safetyPluseA[3]}];
set_property -dict {PACKAGE_PIN L18 IOSTANDARD LVCMOS33} [get_ports {safetyPluseA[4]}];
set_property -dict {PACKAGE_PIN N18 IOSTANDARD LVCMOS33} [get_ports {safetyPluseA[5]}];

set_property -dict {PACKAGE_PIN N19 IOSTANDARD LVCMOS33} [get_ports {safetyPluseB[0]}];
set_property -dict {PACKAGE_PIN N20 IOSTANDARD LVCMOS33} [get_ports {safetyPluseB[1]}];
set_property -dict {PACKAGE_PIN M20 IOSTANDARD LVCMOS33} [get_ports {safetyPluseB[2]}];
set_property -dict {PACKAGE_PIN K13 IOSTANDARD LVCMOS33} [get_ports {safetyPluseB[3]}];
set_property -dict {PACKAGE_PIN K14 IOSTANDARD LVCMOS33} [get_ports {safetyPluseB[4]}];
set_property -dict {PACKAGE_PIN M13 IOSTANDARD LVCMOS33} [get_ports {safetyPluseB[5]}];

set_property -dict {PACKAGE_PIN L13 IOSTANDARD LVCMOS33} [get_ports {redLed}];
set_property -dict {PACKAGE_PIN K17 IOSTANDARD LVCMOS33} [get_ports {greenLed}];
set_property -dict {PACKAGE_PIN J17 IOSTANDARD LVCMOS33} [get_ports {BZ}];



















#####         SPI Configurate Setting        #######
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design] 
set_property CONFIG_MODE SPIx4 [current_design] 
set_property BITSTREAM.CONFIG.CONFIGRATE 50 [current_design]




