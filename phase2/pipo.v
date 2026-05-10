/*
PIPO — Parallel In Parallel Out
Load all bits together
Read all bits together
Basically a normal register.
*/

module pipo (
    input clk,
    input rst,
    input [3:0] pdata,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (rst)
        q <= 4'b0000;
    else
        q <= pdata;
end

endmodule

`timescale 1ns/1ps

module tb_pipo;

reg clk, rst;
reg [3:0] pdata;
wire [3:0] q;

pipo dut(
    .clk(clk),
    .rst(rst),
    .pdata(pdata),
    .q(q)
);

always #5 clk = ~clk;

initial begin
    clk = 0;
    rst = 1;

    #10 rst = 0;

    pdata = 4'b1010; #10;
    pdata = 4'b1111; #10;

    #30 $finish;
end

endmodule