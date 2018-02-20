`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/11/2017 07:21:22 PM
// Design Name: 
// Module Name: memIO
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module memIO#(
parameter Dbits = 32,
parameter Nloc = 32,
parameter dmem_init = "dmem_screentest.mem",
parameter smem_init = "smem_screentest.mem"
)(
    input wire clk,
    input wire mem_wr,
    input wire [31:0] keyb_char,
    input wire [10:0] smem_addr,
    input wire [31:0] mem_addr,
    input wire [31:0] mem_writedata,
    output wire [31:0] mem_readdata,
    output wire [3:0] charcode,
    output wire audEn,
    output wire [2:0]periodToPlay,
    output wire [3:0]light
//    output wire [8:0] accelX,
//    output wire [8:0] accelY
    );
    wire dmem_wr, smem_wr, lights_wr, sound_wr; 
    wire [31:0]smem_readdata, dmem_readdata;// lights_val, sound_val;
    
    
    assign lights_wr = (mem_addr[17:16] == 2'b11) & (mem_addr[3:2] == 2'b11) & mem_wr;
    assign sound_wr = (mem_addr[17:16] == 2'b11) & (mem_addr[3:2] == 2'b10) & mem_wr;
    assign dmem_wr = (mem_addr[17:16] == 2'b01) & mem_wr;
    assign smem_wr = (mem_addr[17:16] == 2'b10) & mem_wr;
 
    assign mem_readdata = (mem_addr[17:16] == 2'b11)  & (mem_addr[3:2] == 2'b00) ? keyb_char :
//                          (mem_addr[17:16] == 2'b11)  & (mem_addr[3:2] == 2'b11) ? lights_val :
                          (mem_addr[17:16] == 2'b10)? smem_readdata:
                          (mem_addr[17:16] == 2'b01) ? dmem_readdata:
                               32'b0;
                               
    screenmemory  scrmem(smem_addr, mem_addr[12:0], mem_writedata, smem_wr, clk, charcode, smem_readdata);
    dmem #(64, 32, dmem_init) datamem(clk, dmem_wr, mem_addr[7:0], mem_writedata, dmem_readdata);
    soundregister sound(clk, sound_wr,mem_writedata[3:0],periodToPlay,audEn);
    lightregister LEDs(clk, lights_wr, mem_writedata[3:0],light);
endmodule
