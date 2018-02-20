## Clock signal
set_property PACKAGE_PIN E3 [get_ports clk]
create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} -add [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]

##PWM Audio Amplifier
set_property PACKAGE_PIN A11 [get_ports audPWM]					
set_property IOSTANDARD LVCMOS33 [get_ports audPWM]

# audEn = 1 means enable audio; 0 means disable
set_property PACKAGE_PIN D12 [get_ports audEn]						
set_property IOSTANDARD LVCMOS33 [get_ports audEn]

##Accelerometer
##Bank = 15, Pin name = IO_L6N_T0_VREF_15,					Sch name = ACL_MISO
set_property PACKAGE_PIN D13 [get_ports aclMISO]					
	set_property IOSTANDARD LVCMOS33 [get_ports aclMISO]
##Bank = 15, Pin name = IO_L2N_T0_AD8N_15,					Sch name = ACL_MOSI
set_property PACKAGE_PIN B14 [get_ports aclMOSI]					
	set_property IOSTANDARD LVCMOS33 [get_ports aclMOSI]
##Bank = 15, Pin name = IO_L12P_T1_MRCC_15,					Sch name = ACL_SCLK
set_property PACKAGE_PIN D15 [get_ports aclSCK]					
	set_property IOSTANDARD LVCMOS33 [get_ports aclSCK]
##Bank = 15, Pin name = IO_L12N_T1_MRCC_15,					Sch name = ACL_CSN
set_property PACKAGE_PIN C15 [get_ports aclSS]						
	set_property IOSTANDARD LVCMOS33 [get_ports aclSS]

##7 segment display
##Bank = 34, Pin name = IO_L2N_T0_34,						Sch name = CA
set_property PACKAGE_PIN L3 [get_ports {segments[7]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {segments[7]}]
##Bank = 34, Pin name = IO_L3N_T0_DQS_34,					Sch name = CB
set_property PACKAGE_PIN N1 [get_ports {segments[6]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {segments[6]}]
##Bank = 34, Pin name = IO_L6N_T0_VREF_34,					Sch name = CC
set_property PACKAGE_PIN L5 [get_ports {segments[5]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {segments[5]}]
##Bank = 34, Pin name = IO_L5N_T0_34,						Sch name = CD
set_property PACKAGE_PIN L4 [get_ports {segments[4]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {segments[4]}]
##Bank = 34, Pin name = IO_L2P_T0_34,						Sch name = CE
set_property PACKAGE_PIN K3 [get_ports {segments[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {segments[3]}]
##Bank = 34, Pin name = IO_L4N_T0_34,						Sch name = CF
set_property PACKAGE_PIN M2 [get_ports {segments[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {segments[2]}]
##Bank = 34, Pin name = IO_L6P_T0_34,						Sch name = CG
set_property PACKAGE_PIN L6 [get_ports {segments[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {segments[1]}]

##Bank = 34, Pin name = IO_L16P_T2_34,						Sch name = DP
set_property PACKAGE_PIN M4 [get_ports {segments[0]}]							
	set_property IOSTANDARD LVCMOS33 [get_ports {segments[0]}]

##Bank = 34, Pin name = IO_L18N_T2_34,						Sch name = AN0
set_property PACKAGE_PIN N6 [get_ports {digitselect[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {digitselect[0]}]
##Bank = 34, Pin name = IO_L18P_T2_34,						Sch name = AN1
set_property PACKAGE_PIN M6 [get_ports {digitselect[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {digitselect[1]}]
##Bank = 34, Pin name = IO_L4P_T0_34,						Sch name = AN2
set_property PACKAGE_PIN M3 [get_ports {digitselect[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {digitselect[2]}]
##Bank = 34, Pin name = IO_L13_T2_MRCC_34,					Sch name = AN3
set_property PACKAGE_PIN N5 [get_ports {digitselect[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {digitselect[3]}]
##Bank = 34, Pin name = IO_L3P_T0_DQS_34,					Sch name = AN4
set_property PACKAGE_PIN N2 [get_ports {digitselect[4]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {digitselect[4]}]
##Bank = 34, Pin name = IO_L16N_T2_34,						Sch name = AN5
set_property PACKAGE_PIN N4 [get_ports {digitselect[5]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {digitselect[5]}]
##Bank = 34, Pin name = IO_L1P_T0_34,						Sch name = AN6
set_property PACKAGE_PIN L1 [get_ports {digitselect[6]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {digitselect[6]}]
##Bank = 34, Pin name = IO_L1N_T034,							Sch name = AN7
set_property PACKAGE_PIN M1 [get_ports {digitselect[7]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {digitselect[7]}]