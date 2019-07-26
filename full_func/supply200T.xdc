## This file is a general .xdc for supperYJ200T

## To use it in a project:

## - uncomment the lines corresponding to used pins

## - rename the used ports (in each line, after get_ports) according to the top level signal names in the project



# Clock signal 50 MHz

set_property -dict {PACKAGE_PIN W11 IOSTANDARD LVCMOS33} [get_ports i_sysclk];
create_clock -period 20.000 -name sys_clk_pin -waveform {0.000 10.000} -add [get_ports i_sysclk];

# Real-time Clock signal 32.768 kHz

set_property -dict {PACKAGE_PIN K4 IOSTANDARD LVCMOS33} [get_ports i_rtcclk];
create_clock -period 30517.578 -name rtc_clk_pin -waveform {0.000 15258.789} -add [get_ports i_rtcclk];

# MCU JTAG TCK Clock signal 10Mhz
set_property -dict {PACKAGE_PIN W22 IOSTANDARD LVCMOS33} [get_ports MCU_TCK];
create_clock -period 100.000 -name TCK_clk_pin -waveform {0.000 50.000} -add [get_ports MCU_TCK];
set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets IOBUF_jtag_TCK/O]


# asynchronous

set_clock_groups -name async_sys_rtc_jtag -asynchronous -group sys_clk_pin -group rtc_clk_pin -group TCK_clk_pin

# SRAM0
# set_property -dict {PACKAGE_PIN H22 IOSTANDARD LVCMOS33} [get_ports {SRAM0_A[0]}];
# set_property -dict {PACKAGE_PIN H19 IOSTANDARD LVCMOS33} [get_ports {SRAM0_A[1]}];
# set_property -dict {PACKAGE_PIN G20 IOSTANDARD LVCMOS33} [get_ports {SRAM0_A[2]}];
# set_property -dict {PACKAGE_PIN J19 IOSTANDARD LVCMOS33} [get_ports {SRAM0_A[3]}];
# set_property -dict {PACKAGE_PIN H20 IOSTANDARD LVCMOS33} [get_ports {SRAM0_A[4]}];
# set_property -dict {PACKAGE_PIN H13 IOSTANDARD LVCMOS33} [get_ports {SRAM0_A[5]}];
# set_property -dict {PACKAGE_PIN H15 IOSTANDARD LVCMOS33} [get_ports {SRAM0_A[6]}];
# set_property -dict {PACKAGE_PIN J14 IOSTANDARD LVCMOS33} [get_ports {SRAM0_A[7]}];
# set_property -dict {PACKAGE_PIN L20 IOSTANDARD LVCMOS33} [get_ports {SRAM0_A[8]}];
# set_property -dict {PACKAGE_PIN M20 IOSTANDARD LVCMOS33} [get_ports {SRAM0_A[9]}];
# set_property -dict {PACKAGE_PIN M21 IOSTANDARD LVCMOS33} [get_ports {SRAM0_A[10]}];
# set_property -dict {PACKAGE_PIN N22 IOSTANDARD LVCMOS33} [get_ports {SRAM0_A[11]}];
# set_property -dict {PACKAGE_PIN L21 IOSTANDARD LVCMOS33} [get_ports {SRAM0_A[12]}];
# set_property -dict {PACKAGE_PIN M22 IOSTANDARD LVCMOS33} [get_ports {SRAM0_A[13]}];
# set_property -dict {PACKAGE_PIN L14 IOSTANDARD LVCMOS33} [get_ports {SRAM0_A[14]}];
# set_property -dict {PACKAGE_PIN M13 IOSTANDARD LVCMOS33} [get_ports {SRAM0_A[15]}];
# set_property -dict {PACKAGE_PIN L15 IOSTANDARD LVCMOS33} [get_ports {SRAM0_A[16]}];
# set_property -dict {PACKAGE_PIN J16 IOSTANDARD LVCMOS33} [get_ports {SRAM0_A[17]}];
# set_property -dict {PACKAGE_PIN L19 IOSTANDARD LVCMOS33} [get_ports {SRAM0_A[18]}];
# set_property -dict {PACKAGE_PIN K22 IOSTANDARD LVCMOS33} [get_ports {SRAM0_A[19]}];
# set_property -dict {PACKAGE_PIN N18 IOSTANDARD LVCMOS33} [get_ports {SRAM0_A[20]}];
# set_property -dict {PACKAGE_PIN L13 IOSTANDARD LVCMOS33} [get_ports {SRAM0_A[21]}];
# 
# set_property -dict {PACKAGE_PIN G16 IOSTANDARD LVCMOS33} [get_ports {SRAM0_DQ[0]}];
# set_property -dict {PACKAGE_PIN G18 IOSTANDARD LVCMOS33} [get_ports {SRAM0_DQ[1]}];
# set_property -dict {PACKAGE_PIN G15 IOSTANDARD LVCMOS33} [get_ports {SRAM0_DQ[2]}];
# set_property -dict {PACKAGE_PIN H14 IOSTANDARD LVCMOS33} [get_ports {SRAM0_DQ[3]}];
# set_property -dict {PACKAGE_PIN M17 IOSTANDARD LVCMOS33} [get_ports {SRAM0_DQ[4]}];
# set_property -dict {PACKAGE_PIN M18 IOSTANDARD LVCMOS33} [get_ports {SRAM0_DQ[5]}];
# set_property -dict {PACKAGE_PIN M16 IOSTANDARD LVCMOS33} [get_ports {SRAM0_DQ[6]}];
# set_property -dict {PACKAGE_PIN N19 IOSTANDARD LVCMOS33} [get_ports {SRAM0_DQ[7]}];
# set_property -dict {PACKAGE_PIN J17 IOSTANDARD LVCMOS33} [get_ports {SRAM0_DQ[8]}];
# set_property -dict {PACKAGE_PIN K18 IOSTANDARD LVCMOS33} [get_ports {SRAM0_DQ[9]}];
# set_property -dict {PACKAGE_PIN K17 IOSTANDARD LVCMOS33} [get_ports {SRAM0_DQ[10]}];
# set_property -dict {PACKAGE_PIN K19 IOSTANDARD LVCMOS33} [get_ports {SRAM0_DQ[11]}];
# set_property -dict {PACKAGE_PIN K16 IOSTANDARD LVCMOS33} [get_ports {SRAM0_DQ[12]}];
# set_property -dict {PACKAGE_PIN K13 IOSTANDARD LVCMOS33} [get_ports {SRAM0_DQ[13]}];
# set_property -dict {PACKAGE_PIN K14 IOSTANDARD LVCMOS33} [get_ports {SRAM0_DQ[14]}];
# set_property -dict {PACKAGE_PIN K21 IOSTANDARD LVCMOS33} [get_ports {SRAM0_DQ[15]}];
# 
# set_property -dict {PACKAGE_PIN G17 IOSTANDARD LVCMOS33} [get_ports {SRAM0_CEn}];
# set_property -dict {PACKAGE_PIN J20 IOSTANDARD LVCMOS33} [get_ports {SRAM0_OEn}];
# set_property -dict {PACKAGE_PIN N20 IOSTANDARD LVCMOS33} [get_ports {SRAM0_WEn}];
# 
# set_property -dict {PACKAGE_PIN J21 IOSTANDARD LVCMOS33} [get_ports {SRAM0_UBn}];
# set_property -dict {PACKAGE_PIN J22 IOSTANDARD LVCMOS33} [get_ports {SRAM0_LBn}];



