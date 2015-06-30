`timescale 1ns/1ps

module basic_and_or_not(
        input  wire a,
        input  wire b,
        output wire[2:0] y
);

        assign y[2] = a & b;
        assign y[1] = a | b;
        assign y[0] = ~a;

endmodule
