// 
/*
SIPO — Serial In Parallel Out
    Data enters serially
    Entire register is available as output

    Input bits: 1 → 0 → 1 → 1

Register fills like:
0001
0010
0101
1011

*/

module sipo (
    input clk,
    input rst,
    input din,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (rst)
        q <= 4'b0000;
    else
        q <= {q[2:0], din};
end

endmodule

`timescale 1ns/1ps

module tb_sipo;

reg clk, rst, din;
wire [3:0] q;

sipo dut(
    .clk(clk),
    .rst(rst),
    .din(din),
    .q(q)
);

always #5 clk = ~clk;

initial begin
    clk = 0;
    rst = 1;
    din = 0;

    #10 rst = 0;

    din = 1; #10;
    din = 0; #10;
    din = 1; #10;
    din = 1; #10;

    #30 $finish;
end

endmodule