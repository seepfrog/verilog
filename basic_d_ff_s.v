`timescale 1ns/1ps

module basic_d_ff_s(
        input wire c,
        output reg[3:0] Q
);
      always @( posedge c)begin
            Q[0] <= !Q[0];
      end
      always @( posedge Q[0])begin
            Q[1] <= !Q[1];
      end
      always @( posedge Q[1])begin
            Q[2] <= !Q[2];
      end
      always @( posedge Q[2])begin
            Q[3] <= !Q[3];
      end
endmodule
