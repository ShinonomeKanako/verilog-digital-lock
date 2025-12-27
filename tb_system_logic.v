`timescale  1ns / 1ps

module tb_system_logic;

// system_logic Parameters
parameter PERIOD    = 10   ;
parameter waiting   = 2'b00;
parameter editing   = 2'b01;
parameter unlocked  = 2'b10;
parameter alarming  = 2'b11;
parameter user      = 1'b1 ;
parameter admin     = 1'b0 ;

// system_logic Inputs
reg   clk                                  = 0 ;
reg   [3:0]  switches                      = 0 ;
reg   load                                 = 0 ;
reg   ok_button                            = 0 ;
reg   admin_button                         = 0 ;
reg   key_button                           = 0 ;

// system_logic Outputs
wire  [6:0]  tubes                         ;
wire  [3:0]  LEDs                          ;
wire  [7:0]  sel                           ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end



system_logic #(
    .waiting  ( waiting  ),
    .editing  ( editing  ),
    .unlocked ( unlocked ),
    .alarming ( alarming ),
    .user     ( user     ),
    .admin    ( admin    ))
 u_system_logic (
    .clk                     ( clk                 ),
    .switches                ( switches      [3:0] ),
    .load                    ( load                ),
    .ok_button               ( ok_button           ),
    .admin_button            ( admin_button        ),
    .key_button              ( key_button          ),

    .tubes                   ( tubes         [6:0] ),
    .LEDs                    ( LEDs          [3:0] ),
    .sel                     ( sel           [7:0] )
);

initial
begin
    switches = 4'b1101; load = 1'b1; admin_button = 1'b1; ok_button = 1'b1; key_button = 1'b1;
    // enter the editing mode (an invalid BCD code)
    // admin set the password
    admin_button = 1'b0; #10; admin_button = 1'b1; #10;
    load = 1'b0; #10; load = 1'b1; #10;
    switches = 4'b0010; #10;
    load = 1'b0; #10; load = 1'b1; #10;
    switches = 4'b0011; #10;
    load = 1'b0; #10; load = 1'b1; #10;
    switches = 4'b0100; #10;
    load = 1'b0; #10; load = 1'b1; #10;
    switches = 4'b0101; #10;
    load = 1'b0; #10; load = 1'b1; #10;
    admin_button = 1'b0; #10; admin_button = 1'b1; #10; //transfer to user mode
    //enter the right password
    switches = 4'b0010; #10;
    load = 1'b0; #10; load = 1'b1; #10;
    switches = 4'b0011; #10;
    load = 1'b0; #10; load = 1'b1; #10;
    switches = 4'b0100; #10;
    load = 1'b0; #10; load = 1'b1; #10;
    switches = 4'b0101; #10;
    load = 1'b0; #10; load = 1'b1; #10;
    // confirm to unlock
    ok_button = 1'b0; #10; ok_button = 1'b1;
    //$finish;
end

endmodule