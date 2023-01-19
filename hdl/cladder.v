`timescale 1ns / 1ps

module cladder (
    input [3:0] a,
    input [3:0] b,
    output [4:0] sum
);

wire [4:0] carry;
wire [3:0] g, p;
wire[3:0] presum;

fulladder u1(.a(a[0]), .b(b[0]), .cin(carry[0]), .sum(presum[0]), .cout());
fulladder u2(.a(a[1]), .b(b[1]), .cin(carry[1]), .sum(presum[1]), .cout());
fulladder u3(.a(a[2]), .b(b[2]), .cin(carry[2]), .sum(presum[2]), .cout());
fulladder u4(.a(a[3]), .b(b[3]), .cin(carry[3]), .sum(presum[3]), .cout());

// Create the generate terms
assign g[0] = a[0] & b[0];
assign g[1] = a[1] & b[1];
assign g[2] = a[2] & b[2];
assign g[3] = a[3] & b[3];

// Create the propagate terms
assign p[0] = a[0] | b[0];
assign p[1] = a[1] | b[1];
assign p[2] = a[2] | b[2];
assign p[3] = a[3] | b[3];

// Create carry terms
assign carry[0] = 1'b0;
assign carry[1] = g[0] | (p[0] & carry[0]);
assign carry[2] = g[1] | (p[1] & carry[1]);
assign carry[3] = g[2] | (p[2] & carry[2]);
assign carry[4] = g[3] | (p[3] & carry[3]);

assign sum = {carry[4], presum};

endmodule