# SRAM1
# set_property -dict {PACKAGE_PIN C15 IOSTANDARD LVCMOS33} [get_ports {SRAM1_A[0]}];
# set_property -dict {PACKAGE_PIN C14 IOSTANDARD LVCMOS33} [get_ports {SRAM1_A[1]}];
# set_property -dict {PACKAGE_PIN A13 IOSTANDARD LVCMOS33} [get_ports {SRAM1_A[2]}];
# set_property -dict {PACKAGE_PIN B15 IOSTANDARD LVCMOS33} [get_ports {SRAM1_A[3]}];
# set_property -dict {PACKAGE_PIN A14 IOSTANDARD LVCMOS33} [get_ports {SRAM1_A[4]}];
# set_property -dict {PACKAGE_PIN E17 IOSTANDARD LVCMOS33} [get_ports {SRAM1_A[5]}];
# set_property -dict {PACKAGE_PIN F16 IOSTANDARD LVCMOS33} [get_ports {SRAM1_A[6]}];
# set_property -dict {PACKAGE_PIN D17 IOSTANDARD LVCMOS33} [get_ports {SRAM1_A[7]}];
# set_property -dict {PACKAGE_PIN C20 IOSTANDARD LVCMOS33} [get_ports {SRAM1_A[8]}];
# set_property -dict {PACKAGE_PIN D20 IOSTANDARD LVCMOS33} [get_ports {SRAM1_A[9]}];
# set_property -dict {PACKAGE_PIN D22 IOSTANDARD LVCMOS33} [get_ports {SRAM1_A[10]}];
# set_property -dict {PACKAGE_PIN E22 IOSTANDARD LVCMOS33} [get_ports {SRAM1_A[11]}];
# set_property -dict {PACKAGE_PIN C22 IOSTANDARD LVCMOS33} [get_ports {SRAM1_A[12]}];
# set_property -dict {PACKAGE_PIN D21 IOSTANDARD LVCMOS33} [get_ports {SRAM1_A[13]}];
# set_property -dict {PACKAGE_PIN A19 IOSTANDARD LVCMOS33} [get_ports {SRAM1_A[14]}];
# set_property -dict {PACKAGE_PIN A20 IOSTANDARD LVCMOS33} [get_ports {SRAM1_A[15]}];
# set_property -dict {PACKAGE_PIN C18 IOSTANDARD LVCMOS33} [get_ports {SRAM1_A[16]}];
# set_property -dict {PACKAGE_PIN A18 IOSTANDARD LVCMOS33} [get_ports {SRAM1_A[17]}];
# set_property -dict {PACKAGE_PIN C19 IOSTANDARD LVCMOS33} [get_ports {SRAM1_A[18]}];
# set_property -dict {PACKAGE_PIN B22 IOSTANDARD LVCMOS33} [get_ports {SRAM1_A[19]}];
# set_property -dict {PACKAGE_PIN F20 IOSTANDARD LVCMOS33} [get_ports {SRAM1_A[20]}];
# set_property -dict {PACKAGE_PIN B18 IOSTANDARD LVCMOS33} [get_ports {SRAM1_A[21]}];
# 
# set_property -dict {PACKAGE_PIN B13 IOSTANDARD LVCMOS33} [get_ports {SRAM1_DQ[0]}];
# set_property -dict {PACKAGE_PIN F13 IOSTANDARD LVCMOS33} [get_ports {SRAM1_DQ[1]}];
# set_property -dict {PACKAGE_PIN C13 IOSTANDARD LVCMOS33} [get_ports {SRAM1_DQ[2]}];
# set_property -dict {PACKAGE_PIN F15 IOSTANDARD LVCMOS33} [get_ports {SRAM1_DQ[3]}];
# set_property -dict {PACKAGE_PIN E13 IOSTANDARD LVCMOS33} [get_ports {SRAM1_DQ[4]}];
# set_property -dict {PACKAGE_PIN B20 IOSTANDARD LVCMOS33} [get_ports {SRAM1_DQ[5]}];
# set_property -dict {PACKAGE_PIN A21 IOSTANDARD LVCMOS33} [get_ports {SRAM1_DQ[6]}];
# set_property -dict {PACKAGE_PIN F19 IOSTANDARD LVCMOS33} [get_ports {SRAM1_DQ[7]}];
# set_property -dict {PACKAGE_PIN D15 IOSTANDARD LVCMOS33} [get_ports {SRAM1_DQ[8]}];
# set_property -dict {PACKAGE_PIN A16 IOSTANDARD LVCMOS33} [get_ports {SRAM1_DQ[9]}];
# set_property -dict {PACKAGE_PIN B16 IOSTANDARD LVCMOS33} [get_ports {SRAM1_DQ[10]}];
# set_property -dict {PACKAGE_PIN D16 IOSTANDARD LVCMOS33} [get_ports {SRAM1_DQ[11]}];
# set_property -dict {PACKAGE_PIN E16 IOSTANDARD LVCMOS33} [get_ports {SRAM1_DQ[12]}];
# set_property -dict {PACKAGE_PIN B17 IOSTANDARD LVCMOS33} [get_ports {SRAM1_DQ[13]}];
# set_property -dict {PACKAGE_PIN C17 IOSTANDARD LVCMOS33} [get_ports {SRAM1_DQ[14]}];
# set_property -dict {PACKAGE_PIN B21 IOSTANDARD LVCMOS33} [get_ports {SRAM1_DQ[15]}];
# 
# set_property -dict {PACKAGE_PIN D14 IOSTANDARD LVCMOS33} [get_ports {SRAM1_CEn}];
# set_property -dict {PACKAGE_PIN A15 IOSTANDARD LVCMOS33} [get_ports {SRAM1_OEn}];
# set_property -dict {PACKAGE_PIN E21 IOSTANDARD LVCMOS33} [get_ports {SRAM1_WEn}];
# 
# set_property -dict {PACKAGE_PIN E19 IOSTANDARD LVCMOS33} [get_ports {SRAM1_UBn}];
# set_property -dict {PACKAGE_PIN E18 IOSTANDARD LVCMOS33} [get_ports {SRAM1_LBn}];



