`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/27/2017 06:19:46 PM
// Design Name: 
// Module Name: soundregister
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


module soundregister(
    input wire clk,
    input wire sound_wr,
    input wire [3:0] data, 
    output logic [2:0] period,
    output logic audEn
    );
    
   
    always_ff @(posedge clk)
    begin
        audEn <= sound_wr? data[3]: audEn;    //audEn
         period <= sound_wr? data[2:0]:period;
         end
     
    
    
endmodule
