`timescale 1ns / 1ps
`default_nettype none

module top #(
    parameter imem_init="imem_screentest_pause.mem", 	// for SIMULATION:  imem_screentest_nopause.txt 
    parameter dmem_init="dmem_screentest.mem",
    parameter smem_init="smem_screentest.mem", 	// text file to initialize screen memory
    parameter bmem_init="bmem_screentest.mem" 	// text file to initialize bitmap memory
)(
    input wire clk, ps2_clk, ps2_data, reset,
    output wire [3:0] red, green, blue,
    output wire hsync, vsync,
    output logic [7:0] segments, digitselect,
    
    //Sound   
    output wire audPWM,
    output wire audEn,
    
    //Accelerometer
    
//    output wire aclSCK,
//    output wire aclMOSI,
//    input wire aclMISO,
//    output wire aclSS,
    
    // LED Lights
    output logic [15:0] LED
);
   
   wire [31:0] pc, instr, mem_readdata, mem_writedata, mem_addr;
   wire mem_wr;
   wire clk100, clk50, clk25, clk12;
   wire [3:0] periodToPlay;
   wire [3:0] light;
   wire [10:0] smem_addr;
   wire [3:0] charcode;
   wire [31:0] keyb_char;
//   wire [8:0] accelX, accelY;
//   wire [11:0] accelTmp;

   // Uncomment *only* one of the following two lines:
   //    when synthesizing, use the first line
   //    when simulating, get rid of the clock divider, and use the second line
   
   clockdivider_Nexys4 clkdv(clk, clk100, clk50, clk25, clk12);
//   assign clk100=clk; assign clk50=clk; assign clk25=clk;   assign clk12=clk;
//    For synthesis:  use an appropriate clock frequency(ies) below
//      clk100 will work for hardly anyone
   //   clk50 or clk 25 should work for the vast majority
   //   clk12 should work for everyone!  I'd say use this!
   //
   // Use the same clock frequency for the MIPS and data memory/memIO modules
   // The VGA display and 8-digit display should keep the 100 MHz clock.
   // For example:

    
   mips mips(clk12, reset, pc, instr, mem_wr, mem_addr, mem_writedata, mem_readdata);
   imem #(.Nloc(512), .Dbits(32), .imem_init(imem_init)) imem(pc[11:0], instr);
   memIO #(.Nloc(16), .Dbits(32), .dmem_init(dmem_init), .smem_init(smem_init)) memIO(clk12, mem_wr, keyb_char, smem_addr, mem_addr, mem_writedata, mem_readdata, charcode, audEn, periodToPlay, light);  
   vgadisplaydriver #(bmem_init) display(clk100, charcode, smem_addr, red, green, blue, hsync, vsync );
   display8digit PCdisplay(keyb_char, clk100, segments, digitselect);
   keyboard keyboard(clk100, ps2_clk, ps2_data, keyb_char);
//accelerometer accel(clk, aclSCK, aclMOSI, aclMISO, aclSS, accelX, accelY, accelTmp);
  wire [31:0] notes_periods[0:7] = {382219, 340530, 303370, 286344, 255102, 227273, 202478, 191113};
   
   wire [31:0] period = notes_periods[periodToPlay];
   
   montek_sound_Nexys4 snd(
      clk,           // 100 MHz clock
      period,          // sound period in tens of nanoseconds
                       // period = 1 means 10 ns (i.e., 100 MHz)      
      audPWM);
      
        always_comb
      case (light[3:0])
          4'b0000: LED <= 16'b0000000000000000;
          4'b0001: LED <= 16'b0000000000000001;
          4'b0010: LED <= 16'b0000000000000011;
          4'b0011: LED <= 16'b0000000000000111;
          4'b0100: LED <= 16'b0000000000001111;
          4'b0101: LED <= 16'b0000000000011111;
          4'b0110: LED <= 16'b0000000000111111;
          4'b0111: LED <= 16'b0000000001111111;
          4'b1000: LED <= 16'b0000000011111111;
      default: LED <= 16'b0000000000000000;
      endcase
endmodule