# QSPI

set_property -dict {PACKAGE_PIN P22 IOSTANDARD LVCMOS33} [get_ports {QSPI_DQ[0]}];
set_property -dict {PACKAGE_PIN R22 IOSTANDARD LVCMOS33} [get_ports {QSPI_DQ[1]}];
set_property -dict {PACKAGE_PIN P21 IOSTANDARD LVCMOS33} [get_ports {QSPI_DQ[2]}];
set_property -dict {PACKAGE_PIN R21 IOSTANDARD LVCMOS33} [get_ports {QSPI_DQ[3]}];
set_property -dict {PACKAGE_PIN V22 IOSTANDARD LVCMOS33} [get_ports {QSPI_SCK}];
set_property -dict {PACKAGE_PIN T19 IOSTANDARD LVCMOS33} [get_ports {QSPI_CS}];

# SDIO
# set_property -dict {PACKAGE_PIN G3 IOSTANDARD LVCMOS33} [get_ports {TF_DAT0}];
# set_property -dict {PACKAGE_PIN F1 IOSTANDARD LVCMOS33} [get_ports {TF_DAT1}];
# set_property -dict {PACKAGE_PIN H2 IOSTANDARD LVCMOS33} [get_ports {TF_DAT2}];
# set_property -dict {PACKAGE_PIN H3 IOSTANDARD LVCMOS33} [get_ports {TF_DAT3}];
# set_property -dict {PACKAGE_PIN G1 IOSTANDARD LVCMOS33} [get_ports {TF_CMD}];
# set_property -dict {PACKAGE_PIN G2 IOSTANDARD LVCMOS33} [get_ports {TF_CLK}];

