`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/07/2017 09:17:12 PM
// Design Name: 
// Module Name: xycounter
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


module xycounter #(parameter width = 2, height = 2) (
    input wire clk,
    input wire enable,
    output logic [$clog2(width)-1:0] x=0,
    output logic [$clog2(height)-1:0] y=0
    );
    
     always_ff @(posedge clk) begin
           if(enable)
               if(x <= width-1) begin
                   x++;
               end
               if(x > width-1 && y != height-1) begin
                   x = 0;
                   y++;
               end
               if(x > width-1 && y == height-1) begin
                   x = 0;
                   y = 0;
               end
           end
endmodule
