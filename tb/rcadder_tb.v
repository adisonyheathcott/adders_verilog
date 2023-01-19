`timescale 1ns / 1ps

module rcadder_tb;

reg [7:0] a;
reg [7:0] b;

reg [8:0] i = 9'b000000000;
reg [8:0] j = 9'b000000000;

wire [7:0] sum;
wire cout;

rcadder uut (
    .a(a),
    .b(b),
    .sum(sum),
    .cout(cout)
);

initial begin
    a  = 8'b00000000;
    b  = 8'b00000000;

    #20

    for (i = 0; i < 256; i = i + 1'b1) begin
        a = i;
        for (j = 0; j < 256; j = j + 1'b1) begin
            b = j;
            #20
            if (sum != a + b) $display("FAILED");
        end
    end

    $display ("Simulation Finished");
    $finish;
end

endmodule;