# FTDI

# set_property -dict {PACKAGE_PIN W22 IOSTANDARD LVCMOS33} [get_ports {ADBUS[0]}];
# set_property -dict {PACKAGE_PIN W21 IOSTANDARD LVCMOS33} [get_ports {ADBUS[1]}];
# set_property -dict {PACKAGE_PIN W20 IOSTANDARD LVCMOS33} [get_ports {ADBUS[2]}];
# set_property -dict {PACKAGE_PIN Y22 IOSTANDARD LVCMOS33} [get_ports {ADBUS[3]}];

set_property -dict {PACKAGE_PIN W22 IOSTANDARD LVCMOS33} [get_ports {MCU_TCK}];
set_property -dict {PACKAGE_PIN W21 IOSTANDARD LVCMOS33} [get_ports {MCU_TDI}];
set_property -dict {PACKAGE_PIN W20 IOSTANDARD LVCMOS33} [get_ports {MCU_TDO}];
set_property -dict {PACKAGE_PIN Y22 IOSTANDARD LVCMOS33} [get_ports {MCU_TMS}];
# set_property -dict {PACKAGE_PIN Y21 IOSTANDARD LVCMOS33} [get_ports {ADBUS[4]}];
# set_property -dict {PACKAGE_PIN AA21 IOSTANDARD LVCMOS33} [get_ports {ADBUS[5]}];
# set_property -dict {PACKAGE_PIN AA20 IOSTANDARD LVCMOS33} [get_ports {ADBUS[6]}];
# set_property -dict {PACKAGE_PIN Y19 IOSTANDARD LVCMOS33} [get_ports {ADBUS[7]}];

# set_property -dict {PACKAGE_PIN AB22 IOSTANDARD LVCMOS33} [get_ports {BDBUS[0]}];
# set_property -dict {PACKAGE_PIN AB21 IOSTANDARD LVCMOS33} [get_ports {BDBUS[1]}];
set_property -dict {PACKAGE_PIN AB22 IOSTANDARD LVCMOS33} [get_ports {gpio[16]}];
set_property -dict {PACKAGE_PIN AB21 IOSTANDARD LVCMOS33} [get_ports {gpio[17]}];
# set_property -dict {PACKAGE_PIN AB20 IOSTANDARD LVCMOS33} [get_ports {BDBUS[2]}];
# set_property -dict {PACKAGE_PIN AA19 IOSTANDARD LVCMOS33} [get_ports {BDBUS[3]}];
# set_property -dict {PACKAGE_PIN Y18 IOSTANDARD LVCMOS33} [get_ports {BDBUS[4]}];
# set_property -dict {PACKAGE_PIN AA18 IOSTANDARD LVCMOS33} [get_ports {BDBUS[5]}];
# set_property -dict {PACKAGE_PIN AB18 IOSTANDARD LVCMOS33} [get_ports {BDBUS[6]}];
# set_property -dict {PACKAGE_PIN W17 IOSTANDARD LVCMOS33} [get_ports {BDBUS[7]}];

