`timescale 1ns / 1ps

module rcadder(
    input [7:0] a,
    input [7:0] b,
    output [7:0] sum,
    output cout
);

wire [6:0] c;

fulladder u1(.a(a[0]), .b(b[0]), .cin(1'b0), .sum(sum[0]), .cout(c[0]));
fulladder u2(.a(a[1]), .b(b[1]), .cin(c[0]), .sum(sum[1]), .cout(c[1]));
fulladder u3(.a(a[2]), .b(b[2]), .cin(c[1]), .sum(sum[2]), .cout(c[2]));
fulladder u4(.a(a[3]), .b(b[3]), .cin(c[2]), .sum(sum[3]), .cout(c[3]));
fulladder u5(.a(a[4]), .b(b[4]), .cin(c[3]), .sum(sum[4]), .cout(c[4]));
fulladder u6(.a(a[5]), .b(b[5]), .cin(c[4]), .sum(sum[5]), .cout(c[5]));
fulladder u7(.a(a[6]), .b(b[6]), .cin(c[5]), .sum(sum[6]), .cout(c[6]));
fulladder u8(.a(a[7]), .b(b[7]), .cin(c[6]), .sum(sum[7]), .cout(cout));

endmodule