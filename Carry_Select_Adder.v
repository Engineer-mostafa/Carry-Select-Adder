module FullAdder(in1 , in2 , c_in , sum , carry);
input in1 , in2 , c_in;
output wire sum , carry;

assign carry = ((in1 & in2) + (c_in & in2) + (in1 & c_in));
xor(sum , in1 , in2 , c_in);
endmodule

module mux(z , y , x , sel);
output  [3:0]z;
input wire sel ;
input [3:0] x , y;
assign z = sel == 0 ? x :
	   sel == 1 ? y : 1'bx;

endmodule

module mux_tb();
reg x , y , s;
wire o;
mux_2020 m1(o , y , x ,s);
initial
begin
$monitor(" x = %b , y = %b , selector = %b , output = %b ", x , y , s , o );
x = 1;
y = 0;
s = 1;
#5
s = 0;
end
endmodule
module FA_tb();

wire sum , carry;
reg in1 , in2 , c_in;
FullAdder f1(in1 , in2 , c_in , sum , carry );
initial
begin
$monitor("in1 = %b , in2 = %b  , c_in = %b ,Sum = %b , Carry = %b" ,in1 , in2 , c_in , sum , carry);
in1 = 0;
in2 = 0;
c_in =0;
#5
in1 = 1;
in2 = 0;
c_in =0;
#5
in1 = 0;
in2 = 1;
c_in =0;
#5
in1 = 1;
in2 = 1;
c_in =0;
#5
in1 = 1;
in2 = 1;
c_in =1;
end
endmodule

module FullAdder_4bit_ripple(Number_1 , Number_2, c_in , sum , carry);
input [3:0] Number_1 , Number_2;
input c_in;
output [3:0] sum;
output 	carry;
wire c0,c1,c2;

FullAdder f0(Number_1[0] , Number_2[0] , c_in , sum[0] , c0 );
FullAdder f1(Number_1[1] , Number_2[1] , c0, sum[1]    , c1 );
FullAdder f2(Number_1[2] , Number_2[2] , c1, sum[2]    , c2 );
FullAdder f3(Number_1[3] , Number_2[3] , c2, sum[3]    , carry  );
endmodule

module tb_FullAdder_4bit_ripple();
reg [15:0] Number_1 , Number_2;
reg c_in;
wire [15:0] sum ;
wire [3:0] s10 ;
wire [3:0] s11 ;
wire [3:0] s20 ;
wire [3:0] s21 ;
wire [3:0] s30 ;
wire [3:0] s31 ;
wire carry1;
wire carry2;
wire carry3;
wire clow;
wire c10;
wire c11;
wire c20;
wire c21;
wire c30;
wire c31;
 FullAdder_4bit_ripple f0( Number_1[3:0] , Number_2[3:0] , 0 , sum[3:0] , clow );


 FullAdder_4bit_ripple f10(Number_1[7:4] , Number_2[7:4] , 0 , s10 , c10);
 FullAdder_4bit_ripple f11(Number_1[7:4] , Number_2[7:4] , 1 , s11 , c11);

mux ms1(sum[7:4] , s11 , s10 , clow);
mux mc1(carry1 , c11 , c10 , clow);


 FullAdder_4bit_ripple f20(Number_1[11:8] , Number_2[11:8] , 0 , s20 , c20);
 FullAdder_4bit_ripple f21(Number_1[11:8] , Number_2[11:8] , 1 , s21 , c21);

mux ms2(sum[11:8] , s21 , s20 , carry1);
mux mc2(carry2, c21 , c20 , carry1);

 FullAdder_4bit_ripple f30(Number_1[15:12] , Number_2[15:12] , 0 , s30 , c30);
FullAdder_4bit_ripple f31(Number_1[15:12] , Number_2[15:12] , 1 , s31 , c31);

mux ms3(sum[15:12] , s31 , s30 , carry2);
mux mc3(carry3, c31 , c30 , carry2);

initial begin
$monitor("Number_1 = %16b +\nNumber_2 = %16b\nthe sum  = %16b  carry = %b " , Number_1 , Number_2 , sum[15:0] , carry3);
Number_1 = 16'b0000000000000000;
Number_2 = 16'b0000000000000000;
#5
Number_1 = 16'b1000000100000001;
Number_2 = 16'b1000000100011001;
#5
Number_1 = 16'b0000000111111001;
Number_2 = 16'b0000000111111001;
#5
Number_1 = 16'b1111111111111111;
Number_2 = 16'b1111111111111111;
end
endmodule