# set_property -dict {PACKAGE_PIN Y17 IOSTANDARD LVCMOS33} [get_ports {BCBUS[0]}];
# set_property -dict {PACKAGE_PIN AB17 IOSTANDARD LVCMOS33} [get_ports {BCBUS[1]}];
# set_property -dict {PACKAGE_PIN Y16 IOSTANDARD LVCMOS33} [get_ports {BCBUS[2]}];
# set_property -dict {PACKAGE_PIN AB16 IOSTANDARD LVCMOS33} [get_ports {BCBUS[3]}];
# set_property -dict {PACKAGE_PIN AA16 IOSTANDARD LVCMOS33} [get_ports {BCBUS[4]}];
# set_property -dict {PACKAGE_PIN AA15 IOSTANDARD LVCMOS33} [get_ports {BCBUS[5]}];
# set_property -dict {PACKAGE_PIN AB15 IOSTANDARD LVCMOS33} [get_ports {BCBUS[6]}];
# set_property -dict {PACKAGE_PIN Y14 IOSTANDARD LVCMOS33} [get_ports {BCBUS[7]}];


# LED

# set_property -dict {PACKAGE_PIN D1 IOSTANDARD LVCMOS33} [get_ports {LED_RED}];
# set_property -dict {PACKAGE_PIN E2 IOSTANDARD LVCMOS33} [get_ports {LED_GREEN}];
# set_property -dict {PACKAGE_PIN D2 IOSTANDARD LVCMOS33} [get_ports {LED_BLUE}];


# KEY
# set_property -dict {PACKAGE_PIN L1 IOSTANDARD LVCMOS33} [get_ports {KEY[0]}];
set_property -dict {PACKAGE_PIN L1 IOSTANDARD LVCMOS33 PULLUP true} [get_ports {mcu_rst}];

# set_property -dict {PACKAGE_PIN E1 IOSTANDARD LVCMOS33} [get_ports {KEY[1]}];

# SW

# set_property -dict {PACKAGE_PIN K1 IOSTANDARD LVCMOS33} [get_ports {SW[0]}];
# set_property -dict {PACKAGE_PIN K2 IOSTANDARD LVCMOS33} [get_ports {SW[1]}];
# set_property -dict {PACKAGE_PIN J1 IOSTANDARD LVCMOS33} [get_ports {SW[2]}];
# set_property -dict {PACKAGE_PIN J2 IOSTANDARD LVCMOS33} [get_ports {SW[3]}];







