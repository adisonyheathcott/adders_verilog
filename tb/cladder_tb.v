`timescale 1ns / 1ps

module cladder_tb;

reg [3:0] a;
reg [3:0] b;

reg [4:0] i = 5'b00000;
reg [4:0] j = 5'b00000;

wire [4:0] sum;
wire cout;

cladder uut (
    .a(a),
    .b(b),
    .sum(sum)
);

initial begin
    a  = 4'b0000;
    b  = 4'b0000;

    #20

    for (i = 0; i < 16; i = i + 1'b1) begin
        a = i;
        for (j = 0; j < 16; j = j + 1'b1) begin
            b = j;
            #20
            if (sum != a + b) $display("FAILED");
        end
    end

    $display ("Simulation Finished");
    $finish;
end

endmodule;