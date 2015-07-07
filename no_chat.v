`timescale 1ns/1ps

module no_chat(
        input wire a,b,
        output reg[3:0] Q
);
      wire y0, y1;
      assign y0 = ~(y1&a);
      assign y1 = ~(y0&b);

      always @( posedge y1)begin
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
