`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/27/2017 08:54:32 PM
// Design Name: 
// Module Name: lightregister
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


module lightregister(
input wire clk,
input wire lights_wr,
input wire [3:0] data,
output logic [3:0] light
);
     always_ff @(posedge clk)
       begin
           light <= lights_wr? data[3:0]: light;
          end             
endmodule
