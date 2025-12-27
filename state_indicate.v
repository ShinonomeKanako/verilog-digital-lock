module state_indicate ( // control the LEDs
    //ports
    input[1:0] state,

    output reg [3:0] LEDs
  );
/*
unlocked: turn on all LEDs;
alarming:  all LEDs flashing;
waiting:  turn on one LED;
editing:  turn on two LEDs;
*/
parameter waiting = 2'b00;
parameter editing = 2'b01;
parameter unlocked = 2'b10;
parameter alarming = 2'b11;
parameter user = 1'b1;
parameter admin = 1'b0;
always @(*)
  begin
    case (state)
      waiting:
        LEDs = 4'b0001;
      editing:
        LEDs = 4'b0011;
      alarming:
        LEDs = 4'b0111;
      unlocked:
        LEDs = 4'b1111;
      default:
        LEDs = 4'b0000;
    endcase
  end

endmodule