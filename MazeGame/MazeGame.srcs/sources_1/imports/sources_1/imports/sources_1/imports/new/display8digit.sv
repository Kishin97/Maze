`timescale 1ns / 1ps

module display8digit(
input wire [31:0] val,
input wire clock,
output logic [7:0] segments,
output logic [7:0] digitselect
);

logic [31:0] count = 0;
logic [2:0] topthree;
logic [3:0] value4bit;

always_ff @(posedge clock)
    count <= count + 1'b 1;

assign topthree[2:0] = count[19:17];
//     assign toptwo[1:0] = count[24:22];  // Try this instead to slow things down!


assign digitselect[7:0] = ~ (              // Note inversion
                    topthree == 3'b000 ? 8'b00000001  // Note inversion
                    : topthree == 3'b001 ? 8'b00000010
                    : topthree == 3'b010 ? 8'b00000100
                    : topthree == 3'b011 ? 8'b00001000
                    : topthree == 3'b100 ? 8'b00010000
                    : topthree == 3'b101 ? 8'b00100000
                    : topthree == 3'b110 ? 8'b01000000
    : 8'b10000000 );

    
assign value4bit   =   (
              topthree == 3'b000 ? val[3:0]
              : topthree == 3'b001 ? val[7:4]
              : topthree == 3'b010 ? val[11:8]
              : topthree == 3'b011 ? val[15:12]
              : topthree == 3'b100 ? val[19:16]
              : topthree == 3'b101 ? val[23:20]
              : topthree == 3'b110 ? val[27:24]
: val[31:29] );

hexto7seg myhexencoder(value4bit, segments);

endmodule