# RASPBERRY
# set_property -dict {PACKAGE_PIN Y1 IOSTANDARD LVCMOS33} [get_ports {BCM[0]}];
# set_property -dict {PACKAGE_PIN W2 IOSTANDARD LVCMOS33} [get_ports {BCM[1]}];
# set_property -dict {PACKAGE_PIN Y6 IOSTANDARD LVCMOS33} [get_ports {BCM[2]}];
# set_property -dict {PACKAGE_PIN AB5 IOSTANDARD LVCMOS33} [get_ports {BCM[3]}];
# set_property -dict {PACKAGE_PIN AA5 IOSTANDARD LVCMOS33} [get_ports {BCM[4]}];
# set_property -dict {PACKAGE_PIN W1 IOSTANDARD LVCMOS33} [get_ports {BCM[5]}];
# set_property -dict {PACKAGE_PIN V3 IOSTANDARD LVCMOS33} [get_ports {BCM[6]}];
# set_property -dict {PACKAGE_PIN Y2 IOSTANDARD LVCMOS33} [get_ports {BCM[7]}];
# set_property -dict {PACKAGE_PIN AA1 IOSTANDARD LVCMOS33} [get_ports {BCM[8]}];
# set_property -dict {PACKAGE_PIN U7 IOSTANDARD LVCMOS33} [get_ports {BCM[9]}];
# set_property -dict {PACKAGE_PIN W5 IOSTANDARD LVCMOS33} [get_ports {BCM[10]}];
# set_property -dict {PACKAGE_PIN V4 IOSTANDARD LVCMOS33} [get_ports {BCM[11]}];
# set_property -dict {PACKAGE_PIN V2 IOSTANDARD LVCMOS33} [get_ports {BCM[12]}];
# set_property -dict {PACKAGE_PIN U3 IOSTANDARD LVCMOS33} [get_ports {BCM[13]}];
# set_property -dict {PACKAGE_PIN AA4 IOSTANDARD LVCMOS33} [get_ports {BCM[14]}];
# set_property -dict {PACKAGE_PIN Y4 IOSTANDARD LVCMOS33} [get_ports {BCM[15]}];
# set_property -dict {PACKAGE_PIN U1 IOSTANDARD LVCMOS33} [get_ports {BCM[16]}];
# set_property -dict {PACKAGE_PIN AB3 IOSTANDARD LVCMOS33} [get_ports {BCM[17]}];
# set_property -dict {PACKAGE_PIN AA3 IOSTANDARD LVCMOS33} [get_ports {BCM[18]}];
# set_property -dict {PACKAGE_PIN U2 IOSTANDARD LVCMOS33} [get_ports {BCM[19]}];
# set_property -dict {PACKAGE_PIN T3 IOSTANDARD LVCMOS33} [get_ports {BCM[20]}];
# set_property -dict {PACKAGE_PIN R3 IOSTANDARD LVCMOS33} [get_ports {BCM[21]}];
# set_property -dict {PACKAGE_PIN AB2 IOSTANDARD LVCMOS33} [get_ports {BCM[22]}];
# set_property -dict {PACKAGE_PIN AB1 IOSTANDARD LVCMOS33} [get_ports {BCM[23]}];
# set_property -dict {PACKAGE_PIN W7 IOSTANDARD LVCMOS33} [get_ports {BCM[24]}];
# set_property -dict {PACKAGE_PIN W4 IOSTANDARD LVCMOS33} [get_ports {BCM[25]}];
# set_property -dict {PACKAGE_PIN T1 IOSTANDARD LVCMOS33} [get_ports {BCM[26]}];
# set_property -dict {PACKAGE_PIN Y3 IOSTANDARD LVCMOS33} [get_ports {BCM[27]}];



















# PMOD

