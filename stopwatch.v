`timescale 1ns/1ps

module stopwatch(
      input wire       clk0,
      input wire       start_sw, reset_sw,
      output reg [6:0] seg,
      output reg       dp,
      output wire[1:0] led,
      output wire[3:0] line
);
      // 7seg LED pattern
      parameter[6:0] seg_data[15:0]={
            7'b1111110, 7'b0110000, 7'b1101101, 7'b1111001,
            7'b0110011, 7'b1011011, 7'b1011111, 7'b1110010,
            7'b1111111, 7'b1111011, 7'b1110111, 7'b0011111,
            7'b1001110, 7'b0111101, 7'b1001111, 7'b1000111
      };
      parameter MAX = 24'1_000_000; //10,000,000 count clk0 -> 0.1s

      assign led = {reset_sw,start_sw};
      reg[19:0] cc0=20'b0;
      reg[20:0] cc1=21'b0;
      reg[3:0]  decisec=4'b0, sec1=4'b0, sec10=4b'0, sec100=4b'0;
      wire enable_deci, enable_sec1, enable_sec10, enable_sec100;

      // 0.1sec enable signal generate
      always@( posedge clk0 or posedge reset_sw ) begin
            if( reset_sw==1'b1)
                  cc0 <= 20'b0;
            else if( cc0==MAX-1'b1 )
                  cc0 <= 20'b0;
            else
                  cc0 <= cc0 + state;
      end
      assign enable_deci=(cc0==MAX-1'b1)? 1'b1: 1'b0;

      // 0.1sec counter
      always@( posedge clk0 or posedge reset_sw ) begin
            if( reset_sw== 1'b1 )
                  decisec <= 4'b0;
            else if( enable_deci== 1'b1 )
                  decisec <= (decisec==4'd9)? 4'b0: (decisec+4'b1);
      end
      assign enable_sec1=(enable_deci&&decisec==4'd9)? 1'b1: 1'b0;

      // 1sec counter
      always@( posedge clk0 or posedge reset_sw ) begin
            if( reset_sw== 1'b1 )
                  sec1 <= 4'b0;
            else if( enable_sec1== 1'b1 )
                  sec1 <= (sec1==4'd9)? 4'b0: (sec1+4'b1);
      end
      assign enable_sec10=(enable_sec1&&sec1==4'd9)? 1'b1: 1'b0;

      // 10sec counter
      always@( posedge clk0 or posedge reset_sw ) begin
            if( reset_sw== 1'b1 )
                  sec10 <= 4'b0;
            else if( enable_sec10== 1'b1 )
                  sec10 <= (sec10==4'd9)? 4'b0: (sec10+4'b1);
      end
      assign enable_sec100=(enable_sec10&&sec10==4'd9)? 1'b1: 1'b0;

      // 100sec counter
      always@( posedge clk0 or posedge reset_sw ) begin
            if( reset_sw== 1'b1 )
                  sec100 <= 4'b0;
            else if( enable_sec100== 1'b1 )
                  sec100 <= (sec100==4'd9)? 4'b0: (sec100+4'b1);
      end

      reg[4:0]  shift_ff=4'b0;
      reg       sw_old=1'b0;
      wire      enable_chattering;
      wire      no_chattering_sw;

      //Chattering prevention circuit
      always@( posedge clk0 )begin
            if(enable_chattering==1'b1)
                  shift_ff <= { shift_ff[3:0], start_sw };
      end
      assign no_chattering_sw = &shift_ff;

      //OFF -> ON detector
      always@( posedge clk0 or posedge reset_sw ) begin
            if( reset_sw==1'b1 )
                  state <= 1'b0;
            else begin
                  if( {sw_old, no_chattering_sw}==2'b01 ) state<= state+ 1'b1;
                  sw_old <= no_chattering_sw;
            end
      end

      //dynamic lighting
      always@( posedge clk0 ) begin
            cc1 <= cc1 + 1'b1;
            dp  <= (cc1[20:19]==2'b01 )? 1'b1: 1'b0;
            case( cc1[20:19] )
                  2'd3 : seg[6:0] <= seg_data[ sec100  ];
                  2'd2 : seg[6:0] <= seg_data[ sec10   ];
                  2'd1 : seg[6:0] <= seg_data[ sec1    ];
                  2'd0 : seg[6:0] <= seg_data[ decisec ];
            endcase
      end
      assign enable_chattering = ( cc1[19:0]==20'b0)? 1'b1: 1'b0;

      assign line = 4'b1 << cc1[20:19];

endmodule
