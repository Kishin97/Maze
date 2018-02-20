`timescale 1ns / 1ps

module bitmapmemory#(
parameter Nloc = 4096,
parameter Dbits = 12,
parameter initfile = "bmem_screentest.mem"
)(
   input wire [$clog2(Nloc)-1:0] bmem_addr,   
   output logic [Dbits-1:0] bmem_color   
   );
      
	logic [Dbits-1:0] mem[Nloc-1:0];  
	initial $readmemh(initfile, mem, 0,Nloc-1);   
    assign bmem_color = mem[bmem_addr];    
   
endmodule