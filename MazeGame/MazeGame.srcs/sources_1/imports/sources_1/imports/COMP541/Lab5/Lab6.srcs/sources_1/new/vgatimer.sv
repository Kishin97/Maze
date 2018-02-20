`timescale 1ns / 1ps
`default_nettype none
`include "display640x480.sv"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/10/2017 09:23:49 PM
// Design Name: 
// Module Name: vgatimer
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


module vgatimer(
input wire clock,
output wire hsync, vsync, activevideo,
output wire [`xbits-1:0] x,
output wire [`ybits-1:0] y
    );   
    
logic[1:0] clock_count = 0;
    always_ff @(posedge clock)
        clock_count <= clock_count + 2'b01;
logic Every2ndTick,Every4thTick;
assign Every2ndTick = (clock_count[0] == 1'b1);
assign Every4thTick = (clock_count[1:0] == 2'b11);
    
xycounter #(`WholeLine, `WholeFrame) xy(clock, Every4thTick, x, y);


    assign hsync = (x <= `hSyncStart - 1 || x >= `hSyncEnd + 1);
    assign vsync = (y <= `vSyncStart - 1 || y >= `vSyncEnd + 1);
    assign activevideo = (x < `hVisible && y < `vVisible);


endmodule
