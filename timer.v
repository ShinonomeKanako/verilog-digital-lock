module timer (
    input[1:0] state, // 4 states: 00 waiting, 01:editing, 10:unlocked, 11:alarming
    input ok,       // press the button to transfer to waiting mode when unlocked
    input clk,      // a standard square wave signal
    input [3:0]switches,
    input load,
    input key,
    input admin_button,
    output reg [31:0]cnttemp,
    output reg finished
  );
parameter waiting = 2'b00;
parameter editing = 2'b01;
parameter unlocked = 2'b10;
parameter alarming = 2'b11;
reg [31:0] cnt_1ms = 32'b0;
reg [31:0] cnt = 32'b0;
reg [31:0] cnt_1s = 32'b0;
reg [3:0] lastone = 4'b0;
always @(negedge clk)
  begin
    lastone=switches;
  end

always @(posedge clk)
  begin
    if(!key||!load||!admin_button||!ok||lastone!=switches)
      begin // any operation will interrupt the timing
        cnt_1s<=0;
        cnt_1ms<=0;
      end
    cnttemp = cnt_1s;
    if(cnt == 32'd49999) // time 1ms					   
      begin
        cnt_1ms <= cnt_1ms+1;
        cnt<=0;							
      end
    else										
      cnt <= cnt + 1;					

    if(cnt_1ms == 32'd1000)		// time 1s			   
      begin
        cnt_1s <= cnt_1s+1;
        cnt_1ms<=0;							
      end

    if  (cnt_1s==32'd10&&state==editing)
      begin
        finished <= 1'b1;
        cnt_1s <= 32'd0;
      end
    else if  (cnt_1s==32'd20&&state==unlocked)
      begin
        finished <= 1'b1;
        cnt_1s<=32'd0;
      end
    if(state==waiting)
      finished <= 1'b0;
  end
endmodule