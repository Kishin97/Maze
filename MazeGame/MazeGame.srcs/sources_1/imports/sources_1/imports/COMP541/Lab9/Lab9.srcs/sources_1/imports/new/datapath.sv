`timescale 1ns / 1ps

module datapath #(
   parameter Dbits = 32,         // Number of bits in data
   parameter Nloc = 64           // Number of memory locations
)(
    input wire clk,
    input wire reset,
    output logic [31:0] pc = 'h0x00400_000,
    input wire [31:0] instr,
    input wire [1:0] pcsel, 
    input wire [1:0] wasel, 
    input wire [1:0] wdsel, 
    input wire [1:0] asel,
    input wire sext, bsel,
    input wire [4:0] alufn,
    input wire werf, 
    output wire Z,
    output wire [31:0] mem_addr,
    output wire [31:0] mem_writedata,
    input wire [31:0] mem_readdata
    );
    
    wire [31:0] reg_writedata;
    wire [4:0] Rs, Rt, Rd, shamt;
    wire [25:0] J;
    wire [31:0] JT;
    wire [31:0] BT;
    wire [15:0] Imm;
    wire [31:0] signImm;
    wire [31:0] aluA, aluB, alu_result, ReadData1, ReadData2;
    wire [4:0] reg_writeaddr;
    wire [31:0] PCPlus4;
    wire [31:0] newpc;
    
    assign PCPlus4 = pc + 4;
    assign Rs = instr[25:21];
    assign Rt = instr[20:16];
    assign Rd = instr[15:11];
    assign shamt = instr[10:6];
    assign J = instr[25:0];
    assign JT = ReadData1;
    assign BT = ((PCPlus4)+(signImm << 2));
    assign Imm = instr[15:0];
    assign signImm = (sext == 1'b0) ? {16'b0, Imm} 
                    : (Imm[15] == 1'b1) ? {16'b1111111111111111, Imm}
                    : {16'b0, Imm};
    
    assign aluA = (asel == 2'b00) ? ReadData1 : (asel == 2'b01) ? shamt : {27'b0, 5'b10000};
    assign aluB = (bsel == 1'b1 && sext == 1'b0) ? {16'b0, Imm[15:0]} 
                : (bsel == 1'b0) ? ReadData2 
                : (Imm[15] == 1'b1) ? {16'b1111111111111111, Imm[15:0]}
                : {16'b0, Imm[15:0]};
    
    always_ff @(posedge clk)
        pc <= (reset == 1'b1) ? 'h0x00400_000 : newpc;
        
    assign newpc = (pcsel == 2'b00) ? PCPlus4 : (pcsel == 2'b01) ? BT 
            : (pcsel == 2'b10) ? {PCPlus4[31:28], J, 2'b00} : (pcsel == 2'b11) ? JT : PCPlus4;
    
    assign reg_writeaddr = (wasel == 2'b00) ? Rd : (wasel == 2'b01) ? Rt : (wasel == 2'b10) ? 5'b11111 : 5'b0;
    assign reg_writedata = (wdsel == 2'b00) ? PCPlus4 : (wdsel == 2'b01) ? alu_result : (wdsel == 2'b10) ? mem_readdata : 32'bx;
    
    assign mem_addr = alu_result;
    assign mem_writedata = ReadData2;
    
    register_file registers(clk, werf, Rs, Rt, reg_writeaddr, reg_writedata, ReadData1, ReadData2);
    ALU alu(aluA, aluB, alu_result, alufn, Z);
    
  
endmodule