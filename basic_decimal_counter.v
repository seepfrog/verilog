`timescale 1ns/1ps

module basic_decimal_counter(
        input wire c0,
        input wire c1,
        output reg[3:0] Q
);
      wire y0 = ~(y1&c0);
      wire y1 = ~(y0&c1);

      always @( posedge y1)begin
            if(Q==9)
                  Q <= 0;
            else
                  Q <= Q + 1'b1;
      end
endmodule