# set_property -dict {PACKAGE_PIN J6 IOSTANDARD LVCMOS33} [get_ports {J1[0]}];
# set_property -dict {PACKAGE_PIN J5 IOSTANDARD LVCMOS33} [get_ports {J1[1]}];
# set_property -dict {PACKAGE_PIN C2 IOSTANDARD LVCMOS33} [get_ports {J1[2]}];
# set_property -dict {PACKAGE_PIN A1 IOSTANDARD LVCMOS33} [get_ports {J1[3]}];
# set_property -dict {PACKAGE_PIN K6 IOSTANDARD LVCMOS33} [get_ports {J1[4]}];
# set_property -dict {PACKAGE_PIN F4 IOSTANDARD LVCMOS33} [get_ports {J1[5]}];
# set_property -dict {PACKAGE_PIN B2 IOSTANDARD LVCMOS33} [get_ports {J1[6]}];
# set_property -dict {PACKAGE_PIN B1 IOSTANDARD LVCMOS33} [get_ports {J1[7]}];
# 
# set_property -dict {PACKAGE_PIN M1 IOSTANDARD LVCMOS33} [get_ports {J2[0]}];
# set_property -dict {PACKAGE_PIN M3 IOSTANDARD LVCMOS33} [get_ports {J2[1]}];
# set_property -dict {PACKAGE_PIN P2 IOSTANDARD LVCMOS33} [get_ports {J2[2]}];
# set_property -dict {PACKAGE_PIN P1 IOSTANDARD LVCMOS33} [get_ports {J2[3]}];
# set_property -dict {PACKAGE_PIN M2 IOSTANDARD LVCMOS33} [get_ports {J2[4]}];
# set_property -dict {PACKAGE_PIN N2 IOSTANDARD LVCMOS33} [get_ports {J2[5]}];
# set_property -dict {PACKAGE_PIN N3 IOSTANDARD LVCMOS33} [get_ports {J2[6]}];
# set_property -dict {PACKAGE_PIN R1 IOSTANDARD LVCMOS33} [get_ports {J2[7]}];
# 
# set_property -dict {PACKAGE_PIN Y8 IOSTANDARD LVCMOS33} [get_ports {J3[0]}];
# set_property -dict {PACKAGE_PIN AB7 IOSTANDARD LVCMOS33} [get_ports {J3[1]}];
# set_property -dict {PACKAGE_PIN AB6 IOSTANDARD LVCMOS33} [get_ports {J3[2]}];
# set_property -dict {PACKAGE_PIN AA6 IOSTANDARD LVCMOS33} [get_ports {J3[3]}];
# set_property -dict {PACKAGE_PIN AA8 IOSTANDARD LVCMOS33} [get_ports {J3[4]}];
# set_property -dict {PACKAGE_PIN AB8 IOSTANDARD LVCMOS33} [get_ports {J3[5]}];
# set_property -dict {PACKAGE_PIN W9 IOSTANDARD LVCMOS33} [get_ports {J3[6]}];
# set_property -dict {PACKAGE_PIN Y9 IOSTANDARD LVCMOS33} [get_ports {J3[7]}];
# 
# set_property -dict {PACKAGE_PIN R19 IOSTANDARD LVCMOS33} [get_ports {J4[0]}];
# set_property -dict {PACKAGE_PIN R18 IOSTANDARD LVCMOS33} [get_ports {J4[1]}];
# set_property -dict {PACKAGE_PIN V20 IOSTANDARD LVCMOS33} [get_ports {J4[2]}];
# set_property -dict {PACKAGE_PIN V19 IOSTANDARD LVCMOS33} [get_ports {J4[3]}];
# set_property -dict {PACKAGE_PIN U18 IOSTANDARD LVCMOS33} [get_ports {J4[4]}];
# set_property -dict {PACKAGE_PIN T18 IOSTANDARD LVCMOS33} [get_ports {J4[5]}];
# set_property -dict {PACKAGE_PIN W19 IOSTANDARD LVCMOS33} [get_ports {J4[6]}];
# set_property -dict {PACKAGE_PIN V18 IOSTANDARD LVCMOS33} [get_ports {J4[7]}];
# 
# set_property -dict {PACKAGE_PIN N5 IOSTANDARD LVCMOS33} [get_ports {J5[0]}];
# set_property -dict {PACKAGE_PIN M5 IOSTANDARD LVCMOS33} [get_ports {J5[1]}];
# set_property -dict {PACKAGE_PIN L5 IOSTANDARD LVCMOS33} [get_ports {J5[2]}];
# set_property -dict {PACKAGE_PIN L6 IOSTANDARD LVCMOS33} [get_ports {J5[3]}];
# set_property -dict {PACKAGE_PIN F3 IOSTANDARD LVCMOS33} [get_ports {J5[4]}];
# set_property -dict {PACKAGE_PIN P6 IOSTANDARD LVCMOS33} [get_ports {J5[5]}];
# set_property -dict {PACKAGE_PIN H5 IOSTANDARD LVCMOS33} [get_ports {J5[6]}];
# set_property -dict {PACKAGE_PIN M6 IOSTANDARD LVCMOS33} [get_ports {J5[7]}];
# 
# set_property -dict {PACKAGE_PIN P5 IOSTANDARD LVCMOS33} [get_ports {J6[0]}];
# set_property -dict {PACKAGE_PIN N4 IOSTANDARD LVCMOS33} [get_ports {J6[1]}];
# set_property -dict {PACKAGE_PIN H4 IOSTANDARD LVCMOS33} [get_ports {J6[2]}];
# set_property -dict {PACKAGE_PIN G4 IOSTANDARD LVCMOS33} [get_ports {J6[3]}];
# set_property -dict {PACKAGE_PIN P4 IOSTANDARD LVCMOS33} [get_ports {J6[4]}];
# set_property -dict {PACKAGE_PIN K3 IOSTANDARD LVCMOS33} [get_ports {J6[5]}];
# set_property -dict {PACKAGE_PIN J4 IOSTANDARD LVCMOS33} [get_ports {J6[6]}];
# set_property -dict {PACKAGE_PIN E3 IOSTANDARD LVCMOS33} [get_ports {J6[7]}];
# 
# 
# set_property -dict {PACKAGE_PIN V5 IOSTANDARD LVCMOS33} [get_ports {J7[0]}];
# set_property -dict {PACKAGE_PIN T6 IOSTANDARD LVCMOS33} [get_ports {J7[1]}];
# set_property -dict {PACKAGE_PIN U5 IOSTANDARD LVCMOS33} [get_ports {J7[2]}];
# set_property -dict {PACKAGE_PIN R2 IOSTANDARD LVCMOS33} [get_ports {J7[3]}];
# set_property -dict {PACKAGE_PIN U6 IOSTANDARD LVCMOS33} [get_ports {J7[4]}];
# set_property -dict {PACKAGE_PIN T5 IOSTANDARD LVCMOS33} [get_ports {J7[5]}];
# set_property -dict {PACKAGE_PIN T4 IOSTANDARD LVCMOS33} [get_ports {J7[6]}];
# set_property -dict {PACKAGE_PIN R4 IOSTANDARD LVCMOS33} [get_ports {J7[7]}];




