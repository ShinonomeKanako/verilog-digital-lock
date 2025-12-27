module system_logic (  // manages the overall logic of the lock, **it should be the top module**
         input clk, // the clock signal
         input [3:0] switches, // represent a decimal 0~9
         input load, // load one digit
         input ok_button,   // confirm button
         input admin_button,  // clear the alarm signal, posedge trigger
         input key_button,
         output[6:0] tubes, // LED tubes that display the passwords you entered
         output[3:0] LEDs,  // the LEDs that indicates the state of the lock
         output[7:0] sel   // select the digit you want to display
       );
wire[15:0] password;
wire[15:0] correct_pswd;
wire[6:0] tubes_temp;
wire[31:0] cnttemp;
reg[1:0] state = 2'b00;
reg[1:0] next_state = 2'b00;
wire check_result;
wire[1:0] time_of_error;
reg identity = 1'b1; // 0-admin, 1-user
wire load_button ;
wire admin_temp ;
wire ok_signal;
wire key;
parameter waiting = 2'b00;
parameter editing = 2'b01;
parameter unlocked = 2'b10;
parameter alarming = 2'b11;
parameter user = 1'b1;
parameter admin = 1'b0;

always @ (posedge admin_temp)
  begin
    if(identity==1'b1)
      identity <= 1'b0; // admin
    else if(identity==1'b0)
      identity <= 1'b1; // user
  end


ERZP u_ERZP(
       .CLK  (clk),
       .KIN  (load),
       .KOUT (load_button)
     );
ERZP u_ERZP1(
       .CLK  (clk),
       .KIN  (admin_button),
       .KOUT (admin_temp)
     );
ERZP u_ERZP2(
       .CLK  (clk),
       .KIN  (ok_button),
       .KOUT (ok_signal)
     );
ERZP u_ERZP3(
       .CLK  (clk),
       .KIN  (key_button),
       .KOUT (key)
     );

password_reg pswd_reg(
               .clk(clk),
               .identity(identity),
               .time_of_error(time_of_error),
               .cnt_1s(cnttemp),
               .load(load_button),
               .one_digit(switches),
               .ok(key),
               .q(password),
               .new_pswd(correct_pswd),
               .tubesreg(tubes),
               .sel(sel)
             );


password_check pswd_check(
                 .identity(identity),
                 .ok_signal(ok_signal),
                 .password(password),
                 .correct_pswd(correct_pswd),
                 .result(check_result),
                 .time_of_error(time_of_error)
               );
/*     counter count(
        .error_signal(check_result),
        .count(time_of_error)
    ); */

timer u_timer(
        .state        (state),
        .ok           (ok_signal),
        .clk          (clk),
        .switches     (switches),
        .load         (load_button),
        .admin_button (admin_temp),
        .key          (key),
        .cnttemp      (cnttemp),
        .finished     (finished)
      );

state_indicate u_state_indicate(
                 .state (state),
                 .LEDs  (LEDs)
               );

always @(posedge clk)
  begin
    next_state = state; // to avoid generating latch
    if (state == waiting &&(!load||(switches[3]&&switches[2])))
      begin
        next_state = editing;
      end
    if (state == editing && finished == 1)
      begin // 10s no operation,back to waiting
        next_state = waiting;
      end
    if (state == editing && check_result == 1&&!ok_signal)
      begin // when you entered the right password
        next_state = unlocked;
      end
    if (state == unlocked && finished == 1)
      begin // 20s no operation,back to waiting
        next_state = waiting;
      end
    if (state == editing && time_of_error == 2'd3)
      begin // when you entered wrong password 3 times
        next_state = alarming;
      end
    if (state == alarming && !ok_signal &&!identity )
      begin // admin can clear the alarm
        next_state = waiting;
      end
    if (state == unlocked && !key_button )
      begin // when unlocked, press the button to return to waiting
        next_state = waiting;
      end
  end

always @(posedge clk)
  begin


    state <= next_state;

  end

assign state_out = state;



endmodule