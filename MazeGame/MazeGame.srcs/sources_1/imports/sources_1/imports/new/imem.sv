`timescale 1ns / 1ps
`default_nettype none
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/31/2017 04:30:00 AM
// Design Name: 
// Module Name: imem
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

`timescale 1ns / 1ps
`default_nettype none

module imem #(
   parameter Nloc = 64,                      // Number of memory locations
   parameter Dbits = 32,                      // Number of bits in data
   parameter imem_init = "imem_screentest_pause.mem"       // Name of file with initial values
)(
   input wire [11:0] pc,
   input wire [31:0] instr
   );

   logic [Dbits-1 : 0] mem [Nloc-1 : 0];     // The actual storage where data resides
   initial $readmemh(imem_init, mem, 0, Nloc-1); // Initialize memory contents from a file

   assign instr = mem[pc >> 2]; 

endmodule