set_property -dict {PACKAGE_PIN M1 IOSTANDARD LVCMOS33} [get_ports {gpio[0]}];
set_property -dict {PACKAGE_PIN M3 IOSTANDARD LVCMOS33} [get_ports {gpio[1]}];
set_property -dict {PACKAGE_PIN P2 IOSTANDARD LVCMOS33} [get_ports {gpio[2]}];
set_property -dict {PACKAGE_PIN P1 IOSTANDARD LVCMOS33} [get_ports {gpio[3]}];
set_property -dict {PACKAGE_PIN M2 IOSTANDARD LVCMOS33} [get_ports {gpio[4]}];
set_property -dict {PACKAGE_PIN N2 IOSTANDARD LVCMOS33} [get_ports {gpio[5]}];
set_property -dict {PACKAGE_PIN N3 IOSTANDARD LVCMOS33} [get_ports {gpio[6]}];
set_property -dict {PACKAGE_PIN R1 IOSTANDARD LVCMOS33} [get_ports {gpio[7]}];

set_property -dict {PACKAGE_PIN Y8 IOSTANDARD LVCMOS33} [get_ports {gpio[8]}];
set_property -dict {PACKAGE_PIN AB7 IOSTANDARD LVCMOS33} [get_ports {gpio[9]}];
set_property -dict {PACKAGE_PIN AB6 IOSTANDARD LVCMOS33} [get_ports {gpio[10]}];
set_property -dict {PACKAGE_PIN AA6 IOSTANDARD LVCMOS33} [get_ports {gpio[11]}];
set_property -dict {PACKAGE_PIN AA8 IOSTANDARD LVCMOS33} [get_ports {gpio[12]}];
set_property -dict {PACKAGE_PIN AB8 IOSTANDARD LVCMOS33} [get_ports {gpio[13]}];
set_property -dict {PACKAGE_PIN W9 IOSTANDARD LVCMOS33} [get_ports {gpio[14]}];
set_property -dict {PACKAGE_PIN Y9 IOSTANDARD LVCMOS33} [get_ports {gpio[15]}];

# set_property -dict {PACKAGE_PIN R19 IOSTANDARD LVCMOS33} [get_ports {J4[0]}];
# set_property -dict {PACKAGE_PIN R18 IOSTANDARD LVCMOS33} [get_ports {J4[1]}];
set_property -dict {PACKAGE_PIN V20 IOSTANDARD LVCMOS33} [get_ports {gpio[18]}];
set_property -dict {PACKAGE_PIN V19 IOSTANDARD LVCMOS33} [get_ports {gpio[19]}];
set_property -dict {PACKAGE_PIN U18 IOSTANDARD LVCMOS33} [get_ports {gpio[20]}];
set_property -dict {PACKAGE_PIN T18 IOSTANDARD LVCMOS33} [get_ports {gpio[21]}];
set_property -dict {PACKAGE_PIN W19 IOSTANDARD LVCMOS33} [get_ports {gpio[22]}];
set_property -dict {PACKAGE_PIN V18 IOSTANDARD LVCMOS33} [get_ports {gpio[23]}];

set_property -dict {PACKAGE_PIN N5 IOSTANDARD LVCMOS33} [get_ports {gpio[24]}];
set_property -dict {PACKAGE_PIN M5 IOSTANDARD LVCMOS33} [get_ports {gpio[25]}];
set_property -dict {PACKAGE_PIN L5 IOSTANDARD LVCMOS33} [get_ports {gpio[26]}];
set_property -dict {PACKAGE_PIN L6 IOSTANDARD LVCMOS33} [get_ports {gpio[27]}];
set_property -dict {PACKAGE_PIN F3 IOSTANDARD LVCMOS33} [get_ports {gpio[28]}];
set_property -dict {PACKAGE_PIN P6 IOSTANDARD LVCMOS33} [get_ports {gpio[29]}];
set_property -dict {PACKAGE_PIN H5 IOSTANDARD LVCMOS33} [get_ports {gpio[30]}];
set_property -dict {PACKAGE_PIN M6 IOSTANDARD LVCMOS33} [get_ports {gpio[31]}];



set_property CONFIG_MODE SPIx4 [current_design]





