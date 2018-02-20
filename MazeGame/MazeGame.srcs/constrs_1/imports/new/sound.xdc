## Be sure to also use an XDC file for the clock input
## Or, uncomment the following two lines here
# set_property -dict { PACKAGE_PIN E3 IOSTANDARD LVCMOS33 } [get_ports { clock }]
# create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports { clock }]

##PWM Audio Amplifier
set_property PACKAGE_PIN A11 [get_ports audPWM]					
set_property IOSTANDARD LVCMOS33 [get_ports audPWM]

# audEn = 1 means enable audio; 0 means disable
set_property PACKAGE_PIN D12 [get_ports audEn]						
set_property IOSTANDARD LVCMOS33 [get_ports audEn]
