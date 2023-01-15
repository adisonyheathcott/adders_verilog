`timescale 1ns / 1ps

module fulladder_tb;

reg a;
reg b;
reg cin;

reg [2:0] i = 3'd0;

wire sum;
wire cout;

fulladder uut (
    .a(a),
    .b(b),
    .cin(cin),
    .sum(sum),
    .cout(cout)
);

initial begin
    a = 1'b0;
    b = 1'b0;
    cin = 1'b0;

    #20

    for (i = 0; i < 8; i = i + 1'b1) begin
        {a, b, cin} = i;
        #20;
    end

    $finish;
end


endmodule