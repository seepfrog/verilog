`timescale 1ns/1ps

module seg7test(
      input wire[3:0]  sw,
      input wire[3:0]  ssw,
      output wire[6:0] seg,
      output wire      dp,
      output wire[3:0] line
);

      parameter[6:0] seg_data[15:0]={
          7'b1111110, 7'b0110000, 7'b1101101, 7'b1111001,
          7'b0110011, 7'b1011011, 7'b1011111, 7'b1110010,
          7'b1111111, 7'b1111011, 7'b1110111, 7'b0011111,
          7'b1001110, 7'b0111101, 7'b1001111, 7'b1000111
      };

      assign line[3:0] = sw[3:0]^4'b1111;
      assign dp = 1'b1;
      assign seg[6:0] = seg_data[ssw[3:0]];
endmodule
