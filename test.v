 `timescale 1ns / 1ps

module test(
    input wire clk0,
    output wire led
);

    assign led = c[26];
    reg[26:0] c = 0;

    always @( posedge clk0)begin
              if( c==27'd99999999)
                    c <= 0;
              else
                    c <= c + 1'dl;
    end

endmodule
