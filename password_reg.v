 module password_reg(
    input clk,
    input identity,    // user'1' / admininstrator'0'
    input load, // to load one digit (left-shift), posedge trigger
    input[3:0] one_digit, // the one decimal digit you input
    input[1:0] time_of_error,
    input[31:0]cnt_1s,
    input ok,
    output reg [15:0] q, // the shift reg that loads password
    output reg [15:0] new_pswd, // the new password you set,when"identity==0"
    output reg [6:0] tubesreg, // the tubes to display the first decimal digit
    output reg [7:0] sel //
  );
reg [3:0]left_shift = 4'b0;
reg[31:0] cnt_1ms = 32'b0;
reg[1:0]load_cnt = 2'b0;
//reg load_signal = 1'b0;

always @(negedge load)
  begin
    if (identity == 1)
      begin //user
        if (one_digit < 4'd10)
          begin
            q <= {q[11:0],one_digit};
          end
        else if(one_digit > 4'd10)
          begin
            new_pswd <= {4'b0000,new_pswd[15:4]};
          end
        else
          begin
            new_pswd<=new_pswd;
          end
      end
    else
      begin //administrator
        if (one_digit < 4'd10)
          begin
            new_pswd <= {new_pswd[11:0],one_digit};
          end
        else if(one_digit > 4'd10)
          begin
            new_pswd <= {4'b0000,new_pswd[15:4]};
          end
        else
          begin
            new_pswd<=new_pswd;
          end
      end
  end

always @(posedge clk)
  begin
    if(cnt_1ms == 49_999)					   // time 1ms
      cnt_1ms <= 0;							// clear
    else										
      cnt_1ms <= cnt_1ms + 1;					
    if (!load)
      sel <= 8'b11111110;
    else if(cnt_1ms == 49_999)					// time 1s
      sel <= {sel[6:0],sel[7]};	// loop shift left
    else
      sel <= sel;
  end


always @(posedge clk)
  begin
    if(identity==1) // user
      begin
        if(sel==8'b11111110)
          begin
            case(q[3:0])
              4'b0000 :
                tubesreg <= 7'b1000_000;//7'b0111_111;//
              4'b0001 :
                tubesreg <= 7'b1111_001;//7'b0000_110;
              4'b0010 :
                tubesreg <= 7'b0100_100;//7'b1011_011;
              4'b0011 :
                tubesreg <= 7'b0110_000;//7'b1001_111;
              4'b0100 :
                tubesreg <= 7'b0011_001;//7'b1100_110;
              4'b0101 :
                tubesreg <= 7'b0010_010;//7'b1101_101;
              4'b0110 :
                tubesreg <= 7'b0000_010;//7'b1111_101;
              4'b0111 :
                tubesreg <= 7'b1111_000;//7'b0000_111;
              4'b1000 :
                tubesreg <= 7'b0000_000;//7'b1111_111;
              4'b1001 :
                tubesreg <= 7'b0010_000;//7'b1101_111;
              default :
                tubesreg <= 7'b1000_000;//7'b0111_111;
            endcase
          end
        if(sel==8'b11111101)
          begin
            case(q[7:4])
              4'b0000 :
                tubesreg <= 7'b1000_000;//7'b0111_111;//
              4'b0001 :
                tubesreg <= 7'b1111_001;//7'b0000_110;
              4'b0010 :
                tubesreg <= 7'b0100_100;//7'b1011_011;
              4'b0011 :
                tubesreg <= 7'b0110_000;//7'b1001_111;
              4'b0100 :
                tubesreg <= 7'b0011_001;//7'b1100_110;
              4'b0101 :
                tubesreg <= 7'b0010_010;//7'b1101_101;
              4'b0110 :
                tubesreg <= 7'b0000_010;//7'b1111_101;
              4'b0111 :
                tubesreg <= 7'b1111_000;//7'b0000_111;
              4'b1000 :
                tubesreg <= 7'b0000_000;//7'b1111_111;
              4'b1001 :
                tubesreg <= 7'b0010_000;//7'b1101_111;
              default :
                tubesreg <= 7'b1000_000;//7'b0111_111;
            endcase
          end

        if(sel==8'b11111011)
          begin
            case(q[11:8])
              4'b0000 :
                tubesreg <= 7'b1000_000;//7'b0111_111;//
              4'b0001 :
                tubesreg <= 7'b1111_001;//7'b0000_110;
              4'b0010 :
                tubesreg <= 7'b0100_100;//7'b1011_011;
              4'b0011 :
                tubesreg <= 7'b0110_000;//7'b1001_111;
              4'b0100 :
                tubesreg <= 7'b0011_001;//7'b1100_110;
              4'b0101 :
                tubesreg <= 7'b0010_010;//7'b1101_101;
              4'b0110 :
                tubesreg <= 7'b0000_010;//7'b1111_101;
              4'b0111 :
                tubesreg <= 7'b1111_000;//7'b0000_111;
              4'b1000 :
                tubesreg <= 7'b0000_000;//7'b1111_111;
              4'b1001 :
                tubesreg <= 7'b0010_000;//7'b1101_111;
              default :
                tubesreg <= 7'b1000_000;//7'b0111_111;
            endcase
          end


        if(sel==8'b11110111)
          begin
            case(q[15:12])
              4'b0000 :
                tubesreg <= 7'b1000_000;//7'b0111_111;//
              4'b0001 :
                tubesreg <= 7'b1111_001;//7'b0000_110;
              4'b0010 :
                tubesreg <= 7'b0100_100;//7'b1011_011;
              4'b0011 :
                tubesreg <= 7'b0110_000;//7'b1001_111;
              4'b0100 :
                tubesreg <= 7'b0011_001;//7'b1100_110;
              4'b0101 :
                tubesreg <= 7'b0010_010;//7'b1101_101;
              4'b0110 :
                tubesreg <= 7'b0000_010;//7'b1111_101;
              4'b0111 :
                tubesreg <= 7'b1111_000;//7'b0000_111;
              4'b1000 :
                tubesreg <= 7'b0000_000;//7'b1111_111;
              4'b1001 :
                tubesreg <= 7'b0010_000;//7'b1101_111;
              default :
                tubesreg <= 7'b1000_000;//7'b0111_111;
            endcase
          end
        if(sel==8'b11101111)
          begin
            tubesreg <= 7'b1111_001;//user
          end

        if(sel==8'b11011111)
          begin
            case(time_of_error[1:0])
              2'b00 :
                tubesreg <= 7'b1000_000;//7'b0111_111;//
              2'b01 :
                tubesreg <= 7'b1111_001;//7'b0000_110;
              2'b10 :
                tubesreg <= 7'b0100_100;//7'b1011_011;
              2'b11 :
                tubesreg <= 7'b0110_000;//7'b1001_111;
              default :
                tubesreg <= 7'b1000_000;//7'b0111_111;
            endcase
          end

        if(sel==8'b10111111)
          begin
            case(cnt_1s)
              32'd0 :
                tubesreg <= 7'b1000_000;
              32'd1 :
                tubesreg <= 7'b1111_001;
              32'd2 :
                tubesreg <= 7'b0100_100;//7'b1011_011;
              32'd3 :
                tubesreg <= 7'b0110_000;//7'b1001_111;
              32'd4 :
                tubesreg <= 7'b0011_001;//7'b1100_110;
              32'd5 :
                tubesreg <= 7'b0010_010;//7'b1101_101;
              32'd6 :
                tubesreg <= 7'b0000_010;//7'b1111_101;
              32'd7 :
                tubesreg <= 7'b1111_000;//7'b0000_111;
              32'd8 :
                tubesreg <= 7'b0000_000;//7'b1111_111;
              32'd9 :
                tubesreg <= 7'b0010_000;//7'b1101_111;
              32'd10 :
                tubesreg <= 7'b1000_000;
              32'd11 :
                tubesreg <= 7'b1111_001;
              32'd12 :
                tubesreg <= 7'b0100_100;//7'b1011_011;
              32'd13 :
                tubesreg <= 7'b0110_000;//7'b1001_111;
              32'd14 :
                tubesreg <= 7'b0011_001;//7'b1100_110;
              32'd15 :
                tubesreg <= 7'b0010_010;//7'b1101_101;
              32'd16 :
                tubesreg <= 7'b0000_010;//7'b1111_101;
              32'd17 :
                tubesreg <= 7'b1111_000;//7'b0000_111;
              32'd18 :
                tubesreg <= 7'b0000_000;//7'b1111_111;
              32'd19 :
                tubesreg <= 7'b0010_000;//7'b1101_111;
              default:
                tubesreg <= 7'b1000_000;
            endcase
          end
        if(sel==8'b01111111)
          begin
            case(cnt_1s)
              32'd10 :
                tubesreg <= 7'b1111_001;
              32'd11 :
                tubesreg <= 7'b1111_001;
              32'd12 :
                tubesreg <= 7'b1111_001;//7'b1011_011;
              32'd13 :
                tubesreg <= 7'b1111_001;//7'b1001_111;
              32'd14 :
                tubesreg <= 7'b1111_001;//7'b1100_110;
              32'd15 :
                tubesreg <= 7'b1111_001;//7'b1101_101;
              32'd16 :
                tubesreg <= 7'b1111_001;//7'b1111_101;
              32'd17 :
                tubesreg <= 7'b1111_001;//7'b0000_111;
              32'd18 :
                tubesreg <= 7'b1111_001;//7'b1111_111;
              32'd19 :
                tubesreg <= 7'b1111_001;//7'b1101_111;
              default:
                tubesreg <= 7'b1000_000;
            endcase
          end
      end
    if(identity==0) // admin
      begin
        if(sel==8'b11111110)
          begin
            case(new_pswd[3:0])
              4'b0000 :
                tubesreg <= 7'b1000_000;//7'b0111_111;//
              4'b0001 :
                tubesreg <= 7'b1111_001;//7'b0000_110;
              4'b0010 :
                tubesreg <= 7'b0100_100;//7'b1011_011;
              4'b0011 :
                tubesreg <= 7'b0110_000;//7'b1001_111;
              4'b0100 :
                tubesreg <= 7'b0011_001;//7'b1100_110;
              4'b0101 :
                tubesreg <= 7'b0010_010;//7'b1101_101;
              4'b0110 :
                tubesreg <= 7'b0000_010;//7'b1111_101;
              4'b0111 :
                tubesreg <= 7'b1111_000;//7'b0000_111;
              4'b1000 :
                tubesreg <= 7'b0000_000;//7'b1111_111;
              4'b1001 :
                tubesreg <= 7'b0010_000;//7'b1101_111;
              default :
                tubesreg <= 7'b1000_000;//7'b0111_111;
            endcase
          end
        if(sel==8'b11111101)
          begin
            case(new_pswd[7:4])
              4'b0000 :
                tubesreg <= 7'b1000_000;//7'b0111_111;//
              4'b0001 :
                tubesreg <= 7'b1111_001;//7'b0000_110;
              4'b0010 :
                tubesreg <= 7'b0100_100;//7'b1011_011;
              4'b0011 :
                tubesreg <= 7'b0110_000;//7'b1001_111;
              4'b0100 :
                tubesreg <= 7'b0011_001;//7'b1100_110;
              4'b0101 :
                tubesreg <= 7'b0010_010;//7'b1101_101;
              4'b0110 :
                tubesreg <= 7'b0000_010;//7'b1111_101;
              4'b0111 :
                tubesreg <= 7'b1111_000;//7'b0000_111;
              4'b1000 :
                tubesreg <= 7'b0000_000;//7'b1111_111;
              4'b1001 :
                tubesreg <= 7'b0010_000;//7'b1101_111;
              default :
                tubesreg <= 7'b1000_000;//7'b0111_111;
            endcase
          end

        if(sel==8'b11111011)
          begin
            case(new_pswd[11:8])
              4'b0000 :
                tubesreg <= 7'b1000_000;//7'b0111_111;//
              4'b0001 :
                tubesreg <= 7'b1111_001;//7'b0000_110;
              4'b0010 :
                tubesreg <= 7'b0100_100;//7'b1011_011;
              4'b0011 :
                tubesreg <= 7'b0110_000;//7'b1001_111;
              4'b0100 :
                tubesreg <= 7'b0011_001;//7'b1100_110;
              4'b0101 :
                tubesreg <= 7'b0010_010;//7'b1101_101;
              4'b0110 :
                tubesreg <= 7'b0000_010;//7'b1111_101;
              4'b0111 :
                tubesreg <= 7'b1111_000;//7'b0000_111;
              4'b1000 :
                tubesreg <= 7'b0000_000;//7'b1111_111;
              4'b1001 :
                tubesreg <= 7'b0010_000;//7'b1101_111;
              default :
                tubesreg <= 7'b1000_000;//7'b0111_111;
            endcase
          end


        if(sel==8'b11110111)
          begin
            case(new_pswd[15:12])
              4'b0000 :
                tubesreg <= 7'b1000_000;//7'b0111_111;//
              4'b0001 :
                tubesreg <= 7'b1111_001;//7'b0000_110;
              4'b0010 :
                tubesreg <= 7'b0100_100;//7'b1011_011;
              4'b0011 :
                tubesreg <= 7'b0110_000;//7'b1001_111;
              4'b0100 :
                tubesreg <= 7'b0011_001;//7'b1100_110;
              4'b0101 :
                tubesreg <= 7'b0010_010;//7'b1101_101;
              4'b0110 :
                tubesreg <= 7'b0000_010;//7'b1111_101;
              4'b0111 :
                tubesreg <= 7'b1111_000;//7'b0000_111;
              4'b1000 :
                tubesreg <= 7'b0000_000;//7'b1111_111;
              4'b1001 :
                tubesreg <= 7'b0010_000;//7'b1101_111;
              default :
                tubesreg <= 7'b1000_000;//7'b0111_111;
            endcase
          end
        if(sel==8'b11101111)

          begin

            tubesreg <= 7'b1000_000;//admin

          end

        if(sel==8'b11011111)
          begin
            case(time_of_error[1:0])
              2'b00 :
                tubesreg <= 7'b1000_000;//7'b0111_111;//
              2'b01 :
                tubesreg <= 7'b1111_001;//7'b0000_110;
              2'b10 :
                tubesreg <= 7'b0100_100;//7'b1011_011;
              2'b11 :
                tubesreg <= 7'b0110_000;//7'b1001_111;
              default :
                tubesreg <= 7'b1000_000;//7'b0111_111;
            endcase
          end

        if(sel==8'b10111111)
          begin
            case(cnt_1s)
              32'd0 :
                tubesreg <= 7'b1000_000;
              32'd1 :
                tubesreg <= 7'b1111_001;
              32'd2 :
                tubesreg <= 7'b0100_100;//7'b1011_011;
              32'd3 :
                tubesreg <= 7'b0110_000;//7'b1001_111;
              32'd4 :
                tubesreg <= 7'b0011_001;//7'b1100_110;
              32'd5 :
                tubesreg <= 7'b0010_010;//7'b1101_101;
              32'd6 :
                tubesreg <= 7'b0000_010;//7'b1111_101;
              32'd7 :
                tubesreg <= 7'b1111_000;//7'b0000_111;
              32'd8 :
                tubesreg <= 7'b0000_000;//7'b1111_111;
              32'd9 :
                tubesreg <= 7'b0010_000;//7'b1101_111;
              32'd10 :
                tubesreg <= 7'b1000_000;
              32'd11 :
                tubesreg <= 7'b1111_001;
              32'd12 :
                tubesreg <= 7'b0100_100;//7'b1011_011;
              32'd13 :
                tubesreg <= 7'b0110_000;//7'b1001_111;
              32'd14 :
                tubesreg <= 7'b0011_001;//7'b1100_110;
              32'd15 :
                tubesreg <= 7'b0010_010;//7'b1101_101;
              32'd16 :
                tubesreg <= 7'b0000_010;//7'b1111_101;
              32'd17 :
                tubesreg <= 7'b1111_000;//7'b0000_111;
              32'd18 :
                tubesreg <= 7'b0000_000;//7'b1111_111;
              32'd19 :
                tubesreg <= 7'b0010_000;//7'b1101_111;
              default:
                tubesreg <= 7'b1000_000;
            endcase
          end
        if(sel==8'b01111111)
          begin
            case(cnt_1s)
              32'd10 :
                tubesreg <= 7'b1111_001;
              32'd11 :
                tubesreg <= 7'b1111_001;
              32'd12 :
                tubesreg <= 7'b1111_001;//7'b1011_011;
              32'd13 :
                tubesreg <= 7'b1111_001;//7'b1001_111;
              32'd14 :
                tubesreg <= 7'b1111_001;//7'b1100_110;
              32'd15 :
                tubesreg <= 7'b1111_001;//7'b1101_101;
              32'd16 :
                tubesreg <= 7'b1111_001;//7'b1111_101;
              32'd17 :
                tubesreg <= 7'b1111_001;//7'b0000_111;
              32'd18 :
                tubesreg <= 7'b1111_001;//7'b1111_111;
              32'd19 :
                tubesreg <= 7'b1111_001;//7'b1101_111;
              default:
                tubesreg <= 7'b1000_000;
            endcase
          end
      end
  end
endmodule