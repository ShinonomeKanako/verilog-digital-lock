module password_check (
    input identity,  // user'1' / admin '0' , only when identity==1 will this module be enabled
    input ok_signal, // when posedge, check the password
    input  [15:0] password,    // the password you input
    input  [15:0] correct_pswd, // the correct password
    // input admin_buttion,  // clear the alarm signal, posedge trigger
    output reg result, // '1': right '0': wrongs
    output reg [1:0]time_of_error
  );
  
always @(negedge ok_signal)
  begin
    if (password==correct_pswd && identity==1) // user
      begin
        result <= 1'b1; // right
        time_of_error <= 2'b00; // no error
      end
    else if (password!=correct_pswd && identity==1) // user
      begin
        result <= 1'b0; // wrong
        time_of_error <= time_of_error+2'b01; // error happened
      end

    else if (identity==0) // admin
      begin
        time_of_error <= 2'b00; // no error
      end
  end




/*
    check the password;        
*/

endmodule