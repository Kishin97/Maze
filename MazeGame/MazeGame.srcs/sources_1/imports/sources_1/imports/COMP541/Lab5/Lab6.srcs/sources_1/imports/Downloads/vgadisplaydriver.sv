`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//
// Montek Singh
// 10/2/2015 
//
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps
`default_nettype none
`include "display640x480.sv"

module vgadisplaydriver#(
parameter bmem_init = "bmem_screentest.mem"
)(
    input wire clk,
    input wire [3:0] charcode,
    output wire [10:0] smem_addr,
    output wire [3:0] red, green, blue,
    output wire hsync, vsync
    );
    
   wire [`xbits-1:0] x;
   wire [`ybits-1:0] y;
   wire activevideo;
   wire [11:0] bmem_addr;
   wire [11:0] bmem_color;
   wire [`xbits-5:0] column = x[`xbits-1:4];
   wire [`ybits-5:0] row = y[`ybits-1:4];
   wire [3:0] xOffset = x[3:0];
   wire [3:0] yOffset = y[3:0];
   assign red[3:0] = (activevideo == 1) ? bmem_color[11:8] : 4'b0;
   assign green[3:0] = (activevideo == 1) ? bmem_color[7:4] : 4'b0;
   assign blue[3:0]  = (activevideo == 1) ? bmem_color[3:0]: 4'b0;
   assign bmem_addr = {charcode, yOffset, xOffset};
   assign smem_addr = {row,5'b00000} + {row, 3'b000} + column;
   bitmapmemory #(4096,12,bmem_init) bmem(bmem_addr, bmem_color);
   vgatimer myvgatimer(clk, hsync, vsync, activevideo, x, y);

endmodule
