`timescale 1ns/1ps


module screenmemory(
input wire [10:0] smem_addr,    //11 bit address
input wire [12:0] mem_addr,
input wire [31:0] din,    // Data for writing into memory (if wr==1)
input wire smem_wr, clock,
output logic [3:0] charcode,
output wire [31:0] to_mips
);
logic [3:0] mem[1199:0];    //30 * 40
initial $readmemh("smem_screentest.mem",mem,0,1199);
always_ff @(posedge clock)     // Memory write: only when wr==1, and only at posedge clock
      if(smem_wr)
         mem[mem_addr[12:2]] <= din;
assign charcode = mem[smem_addr];
assign to_mips = mem[mem_addr[12:2]];


endmodule
