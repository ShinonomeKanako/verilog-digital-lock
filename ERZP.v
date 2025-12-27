module ERZP (CLK, KIN,KOUT);
input CLK, KIN; //工作时钟和输入信号
output KOUT; reg KOUT;
reg [7:0] KH,KL; //定义对高电平和低电平脉宽计数之寄存器
always @(posedge CLK) begin
if (!KIN) KL<=KL+1 ; //对键输入的低电平脉宽计数
else KL<=8'b00000000; end //若出现高电平, 则计数器清零
always @(posedge CLK) begin
if (KIN) KH<= KH+1; //同时对键输入的高电平脉宽计数
else KH<=8'b00000000; end //若出现高电平, 则计数器清零
always @(posedge CLK) begin
     if (KH > 8'b01111111) KOUT<=1'B1;
else if (KL > 8'b01111000) KOUT<=1'B0; 
end
endmodule