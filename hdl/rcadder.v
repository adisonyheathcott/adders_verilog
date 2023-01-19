`timescale 1ns / 1ps

module rcadder(
    input [7:0] a,
    input [7:0] b,
    output [7:0] sum,
    output cout
);

wire [6:0] c;

fulladder u1(a[0], b[0], 1'b0, sum[0], c[0]);
fulladder u2(a[1], b[1], c[0], sum[1], c[1]);
fulladder u3(a[2], b[2], c[1], sum[2], c[2]);
fulladder u4(a[3], b[3], c[2], sum[3], c[3]);
fulladder u5(a[4], b[4], c[3], sum[4], c[4]);
fulladder u6(a[5], b[5], c[4], sum[5], c[5]);
fulladder u7(a[6], b[6], c[5], sum[6], c[6]);
fulladder u8(a[7], b[7], c[6], sum[7], cout);

endmodule