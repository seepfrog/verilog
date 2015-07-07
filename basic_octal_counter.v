`timescale 1ns/1ps

module basic_octal_counter(
        input wire a,b,
        output reg[2:0] Q
);
      wire y0, y1;
      assign y0 = ~(y1&a);
      assign y1 = ~(y0&b);

      always @( posedge y1)begin
            Q <= !Q + 1'b1;
      end
endmodule
