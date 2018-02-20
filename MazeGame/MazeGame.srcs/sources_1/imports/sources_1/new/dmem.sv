`timescale 1ns / 1ps

module dmem #(
   parameter Nloc = 512,         // Number of memory locations
   parameter Dbits = 32,        // Number of bits in data
   parameter initfile = "dmem_screentest.mem"
   )(
   input wire clock,
   input wire wr,                   // WriteEnable:  if wr==1, data is written into mem
   input wire [$clog2(Nloc)-1 : 0] addr,   // Address for specifying memory location
   input wire [Dbits-1 : 0] din,    // Data for writing into memory (if wr==1)
   output logic [Dbits-1 : 0] dout   // Data read from memory (all the time)
   );
   
   logic [Dbits-1 : 0] mem [Nloc-1 : 0];   // The actual registers where data is stored
   initial $readmemh(initfile, mem, 0, Nloc-1);
   
   always_ff @(posedge clock)     // Memory write: only when wr==1, and only at posedge clock
      if(wr)
         mem[addr >> 2] <= din;
         
   assign dout = mem[addr >> 2];       // Memory read: read all the time, no clock involved

endmodule