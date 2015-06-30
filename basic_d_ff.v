`timescale 1ns/1ps

module basic_d_ff(
        input wire c,
        output reg Q
);
      always @( posedge c)begin
            Q <= !Q;
      end
endmodule
